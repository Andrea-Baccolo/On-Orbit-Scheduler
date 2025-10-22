%%
clear all
clc

fuelMass = 50;
dryMass = 100;
dv = 1;
specificImpulse = 1.2;

finalMass = (fuelMass + dryMass)/exp(dv/(9.81*specificImpulse));
fuel = (fuelMass + dryMass) - finalMass;
 if fuel< fuelMass
    fuelMass = fuelMass - fuel;
 end
display(fuelMass + dryMass)

%% 
clear all
clc

nTar = 9;
seq = [ 0 1 2 3 4 5 0 10 10 10
         0 6 0 7 0 8 0 9 0 10];


d1 = DestroyRandom(seq, nTar, 5);
[n,m] = size(d1.cellTours);
maax = -1;
for i = 1:n
    for j = 1:m
        if(~isempty(d1.cellTours{i,j}))
            alpha = max(d1.cellTours{i,j});
            if(alpha > maax)
                maax = alpha;
            end
        end
    end
end
sltVoid = Solution([],0);

sltVoid = sltVoid.rebuildSeq( d1.cellTours, d1.lTours, maax);











