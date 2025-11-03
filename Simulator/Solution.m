classdef Solution 

    % class used to collect solution's information.

    properties
        seq       % refeuling sequence for every ssc (nSsc, m)

        sscMan    % cell array containing cell arrays of maneuver selected from seq
        fuelUsage % quantity of fuel used to reach every target
        times     % time employed for every maneuver
        totFuel   % total fuelUsage for the solution

        tourInfo % Tour informations
    end

    methods

        function obj = Solution(seq, nTar, initialState)
            if nargin < 1, seq = []; end
            obj.seq = seq;
            [n,m] = size(seq);
            obj.sscMan = cell(n, m-1);
            obj.fuelUsage = zeros(n, m-1);
            obj.totFuel = 0;
            obj.times = zeros(n, m-1);
            if nargin > 1
                obj.tourInfo = TourInfo(seq, nTar);
            else
                obj.tourInfo = TourInfo();
            end
            if nargin > 2
                obj = obj.buildManSet(initialState);
            end
        end
        
        function obj = artificialSlt(obj, seq, sscMan, fuelUsage, times, nTar)
            % from existing inputs, create the object
            obj.sscMan = sscMan;
            obj.fuelUsage = fuelUsage;
            obj.times = times;
            obj.totFuel = sum(sum(fuelUsage));
            obj.tourInfo = TourInfo(seq, nTar);
        end

        function [obj, state] = buildManSet(obj, initialState, fid) 

            % create set of maneuvers to reach targes

            if nargin < 3, fid = 0; end
            simulator = Simulator(initialState);
            
            nTar = length(simulator.initialState.targets);
            nSSc = size(obj.seq,1);
            state = simulator.initialState;
            for i = 1:nSSc % for every ssc
                state.station = simulator.initialState.station; % station at initial point
                state.t = 0;
                % create the set of Target that need to be update 
                updateIndx = obj.generateUpdateIndx(obj.seq, nTar, i);
                sequence = obj.seq(i,:);
                if(~isempty(updateIndx))
                    [state, infeas, fuel, totTime, maneuvers] = simulator.SimulateSeq(state, i, sequence, updateIndx, fid);
                    if(infeas~=0)
                        error('SSc %d Position %d is not feasible', i, infeas);
                    else
                        len = length(fuel);
                        obj.fuelUsage(i,1:len) = fuel';
                        obj.times(i,1:len) = totTime';
                        obj.sscMan(i, 1:len) = maneuvers;
                    end
                end
            end
            obj.totFuel = sum(sum(obj.fuelUsage));        
            
            % set time and position right
            if(nSSc > 1 )
                totalTimes = sum(obj.times,2);
                [maxTime, maxTimeIndx] = max(totalTimes);
                timeIndx = 1:nSSc;
                timeIndx(maxTimeIndx) = [];
                for i = 1:length(timeIndx)
                    % get the target that have to be update
                    updateIndx = obj.generateUpdateIndx(obj.seq, nTar, timeIndx(i));
                    % update ssc
                    state.sscs(timeIndx(i)) = state.sscs(timeIndx(i)).update(maxTime - totalTimes(timeIndx(i)));
                    % update targets
                    for j = 1:length(updateIndx)
                        state.targets(updateIndx(j)) = state.targets(updateIndx(j)).update(maxTime - totalTimes(timeIndx(i)));
                    end
                end
                % the station have to be updated with the time of the last ssc
                state.station = state.station.update(maxTime - totalTimes(end));
                state.t = maxTime;
            end

            if(fid>0), obj.output(fid); end
        end 

        function updateIndx = generateUpdateIndx(~, seq, nTar, i)
            updateIndx = seq(i, seq(i,:) > 0);
            updateIndx = updateIndx( updateIndx(:) <= nTar);
        end

        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            nSSc = size(obj.fuelUsage,1);
            fprintf(fid, 'The solution used %.2f Kg of fuel', obj.totFuel);
            fprintf(fid, ', in particular:\n');
            for i = 1:nSSc
                fprintf(fid, 'SSc %d: %10.2f ', i, obj.fuelUsage(i,:));
                fprintf(fid, '\n');
            end
        
            % Dettaglio times
            fprintf(fid, 'The time is divided in the following way:\n');
            for i = 1:nSSc
                fprintf(fid, 'SSc %d: %10.2f ', i, obj.times(i,:));
                fprintf(fid, '\n');
            end
        
            % Output missionInfo
            obj.tourInfo.output(fid);
        end

    end
        

end