classdef ALNS_SA_I_dR < GeneralALNS & StopNIter & AcceptSA & desRandomPol
    
    % Class that implements an ALNS optimizer with 
        % Simulation annealing acceptance criterion.
        % destroy random policy.

    methods
        function obj = ALNS_SA_I_dR(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep, T0, alpha) 

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
                % accept SA 
                    % T0: initial temperature
                    % alpha: decay temperature parameter
            
             % OUTPUTS:
                % obj: initialized object.

            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
            obj@AcceptSA(T0, alpha);
            obj@desRandomPol();
        end
    end
end

