classdef DestroyRelatedGreedy < DestroyRelated 
    properties
    end

    methods
        function obj = DestroyRelatedGreedy(nTar, p, beta)
            obj@DestroyRelated(nTar, p, beta);
        end

        function destroyedSet = chooseTargets(obj,destroyedSet, nDestroy, keepSet, slt, targets)
            tarIndxI = destroyedSet(1);
            relatedness = obj.computeRelatedness(tarIndxI, keepSet, targets, slt);
            [~, sortedIndx] = sort(relatedness, "descending");
            destroyedSet(2:end) = keepSet(sortedIndx(1:nDestroy-1));
        end
    end
end