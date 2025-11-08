classdef Station < SpacePosition & RefillProp

    % Fuel station object.
    
    methods
        function obj = Station(orbit, trueAnomaly, speedRefill)

            % METHOD: Constructor
                
            % INPUTS:
                % orbit: orbit of the satellite.
                % trueAnomaly: angle that describe the position on the
                    % orbit, measured from the ascending node with respect 
                    % of the dirction of the rotation.
                % speedRefill: refueling speed in L/s.
            % OUTPUTS:
                % station obj.

            if nargin < 3, speedRefill = []; end
            if nargin < 2, trueAnomaly = [];end
            if nargin < 1, orbit = []; end
            
            obj@SpacePosition(orbit, trueAnomaly);
            obj@RefillProp(speedRefill);
        end

        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            obj.output@RefillProp(fid);
            obj.outputPosition(fid);
        end
    end
end