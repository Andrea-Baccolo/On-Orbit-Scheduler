classdef DestroySScRandom < DestroySSc

    properties
    end

    methods
        function obj = DestroySScRandom(nTar, p)
            obj@DestroySSc(nTar, p);
        end 

        function SScs = createIndx(~, nDSSc, slt, ~)
            nSSc = size(slt.tourInfo.lTour,2); 
            SScs = (1:nSSc)';
            SScs = SScs(slt.tourInfo.nTour>0);
            lenSSc = length(SScs);
            while(lenSSc>nDSSc)
                num = randi([1 lenSSc]);
                SScs(num) = [];
                lenSSc = lenSSc - 1;
            end
        end
    end
end