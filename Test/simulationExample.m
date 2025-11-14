clear all
clc

%% Simulation

% for this simulation example, the file "TestInstance.mat" has been used.

%% 1: get the problem instance.

load("TestInstance.mat");
slt = initialSlts(5);
state = initialStates(5);

% this solution is already full, for the sake of demonstration it sscMan
% will be cancelled out and rebuild below.
Cel = cell(2,16);
slt.sscMan = Cel;


%% 2: simulate all sequence.

% the solution class already has an build-in method to simulate all the
% sequence, it is called buldManSeq, for more info check the dedicated help section.
% below there is an example of usage.
newSlt = slt.buildManSet(state);

%% 3: simulate a part of the sequence.

% if other sequences needs to be simulate, one may create himself the simulator object and create the sequence to simulate
simulator = Simulator(state);
[simState, infeas, totFuel, totTime, maneuvers] = simulator.SimulateSeq(state, 1, [0 1 2 3 0], [1, 2, 3]);
% for more info check the dedicated help section.