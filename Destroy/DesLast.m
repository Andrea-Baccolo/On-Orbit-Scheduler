classdef DesLast < Destroy

    % Destroyer that every last target from a tour 

    properties
    end

    methods
        function obj = DesLast(nTar, degDes)
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@Destroy(nTar,degDes);
        end

        function [nDestroy, destroyIndx]= chooseTargets(obj, slt, ~)
            nDestroy = obj.nDesCompute();
            if(nDestroy>0 && nDestroy < obj.nTar)
                destroyIndx = ones(nDestroy,3);
                [nTour,nSSc] = size(slt.tourInfo.lTour);
                countTar = 0;
                exit = 0;
                for i = 1:nTour
                    for j = 1:nSSc
                        if(slt.tourInfo.lTour(i,j)~=0)
                            countTar = countTar + 1;
                            % if you have enough targets, just exit
                            if(countTar>nDestroy)
                                exit = 1;
                                break;
                            end
                            % inserting targets
                            destroyIndx(countTar,1) = j;
                            destroyIndx(countTar,2) = i;
                            destroyIndx(countTar,3) = slt.tourInfo.lTour(i,j);
                        end
                    end
                    if exit
                        break;
                    end
                end
                % update nDestroy if needed
                if(countTar < nDestroy )
                    nDestroy = countTar - 1;
                    destroyIndx = destroyIndx(1:countTar-1,:);
                end
            else
                destroyIndx = [];
            end
        end
    end
end 