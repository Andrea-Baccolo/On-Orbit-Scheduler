clear all
clc

% Comparison script. for more information, see the thesis.

%% 

% Problem
load("Problem.mat")
nTar = length(initialStates.targets);

% fixed ALNS
deltas =  [1, 0.7, 0.3, 0.1];  decay =0.25 ;   nIter = 1000;  nRep = 5;
% accept SA
T0 = 400; alpha = 0.995;

% Repair Sets
repairSet = createRepSet(nTar);
destroySet = createDesSet(nTar, 30); 

%% Destroy Comparison
% getting folder
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
subFolder1 = '5_Comparison';
subFolder2 = 'Destroy';
filePath = fullfile(projectPath, subFolder, subFolder1, subFolder2);

%% Destroy Comparison

completeIndx = 1:10;
% matrix with start and end index to remove from destroySet for every experiment
removeIndx = [ 1, 3
               4, 5
               6, 8
               9, 10
               4, 10];
nExp = size(removeIndx,1);

for e = 1:nExp
    % choosing destroyed set
    newIndx = completeIndx( (completeIndx < removeIndx(e,1)) | (completeIndx > removeIndx(e,2)));
    desSet = destroySet(newIndx);

    fprintf("Comparison_%d\n", e);
    optimizer = ALNS_SA_I_dF(desSet, repairSet, deltas, decay, nIter, initialSlts, initialStates, nRep, T0, alpha);
    optimizer = optimizer.Schedule(12345);
     
    % currIndxSim
    nameCurr = sprintf('Comparison_%d_currSlt', e);
    optimizer.createPlot( optimizer.outCurrIndxSim, optimizer.outCurrFuelSim, nameCurr, filePath);

    % currIndxSim
    nameBest = sprintf('Comparison_%d_bestSlt', e);
    optimizer.createPlot( optimizer.outBestIndxSim, optimizer.outBestFuelSim, nameBest, filePath);

    % data
    result = optimizer.tableConstruction();

    % file .mat
    str = sprintf('Comparison_%d.mat', e);
    nameFile = fullfile(filePath, str);
    save(nameFile, "result", "optimizer");
    addFile(proj, nameFile);

    % file .txt
    str = sprintf('Comparison_%d.txt', e);
    nameFile = fullfile(filePath, str);
    optimizer.writeFile(result, nameFile)
    addFile(proj, nameFile);

    fprintf("end %d\n", e);
end


%% Repair comparison
% getting folder
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
subFolder1 = '5_Comparison';
subFolder2 = 'Repair';
filePath = fullfile(projectPath, subFolder, subFolder1, subFolder2);

%% Repair comparison

completeIndx = 1:3;
% matrix with start and end index to remove from destroySet for every experiment
removeIndx = [ 1, 1
               2, 2
               3, 3
               1, 2
               2, 3];
nExp = size(removeIndx,1);

for e = 1:nExp
    % choosing destroyed set
    newIndx = completeIndx( (completeIndx < removeIndx(e,1)) | (completeIndx > removeIndx(e,2)));
    repSet = repairSet(newIndx);

    fprintf("Comparison_Repair_%d\n", e);
    optimizer = ALNS_SA_I_dF(destroySet, repSet, deltas, decay, nIter, initialSlts, initialStates, nRep, T0, alpha);
    optimizer = optimizer.Schedule(12345);
     
    % currIndxSim
    nameCurr = sprintf('Comparison_Repair_%d_currSlt', e);
    optimizer.createPlot( optimizer.outCurrIndxSim, optimizer.outCurrFuelSim, nameCurr, filePath);

    % currIndxSim
    nameBest = sprintf('Comparison_Repair_%d_bestSlt', e);
    optimizer.createPlot( optimizer.outBestIndxSim, optimizer.outBestFuelSim, nameBest, filePath);

    % data
    result = optimizer.tableConstruction();

    % file .mat
    str = sprintf('Comparison_Repair_%d.mat', e);
    nameFile = fullfile(filePath, str);
    save(nameFile, "result", "optimizer");
    addFile(proj, nameFile);

    % file .txt
    str = sprintf('Comparison_Repair_%d.txt', e);
    nameFile = fullfile(filePath, str);
    optimizer.writeFile(result, nameFile)
    addFile(proj, nameFile);

    fprintf("end %d\n", e);
end


e = 6;
% choosing destroyed set
repSet = repairSet(2);

fprintf("Comparison_Repair_%d\n", e);
optimizer = ALNS_SA_I_dF(destroySet, repSet, deltas, decay, nIter, initialSlts, initialStates, nRep, T0, alpha);
optimizer = optimizer.Schedule(12345);
 
% currIndxSim
nameCurr = sprintf('Comparison_Repair_%d_currSlt', e);
optimizer.createPlot( optimizer.outCurrIndxSim, optimizer.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = sprintf('Comparison_Repair_%d_bestSlt', e);
optimizer.createPlot( optimizer.outBestIndxSim, optimizer.outBestFuelSim, nameBest, filePath);

% data
result = optimizer.tableConstruction();

% file .mat
str = sprintf('Comparison_Repair_%d.mat', e);
nameFile = fullfile(filePath, str);
save(nameFile, "result", "optimizer");
addFile(proj, nameFile);

% file .txt
str = sprintf('Comparison_Repair_%d.txt', e);
nameFile = fullfile(filePath, str);
optimizer.writeFile(result, nameFile)
addFile(proj, nameFile);

fprintf("end %d\n", e);
