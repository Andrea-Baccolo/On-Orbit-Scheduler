clear all
clc
rng(12345)
load("TestInstance.mat");
nTest = length(initialSlts);
degDes = [0,100,50];
for counter = 1:3
    for t = 1:nTest
        nTar = length(initialStates(t).targets);
        nSSc = length(initialStates(t).sscs);
        fprintf("Testing instance %d\n", t)
        desSet = createDesSet(nTar, degDes(counter));
        for d = 1:10
            if(t == 4 && counter == 3)
                alpha = 0;
            end
            fprintf( "   %d.%d\n", d, counter);
            [destroyedSet, tourInfos] = desSet{d}.Destruction(initialSlts(t), initialStates(t));
        end
    end
end

