%% STARTUP.M - Commands exectuted when opening the project

addpath(genpath(pwd));
disp('All folders are added to path.');

[status, cmdout] = system('git pull');
if status == 0
    disp('Repository Git updated successfully:');
    disp(cmdout);
else
    warning('Git pull failed: %s', cmdout);
end

disp('Project ready');
