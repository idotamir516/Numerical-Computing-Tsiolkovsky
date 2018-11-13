classdef World
    %A class to represent the world we are simulating
    %   It holds an array of planets alongside with the rocket, the rocket's initial trajectory
    %   and whether we are accounting for air resistance and gravity
    
    properties
        Planets
        Rocket
        InitialTrajectory
        AirResistanceOn
        GravityOn
    end
    
    methods
        
        %Constructor
        function obj = World()
            obj.Planets = [];
            obj.Rocket = Rocket();
            obj.InitialTrajectory = TwoDVector(0, 1);
            obj.Rocket.Velocity = obj.InitialTrajectory.* 1E-15;
            obj.AirResistanceOn = false;
            obj.GravityOn = false;
        end
        
        %Typical examples
        function obj = earthSatellite(obj)
            obj.Planets = [Planet.earth()];
            obj.Rocket = Rocket();
            obj.Rocket.MassOfFuel = 0;
            earth = obj.Planets(1);
            obj.Rocket.Position = TwoDVector(earth.Location.X + earth.Radius + 1, 0);
            obj.InitialTrajectory = TwoDVector(0, 1);
            obj.Rocket.Velocity = obj.InitialTrajectory.* sqrt(earth.G * earth.Mass / earth.Radius);
            obj.AirResistanceOn = false;
            obj.GravityOn = true;
        end
        
        function obj = earthTakeOff(obj, air)
            obj.Planets = [Planet.earth()];
            obj.Rocket = Rocket();
            earth = obj.Planets(1);
            obj.Rocket.Position = TwoDVector(0, earth.Location.Y + earth.Radius);
            obj.InitialTrajectory = TwoDVector(0, 1);
            obj.Rocket.Velocity = obj.InitialTrajectory.* 1E-15;
            obj.Rocket.MassOfFuel = 15275479140 * 5;
            obj.Rocket.MassOfParts = 10000;
            obj.Rocket.FuelUseageRate = 1527547914 / 2;
            obj.Rocket.ExhaustVelocity = 1350;
            obj.AirResistanceOn = air;
            obj.GravityOn = true;
        end
        
        %Simulate multiple steps in the world and graph the results
        function world = multipleSteps(world, time, steps)
            %initializing variables to store results
            x = zeros(1, steps);
            y = zeros(1, steps);
            times = zeros(1, steps);
            velocity = zeros(1, steps);
            velocityY = zeros(1, steps);
            figure;
            timeStep = time/steps;
            
            %Simulate each step and store the results
            for i = 1:steps
                world = world.oneStep(timeStep);
                x(i) = world.Rocket.Position.X;
                y(i) = world.Rocket.Position.Y;
                times(i) = ((i - 1) * timeStep);
                velocity(i) = world.Rocket.Velocity.Magnitude;
                velocityY(i) = world.Rocket.Velocity.Y;
            end
            
            %Plots results
            plot(x, y);
            title('Position Graph')
            xlabel('X (m)')
            ylabel('Y (m)')
            pbaspect([1 1 1])
            daspect([1 1 1])
            figure;
            plot(times, velocity);
            title('Velocity Over Time')
            xlabel('Time (s)')
            ylabel('Velocity Magnitude (m/s)')
            figure;
            plot(times, velocityY);
            title('Velocity In The Y Direction Over Time')
            xlabel('Time (s)')
            ylabel('Velocity In Y Direction (m/s)')
            figure;
            plot(times, y);
            title('Y over time')
            xlabel('Time (s)')
            ylabel('Y (m)')
        end
        
        %Simulatae one time-step
        function world = oneStep(world, time)
            totalAcceleration = TwoDVector(0, 0);
            
            unitVelocityVector = world.Rocket.Velocity.unitVector();
            fuelAcceleration = world.Rocket.fuelAcceleration(time);
            
            totalAcceleration = totalAcceleration + unitVelocityVector.* fuelAcceleration;
            
            medianMass = world.Rocket.getMedianMass(time);
            medianVelocityVector = (world.Rocket.Velocity + (totalAcceleration.* time)).* 0.5;
            medianVelocity = medianVelocityVector.Magnitude;
            
            %Get effects of gravity and air resistance from each planet 
            for index = 1:numel(world.Planets)
                planet = world.Planets(index);
                if (world.GravityOn)
                    totalAcceleration = totalAcceleration + planet.getGravityOn(world.Rocket.Position);
                end
                
                if (world.AirResistanceOn)
                    totalAcceleration = totalAcceleration + ((-unitVelocityVector).* (planet.getAirResistanceOn(world.Rocket.Position, medianVelocity)./ medianMass));
                end
                
            end
            
            world.Rocket = world.Rocket.update(totalAcceleration, time);
        end
    end
    
end