classdef (Abstract) RefillProp 

    % Implementing Refilling model.

    properties
        speedRefill % L/s
    end

    methods
        function obj = RefillProp(speedRefill)

            % METHOD: Constructor.

            % INPUTS: 
                % speedRefill: refueling speed in L/s.

            % OUTPUTS:
                % requested object.

            if nargin < 1, speedRefill = []; end
            obj.speedRefill = speedRefill;
        end

        function output(obj,fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            fprintf(fid, 'Refueling speed: %.2f\n', obj.speedRefill);
        end
    end

end