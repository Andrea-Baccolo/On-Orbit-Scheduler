classdef TourInfo 

    % Class of missions information of a specific sequence of targets, it
    % implements information regarding tours and some methods to manipulate
    % and update them

    properties
        tours % cell array max(nTour) x nSSc containing targets of tours
        lTour % matrix max(nTour) x nSSc containing length of the tours
        nTour % number of tours for every Ssc
    end

    methods
        
        function obj = TourInfo(seq, nTar)

            % METHOD: Constructor

            % INPUTS:
                % sequence of the solution.
                % nTar: number of targets used to clean the sequence.

            % OUTPUTS:
                % TourInfo object.

            % extraction of tours from the sequence
            % INPUT: seq, sequence of targets; nTar, total number of Targets
            if  nargin < 1
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
                    % cleaning the sequence 
                    sequence = seq(i,:);
                    sequence(sequence > nTar) = [];
                    % getting the positions of the zeros
                    zeroIndx = find(sequence == 0);
                    
                    nTour = length(zeroIndx)-1;
                    for j = 1:nTour
                        % getting the segment of the tour
                        startIndx = zeroIndx(j)+1;
                        endIndx = zeroIndx(j+1) - 1;
                        if startIndx <= endIndx % check ordering
                            segment = sequence(startIndx:endIndx);
                            if ~isempty(segment) % check if empty
                                SubTour{j,i} = segment;
                            end
                            lTour(j,i) = length(segment);
                        end
                    end
                    % counting number of tours
                    nTourSSc(i) = nTour;
                end
    
                indx = 1:max(nTourSSc);
                obj.tours = SubTour(indx,:);
                obj.lTour = lTour(indx,:);
                obj.nTour = nTourSSc;
            end
        end

        function obj = artificialTourInfo(obj, tours, lTour, nTour)

            % METHOD: create an artificial TourInfo object with given data.

            % INPUTS:
                % obj: a TourInfo object (matlab does not allows multiple
                    % contructors, thank you matlab :/ )
                % tours: cell arrays of tours 
                % lTour: lenght of tours stored in a matrix;
                % nTour: column vector that gives the number of non-empty
                    % tour for every ssc

            % OUTPUTS:
                % the tourInfo object constructed with the given inputs.

            obj.tours = tours;
            obj.lTour = lTour;
            obj.nTour = nTour;
        end

        function seq = rebuildSeq(obj, nTar)

            % METHOD: from the tour information, create the sequence

            % INPUTS: 
                % obj: Tour Info object from which the sequence will be
                    % constructed.
                % nTar: number of targets to fill the gap and complete the
                    % sequence.

            % OUTPUTS:
                % the sequence to contruct.
            
            nSSc = size(obj.lTour, 2);
            % total lenght of the ssc path 
            len = -1*ones(1, nSSc);
            for i = 1:nSSc
                if(isscalar(obj.lTour(:,i)))
                    len(i) = obj.lTour(:,i);
                else
                    len(i) = sum(obj.lTour(:,i));
                end
            end
            % 
            numSeq = ones(1,nSSc) + obj.nTour' + len;
            m = max(numSeq);
            seq = zeros(nSSc, m);

            for i = 1:nSSc % for every ssc
                j = 2;
                for t = 1:obj.nTour(i) 
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

            % METHOD: obtain the tour structure with zero to simulate

            % INPUTS: 
                % the object TourInfo.

            % OUTPUTS:
                % cell array with the same dimentions of the tours
                    % attributes with all the initial and final zeros

            [m,n] = size(obj.tours);
            zeroTour = cell(m,n);
            for i = 1:m
                for j = 1:n
                    if ~isempty(obj.tours{i,j}), zeroTour{i,j} = [0 obj.tours{i,j} 0]; end
                end
            end
        end

        function obj = cutTour(obj)

            % METHOD: function used to cut some unnessesary part of TourInfo

            % INPUTS: 
                % object TourInfo 

            % OUTPUTS:
                % object TourInfo without some empty tours rows in all the
                    % informations

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

            % METHOD: passing from a position in a specific tour to a
                % it's position on the sequence row of the ssc. 

            % INPUTS:
                % obj: tourInfo object.
                % sscIndx: index of the ssc in the considered tour.
                % tourIndx: index of the tour.
                % posTour: index of the position inside the tour.

            % OUTPUTS:
                % posSeq: position on the row sscIndx of the sequence.

            % check if it is in a new tour after the one already given
            if(tourIndx == obj.nTour(sscIndx) +1)
                if(isscalar(obj.lTour(:,sscIndx)))
                    len = obj.lTour(:,sscIndx);
                else
                    len = sum(obj.lTour(:,sscIndx));
                end
                posSeq = obj.nTour(sscIndx) + 1 + len;
            else
                startIdx = cumsum([1; obj.lTour(1:end-1,sscIndx) + 1]);
        
                % check input value
                if tourIndx < 1 || tourIndx > obj.nTour(sscIndx)
                    error('invalid tourIndx. It must be >1 and <= %d (%d instead).', obj.nTour(sscIndx), tourIndx);
                end
                
                if posTour < 1 || posTour > obj.lTour(tourIndx,sscIndx)+1
                    error('invalid posTour. It must be >1 and <= %d (%d instead).', obj.lTour(tourIndx,sscIndx)+1, posTour);
                end
                
                % Calcolo posizione assoluta
                posSeq = startIdx(tourIndx) + posTour - 1;
            end
        end

        function [tourIndx, posTour] = Seq2Tour(obj, posSeq, sscIndx)

            % METHOD: passing from position on the sequence row of the ssc
                % to a position in a specific tour. 

            % INPUTS:
                % obj: tourInfo object.
                % sscIndx: index of the ssc in the considered tour.
                % posSeq: position on the row sscIndx of the sequence.

            % OUTPUTS:
                % tourIndx: index of the tour.
                % posTour: index of the position inside the tour.

            % Check for empty InfoTour
            if isempty(obj.lTour) || size(obj.lTour,2) < sscIndx
                if(posSeq == 1)
                    tourIndx = 1;
                    posTour = 1;
                else
                    warning('Invalid posSeq, empty tours in sscIndx = %d', sscIndx);
                    tourIndx = [];
                    posTour = [];
                end
                return;
            end
        
            % Computing indexes of tours
            startIndx = cumsum([1; obj.lTour(1:end-1, sscIndx) + 1]);
            endIndx   = startIndx + obj.lTour(:, sscIndx);
        
            % find the right index
            tourIndx = find(posSeq >= startIndx & posSeq <= endIndx, 1, 'first');
        
            if isempty(tourIndx)
                if ~isempty(endIndx) && posSeq == endIndx(end) + 1
                    tourIndx = obj.nTour(sscIndx) + 1;
                    posTour = 1;
                else
                    error('Position p = %d does not belong to any tours', posSeq);
                end
            else
                posTour = posSeq - startIndx(tourIndx) + 1;
            end
        end

        function obj = expand(obj, k)

            % METHOD: expanding the tourInfo structure by k tours

            % INPUTS:
                % obj: TourInfo object.
                % k: number of expantions

            % OUTPUTS:
                % obj: expanded object.

            % if no input, expand by 1
            if nargin < 2, k = 1; end

            % checking expantions >0
            if (k<1)
                error(" Error: the expantion must be greater than 1, given %d instead", k);
            end
            [ntour, nssc] = size(obj.lTour);

            % case tourInfo empty
            if(nssc==0 && ntour == 0)
                obj.tours = cell(k,1);
                obj.lTour = zeros(k,1);
                obj.nTour = 0;
            else
                obj.lTour(ntour+k, nssc) = 0;
                obj.tours(ntour+k, nssc) = {[]};
            end

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