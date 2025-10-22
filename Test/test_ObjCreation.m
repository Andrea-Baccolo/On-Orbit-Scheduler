clear all
clc
folder = fileparts(mfilename('fullpath'));
filename = fullfile(folder, 'testAstroObj.txt');

%% testing GeoSyncCircOrb
% creating object
iS = 15;
raanS = 20;

orbitS = GeosyncCircOrb(iS, raanS);

% output test
testOutput(orbitS, filename)

% copy test
testCopy(orbitS);

%% test SSc
% creating object
ssc = SSc(orbitS, 0, 150, 150, 150, 0.083, 1);

% output test
testOutput(ssc, filename)

% copy test
testCopy(ssc);

%% test Target
% creating object
iT = 15;
raanT = 20;
orbitT = GeosyncCircOrb(iT, raanT);
target = Target(orbitT,0, 150, 150, 150);

% output test
testOutput(target, filename)

% copy test
testCopy(target);

%% test station
% creating object
station = Station(orbitS, 0, 0.083);

% output test
testOutput(station, filename)

% copy test
testCopy(station);

%% test phasing
% creating object
phasing  = Phasing(1, 2, 54, 52, 0.005, 5555, 1);

% output test
testOutput(phasing, filename)

% copy test
testCopy(phasing);

%% test planarChange
% creating object
planChange  = PlanarChange(1, 2, 54, 52, 0.005, 180,90);

% output test
testOutput(planChange, filename)

% copy test
testCopy(planChange);
%% test phasing
% creating object
refill  = Refilling(1, 2, 54, 52, 30);

% output test
testOutput(refill, filename)

% copy test
testCopy(refill);

%% test state
% creating object
state  = State(ssc, target, station);

% output test
testOutput(state, filename)

% copy test
testCopy(state);

%% test Ex0_2S4T
clear all
clc
folder = fileparts(mfilename('fullpath'));
filename = fullfile(folder, 'testAstroObj.txt');
load("Ex0_2S4T.mat")

% output test
testOutput(simulator.initialState, filename)

% copy test
testCopy(simulator.initialState);
%% test solution
% output test
testOutput(initialSlt, filename)

% copy test
testCopy(initialSlt);