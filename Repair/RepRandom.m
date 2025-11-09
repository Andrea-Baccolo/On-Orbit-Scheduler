classdef RepRandom < Repair

    % Random Repair method. It tries to randomly insert targets to every
    % tours, after found some infeasibility, it passes to another tour and
    % performed some other random checks until it finishes all destroy targets.
    properties 
        prop
    end

    methods

        function obj = RepRandom(nTar, prop)

            % METHOD: Constructor

            % INPUTS:
                % nTar: number of targets.
                % prop: proportion to check when using the random repair, between 0
                    % and 1 , 1 is default.

            % OUTPUTS:
                % obj: Repair object.

            if nargin < 1, nTar = 0; end
            if nargin < 2, prop = 0; end
            obj@Repair(nTar);
            obj.prop = prop;
        end

        function tarIndx = chooseTar(~, destroyedSet)

            % METHOD: function used to choose the target.

            % INPUTS:
                % obj: Repair object.
                % destroyedSet: vector from which the random taarget is
                    % extracted

            % OUTPUTS:
                % tarIndx: the target extracted.

            % chooose random destroyed target
            lDestroyed = length(destroyedSet);
            tarIndx = randi([1 lDestroyed]);
        end

        function tourInfo = buildTours(obj, destroyedSet, tourInfo, initialState)

            % METHOD: general function that adds to the TourInfo the targets in a feasible way.

            % INPUTS:
                % obj: repair object.
                % destroyedSet: row vector of destroyed set index.
                % tourInfo: tourInfo object with info of tours after the destruction.
                % stateSsc: state object that contains the initial info.

            % OUTPUTS:
                % tourInfo: the updated tourInfo information ready to be transformed into a sequence.

            [nTour, nSSc] = size(tourInfo.lTour);
            stateSSc = repmat({initialState}, nSSc, 1);
            % nTar = length(simulator.simState.targets);
            lDestroyed = length(destroyedSet);
            currTour = 1;
            currSSc = 1;
            % create update index 
            updateIndex = obj.updateIndexTour(tourInfo, destroyedSet, currTour, currSSc);
            sim = Simulator(stateSSc{currSSc});

            while(~isempty(destroyedSet))
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
                    %fprintf("beginning of tour, %d target left!\n",lDestroyed)
                else
                    nSearch = ceil((obj.prop/100)*lDestroyed);
                    currDestroyedSet = destroyedSet;
                    lCurrDestroyed = lDestroyed;
                    infeasCount = 0;
                    % try to insert the sscs nK times
                    while(infeasCount < nSearch && ~isempty(currDestroyedSet))

                        % reset state
                        currState = stateSSc{currSSc};
                        
                        % choose random target
                        tarIndx = obj.chooseTar(currDestroyedSet);
                        tarSelect = currDestroyedSet(tarIndx);

                        % select random position on the tour
                        posSelect = randi([1 (tourInfo.lTour(currTour, currSSc)+1)]);

                        % create new tour
                        addedTour = obj.insertTar(tourInfo.tours{currTour, currSSc}, tarSelect, posSelect);
                        
                        % check feasibility
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
                            %fprintf("%d target left!\n",lDestroyed)
                            % exit
                            break;
                        else
                            infeasCount = infeasCount + 1;
                            % remove from the random set the target that has
                            % been tested
                            currDestroyedSet(tarIndx) = [];
                            lCurrDestroyed = lCurrDestroyed - 1;
                            
                            %fprintf("%d current target left!\n",lCurrDestroyed)
                        end
                    end
                    if(infeasCount == nSearch || isempty(currDestroyedSet))

                        % prepare state for the next tour of same ssc
                        [stateSSc{currSSc}, ~] = sim.SimulateSeq(currState, currSSc, [0 tourInfo.tours{currTour, currSSc} 0], updateIndex);

                        % go to the other tours or sscs
                        %fprintf("change from %d,%d ", currTour, currSSc)
                        currSSc = currSSc + 1;
                        currTour = currTour + (currSSc == nSSc + 1);
                        currSSc = currSSc - nSSc*(currSSc == nSSc + 1);
                        
                        if(currTour > nTour)
                            tourInfo = tourInfo.expand();
                            nTour = nTour + 1;
                        end
                        %fprintf("to %d,%d (tour,ssc)\n", currTour, currSSc)
                        updateIndex = obj.updateIndexTour(tourInfo, destroyedSet, currTour, currSSc);
                    end
                 end
                 
            
            
            end
        end

    end
end
