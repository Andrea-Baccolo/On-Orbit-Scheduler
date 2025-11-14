clear all
clc

%% Do all results at once

run("Tuning.m");
run("Acceptance.m");
run("InitialSolution.m");
run("DestroyPolicy.m");
run("OperatorsComparison.m");