function [maneuvers, infeas] = reach(ssc, sscIndx, target, targetIndx)

    % FUNCTION: function used to compute the maneuvers to reach a target.

    % INPUTS: 
        % ssc: SSc object that have to compute the maneuver.
        % sscIndx: index of the ssc that perform the maneuver in the state
            % vector.
        % target: target object that needs to be reached by the ssc.
        % targetIndx: index of the target above in the state vector.

    % OUTPUTS:
        % maneuvers: cell array of the maneuvers to compute to reach the target.
        % infeas: flag of infeasibility: 1 if infeasible, 0 if feasible.

    maneuvers = cell(3,1);
    Indx = 1;
    fuelSSc = ssc.fuelMass; % variable to keep track of the fuel
    infeas = 0;
    % if I need a planar change, calculate it 
    if(ssc.orbit.inclination ~= target.orbit.inclination || ssc.orbit.raan ~= target.orbit.raan)
        % create maneuver 
        man0 = PlanarChange(sscIndx, targetIndx);
        man0 = man0.compute(ssc, target);

        %target update
        target = target.update(man0.dt);
        % ssc update
        ssc.trueAnomaly = man0.nodeTarOrb;
        [fuelSSc, ~,infeas] = ssc.calculateFuel(man0.dv, fuelSSc);
        if (~infeas)
            maneuvers{Indx} = man0;
            Indx = Indx + 1;
        end
    end

    % if I need a phasing, calculate it 
    if((ssc.trueAnomaly ~= target.trueAnomaly) && (~infeas) )
        man1 = Phasing(sscIndx, targetIndx);
        man1 = man1.compute(ssc, target);
        %target update
        target = target.update(man1.dt);
        % ssc update
        [fuelSSc, ~,infeas] = ssc.calculateFuel(man1.dv, fuelSSc);
        if (~infeas)
            ssc.trueAnomaly = target.trueAnomaly;
            maneuvers{Indx} = man1;
            Indx = Indx + 1;
        end
    end

    if (~infeas)
        % create refill
        man2 = Refilling(sscIndx, targetIndx);
        man2 = man2.compute(ssc, target, fuelSSc);
        if(targetIndx ~= 0)
            infeas = (fuelSSc - man2.fuelAdded < 0);
        end
        if (~infeas)
            maneuvers{Indx} = man2;
            % cut the cell array
            maneuvers = maneuvers(1:Indx);   
        end
    end
end