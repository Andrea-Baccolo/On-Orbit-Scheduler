classdef DestroyTourCost < DestroyTour

    properties
    end

    methods
        function obj = DestroyTourCost(nTar,p)
            obj@DestroyTour(nTar,p);
        end

        function [Tours, SScs]= createIndx(obj, slt, ~)
            [nTour, nSsc] = size(slt.tourInfo.lTour);
            costTour = -1*ones(nTour, nSsc);
            for i = 1:nSsc
                counter = 1;
                for j = 1:nTour
                    costTour(j,i) = (sum(slt.fuelUsage(i,counter:counter + slt.tourInfo.lTour(j,i))))/(slt.tourInfo.lTour(j,i)+1);
                    counter = counter + slt.tourInfo.lTour(j,i)+1;
                end
            end
            vec = costTour(:);
            [~, sortIndx] = sort(vec, 'descend');
            [Tours, SScs] = ind2sub(size(costTour), sortIndx(1:nDTour));
        end
    end
end