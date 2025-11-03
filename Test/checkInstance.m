function infeas = checkInstance(i,o)
    % this function check if the instance is acceptable. It has 3 check:
        % 1: 0 <= i < 180
        % 2: 0 <= o < 360
        % 3: all coupel (i,o) are unique
        % 4: for every possible couple, is not satisfied the following condirtion:
            % (i_1 + i_2) == 180 && abs(o_1 - o_2) = 180

    n = length(i);
    infeas = (length(o) ~= n);
    if infeas
        fprintf("the vectors have not the same length")
    else
        %check first 2 conditions
        for k = 1:n
            if ( (i(k)<0) && (i(k)>=180) ) % 1
                fprintf("value of inclination at position %d is not valid",k);
                infeas = 1;
                break;
            end
            if ( (o(k)<0) && (o(k)>=360) ) % 2
                fprintf("value of raan at position %d is not valid",k);
                infeas = 1;
                break;
            end
        end
        if(~infeas)
            % condition 3
            pairs = [i, o];
            [~, ~, ic] = unique(pairs, 'rows');
            duplicateIndx = find(histcounts(ic, 1:max(ic)+1) > 1);
            
            if ~isempty(duplicateIndx)
                disp('Duplicates:');
                for k = duplicateIndx
                    row = find(ic == k);
                    disp(row'); 
                end
            else
                % condition 4
                for k = 1:n-1
                    for j = k+1:n
                        if( (i(k) + i(j) == 180) && (abs(o(k) - o(j)) == 180) )
                            fprintf("the orbit %d and %d forms the same circle but with different orbital element",k,j);
                            infeas = 1;
                            break;
                        end
                    end
                    if infeas, break; end
                end
            end
        end

    end
    if(infeas == 0)
        fprintf("inclinations and raans approved\n")
    end
    
end