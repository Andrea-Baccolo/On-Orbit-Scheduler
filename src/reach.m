function [maneuvers, infeas] = reach(ssc, sscIndx, target, targetIndx)
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