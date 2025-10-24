clear all
clc

% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Examples';   
fileName  = 'ExRep0.mat'; 
nameFile = fullfile(projectPath, subFolder, fileName);


addFile(proj, nameFile);