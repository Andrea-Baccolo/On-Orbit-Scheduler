classdef DestroyRandom < Destroy
    
    properties 
    end

    methods
        function obj = DestroyRandom(nTar, degDes)
            obj@Destroy(nTar,degDes);
        end

        function [nDestroy, destroyIndx] = chooseTargets(obj, slt, ~)
            % number of targets to remove
            nDestroy = ceil(obj.degDes*obj.nTar/100);
            % choose targets
            destroyIndx = -1*ones(nDestroy, 3);
            tourInfoCopy = slt.tourInfo;
            nSsc = size(tourInfoCopy.lTour,2);
            SScAccept = 1:nSsc;
            SScAccept(tourInfoCopy.nTour==0) = [];
            nSScAccept = length(SScAccept);
            for i = 1:nDestroy
                % choosing a random Ssc:
                num = randi([1 nSScAccept]);
                destroyIndx(i,1) = SScAccept(num);

                % choosing a random Tour from the random Ssc:
                tourAccept = find(tourInfoCopy.lTour(:,destroyIndx(i,1)) > 0);
                if(~isempty(tourAccept))
                    destroyIndx(i,2) = tourAccept(randi([1 length(tourAccept)]));
        
                    % choosing a random satellite from the random tour
                    destroyIndx(i,3) = randi([1 tourInfoCopy.lTour(destroyIndx(i,2),destroyIndx(i,1))]);

                    % update accept quantities
                    tourInfoCopy.lTour(destroyIndx(i,2),destroyIndx(i,1)) = tourInfoCopy.lTour(destroyIndx(i,2),destroyIndx(i,1)) -1;
                    if(tourInfoCopy.lTour(destroyIndx(i,2),destroyIndx(i,1)) == 0)
                        tourInfoCopy.nTour(destroyIndx(i,1)) = tourInfoCopy.nTour(destroyIndx(i,1)) - 1;
                        if(tourInfoCopy.nTour(destroyIndx(i,1)) == 0)
                            SScAccept(num) = [];
                            nSScAccept = nSScAccept - 1;
                            if(nSScAccept == 0)
                                error("something went wrong with nDestroy")
                            end
                        end
                    end

                else
                    error('SScAccept not valid');
                end
            end
        end


    end
end