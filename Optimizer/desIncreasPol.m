classdef (Abstract) desIncreasPol
    
    % implementing destroy increasing Policy

    properties
        degDes0 % vector of destroy index
    end

    methods

        function obj = desIncreasPol()
            % getting the initial destroy degree
            obj.degDes0 = -1*ones(obj.nDestroy,1);
            for d = 1:obj.nDestroy
                obj.degDes0(d) = obj.desSet{d}.degDes;
            end
            
        end

        function obj = destroyPolicy(obj, val)

            fraction = obj.fractionComputing(val);
           
            for d = 1:obj.nDestroy
                obj.desSet{d}.degDes = obj.desSet{d}.degDes + (100 - obj.desSet{d}.degDes) * fraction * 0.1;
                %fprintf( "%.2f ",obj.desSet{d}.degDes )
            end
            %fprintf("\n");
        end
        
        function obj = restoreDestroy(obj)
            % resetting the degree
            for d = 1:obj.nDestroy
                obj.desSet{d}.degDes = obj.degDes0(d); 
                %fprintf( "%.2f ",obj.desSet{d}.degDes )
            end
        end
    end
end

