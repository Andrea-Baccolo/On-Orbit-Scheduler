classdef (Abstract) DesTour < Destroy

    % Destroy methods that delete targets from the solutions some tours.

    methods (Abstract)
        [SScs, Tours]= sortTourIndx(obj, slt);
    end

    methods
        function obj = DesTour(nTar, degDes)

            % METHOD: Constructor
                
            % INPUTS:
                % nTar: number of targets.
                % degDes: degree of desctruction, a number between 0 and 100.

            % OUTPUTS:
                % obj: destroyTour object.

            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            obj@Destroy(nTar,degDes);
        end

        function [nDestroy, destroyIndx] = chooseTargets(obj, slt, ~)

            % METHOD: function that gives the total number of destroyed
                        % targets and their indexes

            % INPUTS:
                % obj: destroy object.
                % slt: solution to destroy.
                % initialState: state object that contains the initial info.

            % OUTPUTS:
                % nDestroy: total number of destroyers.
                % destroyIndx: matrix nDestroy x 3 where the first column
                    % there is the sscIndx, the second the tourIndx, the third
                    % the posTour.
                    
            nDestroy = obj.nDesCompute();
            if(nDestroy>0 && nDestroy < obj.nTar)
                destroyIndx = -1*ones(obj.nTar,3); 
    
                % getting the Sorted Index of the Tours
                [SScs, Tours] = obj.sortTourIndx(slt);
                tarCount = 1;
                t = 1;
                % obtaining the indexes
                while(tarCount<= nDestroy)
                    lenTour = slt.tourInfo.lTour(Tours(t),SScs(t));
                    destroyIndx(tarCount:tarCount+lenTour-1,1) = SScs(t)*ones(lenTour,1);
                    destroyIndx(tarCount:tarCount+lenTour-1,2) = Tours(t)*ones(lenTour,1);
                    destroyIndx(tarCount:tarCount+lenTour-1,3) = (lenTour:-1:1)';
                    tarCount = tarCount+lenTour;
                    t = t+1;
                end
                nDestroy = tarCount-1;
                destroyIndx = destroyIndx(1:nDestroy,:);
            else
                destroyIndx = [];
            end
        end
    end
end