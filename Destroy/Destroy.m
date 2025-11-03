classdef (Abstract) Destroy 
    
    % Class that implement the general destroy method. It's purpuse is to
    % delete part of the solutions to later rebuild in a hopefully better
    % way. 

    properties 
        nTar    % total number of target
        degDes  % degree pf destruction of the destroyer
    end

    methods (Abstract)
        [nDestroy, destroyIndx]= chooseTargets(obj, slt, initialState);
        % function that gives the total number of destroyed targets and
        % their indexes
    end

    methods
        function obj = Destroy(nTar, degDes)
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj.nTar = nTar;
            obj.degDes =  degDes;
        end
        
        function [destroyedSet, tourInfos] = Destruction(obj, slt, initialState)

            % choose destoryed targets
            [nDestroy, destroyIndx] = chooseTargets(obj, slt, initialState);
            % destroyIndx is a matrix with the following columns:
                    % 1: sscIndx, 2:tourIndx, 3:posTour
            if (nDestroy>0) % if I have something to destroy
                nSSc = length(initialState.sscs);
                if(nDestroy>=obj.nTar) % if I will destroy everything
                    % destroyedSet
                    destroyedSet = (1:obj.nTar)';
                    % empty tourInfo
                    tourInfos = TourInfo();
                    tourInfos = tourInfos.artificialTourInfo(cell(1,nSSc), zeros(1,nSSc) , zeros(nSSc,1));
                else
                    destroyedSet = -1*ones(nDestroy,1);
                    tourInfos = slt.tourInfo;
                    % save all destroyed targets in destroyedSet
                    for d = 1:nDestroy
                        destroyedSet(d) = tourInfos.tours{destroyIndx(d,2), destroyIndx(d,1)}(destroyIndx(d,3));
                    end
        
                    for d = 1:nDestroy
                        % delete element
                        tourInfos.tours{destroyIndx(d,2), destroyIndx(d,1)}...
                            (tourInfos.tours{destroyIndx(d,2), destroyIndx(d,1)} == destroyedSet(d)) = [];
        
                        % modify tour length and number of sscs tour
                        tourInfos.lTour(destroyIndx(d,2), destroyIndx(d,1)) = tourInfos.lTour(destroyIndx(d,2), destroyIndx(d,1)) - 1;
                        if(tourInfos.lTour(destroyIndx(d,2), destroyIndx(d,1)) == 0)
                            tourInfos.nTour(destroyIndx(d,1)) = tourInfos.nTour(destroyIndx(d,1)) - 1;
                        end
                    end
                    tourInfos = tourInfos.cutTour();
                end
            elseif(nDestroy == 0) % if not destroy anything
                destroyedSet = [];
                tourInfos = slt.tourInfo;
            end
            
        end

        function nDestroy = nDesCompute(obj)
            % number of targets to remove
            nDestroy = ceil(obj.degDes*obj.nTar/100);
        end
    
    end
end