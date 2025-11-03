classdef RepFarInsSim < RepFarIns

    % Repair method bnuild using a farthest Insersion heuristic principle
    % with respect every feasible position adopted by Han et al 2022.

    properties
    end

    methods
        function obj = RepFarInsSim(nTar)
            if nargin < 1, nTar = 0; end
            obj@RepFarIns(nTar);
        end

        function struct = initialStruct(obj, initialState, destroyedSet, currSeq)
            nSSc = size(currSeq,1);
            struct = cell(nSSc,1);
            for i = 1:nSSc
                struct{i} = obj.calculateDf(initialState, i, destroyedSet, currSeq(i,:));
            end
        end

        function df_i = calculateDf(obj, initialState, sscIndx, destroyedSet, currSeq)
            % currSeq è un vettore, gli passo solo il vettorino che mi serve
            currSeq(currSeq>obj.nTar) = [];

            lDes = length(destroyedSet);
            nPos = length(currSeq) - 1;
            state = initialState;
            sim = Simulator(state);
            df_i = zeros(lDes, nPos+1);
            dfCurr = 0;
            updateIndex = obj.updateIndexSeq(currSeq, destroyedSet);
            for p = 1:nPos
                % POPULATE DF STRUCTURE
                % Note that since we do not have the total fuel of the
                % original route yet, in the matrix will be saved just
                % the fuel obtained in that specific scenario, then it
                % will be obtained the requested change
                finalSeq = p+1:nPos+1;
                for j = 1:lDes
                    % simulation from position p to the end with the
                    % destroyed target
                    newSeq = [ currSeq(p), destroyedSet(j), currSeq(finalSeq)];
                    [~, infeas, totFuel, ~, ~] = sim.SimulateSeq(state, sscIndx, newSeq, updateIndex);
                    if(infeas == 0)
                        df_i(j,p) = df_i(j,p) + sum(totFuel);
                    else
                        df_i(j,p) = inf;
                    end
                end

                % FILL THE STATESTRUCTURE
                % simulate from currentSeq
                [nextState, infeas, totFuel, ~, ~] = sim.SimulateReach(state, sscIndx, currSeq(p+1), updateIndex);
                if(~infeas)
                    state = nextState;
                    dfCurr = dfCurr + totFuel;
                    % to reduce the number of reach, I will add dfCurr
                    % to df_i(:,finalSeq), to avoid restarting the
                    % simulation for the destroyedSet and to avoid to
                    % simulate the currentSeq too much
                    if p < nPos
                        df_i(:,p+1) = df_i(:,p+1) + dfCurr*ones(lDes, 1);
                    end
                else
                    error("Part of the old solution must not be infeasible")
                end
            end
            df_i(:,1:end-1) = df_i(:,1:end-1) - dfCurr*ones(lDes,nPos);

            % considers adding a new tour
            for j = 1:lDes
                % since I am creating a new tour, I do not need to
                % simulate everything, the solution will increase just by
                % the new added tour
                newSeq = [ 0 destroyedSet(j) 0];
                % N.B. state is the last state obtained, which is the
                % inizial point of the new mission
                [~, infeas, totFuel, ~, ~] = sim.SimulateSeq(state, sscIndx, newSeq, updateIndex);
                if(infeas == 0)
                    % just need to add this last part, no cumulative sum here
                    df_i(j,end) = sum(totFuel);
                else
                    df_i(j,end) = inf;
                end
            end 
        end

        function [tarIndx, sscIndx, posSeq] = chooseTar(~, struct, ~, ~, ~)
            lDes = size(struct{1},1);
            nSSc = length(struct);

            % SELECT TAR: ind the target (tarIndx)
            insCost = zeros(lDes,1);
            insPos = zeros(lDes,1);
            insSSc = zeros(lDes,1);
            for j = 1:lDes % for every destroyed target
                posSequence = zeros(nSSc, 1);
                c = zeros(nSSc,1);
                for i = 1:nSSc % for every SSc
                    % minimum cost saving the positions
                    [c(i), posSequence(i)] = min(struct{i}(j,:));
                end
                % minimum over all the SScs saving the positions and the SSc
                [insCost(j), insSSc(j)] = min(c);
                insPos(j) = posSequence(insSSc(j));
            end
            % argmax over the insertion cost
            [~,tarIndx] = max(insCost);
            sscIndx = insSSc(tarIndx);
            posSeq = insPos(tarIndx);
        end
        
        function struct = updateStruct(obj, struct, state, currSeq, sscIndx, tarIndx, destroyedSet, ~)
            nSSc = size(currSeq,1);
            for i = 1:nSSc
                if (i == sscIndx)
                    % if I consider the ssc that has changed, update the changes
                    struct{i} = obj.calculateDf(state, i, destroyedSet, currSeq(i,:));
                else
                    % if is another one, just delete the row of the chosen target
                    struct{i}(tarIndx,:) = [];
                end
            end
        end

    end
end