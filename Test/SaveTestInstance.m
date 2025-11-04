% Create Instance of testing
clear all
clc

% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Test';   
fileName  = 'TestInstance.mat'; 
nameFile = fullfile(projectPath, subFolder, fileName);

%% Creating test Structure 
nTest = 6;
initialStates(nTest) = State();
initialSlts(nTest) = Solution();

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

%% Case 1: one element

nSSc = 1; nTar = 1;
i_S = 20;   omega_S = 60; nu_S = 0;  
i_T = 130;  omega_T = 90; nu_T = 0;

dryMass_S = 500*ones(nSSc,1);           dryMass_T = 5000*ones(nTar,1);
fuelMass_S = 2500*ones(nSSc,1);         dm = 100;
totCap_S = 2500*ones(nSSc,1);           totCap_T = 1000*ones(nTar,1);
specificImpulse_S = 3*ones(nSSc,1);     fuelMass_T = totCap_T - dm;
refillSpeedSSc = 0.0083*ones(nSSc,1);   refillSpeed = 0.0083*2;
seq = 0;

[initialStates(1), initialSlts(1)] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% Case 2: Almost Empty

nSSc = 6; nTar = 1;
i_S = 20;   omega_S = 60; nu_S = 0;  
i_T = 130;  omega_T = 90; nu_T = 0;

dryMass_S = 500*ones(nSSc,1);           dryMass_T = 5000*ones(nTar,1);
fuelMass_S = 2500*ones(nSSc,1);         dm = 100;
totCap_S = 2500*ones(nSSc,1);           totCap_T = 1000*ones(nTar,1);
specificImpulse_S = 3*ones(nSSc,1);     fuelMass_T = totCap_T - dm;
refillSpeedSSc = 0.0083*ones(nSSc,1);   refillSpeed = 0.0083*2;
seq = 0;

[initialStates(2), initialSlts(2)] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% Case 3: Small 

nSSc = 2; nTar = 4;
i_S = 20;   omega_S = 60; nu_S = 0;  
i_T = [130, 70, 50, 120];  
omega_T = [90, 350, 110, 240]; 
nu_T = [0, 180, 60, 265];

dryMass_S = 500*ones(nSSc,1);           dryMass_T = 5000*ones(nTar,1);
fuelMass_S = 2500*ones(nSSc,1);         dm = [500, 200, 500, 300]';
totCap_S = 2500*ones(nSSc,1);           totCap_T = 1000*ones(nTar,1);
specificImpulse_S = 3*ones(nSSc,1);     fuelMass_T = totCap_T - dm;
refillSpeedSSc = 0.0083*ones(nSSc,1);   refillSpeed = 0.0083*2;
seq = [0 1 0 2 0
       0 3 4 0 5];

[initialStates(3), initialSlts(3)] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% Case 4: Medium 

nSSc = 4; nTar = 15;
i_S = 20;   omega_S = 60; nu_S = 0;  
i_T = [130, 70, 50, 120, 110,20,105,40,50,60,13,90,10,80,30 ];  
omega_T = [90, 150, 110, 14,145,21,230,150,200,90,15,30,24,75,18];
nu_T = [0, 180, 60, 265, linspace(10, 340, 11) ];

dryMass_S = 500*ones(nSSc,1);           dryMass_T = 5000*ones(nTar,1);
fuelMass_S = 25000*ones(nSSc,1);         dm = [300, 200, 50, 300, 200, 100, 250, 450, 100, 400, 200, 200, 300, 200, 20]';
totCap_S = 25000*ones(nSSc,1);           totCap_T = 1000*ones(nTar,1);
specificImpulse_S = 3*ones(nSSc,1);     fuelMass_T = totCap_T - dm;
refillSpeedSSc = 0.0083*ones(nSSc,1);   refillSpeed = 0.0083*2;
seq = 0;

[initialStates(4), initialSlts(4)] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% Case 5: Full

nSSc = 2; nTar = 15;
i_S = 20;   omega_S = 60; nu_S = 0;  
i_T = [130, 70, 50, 120, 110,20,105,40,50,60,13,90,10,80,30 ];  
omega_T = [90, 150, 110, 14,145,21,230,150,200,90,15,30,24,75,18];
nu_T = [0, 180, 60, 265, linspace(10, 340, 11) ];
dryMass_S = 500*ones(nSSc,1);           dryMass_T = 5000*ones(nTar,1);
fuelMass_S = 25000*ones(nSSc,1);         dm = [300, 200, 50, 300, 200, 100, 250, 450, 100, 400, 200, 200, 300, 200, 20]';
totCap_S = 25000*ones(nSSc,1);           totCap_T = 1000*ones(nTar,1);
specificImpulse_S = 3*ones(nSSc,1);     fuelMass_T = totCap_T - dm;
refillSpeedSSc = 0.0083*ones(nSSc,1);   refillSpeed = 0.0083*2;
seq = 0;

[initialStates(5), initialSlts(5)] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% Case 6: Yin2025
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

[initialStates(6), initialSlts(6)] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% Case 7: Case Experiment

nSSc = 2; nTar = 15;
i_S = 20;   omega_S = 60; nu_S = 0;  
i_T = [130, 70, 50, 120, 110,20,105,40,50,60,13,90,10,80,30 ];  
omega_T = [90, 150, 110, 14,145,21,230,150,200,90,15,30,24,75,18];
nu_T = [0, 180, 60, 265, linspace(10, 340, 11) ];
dryMass_S = 500*ones(nSSc,1);           dryMass_T = 5000*ones(nTar,1);
fuelMass_S = 25000*ones(nSSc,1);         dm = [300, 200, 50, 300, 200, 100, 250, 450, 100, 400, 200, 200, 300, 200, 20]';
totCap_S = 25000*ones(nSSc,1);           totCap_T = 700*ones(nTar,1);
specificImpulse_S = 3*ones(nSSc,1);     fuelMass_T = totCap_T - dm;
refillSpeedSSc = 0.0083*ones(nSSc,1);   refillSpeed = 0.0083*2;
seq = 0;

[initialStates(7), initialSlts(7)] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq);

%% save and add to project
save(nameFile, "initialStates", "initialSlts")
addFile(proj, nameFile);
