classdef ALNS_SA_I_dI < GeneralALNS & StopNIter & AcceptSA & desIncreasPol
    
    methods
        function obj = ALNS_SA_I_dI(...
            destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep,...
            T0, alpha) 
            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
            obj@AcceptSA(T0, alpha);
            obj@desIncreasPol();
        end
    end
end

