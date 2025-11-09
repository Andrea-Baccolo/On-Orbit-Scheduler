function repSet = createRepSet(nTar, nRepair, prop, beta)

    % METHOD: General function to create a repair set.

    % INPUTS:
        % nTar: number of targets.
        % nRepair: total number of destroyers.
        % prop: proportion to check when using the random repair, between 0
            % and 1 , 1 is default.
        % beta: a number between 0 and 1 used in the relatedness measure (default 0.5).
        

    % OUTPUTS:
        % cell array with nRepair repairs.

    if nargin < 2, nRepair = 3; end
    if nargin < 3 , prop = 1; end
    if nargin < 4 && nRepair >= 3, beta = 0.5; end
    
    repSet = cell(nRepair,1);

    for i = 1:nRepair
        switch i
            case 1 
                repSet{i} = RepRandom(nTar, prop); 
            case 2
                repSet{i} = RepFarInsSim(nTar);
            case 3 
                repSet{i} = RepFarInsNear(nTar, beta);
        end
    end
end
