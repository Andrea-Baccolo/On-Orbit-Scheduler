classdef DestroySSc < Destroy

    properties
        p
    end

    methods (Abstract)
        SScs = createIndx(obj, nDSSc, slt, sim);
    end

    methods
        function obj = DestroySSc(nTar, p)
            obj@Destroy(nTar);
            obj.p = p;
        end

        function [nDestroy, destroyIndx] = chooseTargets(obj, slt, ~)
            nSSc = size(slt.tourInfo.lTour, 2);
            nDSSc = ceil(obj.p*nSSc/100);
            maxLen = max(sum(slt.tourInfo.lTour));
            destroyIndx = -1*ones(maxLen*nDSSc,3);
            SScs = obj.createIndx(nDSSc, slt, []);
            tarCount = 1;
            nTour = size(slt.tourInfo.lTour,1);
            for i = 1:length(SScs)
                for j = 1:nTour
                    lenTour = slt.tourInfo.lTour(j,SScs(i));
                    if(lenTour ~=0)
                        destroyIndx(tarCount:tarCount+lenTour-1,1) = SScs(i)*ones(lenTour,1);
                        destroyIndx(tarCount:tarCount+lenTour-1,2) = j*ones(lenTour,1);
                        destroyIndx(tarCount:tarCount+lenTour-1,3) = (lenTour:-1:1)';
                        tarCount = tarCount+lenTour;
                    end
                end
            end
            nDestroy = tarCount-1;
            destroyIndx = destroyIndx(1:nDestroy,:);
        end
        
    end
end