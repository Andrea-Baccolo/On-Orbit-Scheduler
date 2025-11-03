function [seq] = initialSeq(nTar, nSSc)
    nUp = ceil(nTar/nSSc);
    nDown = floor(nTar/nSSc);
    seq = zeros(nSSc,2*nUp+1);
    tarCount = 1;
    seqPos = 2;
    while(tarCount<=nTar)
        for i = 1:nSSc
            if(tarCount<=nTar)
                seq(i,seqPos) = tarCount;
                tarCount = tarCount + 1;
            else
                break;
            end
        end
        if(tarCount<=nTar)
            seqPos = seqPos + 2;
        end
    end
    if(nUp ~= nDown)
        seq = seq(:,1:seqPos+1);
        seq(i:end, seqPos:end) = tarCount;
    end
    % 
    % 
    % targetCounter = 1;
    % for i = 1:nSsc
    %     for j = 1:2*nDown+1
    %         if(targetCounter<=nTar)
    %             if(mod(j,2)==0)
    %                 seq(i,j) = targetCounter;
    %                 if(targetCounter == nTar)
    %                     pos = [i,j+1];
    %                 end
    %                 targetCounter = targetCounter + 1;
    %             end
    %         else, seq(i,j) = nTar+1; 
    %         end
    %     end
    % end
    % seq(pos(1), pos(2)) = 0;
end