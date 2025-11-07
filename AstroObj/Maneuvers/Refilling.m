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
            
            % METHOD: Constructor

            % INPUTS:
                % sscIndx: index of the ssc that is performing the maneuver.
                % targetIndx: index of the target to reach with this maneuver.
                % dt: total dutation of the maneuver in seconds.
                % totAngle: total angle that correspond to time dt.
                % fuelAdded: amount of fuel added to the target/ssc.
            % OUTPUTS:
                % Maneuver obj.

            if nargin < 1, sscIndx = []; end
            if nargin < 2, targetIndx = []; end
            if nargin < 3, dt = 0; end
            if nargin < 4, totAngle = 0; end
            if nargin < 5, fuelAdded = 0; end
            obj@Maneuver(sscIndx, targetIndx, dt, totAngle);
            obj.fuelAdded = fuelAdded;
        end

        function [simState, fuelUsed] = execute(obj, simState)
            % the fuel used in this maneuver is not considered in the reach fuel
            fuelUsed = 0;
            if obj.targetIndx == 0
                % station refill ssc saved in target

                % refill the ssc
                simState.sscs(obj.sscIndx) = simState.sscs(obj.sscIndx).add_fuel();
                % update the ssc
                simState.sscs(obj.sscIndx) = simState.sscs(obj.sscIndx).update(obj.dt);
            else
                % ssc refill target

                % refill the target
                simState.targets(obj.targetIndx) = simState.targets(obj.targetIndx).add_fuel();
                % subtract the fuel from the ssc
                simState.sscs(obj.sscIndx)= simState.sscs(obj.sscIndx).giveFuel(obj.fuelAdded);
                % update the ssc
                simState.sscs(obj.sscIndx) = simState.sscs(obj.sscIndx).update(obj.dt);
            end
        end
    
        function obj = compute(obj, ssc, target, fuelReal)
            % I have to compute the time it will take to refill
            % obj.targetIndx is the attribute I need to controll

            if(obj.targetIndx == 0)
                % target is the station and I need to refill the ssc
                % fuel real is a computed quantity regarding the refill of
                % the ssc, I can't use the ssc.fuelMass because it is the fuel
                % before the planar change and the phasing, I need the fuel after.

                % get the fuel that need to be added
                obj.fuelAdded = ssc.tot_cap - fuelReal;
                % compute the refilling time
                obj.dt = obj.fuelAdded/target.speedRefill;
            else
                % target is refueled by the ssc

                % get the fuel that need to be added
                obj.fuelAdded = target.tot_cap - target.fuelMass;
                % compute the refilling time
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