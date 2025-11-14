clear all
clc
%% 
% Script used to test the repairers

rng(12345)
load("TestInstRepair.mat");
nTest = length(initialSltsRep);
for t = 1:nTest
    nTar = length(initialStatesRep(t).targets);
    nSSc = length(initialStatesRep(t).sscs);
    fprintf("Testing instance %d\n", t)
    repSet = createRepSet(nTar);
    for r = 1:3
        fprintf( "   %d.%d\n", t, r);
        newSlt = repSet{r}.Reparing(initialStatesRep(t), destroyedSetRep{t}, tourInfosRep(t));
    end
end
