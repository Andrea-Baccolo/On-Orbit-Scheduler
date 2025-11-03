classdef (Abstract) AcceptGreedy
    
    properties
    end
    
    methods
        function [bool, obj] = accept(obj, newSlt)
            bool = newSlt.totFuel < obj.bestSlt.totFuel;
        end

        function obj = restoreAccept(obj)
            % nothing to restore
        end
    end
end

