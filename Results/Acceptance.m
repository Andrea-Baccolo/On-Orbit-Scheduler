clear all
clc
%%
% getting folder
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
subFolder1 = '2_Accept'; 
filePath = fullfile(projectPath, subFolder, subFolder1);

%% 

% Problem
load("Problem.mat")
nTar = length(initialStates.targets);

% Sets
destroySet = createDesSet(nTar, 30);
repairSet = createRepSet(nTar);

% fixed ALNS
deltas = [10, 7, 3, 1];  decay =0.75 ;   nIter = 1000;  nRep = 5;
% accept SA
T0 = 400; alpha = 0.995;

%% SA opt
saOpt = ALNS_SA_I_dF(destroySet, repairSet, deltas, decay, nIter, initialSlts, initialStates, nRep, T0, alpha);
fprintf("start SA");
saOpt = saOpt.Schedule(12345);
fprintf("end SA");
% currIndxSim
nameCurr = 'SA_opt_currentSlt';
saOpt.createPlot( saOpt.outCurrIndxSim, saOpt.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = 'SA_opt_bestSlt';
saOpt.createPlot( saOpt.outBestIndxSim, saOpt.outBestFuelSim, nameBest, filePath);

% data
result = saOpt.tableConstruction();

% file .mat
str = 'SA_opt.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "saOpt");
addFile(proj, nameFile);

% file .txt
str = 'SA_opt.txt';
nameFile = fullfile(filePath, str);
saOpt.writeFile(result, nameFile)
addFile(proj, nameFile);

%% greedy opt
greedyOpt = ALNS_Gr_I_dF(destroySet, repairSet, deltas, decay, nIter, initialSlts, initialStates, nRep);
fprintf("start Greedy");
greedyOpt = greedyOpt.Schedule(12345);
fprintf("end Greedy");

% currIndxSim
nameCurr = 'Greedy_opt_currentSlt';
greedyOpt.createPlot( greedyOpt.outCurrIndxSim, greedyOpt.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = 'Greedy_opt_bestSlt';
greedyOpt.createPlot( greedyOpt.outBestIndxSim, greedyOpt.outBestFuelSim, nameBest, filePath);

% data
result = greedyOpt.tableConstruction();

% file .mat
str = 'Greedy_opt.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "greedyOpt");
addFile(proj, nameFile);

% file .txt
str = 'Greedy_opt.txt';
nameFile = fullfile(filePath, str);
greedyOpt.writeFile(result, nameFile)
addFile(proj, nameFile);


