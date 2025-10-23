%% 
clear all
clc
rng(123456)
load('ExRep.mat')
r = RepairRandom(50, nTar);
slt = r.Reparing(simulator.initialState, destroyedSet, tourInfos);
 % initialState, destroyedSet, tourInfo