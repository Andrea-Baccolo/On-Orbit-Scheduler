classdef PlanarChange < OrbitalManeuver
    
    % Implementing planar change.

    properties
        nodeTarOrb
        nodeSScOrb
    end

    properties (Constant)
        type = "Planar Change";
        tol = 1e-8;
    end

    methods
        function obj = PlanarChange(sscIndx, targetIndx, dt, totAngle, dv, nodeTargetOrb, nodeSScOrb)
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
            % check fuel
            [~, fuelUsed, ~] = simState.sscs(obj.sscIndx).calculateFuel(obj.dv, simState.sscs(obj.sscIndx).fuelMass);
            simState.sscs(obj.sscIndx) = simState.sscs(obj.sscIndx).giveFuel(fuelUsed);

            simState.sscs(obj.sscIndx).trueAnomaly = obj.nodeTarOrb;
            if(obj.targetIndx == 0)
                simState.sscs(obj.sscIndx).orbit = simState.station.orbit ;
            else
                simState.sscs(obj.sscIndx).orbit = simState.targets(obj.targetIndx).orbit ;
            end
        end

        function obj = compute(obj, ssc, target, ~)

            % computing Planar Change maneuver

            os = ssc.orbit.raan;        ot = target.orbit.raan;
            is = ssc.orbit.inclination; it = target.orbit.inclination;
            nuS = ssc.trueAnomaly;      a = target.orbit.semiMajorAxis;
            cis = cosd(is); cit = cosd(it); sis = sind(is); sit = sind(it);

            % Han et al 2022
            CosAlpha = sis*sit*cosd(os-ot)+cis*cit; % dihedral angle
            SinAlphaHalf = sqrt((1-CosAlpha)/2); % bisection formula

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

            obj.nodeSScOrb = angleS(col);
            obj.nodeTarOrb = angleT(col);

            obj.dv = 2*abs(target.orbit.angVel)*SinAlphaHalf;
            obj.dt = 0;
            chi = obj.nodeSScOrb - ssc.trueAnomaly;
            chi = chi +(chi <= -180)*360 -(chi > 180)*360;
            if(chi~=0)
                obj.dt = obj.dt + chi*(pi/180)/ssc.orbit.angVel;
            end
            obj.totAngle = (180/pi)*ssc.orbit.angVel*obj.dt;
        end

        function [phi] = point2trueAnomaly(obj, r, omega, i, a)
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
            val = (abs(pNorm(1)))*(abs(pNorm(1)) <= 1) + 1*(abs(pNorm(1)) >1);
        
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