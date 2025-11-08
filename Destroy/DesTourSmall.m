classdef DesTourSmall < DesTour

     % Destroy methods that delete targets from the smallest tours.

    methods
        function obj = DesTourSmall(nTar,degDes)

            % METHOD: Constructor
                
            % INPUTS:
                % nTar: number of targets.
                % degDes: degree of desctruction, a number between 0 and 100.

            % OUTPUTS:
                % obj: destrouy tour small object.

            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@DesTour(nTar,degDes);
        end

        function [SScs, Tours]= sortTourIndx(~, slt)

            % METHOD: sorting the tour randomly.

            % INPUTS: 
                % obj: destroy object.
                % slt: solution to destroy.

            % OUTPUTS:
                % SScs: sorted ssc index.
                % Tours: sorted tour index.
                
            % compute number of zero element
            nZeros = numel(slt.tourInfo.lTour) - nnz(slt.tourInfo.lTour);
            vec = slt.tourInfo.lTour(:);
            % sorting by length
            [~, sortIndx] = sort(vec, "ascend");
            % when sorting the vectors, the first nZeros will have length 0
            [Tours, SScs] = ind2sub(size(slt.tourInfo.lTour), sortIndx);
            % deleting the zero length tours
            Tours = Tours(nZeros+1:end);
            SScs = SScs(nZeros+1:end);
        end
    end
end