classdef RepairRandom

    properties 
        prop
        nTar
    end

    methods

        function obj = RepairRandom(prop, nTar)
            obj.prop = prop;
            obj.nTar = nTar;
        end

        function tarIndx = chooseTar(~, destroyedSet)
            lDestroyed = length(destroyedSet);
            tarIndx = randi([1 lDestroyed]);
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

        function slt = Reparing(obj, initialState, destroyedSet, tourInfo)
            nSsc = size(tourInfo.lTour,2);
            stateSsc = repmat({initialState}, nSsc, 1);

            % insert targets in existing tours
            [destroyedSet, tourInfo, stateSsc] = obj.buildTours(destroyedSet, tourInfo, stateSsc);
            
            if(~isempty(destroyedSet))
                lDestroyed = length(destroyedSet);
               % insert targets in new tours

                 %initializing lastTourInfo
                lastTourInfo = TourInfo();
                lastTours = cell(lDestroyed,nSsc);
                lastLTour = zeros(lDestroyed,nSsc);
                lastNTour = zeros(nSSc, 1);
                lastTourInfo = lastTourInfo.artificialTourInfo(lastTours, lastLTour, lastNTour);

                % rebuilding lastTourInfo
                [~, lastTourInfo, ~] = obj.buildTours(destroyedSet, lastTourInfo, stateSsc);

                % cutting lastTourInfo
                lastTourInfo = lastTourInfo.cutTour();

                % merging in newTourInfo
                tourInfo = newTourInfo.artificialTourInfo(...
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

        function [destroyedSet, tourInfo, stateSsc] = buildTours(obj, destroyedSet, tourInfo, stateSsc)
            [nTour, nSSc] = size(tourInfo.lTour);
            % nTar = length(simulator.simState.targets);
            lDestroyed = length(destroyedSet);
            currTour = 1;
            currSSc = 1;
            % create update index 
            updateIndex = obj.createUpdateIndex(tourInfo, destroyedSet, currTour, currSSc);
            sim = Simulator(stateSsc{currSSc});

            while(~isempty(destroyedSet) && currTour<= nTour)
                % try to insert some targets
                if(isempty(tourInfo.tours{currTour, currSSc}))
                    % choose target
                    tarIndx = obj.chooseTar(destroyedSet);
                    tarSelect = destroyedSet(tarIndx);

                    % update new tour
                    addedTour = obj.insertTar([], tarSelect, 1);
                    tourInfo.tours{currTour, currSSc} = addedTour;
                    tourInfo.lTour(currTour, currSSc) = tourInfo.lTour(currTour, currSSc) + 1;
                    tourInfo.nTour(currSSc) = tourInfo.nTour(currSSc) + 1;

                    % remove the target that has been inserted
                    destroyedSet(tarIndx) = [];
                    lDestroyed = lDestroyed - 1;
                    fprintf("beginning of tour, %d target left!\n",lDestroyed)
                else
                    nSearch = ceil((obj.prop/100)*lDestroyed);
                    currDestroyedSet = destroyedSet;
                    lCurrDestroyed = lDestroyed;
                    infeasCount = 0;
                    % try to insert the sscs nK times
                    while(infeasCount < nSearch && ~isempty(currDestroyedSet))

                        % reset state
                        currState = stateSsc{currSSc};
                        
                        % choose random target
                        tarIndx = obj.chooseTar(currDestroyedSet);
                        tarSelect = currDestroyedSet(tarIndx);

                        % select random position on the tour
                        posSelect = randi([1 (tourInfo.lTour(currTour, currSSc)+1)]);

                        % create new tour
                        addedTour = obj.insertTar(tourInfo.tours{currTour, currSSc}, tarSelect, posSelect);
                        
                        % check feasibility
                        %%%%%%%%%%%%%%%%
                        [~, infeas, ~, ~, ~] = sim.SimulateSeq(currState, currSSc, addedTour, updateIndex);
                                                                
                        if(infeas==0)
                            % save new tour
                            tourInfo.tours{currTour, currSSc} = addedTour(2:end-1);
                            tourInfo.lTour(currTour, currSSc) = tourInfo.lTour(currTour, currSSc) + 1;

                            % remove the target dall'original destroyed

                            % in this while, this tarIndx is calculated with
                            % respect to currDestroyesSet, that means when
                            % eliminating the target from the Destroyed set, I
                            % need to find the right index 
                            destroyedSet(destroyedSet==tarSelect) = [];
                            lDestroyed = lDestroyed - 1;
                            fprintf("%d target left!\n",lDestroyed)
                            % exit
                            break;
                        else
                            infeasCount = infeasCount + 1;
                            % remove from the random set the target that has
                            % been tested
                            currDestroyedSet(tarIndx) = [];
                            lCurrDestroyed = lCurrDestroyed - 1;
                            
                            fprintf("%d current target left!\n",lCurrDestroyed)
                        end
                    end
                    if(infeasCount == nSearch || isempty(currDestroyedSet))

                        % prepare state for the next tour of same ssc
                        %%%%%%%%%%%%%%%%
                        [stateSsc{currSSc}, ~] = sim.SimulateSeq(currState, currSSc, [0 tourInfo.tours{currTour, currSSc} 0], updateIndex);

                        % go to the other tours or sscs
                        currSSc = currSSc + 1;
                        currTour = currTour + (currSSc == nSSc + 1);
                        currSSc = currSSc - nSSc*(currSSc == nSSc + 1);
                        fprintf("change to tour %d of ssc %d\n",currTour, currSSc)

                        updateIndex = obj.createUpdateIndex(tourInfo, destroyedSet, currTour, currSSc);
                    end
                 end
            end
        end

        function updateIndex = createUpdateIndex(~, tourInfo, destroyedSet, currTour, currSsc)
            lDestroyed = length(destroyedSet);
            [nTour, ~] = size(tourInfo.lTour);
            % create new updateIndex
            if(size(tourInfo.lTour(currTour:end,:),1)==1)
                lenTours = tourInfo.lTour(currTour:end,:);
            else
                lenTours = sum(tourInfo.lTour(currTour:end,:));
            end
            updateIndex = -1*ones(1, lenTours(currSsc) + lDestroyed);
            updateIndex(1:lDestroyed) = destroyedSet';
            index = lDestroyed + 1;
            for h = 1:nTour
                if(tourInfo.lTour(h,currSsc)~=0)
                    updateIndex(index:index + tourInfo.lTour(h,currSsc)-1) = tourInfo.tours{h,currSsc};
                    index = index + tourInfo.lTour(h,currSsc);
                end
            end
        end
    end
end
