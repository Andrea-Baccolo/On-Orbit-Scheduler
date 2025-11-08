classdef DesTourRandom < DesTour

     % Destroy methods that delete targets from random tours.

    properties
    end

    methods
        function obj = DesTourRandom(nTar,degDes)

            % METHOD: Constructor
                
            % INPUTS:
                % nTar: number of targets.
                % degDes: degree of desctruction, a number between 0 and 100.

            % OUTPUTS:
                % obj: destroy tour random object.

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

            % create vectors of tour and ssc without zero length tours
            [Tours, SScs] = find(slt.tourInfo.lTour>0);
            len = length(Tours);
            
            % random permutation
            indx = randperm(len);
            SScs = SScs(indx);
            Tours = Tours(indx);
        end
    end
end