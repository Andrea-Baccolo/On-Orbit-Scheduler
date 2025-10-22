classdef DestroyOdd < Destroy

    properties
    end

    methods
        function obj = DestroyOdd(nTar)
            obj@Destroy(nTar);
        end

        function [nDestroy, destroyIndx]= chooseTargets(~, slt, ~)
            maxLen = ceil(max(max(slt.tourInfo.lTour))/2);
            destroyIndx = -1*ones(maxLen,3);
            [nTour, nSSc] = size(slt.tourInfo.lTour);
            tarCount = 1;
            for i = 1:nSSc
                for j = 1:nTour
                    len = slt.tourInfo.lTour(j,i);
                    if(len>0)
                        totTar = ceil(len/2);
                        vec = len:-1:1;
                        destroyIndx(tarCount:tarCount+totTar-1,1) = i*ones(totTar,1);
                        destroyIndx(tarCount:tarCount+totTar-1,2) = j*ones(totTar,1);
                        destroyIndx(tarCount:tarCount+totTar-1,3) = (vec(mod(vec,2)==1))';
                        tarCount = tarCount+totTar;
                    end
                end
            end
            nDestroy = tarCount-1;
            destroyIndx = destroyIndx(1:nDestroy,:);

        end

    end
end