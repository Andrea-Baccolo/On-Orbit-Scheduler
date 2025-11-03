classdef ALNS_SA_I_dR < GeneralALNS & StopNIter & AcceptSA & desRandomPol
    
    methods
        function obj = ALNS_SA_I_dR(...
            destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep,...
            T0, alpha) 
            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
            obj@AcceptSA(T0, alpha);
        end
    end
end

