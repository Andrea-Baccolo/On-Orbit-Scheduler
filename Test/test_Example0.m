%% Ex0_2S4T SimulateSeq [0 1 0] e [0 2 0]

clear all
clc
rng(123456)
load('Ex0_2S4T.mat')
tic
[state2, ~,  fuel, time, man] = simulator.SimulateSeq(simulator.initialState, 1, [0,1,0], [1,2]);
elapsedTime = toc;
fprintf('Opt time: %.8f\n ' , elapsedTime);
[state3, ~, totFuel3] = simulator.SimulateSeq(state2, 1, [0,2,0], 2);


%% Ex0_2S4T SimulateSeq [0 3 4 0]

clear all
clc
rng(123456)
load('Ex0_2S4T.mat')
tic
[state2, ~,  fuel, time, man] = simulator.SimulateSeq(simulator.initialState, 2, [0 3 4 0], [3 4], 1);
elapsedTime = toc;
fprintf('Opt time: %.8f\n ' , elapsedTime);

%% Ex0_2S4T SimulateSeq SSc 1

clear all
clc
rng(123456)
load('Ex0_2S4T.mat')
tic

updateIndx = initialSlt.generateUpdateIndx(initialSlt.seq, 4, 1);
[state2, ~,  fuel, time, man] = simulator.SimulateSeq(simulator.initialState, 1, initialSlt.seq(1,:), updateIndx, 1);
elapsedTime = toc;
fprintf('Opt time: %.8f\n ' , elapsedTime);

%% Ex0_2S4T SimulateSeq SSc 2
clear all
clc
rng(123456)
load('Ex0_2S4T.mat')
tic
updateIndx = initialSlt.generateUpdateIndx(initialSlt.seq, 4, 2);
[state2, ~,  fuel, time, man] = simulator.SimulateSeq(simulator.initialState, 2, initialSlt.seq(2,:), updateIndx, 1);
elapsedTime = toc;
fprintf('Opt time: %.8f\n ' , elapsedTime);

%% Ex0_1S1T Simulate BuildManSet  

clear all
clc
rng(123456)
load('Ex0_1S1T.mat')
tic
[initialSlt, ~] = initialSlt.buildManSet(simulator, 1);
elapsedTime = toc;
fprintf('Opt time: %.8f\n ' , elapsedTime);

%% Ex0_2S4 Simulate BuildManSet  

clear all
clc
rng(123456)
load('Ex0_2S4T.mat')
tic
[initialSlt, ~] = initialSlt.buildManSet(simulator,1);
elapsedTime = toc;
fprintf('Opt time: %.8f\n ' , elapsedTime);