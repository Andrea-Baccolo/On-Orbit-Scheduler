function testSeq2Pos(nSSc, tourInfo, nPos)
    for i = 1:nSSc
        fprintf("SSc %d\n\n", i);
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

lTour = [1,1,4;3,2,1;2,1,3;4,1,0];
tours = { 1, 11, [16,17,19,18]
          [2,3,4], [12,13],20
          [5,6], 14, [21,22,23]
          [7,8,9,10], 15, []};
nTour = [4,4,3];
tourInfo = TourInfo();
tourInfo = tourInfo.artificialTourInfo(tours, lTour, nTour);

nSSc = 3;

nPos = [15,10,12];
testSeq2Pos(nSSc, tourInfo, nPos)
