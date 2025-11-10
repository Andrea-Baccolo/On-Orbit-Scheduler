classdef (Abstract) AcceptSA

    % Class that implements the SImulation Annealing acceptance criteria.
    
    properties
        T0 % initial Temperature
        alpha % decay parameter of the temperature
        T % current value of the temperature
    end
    
    methods
        function obj = AcceptSA(T0, alpha)

            % METHOD: Constructor

            % INPUTS:
                % T0: initial temperature
                % alpha: decay temperature parameter

            % OUTPUTS:
                % obj: initialized object

            obj.T0 = T0;
            obj.alpha = alpha;
            obj.T = T0;
        end
        
        function [acceptBool, obj] = accept(obj, newSlt)

            % METHOD: accept method that decide if the current solution
                % needs to be updated.

            % INPUTS:
                % obj: initial object.
                % newSlt: new solution to accept

            % OUTPUTS:
                % acceptBool: boolean that express if the solution is
                    % accepted.
                % obj: object modification of the temperature.

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

            % METHOD: function that restore the acceptance paramethers

            % INPUTS: % obj: initial object.

            % OUTPUTS: % obj: the updated object.

            obj.T = obj.T0;
        end
    end
end

