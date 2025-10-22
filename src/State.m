classdef State 
    
    properties
        sscs % cell array of nssc SSc
        targets % cell array of nTar Targets 
        station
        t % starting point of the state
    end

    methods

        function obj = State(sscs, targets, station, time)
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