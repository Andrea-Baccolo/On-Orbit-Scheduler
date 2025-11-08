classdef DesRelated < Destroy & Relatedness

    % Abstract class that implements a general choose targets to remove
    % targets using a realtedness measure.

    properties
        beta
    end

    methods (Abstract)
        destroyedSet = chooseTar(obj,sortedTarIndx);
    end

    methods
        function obj = DesRelated(nTar, degDes, beta)

            % METHOD: Constructor
                
            % INPUTS:
                % nTar: number of targets.
                % degDes: degree of desctruction, a number between 0 and 100.
                % beta: parameters used in the relatedness measure: between
                    % 0 and 1. 

            % OUTPUTS:
                % obj: DestroyRelated object.

            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            if nargin < 3, beta = 0; end
            obj@Destroy(nTar,degDes);
            obj.beta = beta;
        end

        function [nDestroy, destroyIndx] = chooseTargets(obj, slt, initialState)

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
                % extract the first target
                tarChosen = randi([1 obj.nTar]);
                % structure to track the avaiable targets
                tarToChoose = (1:obj.nTar)';
                tarToChoose(tarChosen) = [];
                countTar = 1;
                destroyIndx(countTar,:) = obj.findIndx(tarChosen, slt);
                countTar = countTar +1;
                while(countTar <= nDestroy)
                    % relatedness measure
                    R = obj.relatednessMeasure(tarChosen, tarToChoose, initialState.targets, slt.seq, obj.beta);
                    [~,sortIndx] = sort(R,"descend");
    
                    % choose the target
                    tarChosen = obj.chooseTar(tarToChoose(sortIndx));
                    % add it's indexes
                    destroyIndx(countTar,:) = obj.findIndx(tarChosen, slt);
                    countTar = countTar +1;
                    % deleting tarChosen form tarToChoose
                    tarToChoose(tarToChoose == tarChosen) = [];
                end
            else
                destroyIndx = [];
            end
        end

        function indx = findIndx(~, tarChosen, slt)

            % METHOD: function used to find the position of a target in a
                % sequence

            % INPUTS:
                % obj: destroyFirst object.
                % tarChosen: chosen target to find.
                % slt: solution to destroy.

            % OUTPUTS:
                % indx: position of the chosen target.

            indx = zeros(1,3);
            [sscIndx, posSeq] = find(slt.seq == tarChosen);
            [indx(2), indx(3)] = slt.tourInfo.Seq2Tour(posSeq, sscIndx);
            indx(1) = sscIndx;
            % the position that gives the Seq2Tour is a position where I
            % need to put the target, but I need the position of the
            % target, so I have to subtract one
            indx(3) = indx(3) - 1;
        end
    end
end