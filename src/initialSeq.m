function [seq] = initialSeq(nTar, nSsc)
    n = ceil(nTar/nSsc);

    seq = zeros(nSsc,2*n+1);
    targetCounter = 1;
    for i = 1:nSsc
        for j = 1:2*n+1
            if(targetCounter<=nTar)
                if(mod(j,2)==0)
                    seq(i,j) = targetCounter;
                    if(targetCounter == nTar)
                        pos = [i,j+1];
                    end
                    targetCounter = targetCounter + 1;
                end
            else, seq(i,j) = nTar+1; 
            end
        end
    end
    seq(pos(1), pos(2)) = 0;
end