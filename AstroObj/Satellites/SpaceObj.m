classdef (Abstract) SpaceObj

    % Abstract class used to implement common space object properties

    properties
        orbit
        trueAnomaly
    end

    methods
        function obj = SpaceObj(orbit, trueAnomaly)
            obj.orbit = orbit;
            obj.trueAnomaly = trueAnomaly;
        end

        function obj = update(obj, dt)
            obj.trueAnomaly = mod(obj.trueAnomaly + obj.orbit.angVel*dt*180/pi,360);
        end

        function outputPosition(obj,fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            fprintf(fid, 'nu: %.2f, ' , obj.trueAnomaly);
            obj.orbit.output(fid);
        end
    end
end