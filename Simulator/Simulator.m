classdef Simulator

    properties
        initialState
    end

    methods

        function obj = Simulator(initialState)
            obj.initialState = initialState;
        end
        % Simulation methods ---------------------------------------------------------------------------------------

        function [simState, infeas, totFuel, totTime, maneuvers] = SimulateReach(~, simState, sscIndx, targetIndx, updateIndex, fid) 
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