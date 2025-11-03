classdef DesSScRandom < DesSSc

    % Destroy method that delete targets of random sscs. 

    properties
    end

    methods
        function obj = DesSScRandom(nTar, degDes)
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@DesSSc(nTar, degDes);
        end 

        function SScs = sortSScIndx(~, slt)
            nSSc = size(slt.tourInfo.lTour,2); 
            SScs = (1:nSSc)';
            SScs = SScs(randperm(nSSc));
        end
    end
end