% Create Instance of problem for results
clear all
clc
%%
% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
fileName  = 'Problem.mat'; 
nameFile = fullfile(projectPath, subFolder, fileName);

%% Explaination of variables

% '_S' : SSc; '_T' : Targets;

% nSSc, nTar:                  number of SScs, Targets
% i_S, i_T:                    inclinations
% omega_S, omegaT:             raans
% nu_S, nu_T:                  True anomaly 
% dryMass_S, dryMass_T:        mass that is not fuel 
% fuelMass_S, fuelMass_T:      Fuel Mass
% totCap_S, totCap_T:          total fuel tank capacity
% specificImpulse_S:           specific impulse of the SScs
% refillSpeedSSc, refillSpeed: refilling speed of SScs and Station

%% Case 7: Case Experiment

nSSc = 2; nTar = 14;
i_S = 2;   omega_S = 60; nu_S = 0;  
i_T = [1.60 0.30 1.80 7.77 1.89 1.06 1.45 1.86 0.09 5.00 2.80 4.81 2.21 0.99];
omega_T = [66.76 328.08 45.11 52.63 52.10 59.65 67.40 85.65 103.25 68.04 83.11 71.74 74.98 98.18];
nu_T = [278.27 156.03 252.16 328.00 274.21 144.68 288.52 319.30 331.94 285.07 224.48 337.75 229.24 230.86];
dryMass_S = 500*ones(nSSc,1);           dryMass_T = 5000*ones(nTar,1);
fuelMass_S = 2500*ones(nSSc,1);         %dm = [500, 200, 550, 300, 250, 400, 250, 450, 500, 500, 275, 500, 300, 200]';
dm = 500*ones(1,nTar);
totCap_S = 2500*ones(nSSc,1);           totCap_T = 700*ones(nTar,1);
specificImpulse_S = 0.3058*ones(nSSc,1);     fuelMass_T = totCap_T - dm;
refillSpeedSSc = 0.0083*ones(nSSc,1);   refillSpeed = 0.0083*2;
seq = 0;

[initialStates, initialSlts] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% add to project
save(nameFile, "initialStates", "initialSlts")
addFile(proj, nameFile);

