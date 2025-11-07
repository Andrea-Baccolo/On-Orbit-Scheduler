classdef (Abstract) OrbitalManeuver < Maneuver
    
    % General class that implements common Orbital Maneuvers's properties,

    properties
        dv
    end

    methods
        function obj = OrbitalManeuver(sscIndx, targetIndx, dt, totAngle, dv)

            % METHOD: Constructor

            % INPUTS:
                % sscIndx: index of the ssc that is performing the maneuver.
                % targetIndx: index of the target to reach with this maneuver.
                % dt: total dutation of the maneuver in seconds.
                % totAngle: total angle that correspond to time dt.
                % dv: total velocity increment.
            % OUTPUTS:
                % Orbital Maneuver obj.

            if nargin < 1, sscIndx = 0; end
            if nargin < 2, targetIndx = 0; end
            if nargin < 3, dt = 0; end
            if nargin < 4, totAngle = 0; end
            if nargin < 5, dv = 0; end

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