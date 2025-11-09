
clear all
clc

% Script used to simulate a single simulation-optimization or to run all results in one go.

%% getting folder
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
filePath = fullfile(projectPath, subFolder);

%% Current Setting

% fixed ALNS
deltas = [2, 1.5, 1, 0.5];  decay =0.25 ;   nIter = 1000;  nRep = 5;

% Problem
load("Problem.mat")
nTar = length(initialStates.targets);

% Sets
destroySet = createDesSet(nTar, 30);
repairSet = createRepSet(nTar);

Current_SettingOpt = ALNS_Gr_I_dF(destroySet, repairSet, deltas, decay, nIter, initialSlts, initialStates, nRep);
fprintf("start Current_Setting");
Current_SettingOpt = Current_SettingOpt.Schedule(12345);
fprintf("end Current_Setting");

% currIndxSim
nameCurr = 'Current_Setting_opt_currentSlt';
Current_SettingOpt.createPlot( Current_SettingOpt.outCurrIndxSim, Current_SettingOpt.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = 'Current_Setting_opt_bestSlt';
Current_SettingOpt.createPlot( Current_SettingOpt.outBestIndxSim, Current_SettingOpt.outBestFuelSim, nameBest, filePath);

% data
result = Current_SettingOpt.tableConstruction();

% file .mat
str = 'Current_Setting_opt.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "Current_SettingOpt");
addFile(proj, nameFile);

% file .txt
str = 'Current_Setting_opt.txt';
nameFile = fullfile(filePath, str);
Current_SettingOpt.writeFile(result, nameFile)
addFile(proj, nameFile);

%% Do all results

run("Tuning.m");
run("Acceptance.m");
run("InitialSolution.m");
run("DestroyPolicy.m");
run("OperatorsComparison.m");