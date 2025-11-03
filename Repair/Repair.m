classdef Repair

    % General Repair method used to rebuild a new solution from the
    % destroyed solution

    properties
        nTar
    end

    methods (Abstract)
        tourInfo = buildTours(obj, destroyedSet, tourInfo, stateSsc);
    end

    methods
        function obj = Repair(nTar)
            if nargin < 1, nTar = 0; end
            obj.nTar = nTar;
        end

        function slt = Reparing(obj, initialState, destroyedSet, tourInfo)
            % insert targets in existing tours
            if(~isempty(destroyedSet)) % if there is something to destroy
                tourInfo = obj.buildTours(destroyedSet, tourInfo, initialState);
                tourInfo = tourInfo.cutTour();
            end
            % rebuild the sequence and the solution
            seq = tourInfo.rebuildSeq(obj.nTar);
            slt = Solution(seq);
            slt.tourInfo = tourInfo;
        end

        function updateIndex = updateIndexTour(~, tourInfo, destroyedSet, currTour, currSSc)
            % get the total number of upddateIndex
            lDestroyed = length(destroyedSet);
            if(isscalar(tourInfo.lTour(currTour:end,currSSc)))
                lenTours = tourInfo.lTour(currTour:end,currSSc);
            else
                lenTours = sum(tourInfo.lTour(currTour:end,currSSc));
            end
            % generate updateIndx
            updateIndex = -1*ones(1, lenTours + lDestroyed);
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

        function updateIndex = updateIndexSeq(obj, seq, destroyedSet)
            seq(seq > obj.nTar) = [];
            seq(seq == 0) = [];
            updateIndex = [destroyedSet', seq];
        end

        function newTour = insertTar(~, tour, tarSelect, posSelect)
            % this function add the new target in the positiomn posSelect,
            % shifting the vector tour(posSelect:end) by one position to
            % the right

            if(isempty(tour))
                newTour = tarSelect;
            elseif(posSelect == 1)
                newTour = [ 0 tarSelect tour 0 ];
            else
                newTour = [ 0 tour(1:posSelect-1) tarSelect tour(posSelect:end) 0 ];
            end
        end

    end
end