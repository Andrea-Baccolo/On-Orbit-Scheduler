classdef Phasing < OrbitalManeuver
    
    % Implementing phasing, a maneuver to reach a target 

    properties
        semiMajorAxis   % semimajorAxis of the resulting orbit
        Revolutions     % number of revolutions used for phasing
    end

    properties (Constant)
        type = "Phasing"
        safeRadius = 6378 + 2500; % earth radius + 100km
    end
    

    methods
        function obj = Phasing(sscIndx, targetIndx, dt, totAngle, dv, semiMajoAxis, Revolutions)
            if nargin < 1, sscIndx = []; end
            if nargin < 2, targetIndx = []; end
            if nargin < 3, dt = 0; end
            if nargin < 4, totAngle = 0; end
            if nargin < 5, dv = 0; end
            if nargin < 6, semiMajoAxis = 0; end
            if nargin < 7, Revolutions = 1; end
                
            obj@OrbitalManeuver(sscIndx, targetIndx, dt, totAngle, dv);
            obj.semiMajorAxis = semiMajoAxis;
            obj.Revolutions = Revolutions;
        end

        function [simState, fuelUsed] = execute(obj, simState)
            % check fuel 
            [~, fuelUsed, ~] = simState.sscs(obj.sscIndx).calculateFuel(obj.dv, simState.sscs(obj.sscIndx).fuelMass);
            % use fuel
            simState.sscs(obj.sscIndx)= simState.sscs(obj.sscIndx).giveFuel(fuelUsed);
            
            % Do nothing, the Ssc will do an integer number of revolution,
            % thus the true anomaly does not change
        end

        function obj = compute(obj, ssc, target, ~)
            % computing Phasing maneuver
            a = target.orbit.semiMajorAxis;

            % phase angle
            psi = ssc.trueAnomaly - target.trueAnomaly;
            theta = psi*(abs(psi)<=180) + (abs(psi)-360)*(psi>180) + (360-abs(psi))*(psi<-180);
            
            while 1 
                % computing maneuver time
                tau = (2*pi*obj.Revolutions + theta*(pi/180))/(target.orbit.angVel);
                if(tau>0) % check if time > 0
                    obj.semiMajorAxis = (ssc.orbit.GMp*(tau/(2*pi*obj.Revolutions))^2)^(1/3);
                    % obtaining perigee
                    rp = 2*obj.semiMajorAxis - a;
                    if(rp > obj.safeRadius) % check if perigee is feasible
                        break;
                    end
                end
                % since is not feasible, try with more revolutions
                obj.Revolutions = obj.Revolutions + 1;
            end
            % computing dv 
            obj.dv = 2*abs( sqrt( 2*ssc.orbit.GMp/a - ssc.orbit.GMp/obj.semiMajorAxis ) - sqrt( ssc.orbit.GMp/a )) ;
            obj.dt = tau ;
            obj.totAngle = (180/pi)*ssc.orbit.angVel*obj.dt;
        end
    
        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            obj.output@OrbitalManeuver(fid);
            fprintf(fid,"semiMajorAxis: %.4f, number of Revolutions: %d\n",obj.semiMajorAxis, obj.Revolutions);
        end
    end
end