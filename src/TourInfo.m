classdef TourInfo 

    % Class of Tour information of a specific sequence of targets, it
    % implements information regarding tours and some methods to manipulate
    % and update them

    properties
        tours % cell array max(nTour) x nSSc containing targets of tours
        lTour % matrix max(nTour) x nSSc containing length of the tours
        nTour % number of tours for every Ssc
    end

    methods
        
        function obj = TourInfo(seq, nTar)
            % extraction of tours from the sequence
            % INPUT: seq, sequence of targets; nTar, total number of Targets
            if  nargin < 2
                obj.tours = [];
                obj.lTour = [];
                obj.nTour = [];
            else
                [n,m] = size(seq);
                nTourSSc = zeros(n,1);
                % assuming the longest sequence, that is 1 target for one
                % mission, the number of subtour must be 
                if (mod(m,2)==0)
                    lTour = zeros(m/2 -1,n);
                    SubTour = cell(m/2 -1, n);
                else
                    lTour = zeros((m-1)/2,n);
                    SubTour = cell((m-1)/2, n);
                end
                
                for i = 1:n
                    sequence = seq(i,:);
                    sequence(sequence > nTar) = [];
                    zeroIndx = find(sequence == 0);
                    
                    nTour = length(zeroIndx)-1;
                    for j = 1:nTour
                        startIndx = zeroIndx(j)+1;
                        endIndx = zeroIndx(j+1) - 1;
                        if startIndx <= endIndx
                            segment = sequence(startIndx:endIndx);
                            if ~isempty(segment)
                                SubTour{j,i} = segment;
                            end
                            lTour(j,i) = length(segment);
                        end
                    end
                    nTourSSc(i) = nTour;
                end
    
                indx = 1:max(nTourSSc);
                obj.tours = SubTour(indx,:);
                obj.lTour = lTour(indx,:);
                obj.nTour = nTourSSc;
            end
        end

        function obj = artificialTourInfo(obj, tours, lTour, nTour)
            obj.tours = tours;
            obj.lTour = lTour;
            obj.nTour = nTour;
        end

        function seq = rebuildSeq(obj, nTar)

            % from the tour information, create the sequence
            
            [~, nSSc] = size(obj.lTour);
            % calculate for every ssc the length of the corresponding sequence
            nM = -1*ones(1,nSSc);
            for i = 1:nSSc
                nM(i) = nnz(obj.lTour(:,i));
            end
            if(isscalar(obj.lTour))
                len = obj.lTour;
            else
                len = sum(obj.lTour);
            end
            
            numSeq = ones(1,nSSc) + nM + len;
            m = max(numSeq);
            seq = zeros(nSSc, m);

            for i = 1:nSSc
                j = 2;
                for t = 1:nM(i)
                    if(~isempty(obj.tours{t,i}))
                        l = length(obj.tours{t,i});
                        seq(i,j:j+l-1) = obj.tours{t,i};
                        j = j + l + 1;
                        obj.tours{t,i} = [ 0 obj.tours{t,i} 0 ];
                    end
                end
                if(j<=m)
                    while j<=m
                        seq(i,j) = nTar + 1;
                        j = j+1;
                    end
                end
            end
        end

        function zeroTour = addZeros(obj)

            % obtain the tour structure with zero to simulate

            [m,n] = size(obj.tours);
            zeroTour = cell(m,n);
            for i = 1:m
                for j = 1:n
                    if ~isempty(obj.tours{i,j}), zeroTour{i,j} = [0 obj.tours{i,j} 0]; end
                end
            end
        end

        function obj = cutTour(obj)

        % function used to cut some unnessesary part of TourInfo

            [~,nSSc] = size(obj.tours);
            % delete the empty tours
            colsC = cell(1,nSSc);
            colsM = cell(1,nSSc);
            maxLenM = 0;
            maxLenC = 0;
            % collect 
            for j = 1:nSSc
                colM = obj.lTour(:,j);
                colC = obj.tours(:,j);
                colM = colM(colM ~= 0);
                mask = cellfun(@(x) ~isempty(x), colC);
                colC = colC(mask); 
                colsM{j} = colM;
                colsC{j} = colC;
                maxLenM = max(maxLenM, numel(colM));
                maxLenC = max(maxLenC, numel(colC));
            end
            newLTour = zeros(maxLenM, nSSc);
            newCellTour = cell(maxLenC, nSSc);
            % rebuild 
            for j = 1:nSSc
                colM = colsM{j};
                colC = colsC{j};
                newLTour(1:numel(colM), j) = colM;
                newCellTour(1:numel(colC), j) = colC;
            end
            obj.lTour = newLTour;
            obj.tours = newCellTour;
        end

        function posSeq = Tour2Seq(obj, sscIndx, tourIndx, posTour)
            if(~isscalar(obj.lTour))
                % it means 1 tour and 1 ssc and tourIndx = 1
                len = 0;
            else
                % take the sum of the preavious tours
                len = sum(obj.lTour(1:tourIndx-1,sscIndx));
            end
            posSeq = len*(tourIndx>1) + tourIndx + posTour -1;
        end

        function [tourIndx, posTour] = Seq2Pos(obj, posSeq, sscIndx)
            startIndx = cumsum([1; obj.lTour(1:end-1,sscIndx) + 1]);
            endIndx   = startIndx + obj.lTour(:,sscIndx);
            tourIndx = find(posSeq >= startIndx & posSeq <= endIndx, 1, 'first');
            if isempty(tourIndx)
                error('Position p = %d does not belong to any tours', posSeq);
            end
            posTour = posSeq - startIndx(tourIndx) + 1;
        end

        function output(obj, fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            [~, nSSc] = size(obj.lTour);
            
            fprintf(fid,'MISSION INFO\n');
            for i = 1:nSSc
                fprintf(fid,'In the SSc number %d there are %d non-empty tours.\n', i, obj.nTour(i));
                len = obj.lTour(:, i);
                len = len(len > 0);
                fprintf(fid,'Length of tours of SSc %d:\n', i);
                if isempty(len)
                    fprintf(fid,'   (no non-empty tours)\n');
                else
                    disp(len);
                end
            end
        end

    end
end