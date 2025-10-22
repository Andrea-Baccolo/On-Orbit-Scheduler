classdef OrbitalManeuver < Maneuver
    
    % General class that implements common Orbital Maneuvers's properties,
    % like dv

    properties
        dv
    end

    methods
        function obj = OrbitalManeuver(sscIndx, targetIndx, dt, totAngle, dv)
            obj@Maneuver(sscIndx, targetIndx, dt, totAngle);
            obj.dv = dv;
        end

        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            obj.output@Maneuver(fid)
            fprintf(fid,"dv: %.4f",obj.dv);
        end
    end
end