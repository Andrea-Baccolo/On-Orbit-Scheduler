classdef (Abstract) AcceptSA
    
    properties
        T0 
        alpha
        T
    end
    
    methods
        function obj = AcceptSA(T0, alpha)
            obj.T0 = T0;
            obj.alpha = alpha;
            obj.T = T0;
        end
        
        function [acceptBool, obj] = accept(obj, newSlt)
            delta = newSlt.totFuel - obj.currSlt.totFuel;
            
            if delta < 0
                acceptBool = true;
            else
                
                p = exp(-delta / obj.T);
                %fprintf(" temp: %.8f, p: %.8f\n", obj.T, p);
                acceptBool = rand() < p;
            end

            obj.T = obj.T * obj.alpha;
            
        end

        function obj = restoreAccept(obj)
            obj.T = obj.T0;
        end
    end
end

