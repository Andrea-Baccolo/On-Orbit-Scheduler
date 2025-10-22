classdef Refilling < Maneuver
    
    % Class that implements the refilling of a target or a SSc

    properties 
        fuelAdded
    end

    properties (Constant)
        type = "Refueling"
    end

    methods
        function obj = Refilling(sscIndx, targetIndx, dt, totAngle, fuelAdded)
            if nargin < 1, sscIndx = []; end
            if nargin < 2, targetIndx = []; end
            if nargin < 3, dt = 0; end
            if nargin < 4, totAngle = 0; end
            if nargin < 5, fuelAdded = 0; end
            obj@Maneuver(sscIndx, targetIndx, dt, totAngle);
            obj.fuelAdded = fuelAdded;
        end

        function [simState, fuelUsed] = execute(obj, simState)
            fuelUsed = 0;
            if obj.targetIndx == 0
                % station refill ssc saved in target
                simState.sscs(obj.sscIndx) = simState.sscs(obj.sscIndx).add_fuel();
                simState.sscs(obj.sscIndx) = simState.sscs(obj.sscIndx).update(obj.dt);
            else
                % ssc refill target
                simState.targets(obj.targetIndx) = simState.targets(obj.targetIndx).add_fuel();
                simState.sscs(obj.sscIndx)= simState.sscs(obj.sscIndx).giveFuel(obj.fuelAdded);
                simState.sscs(obj.sscIndx) = simState.sscs(obj.sscIndx).update(obj.dt);
            end
        end
    
        function obj = compute(obj, ssc, target, fuelReal)
            % I have to compute the time it will take to refill
            % obj.targetIndx is the attribute I need to controll
            if(obj.targetIndx == 0)
                % target is the station and I need to refill the ssc
                % fuel real is a computed quantity regarding the refill of
                % the ssc, I can't use the ssc.fuelMass beasue it is the fuel
                % before the planar change and the phasing, I need it after.

                obj.fuelAdded = ssc.tot_cap - fuelReal;
                obj.dt = obj.fuelAdded/target.speedRefill;
            else
                % target is refueled by the ssc
                obj.fuelAdded = target.tot_cap - target.fuelMass;
                obj.dt = obj.fuelAdded/ssc.speedRefill;
            end
            obj.totAngle = (180/pi)*ssc.orbit.angVel*obj.dt;
        end

        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            obj.output@Maneuver(fid)
            fprintf(fid,"Fuel added: %.2f\n",obj.fuelAdded);
        end
    end
end