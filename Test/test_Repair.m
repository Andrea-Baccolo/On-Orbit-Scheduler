%% RepairRandom ExRep0
clear all
clc
rng(1234552876)
load('ExRep0.mat')
r = RepairRandom(50, nTar);
slt = r.Reparing(simulator.initialState, destroyedSet, tourInfos);

%% RepairRandom ExRep1
clear all
clc
rng(1234552876)
load('ExRep1.mat')
r = RepairRandom(50, nTar);
slt = r.Reparing(simulator.initialState, destroyedSet, tourInfos);

%% RepairRandom ExRep2
clear all
clc
rng(1234552876)
load('ExRep2.mat')
r = RepairRandom(50, nTar);
slt = r.Reparing(simulator.initialState, destroyedSet, tourInfos);

%% RepairInsert ExRep0
clear all
clc
rng(1234552876)
load('ExRep0.mat')
r = RepairInsert(nTar);
slt = r.Reparing(simulator.initialState, destroyedSet, tourInfos);



