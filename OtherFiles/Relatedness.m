classdef (Abstract) Relatedness 

    properties
    end

    methods

        function R = relatednessMeasure(obj, kIndx, jIndx, targets, seq, beta)
            [ik, ok, nuk, ij, oj, nuj] = obj.obtainVector(kIndx, jIndx, targets);
            c = obj.cMatrix(ik, ok, nuk, ij, oj, nuj, beta);
            cPrime = obj.cPrimeMatrix(c);
            V = obj.vMatrix(kIndx, jIndx, seq);
            R = 1./(cPrime + V);

        end

        function [ik, ok, nuk, ij, oj, nuj] = obtainVector(~, kIndx, jIndx, targets)
            % j put as rows, k put as columns
            lk = length(kIndx);
            lj = length(jIndx);

            ik = -1*ones(lk,1);
            ok = -1*ones(lk,1);
            nuk = -1*ones(lk,1);

            ij = -1*ones(1,lj);
            oj = -1*ones(1,lj);
            nuj = -1*ones(1,lj);
            for h = 1:lk
                ik(h) = targets(kIndx(h)).orbit.inclination;
                ok(h) = targets(kIndx(h)).orbit.raan;
                nuk(h) = targets(kIndx(h)).trueAnomaly;
            end
            for h = 1:lj
                ij(h) = targets(jIndx(h)).orbit.inclination;
                oj(h) = targets(jIndx(h)).orbit.raan;
                nuj(h) = targets(jIndx(h)).trueAnomaly;
            end
        end

        
        
        function  c = cMatrix(~, ik, ok, nuk, ij, oj, nuj, beta)

            % matrix lk x lj

            % calculating dihedral angle alpha
            val = sin(ik).*sin(ij).*cos(ok - oj) + cos(ik).*cos(ij);
            % correction for numerical reasons
            val = min(max(val, -1), 1);
            alpha = abs(rad2deg(acos(val)));

            % computing phase angle theta
            psi = (ok + nuk) - oj - nuj;
            theta = psi .* (abs(psi) <= 180) + ...
                    (-360 + abs(psi)) .* (psi > 180) + ...
                    ( 360 - abs(psi)) .* (psi < -180);
            
            %cost matrix
            c = beta * alpha + (1 - beta) * theta;
        end

        function  cPrime = cPrimeMatrix(~, c)
            % This function have been created because I may need to change the scale for updating the cost matrix 
            cPrime = c./max(abs(c(:)));
        end
        
        function V = vMatrix(~, kIndx, jIndx, seq)
            [rowK,~] = arrayfun(@(x) find(any(seq==x,2)), kIndx);
            [rowJ,~] = arrayfun(@(x) find(any(seq==x,2)), jIndx);
            
            V = (rowK(:) == rowJ(:)');
        end

    end
end