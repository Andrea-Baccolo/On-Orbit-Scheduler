% Create Instance of problem
clear all
clc

% get the complete filename
folder = fileparts(mfilename('fullpath'));
nameFile = fullfile(folder, 'Ex0_1S1T.mat');
%% NUMBERS AND OTHER STUFF
nSSc = 1;
nTar = 1;

%% ORBITS'S INFO
% station ( ssc's orbit at the beginning are the same of the station) 
i_S = 20;
omega_S = 60;

% tagets

%%%%%% example 0_1S1T
i_T = 130; 
omega_T = 90;

%%%%%% example 0_2S4T
% i_T = [130, 70, 50, 120]; 
% omega_T = [90, 350, 110, 240];

infeas = checkInstance([i_T, i_S], [omega_T, omega_S]);

%% SATELLITES'S INFO
% sscs
dryMass_S = 150*ones(nSSc,1);
fuelMass_S = 150*ones(nSSc,1);
totCap_S = 150*ones(nSSc,1);
specificImpulse_S = 1*ones(nSSc,1);
refillSpeedSSc = 0.0083*ones(nSSc,1); % one Kg every two minutes converted in Kg/s

% Station
nu_ST = 0;
refillSpeed = 0.0083*2; % 1 Kg every  minute converted in Kg/s

% targets
dryMass_T = 300*ones(nTar,1);
fuelMass_T = 70*ones(nTar,1);
totCap_T = 100*ones(nTar,1);

%%%%%% example 0_1S1T
nu_T = 0;
%%%%%% example 0_2S4T
%nu_T = [0, 180, 80, 265];


%% CREATING ORBITS AND SATELLITES

% station
StationOrbit = GeosyncCircOrb(i_S,omega_S);
station = Station(StationOrbit, nu_ST, refillSpeed);

% sscs
sscs(nSSc) = SSc();
for i =1:nSSc
    S = SSc(StationOrbit, nu_ST, dryMass_S(i), fuelMass_S(i), totCap_S(i), refillSpeedSSc(i),specificImpulse_S(i));
    sscs(i) = S;
end

% targets
targets(nTar) = Target();
for i =1:nTar
    orbitT = GeosyncCircOrb(i_T(i),omega_T(i));
    T = Target(orbitT, nu_T(i), dryMass_T(i), fuelMass_T(i), totCap_T(i));
    targets(i) = T;
end

%% SEQUENCE, STATE & SIMULATOR
%%%%%% example 0_1S1T
seq = initialSeq(nTar, nSSc);

%%%%%% example 0_2S4T
% seq = [0 1 0 2 0
%        0 3 4 0 5];
initialSlt = Solution(seq, nTar);
[~,m] = size(seq);
initialState = State(sscs, targets, station, 0);
simulator = Simulator(initialState);
save(nameFile, "simulator", "initialSlt")
