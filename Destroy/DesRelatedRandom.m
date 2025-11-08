classdef DesRelatedRandom < DesRelated

    % Destroy method that extract the best related target using a probability.
    % from han et al (look on thesis).

    properties
        p % l>=1, parameter used to add randomness and not take always the best
        % lower  value of p correspond more randomness
    end

    methods
        function obj = DesRelatedRandom(nTar, degDes, beta, p)

            % METHOD: Constructor
                
            % INPUTS:
                % nTar: number of targets.
                % degDes: degree of desctruction, a number between 0 and 100.
                % beta: parameters used in the relatedness measure: between
                    % 0 and 1.
                % p: parameter to control the randomness of chosing the
                    % best targets, p>=1 , 1 for complete randomness.

            % OUTPUTS:
                % obj: DestroyRelatedRandom object.

            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            if nargin < 3, beta = 0; end
            if nargin < 4, p = 0; end
            obj@DesRelated(nTar, degDes, beta);
            obj.p = p;
        end

        function tarChosen = chooseTar(obj, sortedTarIndx)

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
                    
            nSorted = length(sortedTarIndx);
            r = rand();
            %fprintf(" take the %d th over %d \n", floor((r)^obj.p * nSorted) + 1, nSorted)
            tarChosen = sortedTarIndx(floor((r)^obj.p * nSorted) + 1);
        end
    end
end