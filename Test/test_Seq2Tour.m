function [tourIndx, posTour] = Seq2Pos(p, i, lTour)
    startIndx = cumsum([1; lTour(1:end-1,i) + 1]);
    endIndx   = startIndx + lTour(:,i);
    tourIndx = find(p >= startIndx & p <= endIndx, 1, 'first');
    if isempty(tourIndx)
        error('Position p = %d does not belong to any tours', p);
    end
    posTour = p - startIndx(tourIndx) + 1;
end

function testSeq2Pos(nSSc, lTour, nTour, nPos)
    for i = 1:nSSc
        fprintf("SSc %d", i);
        res = zeros(nPos(i), 3);
        res(:,1) = (1:nPos(i))';
        count = 1;
        % creating the right results
        for l = 1:nTour(i)
            indexes = count:count + lTour(l,i);
            res(indexes,2) = l*ones(length(indexes),1);
            res(indexes,3) = (1:lTour(l,i)+1)';
            count = count + lTour(l,i)+1;
        end
        % checking the function
        fail =  0;
        for pIndx = 1:nPos(i)
            [t, pt] = Seq2Pos(res(pIndx,1),i,lTour);
            if( ( t~=res(pIndx,2) ) || (pt~=res(pIndx,3)) )
                fprintf("TEST FAILED: SSc %d, position %d\n", i,pIndx);
                fprintf("True value: (%d,%d)\n",res(pIndx,2),res(pIndx,3));
                fprintf("Obtained: (%d,%d)\n",t,pt);  
                fail = 1;
            end
        end
        if(fail==0)
            fprintf("Test succesfully passed!\n");
        end

    end
end

clear all
clc

lTour = [1,1,4;3,2,1;2,1,3;4,1,0];
nSSc = 3;
nTour = [4,4,3];
nPos = [14,9,11];
testSeq2Pos(nSSc, lTour, nTour, nPos)