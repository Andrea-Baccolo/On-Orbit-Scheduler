
clear all
clc

% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
subFolder1 = '1_Tuning'; 
fileName  = 'opt_tuning.mat'; 
nameFile = fullfile(projectPath, subFolder, subFolder1, fileName);

%% INPUTS
% accept SA 
    % T0: initial temperature
    % alpha: decay temperature parameter
% GeneralALNS Requires 
    % Fixed input parameters
        % deltas: % column vector set in this way:
            % delta(1) : the new solution is the best one so far
            % delta(2) : the new solution is better than the current one
            % delta(3) : the new solution is accepted
            % delta(4) : the new solution is rejected
        % decay: parameter that considers the preavious weights
        % nIter: maximum number of iterations
    % Problem inputs
        % initialState
        % initialSlt
    % operators
        % desSet: set of destroy 
        % repSet: set of repair


%% Fixed input parameters
%GeneralALNS 
deltas = [7, 5, 3, 1];     decay = 0.5;     nIter = 10000; 

% accept SA
T0 = 1; alpha = 0.95;

% stop Time:
totTime = 60*2;

%% Solutions inputs
% saved as initialSlt and simulator
file = 'Ex1_Yin2025.mat';
load(file)
nTar = length(simulator.initialState.targets);
 
%% Operators

% repair
nRepair = 3;
prop = 50; 
repSet = cell(nRepair,1);
repSet{1} = RepFarInsNear(nTar, beta);
repSet{2} = RepFarInsSim(nTar);
repSet{3} = RepRandom(nTar, prop); 

% taken from AverageTimeComputing file

%% Creation
opt_tuning = ALNS_SA_T_dF(destroySet, repairSet, deltas, decay, nIter, initialSeq, initialState, T0, alpha, totTime);

opt_tuning = ALNS_SA_I_dF(destroySet, repairSet, deltas, decay, nIter, initialSeq, initialState, T0, alpha);

opt_tuning = ALNS_Gr_T_dF(destroySet, repairSet, deltas, decay, nIter, initialSeq, initialState, totTime);

opt_tuning = ALNS_Gr_I_dF(destroySet, repairSet, deltas, decay, nIter, initialSeq, initialState);

save(nameFile, "opt_tuning")
addFile(proj, nameFile);