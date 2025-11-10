classdef (Abstract) SpacePosition

    % Abstract class used to implement position

    properties
        orbit  % orbit object containing the orbit informations
        trueAnomaly % angle defining the position on the orbit.
    end

    methods
        function obj = SpacePosition(orbit, trueAnomaly)

            % METHOD: Constructor

            % INPUTS:
                % orbit: orbit of the satellite.
                % trueAnomaly: angle that describe the position on the
                    % orbit, measured from the ascending node with respect 
                    % of the dirction of the rotation.
            % OUTPUTS:
                % requested object.

            if nargin < 1, orbit = []; end
            if nargin < 2, trueAnomaly = []; end
            
            obj.orbit = orbit;
            obj.trueAnomaly = trueAnomaly;
        end

        function obj = update(obj, dt)

            % METHOD: updating the object position after dt time

            % INPUTS:
                % obj: object to update
                % dt: time to update
            % OUTPUTS:
                % requested updated object.

            obj.trueAnomaly = mod(obj.trueAnomaly + obj.orbit.angVel*dt*180/pi,360);
        end

        function outputPosition(obj,fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            fprintf(fid, 'nu: %.2f, ' , obj.trueAnomaly);
            obj.orbit.output(fid);
        end
    end
end