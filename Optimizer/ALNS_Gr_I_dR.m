classdef ALNS_Gr_I_dR < GeneralALNS & StopNIter & AcceptGreedy & desRandomPol
    
    % Class that implements an ALNS optimizer with 
        % Greedy acceptance criterion.
        % destroy random policy.

    methods
        function obj = ALNS_Gr_I_dR(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep) 

            % METHOD: Constructor.

            % INPUTS
                % GeneralALNS Requires 
                    % Fixed input parameters
                        % deltas: % column vector set in this way:
                            % delta(1) : the new solution is the best one so far
                            % delta(2) : the new solution is better than the current one
                            % delta(3) : the new solution is accepted
                            % delta(4) : the new solution is rejected
                        % decay: parameter that considers the preavious weights
                        % nIter: maximum number of iterations
                    % Problem inputs
                        % initialState
                        % initialSlt
                    % operators
                        % desSet: set of destroy 
                        % repSet: set of repair
            
             % OUTPUTS:
                % obj: initialized object.

            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
            obj@desRandomPol();
        end
    end
end

