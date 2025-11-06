classdef (Abstract) GeneralALNS
    
    properties

        currSlt
        bestSlt
        state

        % output 
        outCurrFuelSim
        outCurrIndxSim
        outBestFuelSim
        outBestIndxSim
        outBestSlt
        outWeightsDes
        outWeightsRep
        % number of times the operators has been selected
        outNSelDes 
        outNSelRep

        % total number of operator
        nDestroy
        nRepair
        nIter
        nRep

        % set of operators
        desSet
        repSet

        % operators's weights and sum of the weights
        desWeights
        repWeights
        sumRep
        sumDes

        deltas % column vector set in this way:
        % delta(1) : the new solution is the best one so far
        % delta(2) : the new solution is better than the current one
        % delta(3) : the new solution is accepted
        % delta(4) : the new solution is rejected
        decay
    end

    methods (Abstract)
        [bool, obj] = accept(obj, newSlt, currSlt);
        stop = stoppingCriteria(obj);
        obj = destroyPolicy(obj, val);
        % if stop = 1, then the algorithm must end
    end

    methods
        function obj = GeneralALNS(destroySet, repairSet, deltas, decay, nIter, initialSlt, initialState, nRep) 
            
            obj.nIter = nIter;
            obj.nRep = nRep;
            % opt variable
            obj.decay= decay;
            obj.deltas = deltas;

            % destroy
            obj.nDestroy = length(destroySet);
            obj.sumDes = obj.nDestroy; % they will be initialized as ones
            obj.desSet = destroySet;
            obj.desWeights = ones(obj.nDestroy, 1);
            obj.outNSelDes = zeros(obj.nDestroy, obj.nRep);

            % repair
            obj.nRepair = length(repairSet);
            obj.sumRep = obj.nRepair; % they will be initialized as ones
            obj.repSet = repairSet;
            obj.repWeights = ones(obj.nRepair, 1);
            obj.outNSelRep = zeros(obj.nRepair, obj.nRep);

            % output 
            M = zeros(nIter,obj.nRep);
            obj.outCurrFuelSim = mat2cell(M, nIter, ones(1, obj.nRep));
            obj.outCurrIndxSim = mat2cell(M, nIter, ones(1, obj.nRep));
            obj.outBestFuelSim = mat2cell(M, nIter, ones(1, obj.nRep));
            obj.outBestIndxSim = mat2cell(M, nIter, ones(1, obj.nRep));

            sltVector(obj.nRep) = Solution();
            obj.outBestSlt = sltVector;
            obj.outWeightsDes = zeros(obj.nDestroy,obj.nRep);
            obj.outWeightsRep = zeros(obj.nRepair,obj.nRep);
            

            % solutions
            obj.currSlt = initialSlt;
            % assumed initialSlt have been evaluated
            obj.bestSlt = obj.currSlt;
            obj.state = initialState;

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

        function obj = Schedule(obj, seed)
            if nargin < 2, seed = []; end 
            if(~isempty(seed)), rng(seed); end
            
            fCurrIndex = ones(obj.nRep,1);
            fBestIndex = ones(obj.nRep,1);
            countIter = ones(obj.nRep,1);
            initialSlt = obj.currSlt;
            
            for rep = 1:obj.nRep
                startTime = tic;
                tic
                % reinitialize the solutions
                obj.currSlt = initialSlt;
                obj.bestSlt = initialSlt;
                % restore the accept quantity and the destroy policy 
                obj = obj.restoreAccept();
                obj = obj.restoreDestroy();
                
                stop = obj.stoppingCriteria(countIter(rep));
                
                while(~stop)
                    % disp(countIter(rep));
                    % if(countIter(2)==10)
                    %     fprintf("hi\n");
                    % end
                    [desIndx, repIndx] = obj.extract();
                    obj.outNSelDes(desIndx, rep) = obj.outNSelDes(desIndx, rep) + 1;
                    obj.outNSelRep(repIndx, rep) = obj.outNSelRep(repIndx, rep) + 1;
    
                    % destruction
                    [destroyedSet, tourInfos] = obj.desSet{desIndx}.Destruction(obj.currSlt, obj.state);
    
                    % repairing
                    newSlt = obj.repSet{repIndx}.Reparing(obj.state, destroyedSet, tourInfos);
                    
                    % evaluating the solution
                    newSlt = newSlt.buildManSet(obj.state);
    
                    % getting bool variable
                    boolBest = (newSlt.totFuel < obj.bestSlt.totFuel);
                    boolCurr = (newSlt.totFuel < obj.currSlt.totFuel);
                    [boolAccept, obj] = obj.accept(newSlt);
    
                    % updating the solutions
                    if boolAccept
                        obj.currSlt = newSlt;
                        obj.outCurrFuelSim{rep}(fCurrIndex(rep)) = newSlt.totFuel;
                        obj.outCurrIndxSim{rep}(fCurrIndex(rep)) = countIter(rep);
                        fCurrIndex(rep) = fCurrIndex(rep) + 1;
                    end
                    if boolBest
                        obj.bestSlt = newSlt;
                        obj.outBestFuelSim{rep}(fBestIndex(rep)) = newSlt.totFuel;
                        obj.outBestIndxSim{rep}(fBestIndex(rep))  = countIter(rep);
                        fBestIndex(rep) = fBestIndex(rep) + 1;
                    end
                    % updating weights
                    obj = obj.updateWeights(boolAccept, boolBest, boolCurr, desIndx, repIndx);
    
                    countIter(rep) = countIter(rep) + 1;
    
                    
                    obj = obj.destroyPolicy(countIter(rep));
                    stop = obj.stoppingCriteria(countIter(rep));
                    
    
                end
                % not counting the last iterations
                countIter(rep) = countIter(rep)-1;
                fCurrIndex(rep) = fCurrIndex(rep)-1;
                fBestIndex(rep) = fBestIndex(rep)-1;
                toc

                % saving output quantities
                obj.outBestSlt(rep) = obj.bestSlt;
                obj.outWeightsDes(:,rep) = obj.desWeights;
                obj.outWeightsRep(:,rep) = obj.repWeights;

                % take effective index
                currIndx = 1:fCurrIndex(rep);
                bestIndx = 1:fBestIndex(rep);
            
                % Cut the cell array
                obj.outCurrFuelSim{rep} = obj.outCurrFuelSim{rep}(currIndx);
                obj.outCurrIndxSim{rep} = obj.outCurrIndxSim{rep}(currIndx);
                obj.outBestFuelSim{rep} = obj.outBestFuelSim{rep}(bestIndx);
                obj.outBestIndxSim{rep} = obj.outBestIndxSim{rep}(bestIndx);
            end
        end

        % SAVE VECTORIAL IMAGES
        function createPlot(obj, cellX, cellY, plotTitle, savePath)
            saving = 1;
            if nargin < 4, plotTitle = '_'; end
            if nargin < 5, saving = 0; end
        
            % Create figure
            fig = figure('Color', 'w', 'Position', [100 100 1200 800]);
            hold on;
            grid on; 
            colors = lines(obj.nRep);
        
            for rep = 1:obj.nRep
                % Plot
                stairs(cellX{rep}, cellY{rep}, 'Color', colors(rep,:), 'LineWidth', 1.5);
        
                % Final Point
                plot(cellX{rep}(end), cellY{rep}(end), 'o', 'Color', colors(rep,:), ...
                     'MarkerFaceColor', colors(rep,:), ...
                     'MarkerSize', 6, 'HandleVisibility', 'off');
            end
        
            xlabel('Iterations', 'Interpreter', 'latex');
            ylabel('Mission cost', 'Interpreter', 'latex');
            title(plotTitle, 'Interpreter', 'none');
            legend(arrayfun(@(r) sprintf('Replica %d', r), 1:obj.nRep, 'UniformOutput', false), ...
                'Location', 'best');
            hold off;
        
            if saving
                % create folder if does not exist
                if ~exist(savePath, 'dir')
                    mkdir(savePath);
                end
        
                % Making the title feasible 
                safeTitle = regexprep(plotTitle, '[^\w\d-]', '_');
                pdfFile = fullfile(savePath, [safeTitle, '.pdf']);
        
                % Save file as PDF vectorial
                exportgraphics(fig, pdfFile, 'ContentType', 'vector');
            end
        
            % Close fig
            close(fig);
        end

        % SAVE PNG
        % function createPlot(obj, cellX, cellY, plotTitle, savePath)
        %     saving = 1;
        %     if nargin < 4, plotTitle = '_'; end
        %     if nargin < 5, saving = 0; end
        % 
        %     % Create figure
        %     fig = figure('Color', 'w', 'Position', [100 100 1200 800]);
        %     hold on;
        %     grid on; 
        %     colors = lines(obj.nRep);
        % 
        %     for rep = 1:obj.nRep
        %         % Plot
        %         stairs(cellX{rep}, cellY{rep}, 'Color', colors(rep,:), 'LineWidth', 1.5);
        % 
        %         % Final Point
        %         plot(cellX{rep}(end), cellY{rep}(end), 'o', 'Color', colors(rep,:), ...
        %              'MarkerFaceColor', colors(rep,:), ...
        %              'MarkerSize', 6, 'HandleVisibility', 'off');
        %     end
        % 
        %     xlabel('Iterations');
        %     ylabel('Mission cost');
        %     title(plotTitle, 'Interpreter', 'none');
        %     legend(arrayfun(@(r) sprintf('Replica %d', r), 1:obj.nRep, 'UniformOutput', false), ...
        %         'Location', 'best');
        %     hold off;
        % 
        %     if saving
        %         % create folder if does not exist
        %         if ~exist(savePath, 'dir')
        %             mkdir(savePath);
        %         end
        % 
        %         % Making the title feasible 
        %         safeTitle = regexprep(plotTitle, '[^\w\d-]', '_');
        %         pngFile = fullfile(savePath, [safeTitle, '.png']);
        % 
        %         % Save file
        %         saveas(fig, pngFile);
        %     end
        % 
        %     % Close fig
        %     close(fig);
        % end

        function outputCell = tableConstruction(obj)
            % create rep string 
            repStr = arrayfun(@(x) sprintf('Rep %d', x), 1:obj.nRep, 'UniformOutput', false);
        
            % create destroy and repair string
            DesStr = string(cellfun(@class, obj.desSet, 'UniformOutput', false));
            RepStr = string(cellfun(@class, obj.repSet, 'UniformOutput', false));
        
            % getting final fuel from solutions 
            finalFuel = zeros(1,obj.nRep);
            for rep = 1:obj.nRep
                finalFuel(rep) = obj.outBestSlt(rep).totFuel;
            end
        
            % Tables creations
            FuelTable = array2table(finalFuel, ...
                'VariableNames', repStr, ...
                'RowNames', {'Total Minimum found'});
        
            DesWeightsTable = array2table(obj.outWeightsDes, ...
                'VariableNames', repStr, ...
                'RowNames', DesStr);
        
            RepWeightsTable = array2table(obj.outWeightsRep, ...
                'VariableNames', repStr, ...
                'RowNames', RepStr);
        
            DesSelTable = array2table(obj.outNSelDes, ...
                'VariableNames', repStr, ...
                'RowNames', DesStr);
        
            RepSelTable = array2table(obj.outNSelRep, ...
                'VariableNames', repStr, ...
                'RowNames', RepStr);
        
            % output cell
            outputCell = {FuelTable, DesWeightsTable, RepWeightsTable, DesSelTable, RepSelTable};
        end

        function writeFile(~, outputCell, nameTxt)
            % open or create the file
            fid = fopen(nameTxt, 'w');
            if fid == -1
                error('Impossibile aprire o creare il file %s', nameTxt);
            end
            % Section names
            secNames = {
                'Fuel Table'
                'Destroy Weights Table'
                'Repair Weights Table'
                'Destroy Selection Table'
                'Repair Selection Table'
            };
        
            % Writing
            for i = 1:numel(outputCell)
                fprintf(fid, '==== %s ====\n', secNames{i});
                tbl = outputCell{i};
        
                % Convert
                tblStr = evalc('disp(tbl)'); 
                fprintf(fid, '%s\n\n', tblStr);
            end
        
            % Closinf file
            fclose(fid);
        
            fprintf('File "%s" written correctly\n', nameTxt);
        end

    end
end