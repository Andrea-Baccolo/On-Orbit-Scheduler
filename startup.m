% startup


%% STARTUP.M - Comandi eseguiti all'apertura del progetto

addpath(genpath(pwd));
disp('All folders are added to path.');

[status, cmdout] = system('git pull');
if status == 0
    disp('Repository Git updated successfully:');
    disp(cmdout);
else
    warning('Git pull failed: %s', cmdout);
end


% Upload Libraies
% run('path/Library.m');

disp('Project ready');
