clear all
clc

% Tuning parameters script, for more information, see the thesis.

%%
% getting folder
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
subFolder1 = '1_Tuning'; 
filePath = fullfile(projectPath, subFolder, subFolder1);

%% decay and deltas
% Problem
load("Problem.mat")
nTar = length(initialStates.targets);

% Sets
destroySet = createDesSet(nTar, 30);
repairSet = createRepSet(nTar);

% fixed ALNS
deltas = [10, 7, 3, 1
          2, 1.5, 1, 0.5
          1, 0.7, 0.3, 0.1];
nDelta = 3;
decay =[0.25, 0.5, 0.75] ;     nIter = 1000;  nRep = 5;
nLambda = 3;
% accept SA
T0 = 400; alpha = 0.995;
%% 
for delta = 1:nDelta
    for lambda = 1:nLambda
        fprintf("Tuning (delta,lambda)_(%d, %d)\n", delta, lambda);
        optimizer = ALNS_SA_I_dF(destroySet, repairSet, deltas(delta,:), decay(lambda), nIter, initialSlts, initialStates, nRep, T0, alpha);
        optimizer = optimizer.Schedule(12345);
        
        % currIndxSim
        nameCurr = sprintf('Tuning_(delta,lambda)_(%d, %d)_currentSlt', delta, lambda);
        optimizer.createPlot( optimizer.outCurrIndxSim, optimizer.outCurrFuelSim, nameCurr, filePath);

        % currIndxSim
        nameBest = sprintf('Tuning_(delta,lambda)_(%d, %d)_bestSlt', delta, lambda);
        optimizer.createPlot( optimizer.outBestIndxSim, optimizer.outBestFuelSim, nameBest, filePath);

        % data
        result = optimizer.tableConstruction();

        % file .mat
        str = sprintf('Tuning_(delta,lambda)_(%d, %d).mat', delta, lambda);
        nameFile = fullfile(filePath, str);
        save(nameFile, "result", "optimizer");
        addFile(proj, nameFile);

        % file .txt
        str = sprintf('Tuning_(delta,lambda)_(%d, %d).txt', delta, lambda);
        nameFile = fullfile(filePath, str);
        optimizer.writeFile(result, nameFile)
        addFile(proj, nameFile);

        fprintf("end (%d, %d)\n", delta, lambda);
    end
end
fprintf("end Tuning\n");

%% select alpha 

% fix delta and lambda: (3,1) chosen
delta = deltas(3,:);
lambda = decay(1);

alphas = [0.9, 0.8];
nAlpha = 2;

for alpha = 1: nAlpha
    fprintf("Tuning alpha_%d\n", alpha);
    optimizer = ALNS_SA_I_dF(destroySet, repairSet, delta, lambda, nIter, initialSlts, initialStates, nRep, T0, alphas(alpha));
    optimizer = optimizer.Schedule(12345);

    % currIndxSim
    nameCurr = sprintf('Tuning_alpha_%d_currentSlt', alpha);
    optimizer.createPlot( optimizer.outCurrIndxSim, optimizer.outCurrFuelSim, nameCurr, filePath);

    % currIndxSim
    nameBest = sprintf('Tuning_alpha_%d_bestSlt', alpha);
    optimizer.createPlot( optimizer.outBestIndxSim, optimizer.outBestFuelSim, nameBest, filePath);

    % data
    result = optimizer.tableConstruction();

    % file .mat
    str = sprintf('Tuning_alpha_%d.mat', alpha);
    nameFile = fullfile(filePath, str);
    save(nameFile, "result", "optimizer");
    addFile(proj, nameFile);
    
    % file .txt
    str = sprintf('Tuning_alpha_%d.txt', alpha);
    nameFile = fullfile(filePath, str);
    optimizer.writeFile(result, nameFile)
    addFile(proj, nameFile);

    fprintf("end alpha %d\n", alpha);
end

%% select T0

% fix alpha
 alpha = 0.995;

T0s = [100, 250];
nT0 = 2;
for t = 1: nT0
    fprintf("Tuning T0_%d\n", t);
    optimizer = ALNS_SA_I_dF(destroySet, repairSet, delta, lambda, nIter, initialSlts, initialStates, nRep, T0s(t), alpha);
    optimizer = optimizer.Schedule(12345);

    % currIndxSim
    nameCurr = sprintf('Tuning_T0_%d_currentSlt', t);
    optimizer.createPlot( optimizer.outCurrIndxSim, optimizer.outCurrFuelSim, nameCurr, filePath);

    % currIndxSim
    nameBest = sprintf('Tuning_T0_%d_bestSlt', t);
    optimizer.createPlot( optimizer.outBestIndxSim, optimizer.outBestFuelSim, nameBest, filePath);

    % data
    result = optimizer.tableConstruction();

    % file .mat
    str = sprintf('Tuning_T0_%d.mat', t);
    nameFile = fullfile(filePath, str);
    save(nameFile, "result", "optimizer");
    addFile(proj, nameFile);

    % file .txt
    str = sprintf('Tuning_T0_%d.txt', t);
    nameFile = fullfile(filePath, str);
    optimizer.writeFile(result, nameFile)
    addFile(proj, nameFile);

    fprintf("end T0 %d\n", t);
end





