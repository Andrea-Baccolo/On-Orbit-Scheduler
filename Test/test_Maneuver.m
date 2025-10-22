%% TEST PHASING example 6-8 of vallado, page 363 (tablet 394)

clear all
clc
format long

orbit = GeosyncCircOrb(0, 0);
nuS1 = 0;

nuT1 = 20;

% in order for this test to work, change in the GeosyncCircOrb class the 
% following constant values:
    % semiMajorAxis = 12756.274; % km
    % angVel = sqrt(398600.4418/((12756.274)^3)); % rad/s
% so that it can match up with the given example

ssc = SSc(orbit, nuS1, 500, 52, 200, 0.2, 0.01);
target = Target(orbit, nuT1, 1000, 82, 700);

man1 = Phasing(1, 1);
man1 = man1.compute(ssc, target);

man2 = Phasing(1, 1, 0, 0, 0, 2, 2);
man2 = man2.compute(ssc, target);

%% TEST PLANAR CHANGE equatorial and inclined
clear all
clc
format long

orbitS = GeosyncCircOrb(0, 0);
orbitT = GeosyncCircOrb(20, 50);
nuS1 = 0;

nuT1 = 20;

% in order for this test to work, change in the GeosyncCircOrb class the 
% following constant values:
    % semiMajorAxis = 12756.274; % km
    % angVel = sqrt(398600.4418/((12756.274)^3)); % rad/s
% so that it can match up with the given example

ssc = SSc(orbitS, nuS1, 500, 52, 200, 0.2, 0.01);
target = Target(orbitT, nuT1, 1000, 82, 700);

man1 = PlanarChange(1, 1);
man1 = man1.compute(ssc, target);

%% TEST PLANAR CHANGE 2 inclined
clear all
clc
format long

orbitS = GeosyncCircOrb(70, 260);
orbitT = GeosyncCircOrb(20, 50);
nuS1 = 0;

nuT1 = 20;

% in order for this test to work, change in the GeosyncCircOrb class the 
% following constant values:
    % semiMajorAxis = 12756.274; % km
    % angVel = sqrt(398600.4418/((12756.274)^3)); % rad/s
% so that it can match up with the given example

ssc = SSc(orbitS, nuS1, 500, 52, 200, 0.2, 0.01);
target = Target(orbitT, nuT1, 1000, 82, 700);

man1 = PlanarChange(1, 1);
man1 = man1.compute(ssc, target);



