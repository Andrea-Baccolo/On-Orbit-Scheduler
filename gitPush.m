function gitPush(branchName)
% GITPUSH - Push changes to GitHub from the current branch

% e.g.: gitPush('main') - Push changes to the 'main' branch

    % check if there is the branch name
    if nargin < 1
        branchName = 'main'; % default branch
    end
    % push
    cmdPush = sprintf('git push origin %s', branchName);
    [statusPush, outputPush] = system(cmdPush);
    % message
    if statusPush == 0
        disp('Push successful:');
        disp(outputPush);
    else
        warning('Push failed: %s', outputPush);
    end
end