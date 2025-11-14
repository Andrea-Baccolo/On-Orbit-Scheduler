clear all
clc
% script used to create a test Instance for testing the repairers

%%

% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Test';   
fileName  = 'TestInstRepair.mat'; 
nameFile = fullfile(projectPath, subFolder, fileName);

%% Creating test Structure 
nTest = 29;
initialStatesRep(nTest) = State();
initialSltsRep(nTest) = Solution();
tourInfosRep(nTest) = TourInfo();
destroyedSetRep = cell(nTest, 1);

load('TestInstance.mat');
counter = 1;

%% repair nothing for test 1:7
n = 7;
startIndx = 1;
endIndx = n;
indx = counter:counter + endIndx - startIndx;
initialStatesRep(indx) = initialStates(startIndx:endIndx);
initialSltsRep(indx) = initialSlts(startIndx:endIndx);
for i = startIndx:endIndx
    nTar = length(initialStates(i).targets);
    des = DesRandom(nTar, 0);
    [destroyedSetRep{counter}, tourInfosRep(counter)] = des.Destruction(initialSlts(i), initialStates(i));
    counter = counter + 1;
end

%% repair all for test 1:7
n = 7;
startIndx = 1;
endIndx = n;
indx = counter:counter + endIndx - startIndx;
initialStatesRep(indx) = initialStates(startIndx:endIndx);
initialSltsRep(indx) = initialSlts(startIndx:endIndx);
for i = startIndx:endIndx
    nTar = length(initialStates(i).targets);
    des = DesRandom(nTar, 100);
    [destroyedSetRep{counter}, tourInfosRep(counter)] = des.Destruction(initialSlts(i), initialStates(i));
    counter = counter + 1;
end

%% without complete ssc for test 3:7
n = 7;
startIndx = 3;
endIndx = n;
indx = counter:counter + endIndx - startIndx;
initialStatesRep(indx) = initialStates(startIndx:endIndx);
initialSltsRep(indx) = initialSlts(startIndx:endIndx);
for i = startIndx:endIndx
    nTar = length(initialStates(i).targets);
    des = DesSScCost(nTar, 100/nTar);
    [destroyedSetRep{counter}, tourInfosRep(counter)] = des.Destruction(initialSlts(i), initialStates(i));
    counter = counter + 1;
end

%% without some random tour for test 3:7
n = 7;
startIndx = 3;
endIndx = n;
indx = counter:counter + endIndx - startIndx;
initialStatesRep(indx) = initialStates(startIndx:endIndx);
initialSltsRep(indx) = initialSlts(startIndx:endIndx);
for i = startIndx:endIndx
    nTar = length(initialStates(i).targets);
    des = DesTourRandom(nTar,30);
    [destroyedSetRep{counter}, tourInfosRep(counter)] = des.Destruction(initialSlts(i), initialStates(i));
    counter = counter + 1;
end

%% random 50% for test 3:7
n = 7;
startIndx = 3;
endIndx = n;
indx = counter:counter + endIndx - startIndx;
initialStatesRep(indx) = initialStates(startIndx:endIndx);
initialSltsRep(indx) = initialSlts(startIndx:endIndx);
for i = startIndx:endIndx
    nTar = length(initialStates(i).targets);
    des = DesRandom(nTar, 50);
    [destroyedSetRep{counter}, tourInfosRep(counter)] = des.Destruction(initialSlts(i), initialStates(i));
    counter = counter + 1;
end

%% save and add to project
save(nameFile, "initialStatesRep", "initialSltsRep", "destroyedSetRep","tourInfosRep" );
addFile(proj, nameFile);

