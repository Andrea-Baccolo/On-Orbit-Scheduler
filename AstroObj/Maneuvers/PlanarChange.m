classdef PlanarChange < OrbitalManeuver
    
    % Implementing planar change, a maneuver to change inclination and raan
    % of an orbit.

    properties
        nodeTarOrb % node position true anomaly with repect the target orbit
        nodeSScOrb % node position true anomaly with repect the SSc orbit
    end

    properties (Constant)
        type = "Planar Change";
        tol = 1e-8; % numerical tolerance.
    end

    methods
        function obj = PlanarChange(sscIndx, targetIndx, dt, totAngle, dv, nodeTargetOrb, nodeSScOrb)
            
            % METHOD: Constructor

            % INPUTS:
                % sscIndx: index of the ssc that is performing the maneuver.
                % targetIndx: index of the target to reach with this maneuver.
                % dt: total dutation of the maneuver in seconds.
                % totAngle: total angle that correspond to time dt.
                % dv: total velocity increment.
                % nodeTargetOrb: true anomaly of the node with respect the target orbit.
                % nodeSScOrb: true anomaly of the node with respect the ssc orbit.
            % OUTPUTS:
                % Planar change obj.

            if nargin < 1, sscIndx = []; end
            if nargin < 2, targetIndx = []; end
            if nargin < 3, dt = 0; end
            if nargin < 4, totAngle = 0; end
            if nargin < 5, dv = 0; end
            if nargin < 6, nodeTargetOrb = 0; end
            if nargin < 7, nodeSScOrb = 0; end

            obj@OrbitalManeuver(sscIndx, targetIndx, dt, totAngle, dv);
            obj.nodeTarOrb = nodeTargetOrb;
            obj.nodeSScOrb = nodeSScOrb;
        end

        function [simState, fuelUsed] = execute(obj, simState)

            % METHOD: % this method has the following goals:
                            % updating ONLY the SSc position
                            % check infeasibility
                            % calculating the fuel used during the generic maneuver
            % INPUTS: 
                % obj: maneuver to be executed.
                % simState: state to update
                
            % OUTPUTS: 
                % simState: updated state.
                % fuelUsed: fuel used during the execution.

            % check fuel
            [~, fuelUsed, ~] = simState.sscs(obj.sscIndx).calculateFuel(obj.dv, simState.sscs(obj.sscIndx).fuelMass);
            % subtract fuel
            simState.sscs(obj.sscIndx) = simState.sscs(obj.sscIndx).giveFuel(fuelUsed);

            % update position with the new target reference angle
            simState.sscs(obj.sscIndx).trueAnomaly = obj.nodeTarOrb;
            % getting the right orbit info
            if(obj.targetIndx == 0)
                simState.sscs(obj.sscIndx).orbit = simState.station.orbit ;
            else
                simState.sscs(obj.sscIndx).orbit = simState.targets(obj.targetIndx).orbit ;
            end
        end

        function obj = compute(obj, ssc, target, ~)

            % METHOD: % calculate maneuver.

            % INPUTS: 
                % obj: maneuver to be updated.
                % ssc: ssc object that needs to reach the target.
                % target: target object to reach.
                % fuelReal: value of ssc fuel at the time when the maneuver
                    % is performed (it may differs from ssc.fuelMass
                    % because the maneuver is computed BEFORE).
                
            % OUTPUTS: 
                % obj: computed maneuver.

            % useful informations
            os = ssc.orbit.raan;        ot = target.orbit.raan;
            is = ssc.orbit.inclination; it = target.orbit.inclination;
            nuS = ssc.trueAnomaly;      a = target.orbit.semiMajorAxis;
            cis = cosd(is); cit = cosd(it); sis = sind(is); sit = sind(it);

            % Han et al 2022
            CosAlpha = sis*sit*cosd(os-ot)+cis*cit; % dihedral angle
            SinAlphaHalf = sqrt((1-CosAlpha)/2); % bisection formula

            % looking for the intersextions of planes 
            vect = cross(target.orbit.h, ssc.orbit.h);

            % considers same equation but different orbital element
            if(norm(vect,2) == 0)
                fprintf("\nERROR \nTarget Orbit: \n")
                target.orbit.output(1);
                fprintf("SSc Orbit: \n")
                ssc.orbit.output(2);
                error("Instance not correct, there are two orbits that define the same circle but with two different rotations")
            else
                % getting intersections in cartesian reference system
                rm1 = a*(cross(target.orbit.h, ssc.orbit.h)/...
                          norm(cross(target.orbit.h, ssc.orbit.h),2));
                
    
                % find the nodes 
                angleS = ones(2,1);
                angleT = ones(2,1);
                angleS(1) = obj.point2trueAnomaly(rm1, -os, -is, a); 
                angleS(2) = mod(angleS(1) + 180, 360);
                angleT(1) = obj.point2trueAnomaly(rm1, -ot, -it, a); 
                angleT(2) = mod(angleT(1) + 180, 360);
                
                % node 1,2 := node in column 1,2
    
                % select the right node
                if(nuS == angleS(1))
                    % if the ssc is at node 1
                    col = 1;
                elseif (nuS == angleS(2))
                    % if the ssc is at node 2
                    col = 2;
                elseif ( ~xor( (nuS<angleS(1)),(nuS<angleS(2)) ) )
                    % if the SSc has behind or in front the two nodes
                    % take col as the index of the minimum
                    [~, col] = min(angleS);
                else
                    % if I have not entered in all the preavious if, then it must be that 
                    % the Ssc is between and not equal the two nodes, I just need
                    % to take the bigger node, it will be the next one the ssc will encounter
                    [~, col] = max(angleS);
                end
    
                % selecting the chosen node
                obj.nodeSScOrb = angleS(col);
                obj.nodeTarOrb = angleT(col);
    
                % computing dv
                obj.dv = 2*abs(target.orbit.angVel)*SinAlphaHalf;

                % computing dt
                obj.dt = 0;
                chi = obj.nodeSScOrb - ssc.trueAnomaly;
                chi = chi +(chi <= -180)*360 -(chi > 180)*360;
                if(chi~=0)
                    obj.dt = obj.dt + chi*(pi/180)/ssc.orbit.angVel;
                end
                obj.totAngle = (180/pi)*ssc.orbit.angVel*obj.dt;
            end
        end

        function [phi] = point2trueAnomaly(obj, r, omega, i, a)

            % METHOD: Function used to pass from a point in 3D to the true
                % anomaly vector described with respect a specific orbit.

            % INPUTS:
                % obj: planar change object.
                % r: vector 3x1 containing the coordinates of the point to convert.
                % omega: raan of the orbit used for reference sistem of the 
                    % true anomaly, it must have a minus.
                % i: inclination of the orbit used for reference sistem of the 
                    % true anomaly, it must have a minus.
                % a: semimajor axis of the orbit used for reference sistem of the 
                    % true anomaly.

            % OUTPUTS:
                % phi: the true anomaly with respect the input orbit data.

            % apply rotation for equatorial orbit
            % rotation x axis: - raan
            % rotation z axis: - inclination
            co = cosd(omega);
            so = sind(omega);
            ci = cosd(i);
            si = sind(i);
        
            Rx = [ 1, 0,   0
                   0, ci,  -si
                   0, si, ci];
            Rz = [ co,  -so, 0
                   so, co, 0
                   0,   0,  1];
            M = Rx*Rz;
            pNorm = (M*r)./a;

            % to avoid numerical problems:
            val = min(max(abs(pNorm(1)), -1), 1);
        
            % find a possible angle in the first quadrants 
            angle = mod(rad2deg(acos(val)), 360);
            
            % check all the eight possible couple 
            k = 1;
            while k<5
                phi = angle + (k-1)*90;
                x_tilda = cosd(phi);
                y_tilda = sind(phi);
                %fprintf(' %2.f: %2.f, %2.f \n', phi, a*cosd(phi), a*sind(phi));
                if(abs(x_tilda - pNorm(1))<= obj.tol  && abs(y_tilda - pNorm(2))<= obj.tol)
                    break;
                end 
                phi = k*90 - angle;
                x_tilda = a*cosd(phi);
                y_tilda = a*sind(phi);
                %fprintf(' %2.f: %2.f, %2.f \n', phi, a*cosd(phi), a*sind(phi));
                if(abs(x_tilda - pNorm(1))<= obj.tol  && abs(y_tilda - pNorm(2))<= obj.tol)
                    break;
                end 
                k = k+1;
            end
            phi = mod(phi,360);
        end

        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            obj.output@OrbitalManeuver(fid);
            fprintf(fid,"chosen node in target's orbit: %.4f, in SSc's orbit: %.4f\n",obj.nodeTarOrb, obj.nodeSScOrb);
        end
    end
end