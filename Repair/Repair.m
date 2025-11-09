classdef Repair

    % General Repair method used to rebuild a new solution from the
    % destroyed solution

    properties
        nTar
    end

    methods (Abstract)
        % general function that adds to the TourInfo the targets in a
        % feasible way.
        tourInfo = buildTours(obj, destroyedSet, tourInfo, stateSsc);
    end

    methods
        function obj = Repair(nTar)

            % METHOD: Constructor

            % INPUTS:
                % nTar: number of targets.

            % OUTPUTS:
                % obj: Repair object.

            if nargin < 1, nTar = 0; end
            obj.nTar = nTar;
        end

        function slt = Reparing(obj, initialState, destroyedSet, tourInfo)

            % METHOD: general repair function used to repair the solution

            % INPUTS:
                % obj: repair object.
                % initialState: state object that contains the initial info.
                % destroyedSet: row vector of destroyed set index.
                % tourInfo: tourInfo object with info of tours after the destruction.
                
            % OUTPUTS:
                % final feasible solution object obtained by the repair. 

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
            
            % METHOD: function used to obtain the udate index from from a 
                % specific tours of a specific ssc united with the destroyedSet.

            % INPUTS:
                % obj: repair object.
                % tourInfo: tourInfo object with info of tours after the destruction.
                % destroyedSet: row vector of destroyed set index.
                % currTour: current tour from which new targets will be added.
                % currSSc: considered ssc.

            % OUTPUTS:
                % updateIndex: row vector of update index to use in the simualtion.

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

             % METHOD: function used to obtain the udate index from the sequence united with the destroyedSet.

            % INPUTS:
                % obj: repair object.
                % seq: row vector of the specific ssc considered.
                % destroyedSet: row vector of destroyed set index.

            % OUTPUTS:
                % updateIndex: row vector of update index to use in the simualtion.

            seq(seq > obj.nTar) = [];
            seq(seq == 0) = [];
            updateIndex = [destroyedSet', seq];
        end

        function newTour = insertTar(~, tour, tarSelect, posSelect)

            % METHOD: this function add the new target in the positiomn posSelect,
                % shifting the vector tour(posSelect:end) by one position to the right.

            % INPUTS:
                % obj: repair object.
                % tour: tour from which the target will be inserted, empty
                    % if new tour needs to be made.
                % tarSelect: target index to add to the tour.
                % posSelect: position in the tour where the target needs to be added.

            % OUTPUTS:
                % newTour: new requested tour, if the tour is empty, it returns just the targets 
                    % without the zeros, if the tour is not empty, it
                    % the new tour with the zeros ready to simulate.

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