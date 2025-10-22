classdef (Abstract) RefillProp 

    % Implementing Refilling modelling.

    properties
        speedRefill % L/s
    end

    methods
        function obj = RefillProp(speedRefill)
            obj.speedRefill = [];
            obj.speedRefill = speedRefill;
        end

        function output(obj,fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            fprintf(fid, 'Refueling speed: %.2f\n', obj.speedRefill);
        end
    end

end