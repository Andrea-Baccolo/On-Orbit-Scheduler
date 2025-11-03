function testSeqPos(nSSc, tourInfo, nPos)
    for i = 1:nSSc
        %fprintf("SSc %d\n\n", i);
        res = zeros(nPos(i), 3);
        res(:,1) = (1:nPos(i))';
        count = 1;
        % creating the right results tourInfo.
        for l = 1:tourInfo.nTour(i)
            indexes = count:count + tourInfo.lTour(l,i);
            res(indexes,2) = l*ones(length(indexes),1);
            res(indexes,3) = (1:tourInfo.lTour(l,i)+1)';
            count = count + tourInfo.lTour(l,i)+1;
        end
        res(end,2) = tourInfo.nTour(i)+1;
        res(end,3) = 1;
        % checking the function
        failST =  0;
        failTS =  0;
        % TEST SEQ2TOUR
        for pIndx = 1:nPos(i)
            [t, pt] = tourInfo.Seq2Tour(res(pIndx,1), i);
            if( ( t~=res(pIndx,2) ) || (pt~=res(pIndx,3)) )
                fprintf("TEST Seq2Tour FAILED: SSc %d, position %d\n", i,pIndx);
                fprintf("True value: (%d,%d)\n",res(pIndx,2),res(pIndx,3));
                fprintf("Obtained: (%d,%d)\n",t,pt);  
                failST = 1;
            end
        end
        % TEST TOUR2SEQ
        for pIndx = 1:nPos(i)
            p = tourInfo.Tour2Seq(i, res(pIndx,2), res(pIndx,3));
            if( p~=res(pIndx,1))
                fprintf("TEST Tour2Seq FAILED : SSc %d, tour Values (%d,%d) \n", i, res(pIndx,2), res(pIndx,3));
                fprintf("True value: %d\n",res(pIndx,1));
                fprintf("Obtained: %d\n",p);  
                failTS = 1;
            end
        end
        
        if(failST==0)
            fprintf("***************Test Seq2Tour succesfully passed!***************\n");
        end
        if(failTS==0)
            fprintf("***************Test Tour2Seq succesfully passed!***************\n");
        end

    end
end
%% 
clear all
clc

load("TestInstance.mat");
nTest = length(initialSlts);
for t = 1:nTest
    nTar = length(initialStates(t).targets);
    nSSc = length(initialStates(t).sscs);
    fprintf("Testing instance %d\n", t)
    instance = initialSlts(t).tourInfo;
    % addZero Test
    zeroTour = instance.addZeros();

    % rebuildSeq Test
    seq = instance.rebuildSeq(nTar);

    % expand
    instance = instance.expand();

    %cut tours
    instance = instance.cutTour();

    % computing nPos
    nPos = zeros(nSSc, 1);
    if(t~=1)
        for i = 1:nSSc
            sequence = initialSlts(t).seq(i,:);
            sequence = sequence(sequence <= nTar);
            nPos(i) = length(sequence);
        end
    else
        nPos = ones(nSSc, 1);
    end

    % Seq Pos test
    testSeqPos(nSSc, instance, nPos);
    fprintf("end test instance %d\n", t)
end

