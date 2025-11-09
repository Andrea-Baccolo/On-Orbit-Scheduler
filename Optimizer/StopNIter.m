classdef (Abstract) StopNIter

    % Class that must be used as a mix-in with the GeneralALNS object. It
    % gives the sopping criteria and the fraction computing for a the destroy
    % policy.

    methods

        function stop = stoppingCriteria(obj, currIter)

            % METHOD: stopping criteria computation

            % INPUTS:
                % obj: initial object.
                % currIter: current iteration.

            % OUTPUTS:
                % stop: 1 if it needs to stop, 0 otherwise.

            stop = (currIter > obj.nIter);
        end

        function fraction = fractionComputing(obj, countIter)

            % METHOD: function used to compute the fraction of increasing
                % for the increasing policy method

            % INPUTS
                % obj: initial object.
                % countIter: number of the current iteration.
                
            % OUTPUTS:
                % fraction: fraction of increasing for the increasing
                    % policy method.

            % min to avoid numerical problem
            fraction = min(countIter / obj.nIter, 1);
        end
    end
end


