classdef Target < SpacePosition & FuelContainer 
    
    % Taregt to refill.
    
    methods
        function obj = Target(orbit, trueAnomaly, dryMass, fuelMass, totCap)

            if nargin < 5, totCap = []; end
            if nargin < 4, fuelMass = [];end
            if nargin < 3, dryMass = [];end
            if nargin < 2, trueAnomaly = [];end
            if nargin < 1, orbit = []; end

            obj@SpacePosition(orbit, trueAnomaly);
            obj@FuelContainer(dryMass, fuelMass, totCap);
        end

        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            obj.output@FuelContainer(fid);
            obj.outputPosition(fid);
        end
    end
end