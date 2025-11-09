classdef (Abstract) AcceptGreedy
    
    properties
    end
    
    methods
        function [bool, obj] = accept(obj, newSlt)

            % METHOD: accept method that decide if the current solution
                % needs to be updated.

            % INPUTS:
                % obj: initial object.
                % newSlt: new solution to accept

            % OUTPUTS:
                % bool: boolean that express if the solution is
                    % accepted.
                % obj: object modification (if any).

            bool = newSlt.totFuel < obj.bestSlt.totFuel;
        end

        function obj = restoreAccept(obj)

            % METHOD: function that restore the acceptance paramethers

            % INPUTS: % obj: initial object.

            % OUTPUTS: % obj: the updated object.

            % nothing to restore
        end
    end
end

