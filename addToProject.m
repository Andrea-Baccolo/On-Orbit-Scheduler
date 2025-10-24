clear all
clc

% get the complete filename
% using fullfile to be indipendent from the OS (operating system)
proj = currentProject;
projectPath = proj.RootFolder;
subFolder = 'Test';   
fileName  = 'test_Seq2Tour.m'; 
nameFile = fullfile(projectPath, subFolder, fileName);


addFile(proj, nameFile);