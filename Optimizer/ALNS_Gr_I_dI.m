classdef ALNS_Gr_I_dI < GeneralALNS & StopNIter & AcceptGreedy & desIncreasPol
    
    methods
        function obj = ALNS_Gr_I_dI(...
                            destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep) 
            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
            obj@desIncreasPol();
        end
    end
end

