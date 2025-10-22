classdef (Abstract) DestroyTour < Destroy

    methods (Abstract)
        [Tours, SScs]= createIndx(obj, slt, sim);
    end

    methods
        function obj = DestroyTour(nTar, p)
            obj@Destroy(nTar);
            obj.p = p;
        end

        function [nDestroy, destroyIndx] = chooseTargets(obj, slt, ~)
            % since thre goal of this destroyer is to delete tours, it may
            % not precisely exacly the quantity requested, so the algorithm
            % has been implemented to remove AT LEAST the requested number of target
             
            % to be sure to allocate all needed memory, two timems the
            % minimum has been preallocated
            destroyIndx = -1*ones(2*obj.nDes,3);  
            [Tours, SScs] = obj.createIndx(2*obj.nDes, slt, []);
            tarCount = 1;
            for i = 1:length(Tours)
                lenTour = slt.tourInfo.lTour(Tours(i),SScs(i));
                destroyIndx(tarCount:tarCount+lenTour-1,1) = SScs(i)*ones(lenTour,1);
                destroyIndx(tarCount:tarCount+lenTour-1,2) = Tours(i)*ones(lenTour,1);
                destroyIndx(tarCount:tarCount+lenTour-1,3) = (lenTour:-1:1)';
                tarCount = tarCount+lenTour;
            end
            nDestroy = tarCount-1;
            destroyIndx = destroyIndx(1:nDestroy,:);
        end
    end
end