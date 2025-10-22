function [missionInfo, seqnew, zeroTour] = callTest(seq,nTar)
    missionInfo = TourInfo(seq, nTar);
    seqnew = missionInfo.rebuildSeq();
    zeroTour = missionInfo.addZeros();
end

%% test 1: complete sequence
clear all
clc
nTar = 10;
seq = [0 1 2 3 0 4 5 0; 0 6 7 0 8 9 10 0];
[missionInfo, seqnew, zeroMissio] = callTest(seq,nTar);

%% test 2.1: last ssc incomplete
clear all
clc
nTar = 7;
seq = [0 1 2 3 0 4 5 0; 0 6 7 0 8 8 8 8];
[missionInfo, seqnew, zeroMissio] = callTest(seq,nTar);

%% test 2.2: first ssc incomplete
clear all
clc
nTar = 7;
seq = [0 6 7 0 8 8 8 8;0 1 2 3 0 4 5 0];
[missionInfo, seqnew, zeroMissio] = callTest(seq,nTar);

%% test 3.1: 3 ssc, first almost empty
clear all
clc
nTar = 11;
seq = [0 1 0 12 12 12 12 12 12 12
       0 2 3 4 0 5 6 0 7 0
       0 8 0 9 10 11 0 12 12 12];
[missionInfo, seqnew, zeroMissio] = callTest(seq,nTar);
%% test 3.2: 3 ssc, second almost empty
clear all
clc
nTar = 11;
seq = [0 2 3 4 0 5 6 0 7 0
       0 1 0 12 12 12 12 12 12 12
       0 8 0 9 10 11 0 12 12 12];
[missionInfo, seqnew, zeroMissio] = callTest(seq,nTar);
%% test 4: 4 ssc with 2 almost empty and 2 very full
clear all
clc
nTar = 16;
seq = [0 10 0 17*ones(1,9)
       0 2 3 0 4 0 5 6 7 0 8 0 
       0 11 0 17*ones(1,9)
       0 1 0 9 12 13 0 14 15 0 16 0 ];
[missionInfo, seqnew, zeroMissio] = callTest(seq,nTar);

%% test 5: ssc empty
clear all
clc
nTar = 9;
seq = [0 1 2 0 3 4 5 6 7 0 8 0 9 0
       0 (nTar+1)*ones(1,13)];
[missionInfo, seqnew, zeroMissio] = callTest(seq,nTar);

folder = fileparts(mfilename('fullpath'));
filename = fullfile(folder, 'testAstroObj.txt');

testOutput(missionInfo, filename);
