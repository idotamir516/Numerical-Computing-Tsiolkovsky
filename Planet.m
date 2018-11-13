classdef Planet
    %A class that represents a planet including its equation for air resistance and atmosphere
    %   The planet contains its location, radius, mass, atmosphere radius and equation for air
    %   resistance (to adjust for pressure)
    
    properties
        Location
        Radius
        Mass
        AirResistance
        AtmosphereRadius
        G = 6.67408e-11
    end
    
    methods
        
        %Constructor
        function obj = Planet(location, radius, mass, airResistance, atmosphereRadius)
            obj.Location = location;
            obj.Radius = radius;
            obj.Mass = mass;
            obj.AirResistance = airResistance;
            obj.AtmosphereRadius = atmosphereRadius;
        end
        
        %Gets acceleration due to this planet at a certain location
        function acceleration = getGravityOn(planet, location)
            dx = (planet.Location.X - location.X);
            dy = (planet.Location.Y - location.Y);
            distanceSquared = dx * dx + dy * dy;
            totalAcceleration = planet.G * planet.Mass / distanceSquared;
            acceleration = TwoDVector(totalAcceleration * dx / sqrt(distanceSquared), totalAcceleration * dy / sqrt(distanceSquared));
        end
        
        %Gets the force due to air resistance from this planet at a specific location with a certain velocitys
        function force = getAirResistanceOn(planet, location, velocity)
            %if it is not in the atmosphere, the force is 0
            if ((location.X > (planet.Location.X + planet.AtmosphereRadius)) || ...
                    (location.X < (planet.Location.X - planet.AtmosphereRadius)) || ...
                    (location.Y > (planet.Location.Y + planet.AtmosphereRadius)) || ...
                    (location.Y < (planet.Location.Y - planet.AtmosphereRadius)))
                force = 0;
            else
                distanceVector = (location - planet.Location);
                distance = distanceVector.Magnitude - planet.Radius + 1;
                airResistanceConstant = polyval(planet.AirResistance, distance);
                force = (velocity.^(2)).* (1 / airResistanceConstant);
            end
        end
    end
    
    %Create planet earth
    methods(Static)
        function earth = earth()
            location = TwoDVector(0, 0);
            radius = 6.371E6;
            mass = 5.972E24;
            airResistance = [1/600, 0];
            atmosphereRadius = 700E3 + radius;
            earth = Planet(location, radius, mass, airResistance, atmosphereRadius);
        end
    end
    
end