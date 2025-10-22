classdef DestroyTourRandom < DestroyTour

    properties
    end

    methods
        function obj = DestroyTourRandom(nTar,p)
            obj@DestroyTour(nTar,p);
        end

        function [Tours, SScs]= createIndx(obj, slt, ~)
            % create vectors of tour and ssc
            [Tours, SScs] = find(slt.tourInfo.lTour>0);
            lenVec = length(Tours);
            nDesTar = nTar;
            while nDesTar > obj.nDes
                num = randi([1 lenVec]);
                nDesTar = 
                Tours(num) = [];
                SScs(num) = [];
                lenVec = lenVec - 1;
            end
            
        end
    end
end