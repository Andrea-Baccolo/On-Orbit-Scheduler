clear all
clc

% in this section I will use a Repair method to build a new solution from
% schratch. Firstly, the Repair Random will be used to heuristically get a
% good but not greedy solution. Then the Fartherst Insertion Simulation
% Repair is used to obtain a high quality solution. The degree of
% descruction is set higher to explore more solutions. It will be compared
% with a fixed degree of destruction.

%%
% getting folder
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
subFolder1 = '3_InitialSlt'; 
filePath = fullfile(projectPath, subFolder, subFolder1);

%%
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

%% Basic Initial Solution

BasicOpt = ALNS_SA_I_dF(destroySet, repairSet, deltas, decay, nIter, initialSlts, initialStates, nRep, T0, alpha);
fprintf("start Basic");
BasicOpt = BasicOpt.Schedule(12345);
fprintf("end Basic");

% currIndxSim
nameCurr = 'Basic_opt_currentSlt';
BasicOpt.createPlot( BasicOpt.outCurrIndxSim, BasicOpt.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = 'Basic_opt_bestSlt';
BasicOpt.createPlot( BasicOpt.outBestIndxSim, BasicOpt.outBestFuelSim, nameBest, filePath);

% data
result = BasicOpt.tableConstruction();

% file .mat
str = 'Basic_opt.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "BasicOpt");
addFile(proj, nameFile);

% file .txt
str = 'Basic_opt.txt';
nameFile = fullfile(filePath, str);
BasicOpt.writeFile(result, nameFile)
addFile(proj, nameFile);

%% Random Initial Solution
rng(12345);
Destroyer = DesRandom(nTar, 100); % complete destruction
[destroyedSet, tourInfos] = Destroyer.Destruction(initialSlts, initialStates);
RandomRepair = RepRandom(nTar, 100); % try all of the destroyed target
newSlt = RandomRepair.Reparing(initialStates, destroyedSet, tourInfos);
newSlt = newSlt.buildManSet(initialStates);

%%
RandomOpt = ALNS_SA_I_dF(destroySet, repairSet, deltas, decay, nIter, newSlt, initialStates, nRep, T0, alpha);
fprintf("start Random");
RandomOpt = RandomOpt.Schedule(12345);
fprintf("end Random");

% currIndxSim
nameCurr = 'Random_opt_currentSlt';
RandomOpt.createPlot( RandomOpt.outCurrIndxSim, RandomOpt.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = 'Random_opt_bestSlt';
RandomOpt.createPlot( RandomOpt.outBestIndxSim, RandomOpt.outBestFuelSim, nameBest, filePath);

% data
result = RandomOpt.tableConstruction();

% file .mat
str = 'Random_opt.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "RandomOpt", "newSlt");
addFile(proj, nameFile);

% file .txt
str = 'Random_opt.txt';
nameFile = fullfile(filePath, str);
RandomOpt.writeFile(result, nameFile)
addFile(proj, nameFile);

%% Simulation Initial Solution
rng(12345);
Destroyer = DesRandom(nTar, 100); % complete destruction
[destroyedSet, tourInfos] = Destroyer.Destruction(initialSlts, initialStates);
SimulationRepair = RepFarInsSim(nTar);
newSlt = SimulationRepair.Reparing(initialStates, destroyedSet, tourInfos);
newSlt = newSlt.buildManSet(initialStates);

%%
SimulationOpt = ALNS_SA_I_dF(destroySet, repairSet, deltas, decay, nIter, newSlt, initialStates, nRep, T0, alpha);
fprintf("start Simulation");
SimulationOpt = SimulationOpt.Schedule(12345);
fprintf("end Simulation");

% currIndxSim
nameCurr = 'Simulation_opt_currentSlt';
SimulationOpt.createPlot( SimulationOpt.outCurrIndxSim, SimulationOpt.outCurrFuelSim, nameCurr, filePath);

% currIndxSim
nameBest = 'Simulation_opt_bestSlt';
SimulationOpt.createPlot( SimulationOpt.outBestIndxSim, SimulationOpt.outBestFuelSim, nameBest, filePath);

% data
result = SimulationOpt.tableConstruction();

% file .mat
str = 'Simulation_opt.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "SimulationOpt", "newSlt");
addFile(proj, nameFile);

% file .txt
str = 'Simulation_opt.txt';
nameFile = fullfile(filePath, str);
SimulationOpt.writeFile(result, nameFile)
addFile(proj, nameFile);

%% Best Solution
seq = [0 7 10 1 14 0 12 5 13 2 0 11 3 6 0
       0 9 8  4  0 15*ones(1,10)];
newSlt = Solution(seq, nTar, initialStates);

%%
BestOpt = ALNS_SA_I_dF(destroySet, repairSet, deltas, decay, nIter, newSlt, initialStates, nRep, T0, alpha);
fprintf("start Best");
BestOpt = BestOpt.Schedule(12345);
fprintf("end Best");

% currIndxSim
nameCurr = 'Best_opt_currentSlt';
BestOpt.createPlot( BestOpt.outCurrIndxSim, BestOpt.outCurrFuelSim, nameCurr, filePath);

hasEmpty = any(cellfun(@isempty, BestOpt.outBestIndxSim));
if (isscalar(hasEmpty))
    flag = hasEmpty;
else
    flag = sum(hasEmpty);
end
if(flag==0)
    % currIndxSim
    nameBest = 'Best_opt_bestSlt';
    BestOpt.createPlot( BestOpt.outBestIndxSim, BestOpt.outBestFuelSim, nameBest, filePath);
else
    fprintf("It exist at least one replica where no improvement has been made\n")
end


% data
result = BestOpt.tableConstruction();

% file .mat
str = 'Best_opt.mat';
nameFile = fullfile(filePath, str);
save(nameFile, "result", "BestOpt", "newSlt");
addFile(proj, nameFile);

% file .txt
str = 'Best_opt.txt';
nameFile = fullfile(filePath, str);
BestOpt.writeFile(result, nameFile)
addFile(proj, nameFile);