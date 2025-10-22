classdef SSc < SpaceObj & RefillProp & FuelContainer 

    % Service Spacecraft (Ssc).

    properties
        specificImpulse
    end

    properties (Constant)
        g0 = 9.81; % m/s^2
    end

    methods
        function obj = SSc(orbit, trueAnomaly, dryMass, fuelMass, totCap, speedRefill, specificImpulse)
            if nargin < 7, specificImpulse = []; end
            if nargin < 6, speedRefill = []; end
            if nargin < 5, totCap = []; end
            if nargin < 4, fuelMass = [];end
            if nargin < 3, dryMass = [];end
            if nargin < 2, trueAnomaly = [];end
            if nargin < 1, orbit = []; end   

            obj@SpaceObj(orbit, trueAnomaly);
            obj@RefillProp(speedRefill);
            obj@FuelContainer(dryMass, fuelMass, totCap);
            obj.specificImpulse = specificImpulse;
        end

        function [finalFuelMass, fuel, infeas] = calculateFuel(obj, dv, fuelSSc)
            finalMass = (fuelSSc + obj.dryMass)/exp(dv/(obj.g0*obj.specificImpulse));
            fuel = (fuelSSc + obj.dryMass) - finalMass;
            finalFuelMass = fuelSSc - fuel;
            if(finalFuelMass<0)
                infeas = 1;
            else
                infeas = 0;
            end
        end

        function obj = giveFuel(obj, quantity)
            obj.fuelMass = obj.fuelMass - quantity;
        end

        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            obj.output@FuelContainer(fid);
            obj.output@RefillProp(fid);
            fprintf(fid, 'Specific Impulse: %.2f, ' , obj.specificImpulse);
            obj.outputPosition(fid);
        end
    end
end