classdef (Abstract) Maneuver 

    % This general class stores all common informations needed to
    % calculate and execute maneuvers.

    properties
        dt          % time to perform the maenuver
        totAngle    % total angle done in dt of time
        sscIndx     % index that identifies which SSc is involved in the maneuver
        targetIndx  % index that identifies which target is involved in the maneuver
    end

    properties (Abstract, Constant)
        type % string that stroe the type of maneuver performed
    end

    methods (Abstract)
        [simState, fuelUsed] = execute(obj, simState);
        % this method has the following goals:
            % - updating ONLY the SSc position
            % - check infeasibility
            % - calculating the fuel used during the generic maneuver
        
        obj = compute(obj, ssc, target, fuelReal);
        % method used to compute the specific maneuver 
    end

    methods
        
        function obj = Maneuver(sscIndx, targetIndx, dt, totAngle)

            % METHOD: Constructor

            % INPUTS:
                % sscIndx: index of the ssc that is performing the maneuver.
                % targetIndx: index of the target to reach with this maneuver.
                % dt: total dutation of the maneuver in seconds.
                % totAngle: total angle that correspond to time dt.
            % OUTPUTS:
                % Maneuver obj.


            if nargin < 1, sscIndx = 0; end
            if nargin < 2, targetIndx = 0; end
            if nargin < 3, dt = 0; end
            if nargin < 4, totAngle = 0; end

            % creating an instance of a Maneuver object given all inputs
            obj.dt = dt ;
            obj.sscIndx = sscIndx ;
            obj.targetIndx = targetIndx;
            obj.totAngle = totAngle;
        end
        
        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            fprintf(fid,"**********%s**********\n", obj.type);
            fprintf(fid,"SSc %d reaches target %d \n Time: %.4f, Total angle: %.2f\n",obj.sscIndx, obj.targetIndx,obj.dt,obj.totAngle);
        end
    end
end