function repSet = createRepSet(nTar, nRepair, prop, beta)

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
