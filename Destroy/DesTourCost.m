classdef DesTourCost < DesTour

     % Destroy methods that delete targets from the most expensive tours.

    properties
    end

    methods
        function obj = DesTourCost(nTar,degDes)

            % METHOD: Constructor
                
            % INPUTS:
                % nTar: number of targets.
                % degDes: degree of desctruction, a number between 0 and 100.

            % OUTPUTS:
                % obj: destroySScCost object.

            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@DesTour(nTar,degDes);
        end

        function [SScs, Tours]= sortTourIndx(~, slt)

            % METHOD: sorting the ssc with respect the cost

            % INPUTS: 
                % obj: destroy object.
                % slt: solution to destroy.

            % OUTPUTS:
                % SScs: sorted ssc index.
                
            [nTour, nSsc] = size(slt.tourInfo.lTour);
            costTour = -1*ones(nTour, nSsc);
            % getting tour cost
            countEmptyTours = 0;
            for i = 1:nSsc
                counter = 1;
                for j = 1:nTour
                    % checking if empty tour
                    if(slt.tourInfo.lTour(j,i) ~=0 )
                        costTour(j,i) = (sum(slt.fuelUsage(i,counter:counter + slt.tourInfo.lTour(j,i))))/(slt.tourInfo.lTour(j,i)+1);
                        counter = counter + slt.tourInfo.lTour(j,i)+1;
                    else
                        countEmptyTours = countEmptyTours + 1;
                    end
                end
            end
            % sorting by descending cost
            vec = costTour(:);
            [~, sortIndx] = sort(vec, 'descend');
            [Tours, SScs] = ind2sub(size(costTour), sortIndx);
            % deleting the zero tour
            Tours = Tours(1:end - countEmptyTours);
            SScs = SScs(1:end - countEmptyTours);
        end
        
    end
end