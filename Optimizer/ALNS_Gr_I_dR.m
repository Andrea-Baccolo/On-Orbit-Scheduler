classdef ALNS_Gr_I_dR < GeneralALNS & StopNIter & AcceptGreedy & desRandomPol
    
    methods
        function obj = ALNS_Gr_I_dR(...
                            destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep) 
            obj@GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, Rep);
        end
    end
end

