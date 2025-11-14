clear all
clc

% testing output objects

%% create cell array of objects
load("Problem.mat");
cellArray = cell(9,1);
cellArray{1} = initialSlts;
cellArray{2} = initialSlts.tourInfo;
cellArray{3} = initialSlts.sscMan{1,1}{1,1};
cellArray{4} = initialSlts.sscMan{1,1}{2,1};
cellArray{5} = initialSlts.sscMan{1,1}{3,1};
cellArray{6} = initialStates.sscs(1,1).orbit;
cellArray{7} = initialStates.sscs(1,1);
cellArray{8} = initialStates.targets(1,1);
cellArray{9} = initialStates.station;

%% test the cellArray 

% Create fileOutput folder
testDir = fullfile(pwd, 'Test');

% Create fileOutput folder
outDir = fullfile(testDir, 'fileOutput');
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

for i = 1:numel(cellArray)
    obj = cellArray{i};

    % get class name
    className = class(obj);

    % get full path 
    filename = fullfile(outDir, [className '_out.txt']);

    % test
    outputTest(obj, filename);
end

fprintf('Testcompleted');

%% test separately the state object

obj = initialStates; 

obj.output()
obj.output(1, 2, [2,4,6]);

% get class name
className = class(obj);

% get full path 
filename = fullfile(outDir, [className '_out.txt']);

%open file
fid = fopen(filename, 'w');
if fid == -1
    error('Errore nell''apertura del file.');
end

obj.output(fid) %write
fclose(fid); %close