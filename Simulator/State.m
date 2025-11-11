classdef State 
    
    % Class that contains information about the Problem in a specific point in time

    properties
        sscs    % vector of nssc SSc
        targets % vector of nTar Targets 
        station % fuel station
        t       % starting point of the state
    end

    methods

        function obj = State(sscs, targets, station, time)

            % METHOD: Constructor

            % INPUTS: 
                % sscs: vector of ssc objects.
                % targets: vector of target objects.
                % station: station oblect.
                % time: time instant of the state.

            % OUTPUTS:
                % state object.

            if nargin < 1, sscs = SSc(); end
            if nargin < 2, targets = Target(); end
            if nargin < 3, station = Station(); end
            if nargin < 4, time = 0; end
            
            obj.sscs = sscs;
            obj.targets = targets;
            obj.station = station;
            obj.t = time;
        end

        function obj = partialUpdate(obj, dt, updateIndex) 


            % METHOD: this function update the positions of the targets and the
                % station, that is why is called partial. the ssc position is 
                % always updated during the execution of the maneuvers. 
                % a specific set of satellites can be updated to indipendently
                % cosider the path of every sscs.

            % INPUTS:
                % obj: state to update
                % dt: interval of time from which I need to update the
                    % objects.
                % updateIndex: index of targets to be update.

            % OUTPUTS:
                % updated state object.

            if(dt~=0)
                % update all usefull targets
                for k = 1:length(updateIndex)
                     obj.targets(updateIndex(k)) = obj.targets(updateIndex(k)).update(dt);
                end
                % update the station 
                obj.station = obj.station.update(dt);
            end
        end

        function output(obj, fid, i, updateIndex)

            % METHOD: function that print ror write the updated position of the ssc i and some targets.

            % INPUTS:
                % obj: state to update
                % fid: value to pass in the fprintf functions, if 1 it
                    % display everything, if grater than 1 it implies a file
                    % has been open and therefore it will write on thah file
                % i: ssc to print
                % updateIndex: set of targets to print

            if nargin<2, fid = 1; end
            if nargin<3, i = 1; end
            if nargin<4
                nTar = length(obj.targets);
                updateIndex = 1:nTar;
            end

            fprintf(fid, "Station position:");
            obj.station.outputPosition(fid);
            fprintf(fid, "SSc %d position:",i);
            obj.sscs(i).outputPosition(fid);
            for j = 1:length(updateIndex)
                fprintf(fid, "Target %d position:", updateIndex(j));
                obj.targets(updateIndex(j)).outputPosition(fid);
            end
        end


    end
end