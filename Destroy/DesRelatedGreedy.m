classdef DesRelatedGreedy < DesRelated

    % Destroy method that applies a greedy policy to choose the best
    % related target.

    properties
    end

    methods
        function obj = DesRelatedGreedy(nTar, degDes, beta)
            if nargin < 1, nTar = 0; end
            if nargin < 2, degDes = 0; end
            if nargin < 3, beta = 0; end
            obj@DesRelated(nTar, degDes, beta);
        end

        function tarChosen = chooseTar(~, sortedTarIndx)
            tarChosen = sortedTarIndx(1);
        end
    end
end