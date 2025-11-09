classdef RepFarInsNear < RepFarIns & Relatedness

    % Repair method bnuild using a farthest Insersion heuristic principle
    % with respect the relatedness measure. 

    properties
        beta
    end

    methods
        function obj = RepFarInsNear(nTar, beta)

            % METHOD: Constructor

            % INPUTS:
                % nTar: number of targets.
                % beta: parameters used in the relatedness measure: between
                    % 0 and 1.

            % OUTPUTS:
                % obj: Repair object.

            if nargin < 1, nTar = 0; end
            if nargin < 2, beta = 0; end
            obj@RepFarIns(nTar);
            obj.beta = beta;
        end

        function struct = initialStruct(obj, state, destroyedSet, currSeq)

            % METHOD: % function that create the structure used to decide the
                % target to insert. the initial structure will be the distance 
                % between the destroyed targets and all the other targets. 
                % Since the normalization is based on all the distances and
                % since they change over time, just the single number is 
                % considered and the normaization is performed when needed 
                % on a copy to mantain and update the structure.

            % INPUTS:
                % obj: repair object.
                % state: state object that contains the initial info.
                % destroyedSet: row vector of destroyed set index.
                % currSeq: matrix of the current sequence.

            % OUTPUTS:
                % struct: initial structure used to decide the target to 
                    % intert in the sequence.
            
            tar = currSeq(currSeq > 0 & currSeq <= obj.nTar);

            % I need to considers all destroyed target and the station
            [ik, ok, nuk, ij, oj, nuj] = obj.obtainVector(destroyedSet, tar, state.targets);

            % adding the station to the J set in position 1
            tar = [0; tar];
            ij = [state.station.orbit.inclination, ij];
            oj = [state.station.orbit.raan, oj];
            nuj = [state.station.trueAnomaly, nuj];

            % computing distance matrix
            % just storing the distance not normalized because when I will
            % update it it may change the normalization scale
            c = obj.cMatrix(ik, ok, nuk, ij, oj, nuj, obj.beta);
            struct = {tar, c};
        end

        function [tarIndx, sscIndx, posSeq] = chooseTar(obj, struct, initialState, currSeq, destroyedSet)

            % METHOD: function that chooses the target to insert using the structure.

            % INPUTS:
                % obj: repair object.
                % struct: structure used.
                % initialState: state object that contains the initial info.
                % currSeq: matrix of the current sequence.
                % destroyedSet: row vector of destroyed set index.
                
            % OUTPUTS:
                % tarIndx: index of the chosen target.
                % sscIndx: index of the ssc where the target needs to be intert.
                % posSeq: index of the position of the sequence where the 
                    % target needs to be intert.

            % normalizing the matrix before using it
            cPrime = obj.cPrimeMatrix(struct{2});

            % select tarIndx
            cDes = max(cPrime, [], 2);
            [~,tarIndx] = min(cDes);

            % getting the vector of targets sorted by similarity
            [~, sortIndx] = sort(cPrime(tarIndx,:), 'descend');
            sortTar = struct{1}(sortIndx);

            % CHECK FEASIBILITY
            sim = Simulator(initialState);
            getFeas = 0;
            for h = 1:length(sortIndx)

                % take the h-th sscIndx and posSeq
                [sscIndxes, positSeq] = find(currSeq == sortTar(h));
                nIndx = length(sscIndxes);

                % checking positions, since sortIndx(h) may be 0 ad it is
                % quite frequent in the seq, I need to check all the
                % possible positions
                f = zeros(nIndx,1);
                for s = 1:nIndx
                    sequence = currSeq(sscIndxes(s),(currSeq(sscIndxes(s),:) <= obj.nTar));
                    finalIndx = positSeq(s)+1:length(sequence);

                    % getting sure to always end with a zero
                    if(isempty(finalIndx))

                        % if it is empty, I will create a new tour
                        newSeq = [ sequence(1:positSeq(s)), destroyedSet(tarIndx), 0 ];
                    else
                        newSeq = [ sequence(1:positSeq(s)), destroyedSet(tarIndx), sequence(finalIndx)];
                    end
                    updateIndex = obj.updateIndexSeq(newSeq, []);

                    % the sequence need to finish with a zero, if I
                    % considers the last position, I will not add anything
                    [~, infeas, totFuel, ~, ~] = sim.SimulateSeq(initialState, sscIndxes(s), newSeq, updateIndex);
                    if infeas, f(s) = inf; else,f(s) = sum(totFuel); end
                end

                % after simulating every position, I will find the minimum
                [fMin, sIndx] = min(f);
                if(fMin ~= inf) % if it exist a feasible configuration

                    % save indexes
                    if(isscalar(sscIndxes))
                        sscIndx = sscIndxes;
                        posSeq = positSeq;
                    else
                        sscIndx = sscIndxes(sIndx);
                        posSeq = positSeq(sIndx);
                    end
                    getFeas = 1;
                    break;
                end
            end
            if(~getFeas)
                % if a feasible solution has not been found, this means
                % that even when creating a new tour, the chosen target
                % is not feasible even if when reaching it alone, which
                % contraddicts the assumptions
                error("Target %d is not feasible when simulating it in a [0 %d 0] tour ", ...
                                                destroyedSet(tarIndx),destroyedSet(tarIndx));
            end


        end

        function struct = updateStruct(obj, struct, state, ~, ~, tarIndx, destroyedSet, currDestroyed)

            % METHOD: % function used to update the structure after interting the new target.

            % INPUTS:
                % obj: repair object.
                % struct: initial structure used to decide the target to 
                    % intert in the sequence.
                % state: state object that contains the initial info.
                % currSeq: matrix of the current sequence.
                % sscIndx: index of the ssc to consider.
                % tarIndx: target index that have been inserted.
                % destroyedSet: destroyedSet: row vector of destroyed set index.
                % currDestroyed: index of the target that have been inserted.

            % OUTPUTS:
                % struct: the updated structure.

            % deleting the new insered target
            struct{2}(tarIndx,:) = [];

            % adding the new insered target in tar: update struct 1
            struct{1} = [ struct{1}; currDestroyed];

            % adding the new part to the matrix: update struct 2
            [ik, ok, nuk, ij, oj, nuj] = obj.obtainVector(destroyedSet, currDestroyed, state.targets);
            c = obj.cMatrix(ik, ok, nuk, ij, oj, nuj, obj.beta);
            struct{2} = [struct{2}, c];
        end
    end
end

