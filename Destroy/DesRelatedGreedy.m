classdef DesRelatedGreedy < DesRelated

    % Destroy method that applies a greedy policy to choose the best
    % related target.

    properties
    end

    methods
        function obj = DesRelatedGreedy(nTar, degDes, beta)

            % METHOD: Constructor
                
            % INPUTS:
                % nTar: number of targets.
                % degDes: degree of desctruction, a number between 0 and 100.
                % beta: parameters used in the relatedness measure: between
                    % 0 and 1. 

            % OUTPUTS:
                % obj: DestroyRelatedGreedy object.

            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            if nargin < 3, beta = 0; end
            obj@DesRelated(nTar, degDes, beta);
        end

        function tarChosen = chooseTar(~, sortedTarIndx)

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
                    
            tarChosen = sortedTarIndx(1);
        end
    end
end