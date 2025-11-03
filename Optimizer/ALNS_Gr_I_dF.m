classdef ALNS_Gr_I_dF < GeneralALNS & StopNIter & AcceptGreedy & desFixedPol
    
    methods
        function obj = ALNS_Gr_I_dF(...
                            destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep) 
            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
        end
    end
end

