classdef RepairInsertFirst < RepairInsert
    properties
        Property1
    end

    methods
        function obj = RepairInsertFirst(nTar)
            obj@RepairInsert(nTar);
        end

        function nPos = nPosCalculate(~, ~, tourInfo)
            if(isscalar(tourInfo.nTour))
                nPos = tourInfo.nTour;
            else
                nPos = max(tourInfo.nTour);
            end
        end

        

    end
end