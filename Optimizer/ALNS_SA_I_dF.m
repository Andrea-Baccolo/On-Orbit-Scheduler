classdef ALNS_SA_I_dF < GeneralALNS & StopNIter & AcceptSA & desFixedPol
    
    methods
        function obj = ALNS_SA_I_dF(...
            destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep,...
            T0, alpha) 
            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
            obj@AcceptSA(T0, alpha);
        end
    end
end

