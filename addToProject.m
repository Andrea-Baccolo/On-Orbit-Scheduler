clear all
clc

%%

% Script that adds a file to the matlab project

% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Destroy';   
fileName  = "DesRelatedGreedy.m";
nameFile = fullfile(projectPath, subFolder, fileName);


addFile(proj, nameFile);