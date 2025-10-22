% Create Instance of problem
clear all
clc

% get the complete filename
folder = fileparts(mfilename('fullpath'));
nameFile = fullfile(folder, 'ExRep.mat');
%% NUMBERS AND OTHER STUFF
nSSc = 3;
nTar = 15;

%% ORBITS'S INFO
% station ( ssc's orbit at the beginning are the same of the station) 
i_S = 20;
omega_S = 60;

% tagets
i_T = [110,20,140,40,150,60,130,90,10,80,30,120,50,100,78]; 
omega_T = [145,210,330,150,270,90,15,30,240,275,180,0,120,300,60];

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

nu_T = 10.*(1:nTar);


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
seq = [0 15 0 4 5 0 6 7 8 0 ;
       0 9 0 1 2 3 0 11 12 0 ;
       0 13 0 14 0 10 0 16 16 16];
slt = Solution(seq,nTar);
[~,m] = size(seq);
initialState = State(sscs, targets, station, 0);
simulator = Simulator(initialState);

d = DestroyOdd(nTar);
[destroyedSet, tourInfos] = d.Destruction(slt, []);
save(nameFile, "simulator", "slt", "nTar","destroyedSet", "tourInfos")

