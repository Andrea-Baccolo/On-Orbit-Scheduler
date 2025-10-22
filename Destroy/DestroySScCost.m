classdef DestroySScCost < DestroySSc

    properties
    end

    methods
        function obj = DestroySScCost(nTar, p)
            obj@DestroySSc(nTar, p);
        end 

        function SScs = createIndx(obj, nDSSc, slt, ~)
            nSSc = size(slt.seq,1);
            passageNum = sum((slt.seq< obj.nTar+1),2)-ones(nSSc,1);
            zeroIndx = find(passageNum==0);
            SScs = 1:nSSc;
            SScs(zeroIndx) = [];
            passageNum(zeroIndx) = [];
            fuelUsageSSc = sum(slt.fuelUsage,2);
            fuelUsageSSc(zeroIndx) = [];
            fuelUsageSSc = fuelUsageSSc./passageNum;
            [~, sortIndx] = sort(fuelUsageSSc, 'descend');
            realNum = min(length(SScs), nDSSc);
            SScs = SScs(sortIndx(1:realNum));
        end
    end
end