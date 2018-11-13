classdef Rocket
    %A class to represent a single-stage rocket
    %   The rocket's position and velocity are kept track of along with its mass of parts,
    %   fuel, exhaust velocity, and how quickly it uses fuel (FuelUsageRate)
    
    properties
        Position
        Velocity
        MassOfParts
        MassOfFuel
        ExhaustVelocity
        FuelUseageRate %kg of fuel per second
    end
    
    properties(Dependent)
        TotalMass
    end
    
    methods
        
        %Constructor
        function obj = Rocket()
            obj.Position = TwoDVector();
            obj.Velocity = TwoDVector();
            obj.MassOfParts = 1000;
            obj.MassOfFuel =  exp(1) * obj.MassOfParts - obj.MassOfParts;
            obj.ExhaustVelocity = 100;
            obj.FuelUseageRate = 10;
        end
        
        %Move the rocket 
        function move(rocket, distance)
            rocket.Position.X = rocket.Position.X + distance.X;
            rocket.Position.Y = rocket.Position.Y + distance.Y;
        end
        
        %Get acceleration due to fuel given a change of time
        function acceleration = fuelAcceleration(rocket, time)
            fuelMass = rocket.getFuelUsed(time);
            
            impulse = fuelMass * rocket.ExhaustVelocity;
            force = impulse / time;
            acceleration = force / rocket.getMedianMass(time);
        end
        
        %Get median mass due to fuel given a change of time
        function medianMass = getMedianMass(rocket, time)
            medianMass = (rocket.MassOfParts + rocket.MassOfFuel - rocket.getFuelUsed(time) / 2);
        end
        
        %Get the amount of mass to use over a given time
        function fuelMass = getFuelUsed(rocket, time)
            fuelMass = rocket.MassOfFuel;
            if (rocket.FuelUseageRate * time < rocket.MassOfFuel)
                fuelMass = rocket.FuelUseageRate * time;
            end
        end
        
        %mass of fuel + mass of parts
        function value = get.TotalMass(obj)
            value = obj.MassOfFuel + obj.MassOfParts;
        end
        
        %Update the rocket for a given time and acceleration linearly
        function rocket = update(rocket, acceleration, time)
            rocket.Position = rocket.Position + rocket.Velocity.* time + acceleration.* (0.5 * time * time);
            rocket.Velocity = rocket.Velocity + acceleration.* time;
            rocket.MassOfFuel = rocket.MassOfFuel - rocket.getFuelUsed(time);
        end
    end
    
end