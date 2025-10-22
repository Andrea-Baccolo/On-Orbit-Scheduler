classdef (Abstract) GeneralALNS
    
    properties
        nDestroy
        destroySet
        desWeights
        sumDes

        nRepair
        repairSet
        repWeights
        sumRep
        
        deltas % column vecotr set in this way:
        % delta(1) : the new solution is the best one so far
        % delta(2) : the new solution is better than the current one
        % delta(3) : the new solution is accepted
        % delta(4) : the new solution is rejected
        decay
        currSlt
        bestSlt

        currTotFuel
        bestTotFuel
    end

    methods (Abstract)
        [bool, obj] = accept(obj, newSlt, currSlt);
        stop = stoppingCriteria(obj);
        % if stop = 1, then the algorithm must end
    end

    methods
        function obj = GeneralALNS(destroySet, repairSet, deltas, decay, initialSeq, simulator, nIter) 
            obj.currTotFuel = zeros(nIter,1);
            obj.bestTotFuel = zeros(nIter,1);
            % opt variable
            obj.decay = decay;
            obj.deltas = deltas;

            %destroy
            obj.nDestroy = length(destroySet);
            obj.sumDes = obj.nDestroy; % they will be initialized as ones
            obj.destroySet = destroySet;
            obj.desWeights = ones(obj.nDestroy, 1);

            %repair
            obj.nRepair = length(repairSet);
            obj.sumRep = obj.nRepair; % they will be initialized as ones
            obj.repairSet = repairSet;
            obj.repWeights = ones(obj.nRepair, 1);

            % solutions
            obj.currSlt = Solution(initialSeq, length(simulator.initialState.targets));
            [obj.currSlt, ~] = obj.currSlt.buildManSet(simulator, ' ', ' ');
            obj.bestSlt = obj.currSlt;
        end

        function obj = updateWeights(obj, boolAccept, boolBest, boolCurr, desIndx, repIndx)
            % instead of always computing the sum of the weights, I will
            % keep a variable and update it every time
            increm = [obj.deltas(1)*boolBest, obj.deltas(2)*boolCurr, ...
                      obj.deltas(3)*boolAccept, obj.deltas(4)*(1-boolAccept)];
            psi = max(increm);
            % update sums before updating the weights
            obj.sumDes = obj.sumDes + (1-obj.decay)*(psi-obj.desWeights(desIndx));
            obj.sumRep = obj.sumRep + (1-obj.decay)*(psi-obj.repWeights(repIndx));
            % update the weights
            obj.desWeights(desIndx) = obj.decay*obj.desWeights(desIndx) + ...
                (1-obj.decay)*psi;
            obj.repWeights(repIndx) = obj.decay*obj.repWeights(repIndx) + ...
                (1-obj.decay)*psi;
        end

        function [probD, probR] = getProbability(obj)
            probD = obj.desWeights./obj.sumDes;
            probR = obj.repWeights./obj.sumRep;
        end

        function [destroyIndx, repairIndx] = extract(obj)
           [probD, probR] = getProbability(obj);
            
            % extraction
            r = rand();
            cumProbDestroy = cumsum(probD);
            destroyIndx = find(r <= cumProbDestroy, 1, 'first');
            
            r = rand();
            cumProbRepair = cumsum(probR);
            repairIndx = find(r <= cumProbRepair, 1, 'first');
        end

        function obj = Schedule(obj, simulator)
            startTime = tic;
            fCurrIndex = 1;
            fBestIndex = 1;
            countIter = 0;
            stop = obj.stoppingCriteria(startTime); 
            while(~stop)
                countIter = countIter + 1;
                [desIndx, repIndx] = obj.extract();
                % get temporary solution
                [destroyedSet, cellTours, lTours] = obj.destroySet(desIndx).Destruction(obj.currSlt);
                newSlt = obj.repairSet(repIndx).Reparing(simulator.initialState, destroyedSet, cellTours, lTours);
                simulator.simState = simulator.initialState;
                % evaluate new soltion
                newSlt = newSlt.buildManSet(simulator, ' ' ,' ');
                % getting bool variable
                boolBest = (newSlt.totFuel < obj.bestSlt.totFuel);
                boolCurr = (newSlt.totFuel < obj.currSlt.totFuel);
                [boolAccept, obj] = obj.accept(newSlt, obj.currSlt);
                % updating the solutions
                if boolAccept
                    obj.currSlt = newSlt;
                    obj.currTotFuel(fCurrIndex) = newSlt.totFuel;
                    % update index only if i won't update it in the best if below
                    fCurrIndex = fCurrIndex + 1;
                end
                if boolBest
                    obj.bestSlt = newSlt;
                    obj.bestTotFuel(fBestIndex) = newSlt.totFuel;
                    fBestIndex = fBestIndex + 1;
                end
                obj = obj.updateWeights(boolAccept, boolBest, boolCurr, desIndx, repIndx);
                stop = obj.stoppingCriteria(); 
            end
            stopTime = toc;
            fprintf('Opt time: %.8f\n ' , stopTime);
        end
    end
end