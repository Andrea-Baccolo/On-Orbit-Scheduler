function gitCommit(commitMessage)
% GITCOMMIT - Commit changes in the current Git repository

% gitCommit('Message') - Commit all changes with the given commit message

% e.g.:
% gitCommit('Add new analysis function')

    % check if there is the message
    if nargin < 1
        error('You must provide a commit message, e.g., gitCommit("My commit message")');
    end
    % Add files
    [statusAdd, outputAdd] = system('git add .');
    if statusAdd ~= 0
        warning('git add failed: %s', outputAdd);
        return;
    end
    % Commit
    cmdCommit = sprintf('git commit -m "%s"', commitMessage);
    [statusCommit, outputCommit] = system(cmdCommit);
    % message
    if statusCommit == 0
        disp('Commit successful:');
        disp(outputCommit);
    else
        warning('Commit failed: %s', outputCommit);
    end
end
