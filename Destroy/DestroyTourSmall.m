classdef DestroyTourSmall < DestroyTour
    methods
        function obj = DestroyTourSmall(nTar,p)
            obj@DestroyTour(nTar,p);
        end

        function [Tours, SScs]= createIndx(obj, slt, ~)
            vec = slt.tourInfo.lTour(:);
            [~, sortIndx] = sort(vec);
            [Tours, SScs] = ind2sub(size(slt.tourInfo.lTour), sortIndx(1:nDTour));
        end
    end
end