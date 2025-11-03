clear all
clc

%%
% getting folder
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
subFolder1 = '5_Comparison'; 
filePath = fullfile(projectPath, subFolder, subFolder1);

% Problem
load("Problem.mat")
nTar = length(initialStates.targets);

% fixed ALNS
deltas = [10, 7, 3, 1];  decay =0.75 ;   nIter = 1000;  nRep = 5;
% accept SA
T0 = 400; alpha = 0.995;

% Repair Sets
repairSet = createRepSet(nTar);
destroySet = createDesSet(nTar, 30); 

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