classdef RepairInsert < Repair

    properties
        nTar
    end

    methods (Abstract)
        [sscIndx, posIndx, desIndx] = chooseTar(obj)
    end

    methods
        function obj = RepairInsert(nTar)
            obj@Repair(nTar);
        end

        function [df, stateStruct] = initialDfStruct(obj, initialState, destroyedSet, tourInfo, seq)
            [~, nSsc] = size(tourInfo.lTour);
            [pos, nPos, lastPos] = obj.getPos(tourInfo, seq);
            sim = Simulator(initialState);
            
            % create and initialize state structure
            stateStruct = cell(nSsc);
            for i = 1:nSSc
                 stateStruct{i} = cell(nPos(i));
            end
            %stateStruct(:,1) = repmat({initialState}, nSSc, 1);
            
            % create and initialize df structure
            lDes = length(destroyedSet);
            df = cell(nSsc);
            
            % for j = 1:lDes
            %     df{j} = zeros(nSSc, nPos);
            % end
            % fuel value of the current slt
            dfCurr = zeros(nSsc,1);
            for i = 1:nSSc
                df{i} = zeros(lDes, nPos(i));
                % updateIndex
                updateIndex = seq(i, seq(i,:) > 0);
                updateIndex = [updateIndex( updateIndex(:) <= obj.nTar), destroyedSet'];

                for p = 1:nPos(i)
                    % saving the state
                    if(p == 1) % saving the first state
                        stateStruct{i}{1} = initialState;
                        stateStruct{i}{1}.targets = stateStruct{i}{1}.targets{updateIndex};
                        if(pos{i}(1)~=1)
                            % if the first state is different from the initial
                            % one, I need to go on with the simulation and
                            % keep in mind that this part will be the same
                            % regarding of what destroyed target I will put
                            [state, infeas, ~] = sim.SimulateSSc(obj, stateStruct{i}{p-1}, i, seq(i,pos{i}(p-1):pos{i}(p)), updateIndex);
                            if(infeas==0)
                                stateStruct{i}{p} = state;
                            end
                            % since in the end I need to store a CHANGE in
                            % the objective function, I don't have to store
                            % this information because this part will not
                            % change in the overall solution
                        end
                    else % saving the other states
                        [state, infeas, totFuel] = sim.SimulateSSc(obj, stateStruct{i}{p-1}, i, seq(i,pos{i}(p-1):pos{i}(p)), updateIndex);
                        if(infeas==0)
                            stateStruct{i}{p} = state;
                            dfCurr(i) = dfCurr(i) + totFuel;
                            % from now on I need to store the original fuel used 
                        end
                    end

                    % populate the df structure
                    % Note that since we do not have the total fuel of the
                    % original route yet, in the matrix will be saved just
                    % the fuel obtained in that specific scenario, then it
                    % will be obtained the requested change
                    for j = 1:lDes
                        newSeq = [seq(i,pos{i}(p)), destroyedSet(j), seq(i,pos{i}(p)+1:lastPos)];
                        [~, infeas, totFuel] = sim.SimulateSSc(obj, stateStruct{i}{p}, i, newSeq, updateIndex);
                        if(infeas == 0)
                            df{i}(j,p) = df{i}(j,p) + totFuel;
                        end
                    end

                    % finish the original simulation
                    if(p == nPos)
                        [~, infeas, totFuel] = sim.SimulateSSc(obj, stateStruct{i}{p}, i, seq(i,pos{i}(p):lastPos), updateIndex);
                        if(infeas == 0)
                            dfCurr(i) = dfCurr(i) + totFuel;
                        end
                    end
                end



            

                
                

            end

            
        end

        
        function [df, stateStruct] = update(obj, sscIndx, seq, state, df, stateStruct)
            % I assume that seq is a row vector, where in the first
            % position is collocated the new added target

            seqOld = seq(2:end);


        end

    end
end