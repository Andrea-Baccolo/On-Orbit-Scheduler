classdef GeosyncCircOrb 

    % class used to make an instance of a geosynchronous circular orbit 
    % with respect the equatorial coordinate system

    properties
        inclination
        raan
        h  % angular momentum         
    end

    properties (Constant)
        semiMajorAxis = 42165;          % km
        angVel = 7.291900448184313e-05; % rad/s
        GMp = 398600.4418;              % km^3/s^2, product between gravitatinal
                                        % constant and earth's mass
    end

    methods
        function obj = GeosyncCircOrb(inclination, raan)
            
            % METHOD: Constructor
                
            % INPUTS: 
                % inclination of the orbit
                % raan of the orbit
            % OUTPUTS:
                % orbit object

            % empty orbit 
            if nargin < 2, raan = []; end
            if nargin < 1, inclination = []; end

            obj.inclination = inclination;
            obj.raan = raan;
            obj.h = sqrt(obj.semiMajorAxis*obj.GMp).*...
                    [sind(obj.raan)*sind(obj.inclination);...
                    -cosd(obj.raan)*sind(obj.inclination); cosd(obj.inclination)];
        end

        function output(obj,fid)
            if nargin < 2 || isempty(fid), fid = 1; end
            fprintf(fid, 'incl: %.2f, raan:%.2f \n' , obj.inclination, obj.raan);
        end
    end
end

            
