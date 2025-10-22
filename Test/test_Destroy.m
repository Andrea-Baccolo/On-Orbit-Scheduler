%% example 
clear all
clc
seq = [0 15 0 4 5 0 6 7 8 0 ;
       0 9 0 1 2 3 0 11 12 0 ;
       0 13 0 14 0 10 0 16 16 16];
fuelUsage = [ 5 5 3 ones(1,6);
              2 1 2 2 2 2 3 3 3;
              3 4 1 1 3 3 0 0 0];
nTar = 15;
folder = fileparts(mfilename('fullpath'));
nameFile = fullfile(folder, 'ExSlt1.mat');
slt = Solution(seq,nTar);
slt = slt.artificialSlt(seq, {}, fuelUsage, [], nTar);
save(nameFile, "slt", "nTar");


%% Destroy Random
clear all
clc
load("ExSlt1.mat")
d = DestroyRandom(nTar, 50);
[destroyedSet, tourInfos] = d.Destruction(slt, []);


%% Destroy Tour Random
clear all
clc
load("ExSlt1.mat")
rng(12345)
d = DestroyTourRandom(nTar, 50);
[destroyedSet, tourInfos] = d.Destruction(slt, []);


%% Destroy Tour Small
clear all
clc
load("ExSlt1.mat")
d = DestroyTourSmall(nTar, 50);
[destroyedSet, tourInfos] = d.Destruction(slt, []);

%% Destroy Tour Cost
clear all
clc
load("ExSlt1.mat")
d = DestroyTourCost(nTar, 50);
[destroyedSet, tourInfos] = d.Destruction(slt, []);

%% Destroy SSc Random
clear all
clc
load("ExSlt1.mat")
d = DestroySScRandom(nTar, 50);
[destroyedSet, tourInfos] = d.Destruction(slt, []);

%% Destroy SSc Cost

clear all
clc
load("ExSlt1.mat")
d = DestroySScCost(nTar, 50);
[destroyedSet, tourInfos] = d.Destruction(slt, []);

%% Destroy First
clear all
clc
load("ExSlt1.mat")
d = DestroyFirst(nTar);
[destroyedSet, tourInfos] = d.Destruction(slt, []);

%% Destroy Last
clear all
clc
load("ExSlt1.mat")
d = DestroyLast(nTar);
[destroyedSet, tourInfos] = d.Destruction(slt, []);

%% Destroy Odd
clear all
clc
load("ExSlt1.mat")
d = DestroyOdd(nTar);
[destroyedSet, tourInfos] = d.Destruction(slt, []);
%% Destroy Even
clear all
clc
load("ExSlt1.mat")
d = DestroyEven(nTar);
[destroyedSet, tourInfos] = d.Destruction(slt, []);