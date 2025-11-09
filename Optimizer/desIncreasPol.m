classdef (Abstract) desIncreasPol
    
    % % Class that must be used as a mix-in with the GeneralALNS object.
    % Implementing destroy increasing Policy

    properties
        degDes0 % vector of destroy degrees
    end

    methods

        function obj = desIncreasPol()

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

        function obj = destroyPolicy(obj, val)

            % METHOD: function used to apply the destory policy

            % INPUTS:
                % obj: initial object.
                % val: value used to get the fraction of increasing.
            % OUTPUTS:
                % obj: updated object with new destroy update.

            fraction = obj.fractionComputing(val);
           
            for d = 1:obj.nDestroy
                obj.desSet{d}.degDes = obj.desSet{d}.degDes + (100 - obj.desSet{d}.degDes) * fraction * 0.1;
                %fprintf( "%.2f ",obj.desSet{d}.degDes )
            end
            %fprintf("\n");
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

