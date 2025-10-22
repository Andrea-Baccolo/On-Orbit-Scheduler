classdef ALNS_Time_SA < GeneralALNS
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        T % temperature
        alpha % rate of decay of temperature
        totTime % in seconds
    end

    methods
        function obj = ALNS_Time_SA(destroySet, repairSet, deltas, decay, initialSeq, simulator, T0, alpha, totTime)
            obj@GeneralALNS(destroySet, repairSet, deltas, decay, initialSeq, simulator, 10000)
            obj.T = T0;
            obj.alpha = alpha;
            obj.totTime = totTime;
        end

        function [bool, obj] = accept(obj, newSlt, currSlt)
            r = rand();
            pi = exp((currSlt.totFuel - newSlt.totFuel)/obj.T);
            bool = (r<=pi);
            obj.T = obj.T*obj.alpha;
        end

        function stop = stoppingCriterion(obj, startTime)
            stop = toc(startTime) > obj.totTime;
        end
    end
end