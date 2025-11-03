% Create Instance of problem for results
clear all
clc

% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Results';   
fileName  = 'Ex1_Yin2025.mat'; 
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

%% Case 7: Yin2025
nSSc = 4; nTar = 9;
i_S = 0.029;    omega_S = 117.5922;     nu_S = 10.3517;  
i_T = [0.0814, 1.7994, 0.0190, 1.7631, 0.0622, 0.1815, 0.0166, 0.0195, 0.9398]; 
omega_T = [87.3687, 90.4605, 117.5922, 84.5555, 14.8070, 89.4354, 145.1002, 120.4, 92.7282];
nu_T = [83.5351, 171.7470, 60.3517, 182.4739, 113.2472, 261.0464, 28.4652, 359.8973, 203.1217];
dryMass_S = 500*ones(nSSc,1);           dryMass_T = 5000*ones(nTar,1);
fuelMass_S = 2500*ones(nSSc,1);         dm = [500, 200, 500, 300, 200, 400, 250, 450, 500]';
totCap_S = 2500*ones(nSSc,1);           totCap_T = 1000*ones(nTar,1);
specificImpulse_S = 3*ones(nSSc,1);     fuelMass_T = totCap_T - dm;
refillSpeedSSc = 0.0083*ones(nSSc,1);   refillSpeed = 0.0083*2;
seq = 0;

[initialState, initialSlt] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% add to project
save(nameFile, "initialState", "initialSlt")
addFile(proj, nameFile);

