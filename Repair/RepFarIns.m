classdef (Abstract) RepFarIns < Repair

    % Abstract class that collects some common features of the Farthest
    % insertion repairs.

    properties
    end

    methods (Abstract)
        % function that create the structure used to decide the target to insert.
        struct = initialStruct(obj, state, destroyedSet, currSeq);

        % function that chooses the target to insert using the structure.
        [tarIndx, sscIndx, posSeq] = chooseTar(obj, struct, initialState, currSeq, destroyedSet);

        % function used to update the structure after interting the new target.
        struct = updateStruct(obj, struct, state, currSeq, sscIndx, tarIndx, destroyedSet, currDestroyed);
    end

    methods
        function obj = RepFarIns(nTar)

            % METHOD: Constructor

            % INPUTS:
                % nTar: number of targets.

            % OUTPUTS:
                % obj: Repair object.

            if nargin < 1, nTar = 0; end
            obj@Repair(nTar);
        end

        function tourInfo = buildTours(obj, destroyedSet, tourInfo, state)

            % METHOD: general function that adds to the TourInfo the targets in a feasible way.

            % INPUTS:
                % obj: repair object.
                % destroyedSet: row vector of destroyed set index.
                % tourInfo: tourInfo object with info of tours after the destruction.
                % stateSsc: state object that contains the initial info.

            % OUTPUTS:
                % tourInfo: the updated tourInfo information ready to be transformed into a sequence.

            % CREATING SEQ and INITIAL STRUCT
            currSeq = tourInfo.rebuildSeq(obj.nTar);
            struct = obj.initialStruct(state, destroyedSet, currSeq);
            
            while(~isempty(destroyedSet)) % while there are some destroyed targets
                
                % CHOOSE TARGET
                [tarIndx, sscIndx, posSeq] = obj.chooseTar(struct, state, currSeq, destroyedSet);

                % INSERT TARGET
                % return ind:go from sequence position to tour position
                [tourIndx, posIndx] = tourInfo.Seq2Tour(posSeq, sscIndx);

                % expanding tours if needed
                if(tourIndx == tourInfo.nTour(sscIndx)+1)
                    tourInfo = tourInfo.expand();
                end
                newTour = obj.insertTar(tourInfo.tours{tourIndx,sscIndx}, destroyedSet(tarIndx), posIndx);

                % save new tour
                if(isempty(tourInfo.tours{tourIndx, sscIndx}))
                    tourInfo.nTour(sscIndx) = tourInfo.nTour(sscIndx) + 1;
                    tourInfo.tours{tourIndx, sscIndx} = newTour;
                else
                    tourInfo.tours{tourIndx, sscIndx} = newTour(2:end-1);
                end
                tourInfo.lTour(tourIndx, sscIndx) = tourInfo.lTour(tourIndx, sscIndx) + 1;
                
                % DELETE TARGET
                currDestroyed = destroyedSet(tarIndx);
                destroyedSet(tarIndx) = [];
                currSeq = tourInfo.rebuildSeq(obj.nTar);

                % UPDATE STRUCT
                struct = obj.updateStruct(struct, state, currSeq, sscIndx, tarIndx, destroyedSet, currDestroyed);
            end
        end
    end
end