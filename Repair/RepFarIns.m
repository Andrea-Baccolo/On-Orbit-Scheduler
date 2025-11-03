classdef (Abstract) RepFarIns < Repair

    properties
    end

    methods (Abstract)
        struct = initialStruct(obj, state, destroyedSet, currSeq);
        [tarIndx, sscIndx, posSeq] = chooseTar(obj, struct, initialState, currSeq, destroyedSet);
        struct = updateStruct(obj, struct, state, currSeq, sscIndx, tarIndx, destroyedSet, currDestroyed);

    end

    methods
        function obj = RepFarIns(nTar)
            if nargin < 1, nTar = 0; end
            obj@Repair(nTar);
        end

        function tourInfo = buildTours(obj, destroyedSet, tourInfo, state)
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