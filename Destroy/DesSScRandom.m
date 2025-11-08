classdef DesSScRandom < DesSSc

    % Destroy method that delete targets of random sscs. 

    properties
    end

    methods
        function obj = DesSScRandom(nTar, degDes)

            % METHOD: Constructor
                
            % INPUTS:
                % nTar: number of targets.
                % degDes: degree of desctruction, a number between 0 and 100.

            % OUTPUTS:
                % obj: destroySScCost object.
                
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@DesSSc(nTar, degDes);
        end 

        function SScs = sortSScIndx(~, slt)

            % METHOD: sorting the ssc randomly.

            % INPUTS: 
                % obj: destroy object.
                % slt: solution to destroy.

            % OUTPUTS:
                % SScs: sorted ssc index.

            nSSc = size(slt.tourInfo.lTour,2); 
            SScs = (1:nSSc)';
            SScs = SScs(randperm(nSSc));
        end
    end
end