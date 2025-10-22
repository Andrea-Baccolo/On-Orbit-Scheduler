classdef DestroyLast < Destroy

    properties
    end

    methods
        function obj = DestroyLast(nTar)
            obj@Destroy(nTar);
        end

        function [nDestroy, destroyIndx]= chooseTargets(~, slt, ~)
            if(isscalar(slt.tourInfo.nTour))
                nDestroy = slt.tourInfo.nTour;
            else
                nDestroy = sum(slt.tourInfo.nTour);
            end
            destroyIndx = ones(nDestroy,3);
            [nTour,nSSc] = size(slt.tourInfo.lTour);
            count = 1;
            for i = 1:nTour
                for j = 1:nSSc
                    if(slt.tourInfo.lTour(i,j)~=0)
                        destroyIndx(count,1) = j;
                        destroyIndx(count,2) = i;
                        destroyIndx(count,3) = slt.tourInfo.lTour(i,j);
                        count = count + 1;
                    end
                end
            end
        end
    end
end