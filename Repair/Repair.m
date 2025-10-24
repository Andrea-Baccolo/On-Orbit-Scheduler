classdef Repair

    properties
        nTar
    end

    methods (Abstract)
        [destroyedSet, tourInfo, stateSsc] = buildTours(obj, destroyedSet, tourInfo, stateSsc);
    end

    methods
        function obj = Repair(nTar)
            obj.nTar = nTar;
        end

        function slt = Reparing(obj, initialState, destroyedSet, tourInfo)
            nSSc = size(tourInfo.lTour,2);
            stateSsc = repmat({initialState}, nSSc, 1);

            % insert targets in existing tours
            [destroyedSet, tourInfo, stateSsc] = obj.buildTours(destroyedSet, tourInfo, stateSsc);
            
            if(~isempty(destroyedSet))
                lDestroyed = length(destroyedSet);
               % insert targets in new tours

                 %initializing lastTourInfo
                lastTourInfo = TourInfo();
                lastTours = cell(lDestroyed,nSSc);
                lastLTour = zeros(lDestroyed,nSSc);
                lastNTour = zeros(nSSc, 1);
                lastTourInfo = lastTourInfo.artificialTourInfo(lastTours, lastLTour, lastNTour);

                % rebuilding lastTourInfo
                [~, lastTourInfo, ~] = obj.buildTours(destroyedSet, lastTourInfo, stateSsc);

                % cutting lastTourInfo
                lastTourInfo = lastTourInfo.cutTour();

                % merging in newTourInfo
                % artificialTourInfo(obj, tours, lTour, nTour)
                tourInfo = tourInfo.artificialTourInfo(...
                    [tourInfo.tours; lastTourInfo.tours], ...
                    [tourInfo.lTour; lastTourInfo.lTour], ...
                    tourInfo.nTour + lastTourInfo.nTour);
            else
                tourInfo = tourInfo.cutTour();
            end
            
            seq = tourInfo.rebuildSeq();
            slt = Solution(seq);
            slt.tourInfo = tourInfo;
        end

        function updateIndex = createUpdateIndex(~, tourInfo, destroyedSet, currTour, currSSc)
            % get the total number of upddateIndex
            lDestroyed = length(destroyedSet);
            if(isscalar(tourInfo.lTour(currTour:end,currSSc)))
                lenTours = tourInfo.lTour(currTour:end,currSSc);
            else
                lenTours = sum(tourInfo.lTour(currTour:end,currSSc));
            end
            % generate updateIndx
            updateIndex = -1*ones(1, lenTours(currSSc) + lDestroyed);
            updateIndex(1:lDestroyed) = destroyedSet';
            % setting counters
            upIndx = lDestroyed + 1;
            tourIndx = currTour;
            while(tourIndx <= tourInfo.nTour(currSSc))
                if(tourInfo.lTour(tourIndx,currSSc)~=0)
                    updateIndex(upIndx:upIndx + tourInfo.lTour(tourIndx,currSSc)-1) = ...
                                            tourInfo.tours{tourIndx,currSSc};
                    upIndx = upIndx + tourInfo.lTour(tourIndx,currSSc);
                    tourIndx = tourIndx + 1;
                end
            end
        end
    end
end