classdef Station < SpacePosition & RefillProp

    % Fuel station object.
    
    methods
        function obj = Station(orbit, trueAnomaly, speedRefill)

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