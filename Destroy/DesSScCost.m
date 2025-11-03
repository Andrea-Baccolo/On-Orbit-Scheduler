classdef DesSScCost < DesSSc

    % Destroy method that delete targets of one or more sscs form the
    % solution by taking the most costly ssc tour.

    properties
    end

    methods
        function obj = DesSScCost(nTar, degDes)
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@DesSSc(nTar, degDes);
        end 

        function SScs = sortSScIndx(~, slt)
            nSSc = size(slt.seq,1);
            SScs = (1:nSSc)';
            % obtaining cost 
            costSSc = sum(slt.fuelUsage,2);
            % sorting sscs 
            [~,sscIndx] = sort(costSSc,"descend");
            SScs = SScs(sscIndx);
        end
    end
end