classdef ALNS_Gr_I_dF < GeneralALNS & StopNIter & AcceptGreedy & desFixedPol
% INPUTS
% accept SA 
    % T0: initial temperature
    % alpha: decay temperature parameter
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
    methods
        function obj = ALNS_Gr_I_dF(...
                            destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep) 
            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
        end
    end
end

