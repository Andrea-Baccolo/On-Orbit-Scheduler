classdef DestroyRelated 

    properties
        beta
        prop
        nTar
    end

    methods (Abstract)
        destroyedSet= chooseTargets(obj,destroyedSet, nDestroy, keepSet, slt, targets);
    end

    methods
        function obj = DestroyRelated(nTar, prop, beta)
            obj.nTar = nTar;
            obj.prop = prop;
            obj.beta = beta;
        end

        function [destroyedSet, tourInfos] = Destruction(obj, slt, sim)
            targets = sim.initialState.targets;
            % set up for the destruction
            nDestroy = ceil(obj.prop*obj.nTar/100);
            destroyedSet = -1*ones(nDestroy,1);
            keepSet = (1:obj.nTar)';
            nKeep = length(keepSet);
            DesTarIndx = randi([1 nKeep]);
            destroyedSet(1) = keepSet(DesTarIndx);
            keepSet(DesTarIndx) = [];

            % rest of destruction
            destroyedSet= chooseTargets(obj,destroyedSet, nDestroy, keepSet, slt, targets);

            % modify tourInfo
            tourInfos = slt.tourInfo;
            desCopy = destroyedSet;
            nDes = length(desCopy);
            nTour = size(tourInfos.lTour,1);
            sscIndx = 1; tourIndx = 1;
            while(nDes>0)
                if(tourInfos.lTours{tourIndx,sscIndx}~=0)
                    deleteIndx = -1*ones(nDes,1);
                    count = 1;
                    for i = 1:nDes
                        f = find(tourInfos.tours{tourIndx,sscIndx}==desCopy(i),1);
                        if(~isempty(f))
                            tourInfos.tours{tourIndx,sscIndx}(f) = [];
                            deleteIndx(count) = i;
                            count = count + 1;
                            tourInfos.lTour(tourIndx,sscIndx) = tourInfos.lTour(tourIndx,sscIndx) - 1;
                            if(tourInfos.lTour(tourIndx,sscIndx)==0)
                                tourInfos.nTour(SscIndx) = tourInfos.nTour(SscIndx) - 1;
                                break;
                            end
                        end
                    end
                    deleteIndx = deleteIndx(1:count-1);
                    if(count-1>0)
                        desCopy(deleteIndx) = [];
                        nDes = nDes - count +1;
                    end
                end
                tourIndx = tourIndx + 1;
                sscIndx = sscIndx + (tourIndx==nTour+1);
                tourIndx = tourIndx - nTour*(tourIndx==nTour+1);
            end
        end

        function costMat = computeCost(obj, targets)
            % compute distance approximation
            % get true anomaly, inclination and raan
            % the first one is the tarIndx 
            incl = -1*ones(obj.nTar,1);
            raan = -1*ones(obj.nTar,1);
            nu = -1*ones(obj.nTar,1);
            for j = 1:obj.nTar
                incl(j) = targets{j}.orbit.inclination;
                raan(j) = targets{j}.orbit.raan;
                nu(j) = targets{j}.trueAnomaly;
            end
            costMat = inf*ones(obj.nTar,obj.nTar);
            nOther = obj.nTar-1;
            for i = 1:obj.nTar
                inclJ = [incl(1:i-1);incl(i+1:obj.nTar)];
                raanJ = [raan(1:i-1);raan(i+1:obj.nTar)];
                nuJ = [nu(1:i-1);nu(i+1:obj.nTar)];
                val = sin(incl(i)).*ones(nOther,1).*sin(inclJ).*...
                      cos(raan(i).*ones(nOther,1)-raanJ) + ...
                      cos(incl(i)).*ones(nOther,1).*cos(inclJ);
                psi = (raan(i) + nu(i))*ones(nOther,1)- raanJ - nuJ;
                theta = psi.*(abs(psi)<=180)+...
                        (-360+abs(psi)).*(psi>180)+...
                        (+360-abs(psi)).*(psi<-180);
                alpha = abs(rad2deg(acos(val)));
                Cost = obj.beta*alpha + (1-obj.beta)*theta;
                costMat(1:i-1,:)  = Cost(1:i-1);
                costMat(i+1:obj.nTar,:)  = Cost(i+1:obj.nTar);
            end
        end

        function relatedness = computeRelatedness(obj, tarIndxI, tarIndxJ, targets, slt)
            costMat = computeCost(obj, targets);
            cPrime = (costMat(tarIndxI,tarIndxJ)')./max(max(costMat));
            % check if same ssc or not
            nJ = length(tarIndxJ);
            V = -1*ones(nJ,1);
            while 1
                if(~isempty(find(slt.seq == tarIndxI,1)))
                    for i = 1:nJ
                        V(i) = (~isempty(find(slt.seq == tarIndxI,1)));
                    end
                    break;
                end
            end
            relatedness = ones(nOther,1)./(cPrime + V);
        end

        
    end
end