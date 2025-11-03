classdef (Abstract) desRandomPol
    
    % implementing destroy random Policy
    
    methods
        function obj = destroyPolicy(obj, ~)
            
            r = min(ceil(rand()*100), 100);
            %fprintf("random degDes: %0.8f\n", r);
            for d = 1:obj.nDestroy
                obj.desSet{d}.degDes = r;
            end
        end

        function obj = restoreDestroy(obj)
            % do nothing
        end
    end
end

