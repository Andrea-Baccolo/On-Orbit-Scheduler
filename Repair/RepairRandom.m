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
            slt = Solution([],0);
            nSsc = size(tourInfo.lTour,2);
            stateSsc = repmat({initialState}, nSsc, 1);

            % insert targets in existing tours
            [destroyedSet, tourInfo, stateSsc] = obj.buildTours(destroyedSet, tourInfo, stateSsc);
            
            if(~isempty(destroyedSet))
               % insert targets in new tours
                newTours = cell(lDestroyed,nSsc);
                newLTours = zeros(lDestroyed,nSsc);
                [~, newCellTours, newLTours, ~] = obj.buildTours(destroyedSet, newTours, newLTours, stateSsc);
                [newCellTours, newLTours] = cutTours(newCellTours, newLTours);
                tourInfo.tours = [cellTours; newCellTours];
                tourInfo.lenTours = [tourInfo.lTour; newLTours];
            else
                tourInfo = tourInfo.cutTours(cellTours, tourInfo.lTour);
            end
            
            slt = slt.rebuildSeq(tourInfo);
        end

        function [destroyedSet, tourInfo, stateSsc] = buildTours(obj, destroyedSet, tourInfo, stateSsc)
            [nTour, nSsc] = size(tourInfo.lTour);
            % nTar = length(simulator.simState.targets);
            lDestroyed = length(destroyedSet);
            currTour = 1;
            currSsc = 1;
            % create update index 
            updateIndex = obj.createUpdateIndex(tourInfo, destroyedSet, currTour, currSsc);
            sim = Simulator(stateSsc{currSsc});

            while(~isempty(destroyedSet) && currTour<= nTour)
                % try to insert some targets
                if(isempty(tourInfo.tours{currTour, currSsc}))
                    % choose target
                    tarSelect = destroyedSet(obj.chooseTar(destroyedSet));

                    % update new tour
                    addedTour = obj.insertTar([], tarSelect, 1);
                    tourInfo.tours{currTour, currSsc} = addedTour;
                    tourInfo.lTour(currTour, currSsc) = tourInfo.lTour(currTour, currSsc) + 1;

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
                    while(infeasCount <= nSearch && ~isempty(currDestroyedSet))

                        % reset state
                        currState = stateSsc{currSsc};
                        
                        % choose random target
                        tarIndx = obj.chooseTar(currDestroyedSet);
                        tarSelect = currDestroyedSet(tarIndx);

                        % select random position on the tour
                        posSelect = randi([1 (tourInfo.lTour(currTour, currSsc)+1)]);

                        % create new tour
                        addedTour = obj.insertTar(tourInfo.tours{currTour, currSsc}, tarSelect, posSelect);
                        
                        % check feasibility
                        %%%%%%%%%%%%%%%%
                        [~, infeas, ~, ~, ~] = sim.SimulateSeq(currState, currSsc, addedTour, updateIndex);
                                                                
                        if(infeas==0)
                            % save new tour
                            tourInfo.tours{currTour, currSsc} = addedTour(2:end-1);
                            tourInfo.lTour(currTour, currSsc) = tourInfo.lTour(currTour, currSsc) + 1;

                            % remove the target dall'original destroyed
                            destroyedSet(tarIndx) = [];
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
                        
                        
                        [stateSsc{currSsc}, ~] = sim.SimulateSeq(currState, currSsc, [0 tourInfo.tours{currTour, currSsc} 0], updateIndex);

                        % go to the other tours or sscs
                        currSsc = currSsc + 1;
                        currTour = currTour + (currSsc == nSsc + 1);
                        currSsc = currSsc - nSsc*(currSsc == nSsc + 1);
                        fprintf("change to tour %d of ssc %d\n",currTour, currSSc)

                        updateIndex = obj.createUpdateIndex(tourInfo, destroyedSet, currTour, currSsc);
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
