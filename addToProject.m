% clear all
% clc

%%

% Script that adds a file to the matlab project

% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Test';
subfolder1 = '';
fileName  = "test_Output.m";
nameFile = fullfile(projectPath, subFolder,subfolder1, fileName);


addFile(proj, nameFile);