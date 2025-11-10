classdef SSc < SpacePosition & RefillProp & FuelContainer 

    % Service Spacecraft (Ssc).

    properties
        specificImpulse % quantity that measures the efficecy of the spacecraft [s^-1]
    end

    properties (Constant)
        g0 = 9.81; % m/s^2
    end

    methods
        function obj = SSc(orbit, trueAnomaly, dryMass, fuelMass, totCap, speedRefill, specificImpulse)

            % METHOD: Constructor
                
            % INPUTS:
                % orbit: orbit of the satellite.
                % trueAnomaly: angle that describe the position on the
                    % orbit, measured from the ascending node with respect 
                    % of the dirction of the rotation.
                % dryMass: mass of the empty satellite.
                % fuelMass: level of fuel in the satellite.
                % tot_cap: maximum tank capacity of the.
                % speedRefill: refueling speed in L/s.
                % specificImpulse: specific impulse of the ssc.
            % OUTPUTS:
                % ssc obj.

            if nargin < 7, specificImpulse = []; end
            if nargin < 6, speedRefill = []; end
            if nargin < 5, totCap = []; end
            if nargin < 4, fuelMass = [];end
            if nargin < 3, dryMass = [];end
            if nargin < 2, trueAnomaly = [];end
            if nargin < 1, orbit = []; end   

            obj@SpacePosition(orbit, trueAnomaly);
            obj@RefillProp(speedRefill);
            obj@FuelContainer(dryMass, fuelMass, totCap);
            obj.specificImpulse = specificImpulse;
        end

        function [finalFuelMass, fuel, infeas] = calculateFuel(obj, dv, fuelSSc)

            % METHOD: function to compute the fuel used by the object.

            % INPUTS:
                % obj: the object used.
                % dv: variation of velocity that has to be applied.
                % fuelSSc: fuel of the object. Tecnically the object should
                    % have it's fuel in the object attribute, but since the function 
                    % reach needs to compute the feasibility of the
                    % reaching, a "future" fuel quantity needs to be
                    % computed before updating the real one.

            % OUTPUTS:
                    % finalFuelMass: computed final fuel mass
                    % fuel: fuel used in the maneuver
                    % infeas: flag of infeasibility: 1 if infeasible, 0 if feasible.

            % Tsiolkovsky rocket equation
            finalMass = (fuelSSc + obj.dryMass)/exp(dv/(obj.g0*obj.specificImpulse));
            % obtaining fuel by subtraction
            fuel = (fuelSSc + obj.dryMass) - finalMass;
            % check if enough fuel with respect to that dv
            finalFuelMass = fuelSSc - fuel;
            if(finalFuelMass<0)
                infeas = 1;
            else
                infeas = 0;
            end
        end

        function obj = giveFuel(obj, quantity)

            % METHOD: function that update the fuel quantity by taking away
                % some fuel

            % INPUTS:
                % obj: obect from which I will take away fuel.
                % quantity: quantity that I have to take away.

            % OUTPUTS:
                % obj: the final object without the quantity to remove.

            finalMass = obj.fuelMass - quantity;
            if(finalMass >= 0)
                obj.fuelMass = obj.fuelMass - quantity;
            else
                % error because before taking fuel, I should compute the
                % quantity using the reach funcion, I should tell before if
                % the maneuver is feasible or not.
                error("Error: negative fuel");
            end
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