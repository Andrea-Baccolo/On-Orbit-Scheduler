classdef RepairInsert < Repair

    properties
        nTar
    end

    methods
        function obj = RepairInsert(nTar)
            obj@Repair(nTar);
        end

        function [df, stateStruct] = initialDfStruct(obj, stateSSc, destroyedSet, tourInfo, currSeq)
            % create stateStruct
            [~, nSSc] = size(tourInfo.lTour);
            lDes = length(destroyedSet);
            if(isscalar(tourInfo.lTour))
                lenTours = tourInfo.lTour;
            else
                lenTours = sum(tourInfo.lTour,1);
            end
            % this is all the possible positions where I can put a target,
            % which corresponds to all the passage from a point to the
            % sequence to another: nPos(i) = nSeq(i) -1
            nPos = lenTours + tourInfo.nTour;
            % this instance allocates more cells for speed reasons
            nPosMax = max(nPos + lDes*ones(1,nSSc));

            stateStruct = cell(nSSc, nPosMax);
            stateStruct(:,1) = stateSSc;
            sim = Simulator(stateSSc{1});

            % creation of df structure
            df = cell(nSSc);
            % fuel value of the current slt
            % to reduce the total number of reach, I will simulate all the sequence
            dfCurr = zeros(nSSc,1);
            for i = 1:nSSc
                df{i} = zeros(lDes, nPos(i));
                % updateIndex
                updateIndex = obj.createUpdateIndex(tourInfo, destroyedSet, 1, i);
                for p = 1:nPos(i)
                    % POPULATE DF STRUCTURE
                    % Note that since we do not have the total fuel of the
                    % original route yet, in the matrix will be saved just
                    % the fuel obtained in that specific scenario, then it
                    % will be obtained the requested change
                    finalSeq = p+1:nPos(i)+1;
                    for j = 1:lDes
                        % to reduce the total number of reach, I will simulate all the sequence
                        newSeq = [ seq(i, p), destroyedSet(j), seq(i,finalSeq)];
                        [~, infeas, totFuel, ~, ~] = sim.SimulateSeq(stateStruct{i,p}, i, newSeq, updateIndex);
                        if(infeas == 0)
                            df{i}(j,p) = df{i}(j,p) + totFuel;
                        else
                            df{i}(j,p) = inf;
                        end
                    end

                    % FILL THE STATESTRUCTURE
                    % simulate from currentSeq
                    [state, infeas, totFuel, ~, ~] = sim.SimulateReach(stateStruct{i,p}, i, currSeq(p+1), updateIndex);
                    if(~infeas)
                        stateStruct{i,p+1} = state;
                        dfCurr(i) = dfCurr(i) + totFuel;
                        % to reduce the number of reach, I will add totFuel
                        % to df{i}(:,finalSeq), to avoid restarting the
                        % simulation for the destroyedSet and to avoid to
                        % simulate the currentSeq too much
                        if p<nPos(i)
                            df{i}(:,p+1) = df{i}(:,p+1) + dfCurr(i)*ones(lDes, p+1);
                        end
                    else
                        error("Part of the old solution must not be infeasible")
                    end
                end
            end

     
        end

        function [destroyedSet, tourInfo, stateSsc] = buildTours(obj, destroyedSet, tourInfo, stateSsc)
            % creating the sequence
            currSeq = TourInfo.rebuildSeq(obj.nTar);

            % generating initial structures
            [df, stateStruct] = obj.initialDfStruct(stateSSc, destroyedSet, tourInfo, currSeq);
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
                [df, stateStruct] = obj.updateStruct(sscIndx, currSeq, df, stateStruct);
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

        function [df, stateStruct] = updateStruct(obj, sscIndx, seq, state, df, stateStruct)
            % I assume that seq is a row vector, where in the first
            % position is collocated the new added target

            seqOld = seq(2:end);


        end

    end
end