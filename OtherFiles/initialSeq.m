function [seq] = initialSeq(nTar, nSSc)

    % METHOD: Function that create a feasible solution for the assumptions
        % made in the thesis. creates missions composd by reaching one
        % single targets, for all targets.

    % INPUTS:
        % nTar: number of targets.
        % nSSc: number of sscs.

    % OUTPUTS:
        % initial sequence.

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
end