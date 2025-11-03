classdef DesRelatedRandom < DesRelated

    % Destroy method that extract the best related target using a probability.

    properties
        p % l>=1, parameter used to add randomness and not take always the best
        % lower  value of p correspond more randomness
    end

    methods
        function obj = DesRelatedRandom(nTar, degDes, beta, p)
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            if nargin < 3, beta = 0; end
            if nargin < 4, p = 0; end
            obj@DesRelated(nTar, degDes, beta);
            obj.p = p;
        end

        function tarChosen = chooseTar(obj, sortedTarIndx)
            nSorted = length(sortedTarIndx);
            r = rand();
            %fprintf(" take the %d th \n", floor((r)^obj.p * nSorted) + 1)
            tarChosen = sortedTarIndx(floor((r)^obj.p * nSorted) + 1);
        end
    end
end