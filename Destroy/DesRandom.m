classdef DesRandom < Destroy

    % Destroy method that remove from the solution random targets.
    
    properties 
    end

    methods
        function obj = DesRandom(nTar, degDes)
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@Destroy(nTar,degDes);
        end

        function [nDestroy, destroyIndx] = chooseTargets(obj, slt, ~)
            % number of targets to remove
            nDestroy = obj.nDesCompute();
            if(nDestroy>0 && nDestroy < obj.nTar)

                destroyIndx = -1*ones(nDestroy, 3);
                % considers all targets
                tarDisp = 1:obj.nTar;

                % randomly estracting nDestroy targets
                extract = randsample(tarDisp, nDestroy);
                
                % obtiaining destroyIndx 
                for d = 1:nDestroy
                    [destroyIndx(d,1), posSeq] = find(slt.seq == extract(d));
                    [destroyIndx(d,2), posTour] = slt.tourInfo.Seq2Tour(posSeq, destroyIndx(d,1));
                    destroyIndx(d,3) = posTour - 1;
                end
            else
                destroyIndx = [];
            end
        end


    end
end

