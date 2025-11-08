classdef Simulator

    % Collection of methods used to update a state through simulation.

    properties
        initialState
    end

    methods

        function obj = Simulator(initialState)

            % METHOD: Constructor

            % INPUTS:
                % initialState: state object with the initial targets and sscs.

            % OUTPUTS:
                % obj: returns simulator object.

            obj.initialState = initialState;
        end

        function [simState, infeas, totFuel, totTime, maneuvers] = SimulateReach(~, simState, sscIndx, targetIndx, updateIndex, fid) 

            % METHOD: function used to simulate oen single ssc that reaches
                % one single target

            % INPUTS:
                % obj: Simulator object, even if the function does not use
                    % it, it still needs to be passed as paramethers.
                % simState: initial state from which it will be computed
                    % the simulation and the maneuvers.
                % sscIndx: index of ssc in the initial state vector of sscs.
                % targetIndx: index of target to reach in the initial state vector of sscs.
                % updateIndex: index of targets to update.
                % fid: optional paramethers used to display or write into a file.

            % OUTPUTS:
                % simState: State object that contains initial state info.
                % infeas: flag of infeasibility: 1 if infeasible, 0 if feasible.
                % totFuel: total fuel consumption.
                % totTime: total time that takes to perform the reach.
                % maneuvers: cell arrays with the maneuvers that needs to
                    % be performed.

            if nargin <6, fid = 0; end
            % Initial output
            if(fid>0)
                fprintf(fid,'\nSSC %d REACH TARGET %d, time %.3f\n', sscIndx, targetIndx, simState.t);
                simState.output(fid, sscIndx, updateIndex);
            end
            totFuel = 0;
            totTime = 0;
            % reach 
            if(targetIndx ~=0)
                [maneuvers, infeas] = reach(simState.sscs(sscIndx), sscIndx, simState.targets(targetIndx), targetIndx);
            else
                [maneuvers, infeas] = reach(simState.sscs(sscIndx), sscIndx, simState.station, 0);
            end

            if(~infeas) % if feasible
                for i = 1:length(maneuvers)
                    % execute maneuver and update the ssc
                    [simState, fuelUsed] = maneuvers{i}.execute(simState);
    
                    % output 
                    totFuel = totFuel + fuelUsed;
                    totTime = totTime + maneuvers{i}.dt;

                    % update positions
                    simState = simState.partialUpdate(maneuvers{i}.dt, updateIndex);
                    simState.t = simState.t + maneuvers{i}.dt;
                    
                    %dispay new positions
                    if(fid>0)
                        fprintf(fid,'%s:\n', maneuvers{i}.type);
                        simState.output(fid, sscIndx, updateIndex);
                    end
                end
            end
        end
    
        function [simState, infeas, totFuel, totTime, maneuvers] = SimulateSeq(obj, simState, sscIndx, seq, updateIndex, fid)

            % METHOD: function used to simulate the sequence given in
                % input. With respect to the solution sequence, it is a
                % specific row or can be a portion of it.

            % INPUTS:
                % obj: Simulator object, even if the function does not use
                    % it, it still needs to be passed as paramethers.
                % simState: initial state from which it will be computed
                    % the simulation and the maneuvers.
                % sscIndx: index of ssc in the initial state vector of sscs.
                % seq: sequence to simulate. In can be aso a tour or a
                    % portion of a row of the original sequence
                % updateIndex: index of targets to update.
                % fid: optional paramethers used to display or write into a file.

            % OUTPUTS:
                % simState: State object that contains initial state info.
                % infeas: flag of infeasibility: 1 if infeasible, 0 if feasible.
                % totFuel: total fuel consumption.
                % totTime: total time that takes to perform the reach.
                % maneuvers: cell arrays with the maneuvers that needs to
                    % be performed.

            if nargin <6, fid = 0; end

            nTar = length(simState.targets);
            % clean sequence
            seq(seq > nTar) = [];
            nStep = length(seq)-1;
            % inizialising stuff 
            totFuel = inf*ones(nStep,1);
            maneuvers = cell(1,nStep);
            totTime = 0*ones(nStep,1);
            infeas = 0;
            for t = 2:nStep+1
                % simulate reach
                [simState, infeas, fuel, time, man] = obj.SimulateReach(simState, sscIndx, seq(t), updateIndex, fid);
                if(infeas)
                    infeas = t;
                    totFuel = [];
                    totTime = [];
                    maneuvers = [];
                    break;
                else
                    totTime(t-1) = time;
                    totFuel(t-1) = fuel;
                    maneuvers{t-1} = man;
                end
            end
        end
        
    end
end