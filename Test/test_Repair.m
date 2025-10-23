%% 
clear all
clc
rng(1234552876)
load('ExRep.mat')
r = RepairRandom(50, nTar);
slt = r.Reparing(simulator.initialState, destroyedSet, tourInfos);
 % initialState, destroyedSet, tourInfo