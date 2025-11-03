function [initialState, initialSlt] = createInstanceProblem(nSSc, nTar, i_S, omega_S, nu_S, i_T, omega_T, nu_T,...
    dryMass_S, fuelMass_S, totCap_S, specificImpulse_S, refillSpeedSSc, refillSpeed, dryMass_T, totCap_T, fuelMass_T, seq)

    infeas = checkInstance([i_T, i_S], [omega_T, omega_S]);
    if(~infeas)
        % station
        StationOrbit = GeosyncCircOrb(i_S,omega_S);
        station = Station(StationOrbit, nu_S, refillSpeed);
        
        % sscs
        sscs(nSSc) = SSc();
        for i =1:nSSc
            S = SSc(StationOrbit, nu_S, dryMass_S(i), fuelMass_S(i), totCap_S(i), refillSpeedSSc(i),specificImpulse_S(i));
            sscs(i) = S;
        end
        
        % targets
        targets(nTar) = Target();
        for i =1:nTar
            orbitT = GeosyncCircOrb(i_T(i),omega_T(i));
            T = Target(orbitT, nu_T(i), dryMass_T(i), fuelMass_T(i), totCap_T(i));
            targets(i) = T;
        end
        initialState = State(sscs, targets, station, 0);

        % initial Solution
        if(isscalar(seq) || nargin < 18) % if it is no given in input
            seq = initialSeq(nTar, nSSc);
        end
        initialSlt = Solution(seq, nTar, initialState);
    end
end

