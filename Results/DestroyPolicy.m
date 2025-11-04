clear all
clc

%%
% getting folder
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
subFolder1 = '4_DesPolicy'; 
filePath = fullfile(projectPath, subFolder, subFolder1);

% Problem
load("Problem.mat")
nTar = length(initialStates.targets);

% Repair Sets
repairSet = createRepSet(nTar);
destroySet = createDesSet(nTar, 30);

% fixed ALNS
deltas =  [1, 0.7, 0.3, 0.1];  decay =0.25 ;   nIter = 1000;  nRep = 5;
% accept SA
T0 = 400; alpha = 0.995;

%% Destruction degree Random
optRandom = ALNS_SA_I_dR(destroySet, repairSet, deltas, decay, nIter, initialSlts, initialStates, nRep, T0, alpha);

fprintf("start policy Random");
optRandom = optRandom.Schedule(12345);
fprintf("end policy Random");
% currIndxSim
nameCurr = 'Policy_Random_currentSlt';
optRandom.createPlot( optRandom.outCurrIndxSim, optRandom.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = 'Policy_Random_bestSlt';
optRandom.createPlot( optRandom.outBestIndxSim, optRandom.outBestFuelSim, nameBest, filePath);

% data
result = optRandom.tableConstruction();

% file .mat
str = 'Policy_Random.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "optRandom");
addFile(proj, nameFile);

% file .txt
str = 'Policy_Random.txt';
nameFile = fullfile(filePath, str);
optRandom.writeFile(result, nameFile)
addFile(proj, nameFile);

%% Destruction degree Increasing
optIncreasing = ALNS_SA_I_dI(destroySet, repairSet, deltas, decay, nIter, initialSlts, initialStates, nRep, T0, alpha);

fprintf("start policy Increasing");
optIncreasing = optIncreasing.Schedule(12345);
fprintf("end policy Increasing");
% currIndxSim
nameCurr = 'Policy_Increasing_currentSlt';
optIncreasing.createPlot( optIncreasing.outCurrIndxSim, optIncreasing.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = 'Policy_Increasing_bestSlt';
optIncreasing.createPlot( optIncreasing.outBestIndxSim, optIncreasing.outBestFuelSim, nameBest, filePath);

% data
result = optIncreasing.tableConstruction();

% file .mat
str = 'Policy_Increasing.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "optIncreasing");
addFile(proj, nameFile);

% file .txt
str = 'Policy_Increasing.txt';
nameFile = fullfile(filePath, str);
optIncreasing.writeFile(result, nameFile)
addFile(proj, nameFile);