%% ExRep1
clear all
clc
rng(1234552876)
load('ExRep1.mat')
r = RepairRandom(50, nTar);
slt = r.Reparing(simulator.initialState, destroyedSet, tourInfos);

%% ExRep2
clear all
clc
rng(1234552876)
load('ExRep2.mat')
r = RepairRandom(50, nTar);
slt = r.Reparing(simulator.initialState, destroyedSet, tourInfos);
