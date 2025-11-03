classdef DesSSc < Destroy

    % destroy method that choose all the targets on sscs.

    properties
    end

    methods (Abstract)
        SScs = sortSScIndx(obj, slt);
    end

    methods
        function obj = DesSSc(nTar, degDes)
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@Destroy(nTar,degDes);
        end

        function [nDestroy, destroyIndx] = chooseTargets(obj, slt, ~)
            nDestroy = obj.nDesCompute();
            if(nDestroy>0 && nDestroy < obj.nTar)
                destroyIndx = -1*ones(obj.nTar,3);
    
                % getting the Sorted Index of the SScs
                SScs = obj.sortSScIndx(slt);
    
                % taking all the needed indexes
                tarCount = 1;
                nTour = size(slt.tourInfo.lTour,1);
                sscCount = 1;
                while(tarCount<= nDestroy)
                    for t = 1:nTour
                        lenTour = slt.tourInfo.lTour(t,SScs(sscCount));
                        if(lenTour~=0)
                            destroyIndx(tarCount:tarCount+lenTour-1, 1) = SScs(sscCount)*ones(lenTour,1);
                            destroyIndx(tarCount:tarCount+lenTour-1,2) = t*ones(lenTour,1);
                            destroyIndx(tarCount:tarCount+lenTour-1,3) = (lenTour:-1:1)';
                            tarCount = tarCount+lenTour;
                        end
                    end
                    sscCount = sscCount + 1;
                end
    
                nDestroy = tarCount-1;
                destroyIndx = destroyIndx(1:nDestroy,:);
            else
                destroyIndx = [];
            end
        end
        
    end
end