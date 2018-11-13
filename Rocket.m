classdef Rocket
    %ROCKET Summary of this class goes here
    %   Detailed explanation goes here

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
         
         function obj = Rocket()
             obj.Position = TwoDVector();
             obj.Velocity = TwoDVector();
             obj.MassOfParts = 1000;
             obj.MassOfFuel =  exp(1) * obj.MassOfParts - obj.MassOfParts;
             obj.ExhaustVelocity = 100;
             obj.FuelUseageRate = 10;
         end
         
         function move(rocket, distance)
            rocket.Position.X = rocket.Position.X + distance.X;
            rocket.Position.Y = rocket.Position.Y + distance.Y;
         end
     
         function acceleration = fuelAcceleration(rocket, time)
             fuelMass = rocket.getFuelUsed(time);
                 
            impulse = fuelMass * rocket.ExhaustVelocity;
            force = impulse / time;
            acceleration = force / rocket.getMedianMass(time);
         end
     
         function medianMass = getMedianMass(rocket, time)
            medianMass = (rocket.MassOfParts + rocket.MassOfFuel - rocket.getFuelUsed(time) / 2);
         end
     
         function fuelMass = getFuelUsed(rocket, time)
            fuelMass = rocket.MassOfFuel;
             if (rocket.FuelUseageRate * time < rocket.MassOfFuel)
                 fuelMass = rocket.FuelUseageRate * time;
             end
         end
        
        function value = get.TotalMass(obj)
             value = obj.MassOfFuel + obj.MassOfParts;
        end
     
         function rocket = update(rocket, acceleration, time)
            rocket.Position = rocket.Position + rocket.Velocity.* time + acceleration.* (0.5 * time * time);
            rocket.Velocity = rocket.Velocity + acceleration.* time;
            rocket.MassOfFuel = rocket.MassOfFuel - rocket.getFuelUsed(time);
         end
     end

end