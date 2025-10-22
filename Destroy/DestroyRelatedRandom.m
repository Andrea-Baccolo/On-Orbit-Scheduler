classdef DestroyRelatedRandom < DestroyRelated 
    properties
    end

    methods
        function obj = DestroyRelatedRandom(nTar, prop, beta, p)
            obj@DestroyRelated(nTar, prop, beta);
            obj.p = p;
        end

        function destroyedSet = chooseTargets(obj, destroyedSet, nDestroy, keepSet, slt, targets)
            nSorted = obj.nTar-1;
            for i = 2:nDestroy
                tarIndxI = destroyedSet(i-1);
                relatedness = obj.computeRelatedness(tarIndxI, keepSet, targets, slt);
                [~, sortedIndx] = sort(relatedness, "descending");
                % index refered to the sorted vector
                tarIndx = floor((rand)^obj.p * nSorted) + 1;
                destroyedSet(i) = keepSet(sortedIndx(tarIndx));
                keepSet(sortedIndx(tarIndx)) = [];
                nSorted = nSorted - 1;
            end
        end
    end
end