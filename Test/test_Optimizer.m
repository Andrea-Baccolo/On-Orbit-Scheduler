
clear all
clc
% Script used to test the optimizers

%% Fixed input parameters

%GeneralALNS 
deltas = [7, 5, 3, 1];     decay = 0.5;     nIter = 25;    nRep = 2;

% accept SA
T0 = 1; alpha = 0.95;

% solutions inputs
%load("TestInstance.mat");
load("Problem.mat");
nTest = length(initialSlts);
for t= 1:nTest
    nTar = length(initialStates(t).targets);
    % operators set
    destroySet = createDesSet(nTar, 30);
    repairSet = createRepSet(nTar);

    Op_cell = cell(1,12);

    Op_cell{1} = ALNS_SA_I_dF(destroySet, repairSet, deltas, decay, nIter, initialSlts(t),  initialStates(t), nRep, T0, alpha);
    Op_cell{2} = ALNS_Gr_I_dF(destroySet, repairSet, deltas, decay, nIter, initialSlts(t),  initialStates(t), nRep);
    Op_cell{3} = ALNS_SA_I_dI(destroySet, repairSet, deltas, decay, nIter, initialSlts(t),  initialStates(t), nRep, T0, alpha);
    Op_cell{4} = ALNS_Gr_I_dI(destroySet, repairSet, deltas, decay, nIter, initialSlts(t),  initialStates(t), nRep);
    Op_cell{5} = ALNS_SA_I_dR(destroySet, repairSet, deltas, decay, nIter, initialSlts(t),  initialStates(t), nRep, T0, alpha);
    Op_cell{6} = ALNS_Gr_I_dR(destroySet, repairSet, deltas, decay, nIter, initialSlts(t),  initialStates(t), nRep);
    % creating operators
    for o = 1:6
        % if(t == 4)
        %     fprintf("hi");
        % end
        fprintf("testing Instance %d optimizer %d\n", t, o);
        Op_cell{o} = Op_cell{o}.Schedule(12345);
        
    end

end



