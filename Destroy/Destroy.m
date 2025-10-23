classdef (Abstract) Destroy 

    properties 
        nTar
        degDes
    end

    methods (Abstract)
        [nDestroy, destroyIndx]= chooseTargets(obj, slt, sim);
    end

    methods
        function obj = Destroy(nTar, degDes)
            obj.nTar = nTar;
            obj.degDes =  degDes;
        end
        
        function [destroyedSet, tourInfos] = Destruction(obj, slt, sim)

            % choose destoryed targets
            [nDestroy, destroyIndx] = chooseTargets(obj, slt, sim);
            destroyedSet = -1*ones(nDestroy,1);
            tourInfos = slt.tourInfo;

            for d = 1:nDestroy
                % save element
                destroyedSet(d) = tourInfos.tours{destroyIndx(d,2), destroyIndx(d,1)}(destroyIndx(d,3));

                % delete element
                tourInfos.tours{destroyIndx(d,2), destroyIndx(d,1)}(destroyIndx(d,3)) = [];

                % modify tour length and number of sscs tour
                tourInfos.lTour(destroyIndx(d,2), destroyIndx(d,1)) = tourInfos.lTour(destroyIndx(d,2), destroyIndx(d,1)) - 1;
                if(tourInfos.lTour(destroyIndx(d,2), destroyIndx(d,1)) == 0)
                    tourInfos.nTour(destroyIndx(d,1)) = tourInfos.nTour(destroyIndx(d,1)) - 1;
                end
            end
            tourInfos = tourInfos.cutTour();
        end
    
    end
end