classdef RepairInsert < Repair

    properties
        nTar
    end

    methods
        function obj = RepairInsert(nTar)
            obj@Repair(nTar);
        end

        function df_i = calculateDf(obj, initialState, sscIndx, destroyedSet, currSeq)
            % currSeq è un vettore, gli passo solo il vettorino che mi serve
            lDes = length(destroyedSet);
            nPos = lenght(currSeq) - 1;
            state = initialState;
            sim = Simulator(state);
            df_i = zeros(lDes, nPos);
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
                    newSeq = [ seq(p), destroyedSet(j), seq(finalSeq)];
                    [~, infeas, totFuel, ~, ~] = sim.SimulateSeq(state, sscIndx, newSeq, updateIndex);
                    if(infeas == 0)
                        df_i(j,p) = df_i(j,p) + totFuel;
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
            df_i = df_i - dfCurr*ones(lDes,nPos);
        end

        function df = initialDfStruct(obj, initialState, destroyedSet, currSeq)
            nSSc = size(currSeq,1);
            df = cell(nSSc,1);
            for i = 1:nSSc
                df{i} = obj.calculateDf(initialState, i, destroyedSet, currSeq(i));
            end
        end

        function [destroyedSet, tourInfo, stateSsc] = buildTours(obj, destroyedSet, tourInfo, stateSsc)
            % creating the sequence
            currSeq = TourInfo.rebuildSeq(obj.nTar);

            % generating initial structures
            [df, stateStruct, nPos] = obj.initialDfStruct(stateSSc, destroyedSet, tourInfo, currSeq);
            while(~isempty(destroyedSet))
                % choose target
                [tarIndx, sscIndx, posSeq] = obj.chooseTar(df);

                % RETURN INDX:go from sequence position to tour position
                [tourIndx, posIndx] = tourInfo.Seq2Tour(posSeq, sscIndx);

                % insert target
                newTour = obj.insertTar(tourInfo.tours(tourIndx,sscIndx), tarIndx, posIndx);

                % save new tour
                if(isempty(tourInfo.tours{tourIndx, sscIndx}))
                    tourInfo.nTour(sscIndx) = tourInfo.nTour(sscIndx) + 1;
                end
                tourInfo.tours{tourIndx, sscIndx} = newTour(2:end-1);
                tourInfo.lTour(tourIndx, sscIndx) = tourInfo.lTour(tourIndx, sscIndx) + 1;
                
                % delete tarIndx form destroyedSet
                destroyedSet(tarIndx) = [];
                currSeq = tourInfo.rebuildSeq(obj.nTar);

                % update df and stateStruct
                [df, stateStruct] = obj.updateStruct(sscIndx, posSeq, currSeq, df, stateStruct, nPos);
            end

        end

        function [tarIndx, sscIndx, posSequence] = chooseTar(~, df)
            lDes = size(df{1},1);
            nSSc = length(df);

            % SELECT TAR: ind the target (tarIndx)
            insCost = zeros(lDes,1);
            insPos = zeros(lDes,1);
            insSSc = zeros(lDes,1);
            for j = 1:lDes % for every destroyed target
                posSeq = zeros(nSSc, 1);
                c = zeros(nSSc,1);
                for i = 1:nSSc % for every SSc
                    % minimum cost saving the positions
                    [c(i), posSeq(i)] = min(df{i}(j,:));
                end
                % minimum over all the SScs saving the positions and the SSc
                [insCost(j), insSSc(j)] = min(c);
                insPos(j) = posSeq(insSSc(j));
            end
            % argmax over the insertion cost
            [~,tarIndx] = max(insCost);
            sscIndx = insSSc(tarIndx);
            posSequence = insPos(tarIndx);


        end

        function [df, stateStruct] = updateStruct(obj, sscIndx, posSeq, currSeq, df, stateStruct, nPos)
            % UPDATE STATESTRUCT
            % I need to simulate from posSeq until the end 
            % I can use the state in position posSec
            nPos(sscIndx) = nPos(sscIndx) + 1;

            [state, infeas, totFuel, ~, ~] = sim.SimulateReach(stateStruct{sccIndx,posSeq}, sccIndx, currSeq(posSeq+1), updateIndex);
            if(~infeas)
                stateStruct{sccIndx,posSeq+1} = state;
                dfCurr(sccIndx) = dfCurr(sccIndx) + totFuel;
                % to reduce the number of reach, I will add totFuel
                % to df{i}(:,finalSeq), to avoid restarting the
                % simulation for the destroyedSet and to avoid to
                % simulate the currentSeq too much
                if p<nPos(sccIndx)
                    df{sccIndx}(:,p+1) = df{sccIndx}(:,p+1) + dfCurr(sccIndx)*ones(lDes, p+1);
                end
            else
                error("Part of the old solution must not be infeasible")
            end



            % UPDATE DF


        end

    end
end