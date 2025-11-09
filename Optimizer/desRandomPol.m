classdef (Abstract) desRandomPol
    
    % % Class that must be used as a mix-in with the GeneralALNS object.
    % Implementing destroy random Policy.
    
    properties
        degDes0 % vector of destroy degrees
    end

    methods

        function obj = desRandomPol()
            
            % METHOD: constructor

            % INPUTS: nothing

            % OUTPUTS:
                % obj: constructed object.

            % getting the initial destroy degree
            obj.degDes0 = -1*ones(obj.nDestroy,1);
            for d = 1:obj.nDestroy
                obj.degDes0(d) = obj.desSet{d}.degDes;
            end
            
        end

        function obj = destroyPolicy(obj, ~)
            
            % METHOD: function used to apply the destory policy

            % INPUTS:
                % obj: initial object.
                % val: value used to get the fraction of increasing.
            % OUTPUTS:
                % obj: updated object with new destroy update.

            r = min(ceil(rand()*100), 100);
            %fprintf("random degDes: %0.8f\n", r);
            for d = 1:obj.nDestroy
                obj.desSet{d}.degDes = r;
            end
        end

        function obj = restoreDestroy(obj)

            % METHOD: function used to restore the destroy degree.

            % INPUTS: % obj: initial object.

            % OUTPUTS: % obj: updated object

            % resetting the degree
            for d = 1:obj.nDestroy
                obj.desSet{d}.degDes = obj.degDes0(d); 
                %fprintf( "%.2f ",obj.desSet{d}.degDes )
            end
        end
    end
end

