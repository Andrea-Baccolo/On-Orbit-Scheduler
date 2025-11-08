classdef (Abstract) FuelContainer 

    % Implementing Fuel properties.

    properties
        dryMass  % mass of the object WITHOUT the fuel.
        fuelMass % fuel that can be used by the object.
        tot_cap  % total capacity of the satellite's tank.
    end

    methods
        function obj = FuelContainer(dryMass, fuelMass, capacity)

            % METHOD: Constructor.

            % INPUTS:
                % dryMass: mass of the empty satellite.
                % fuelMass: level of fuel in the satellite.
                % tot_cap: maximum tank capacity of the.
            % OUTPUTS:
                % returns object.

            if nargin < 1 , dryMass = []; end
            if nargin < 2 , fuelMass = []; end
            if nargin < 3 , capacity = fuelMass; end

            obj.dryMass = dryMass;
            obj.fuelMass = fuelMass;
            obj.tot_cap = capacity;
        end

        function obj = add_fuel(obj)

            % METHOD: Refilling completely the tank of the object

            % INPUTS: the object to refill

            % OUTPUTS: the object with full capacity

            % add fuel, always refill all tank
            obj.fuelMass = obj.tot_cap;
        end

        function output(obj,fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            fprintf(fid, 'Dry Mass: %.2f, Fuel Mass: %.2f, Tank Capacity: %.2f\n' , obj.dryMass, obj.fuelMass, obj.tot_cap);
        end
    end
end