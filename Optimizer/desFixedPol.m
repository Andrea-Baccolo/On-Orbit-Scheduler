classdef (Abstract) desFixedPol

    % % Class that must be used as a mix-in with the GeneralALNS object.
    % Implementing destroy fixed Policy.
    
    properties
    end
    
    methods
        function obj = destroyPolicy(obj, ~)

            % METHOD: function used to apply the destory policy

            % INPUTS:
                % obj: initial object.
                % val: value used to get the fraction of increasing.
            % OUTPUTS:
                % obj: updated object with new destroy update.

            % do nothing
        end

        function obj = restoreDestroy(obj)

            % METHOD: function used to restore the destroy degree.

            % INPUTS: % obj: initial object.

            % OUTPUTS: % obj: updated object
            
            % do nothing
        end
    end
end

