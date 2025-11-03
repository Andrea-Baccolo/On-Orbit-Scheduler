function desSet = createDesSet(nTar, degDes, nDestroy, beta, p)
    if nargin < 2, degDes = 50; end
    if nargin < 3, nDestroy = 10; end
    if nargin < 4 && nDestroy >1, beta = 0.5; end
    if nargin < 5 && nDestroy >2, p = 1; end

    desSet = cell(nDestroy,1);

    for i = 1:nDestroy
        switch i
            case 1 
                desSet{i} = DesRandom(nTar, degDes);
            case 2
                desSet{i} = DesRelatedGreedy(nTar, degDes, beta);
            case 3 
                desSet{i} = DesRelatedRandom(nTar, degDes, beta, p);
            case 4 
                desSet{i} = DesFirst(nTar, degDes);
            case 5 
                desSet{i} = DesLast(nTar, degDes);
            case 6 
                desSet{i} = DesTourCost(nTar, degDes);
            case 7 
                desSet{i} = DesTourRandom(nTar, degDes);
            case 8 
                desSet{i} = DesTourSmall(nTar, degDes);
            case 9 
                desSet{i} = DesSScCost(nTar, degDes);
            case 10 
                desSet{i} = DesSScRandom(nTar, degDes);
        end
    end
end

