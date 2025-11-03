classdef (Abstract) StopNIter

    methods

        function stop = stoppingCriteria(obj, currIter)
            stop = (currIter > obj.nIter);
        end

        function fraction = fractionComputing(obj, countIter)
            % min to avoid numerical problem
            fraction = min(countIter / obj.nIter, 1);
        end
    end
end


