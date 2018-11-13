classdef TwoDVector
    %A class representing a vector in the x and y direction
    
    properties
        X
        Y
    end
    
    properties(Dependent)
        Theta
        Magnitude
    end
    
    methods
        %Dependent properties
        function value = get.Theta(obj)
            value = atan(obj.Y/obj.X);
        end
        
        function value = get.Magnitude(obj)
            value = sqrt(obj.X * obj.X + obj.Y * obj.Y);
        end
        
        %Constructor
        function obj = TwoDVector(x, y)
            if nargin == 0
                obj.X = 0;
                obj.Y = 0;
            elseif nargin ~= 2
                error('Vector must have two components')
            else
                obj.X = x;
                obj.Y = y;
            end
        end
        
        %Gets the unit vecotr in that direction
        function unit = unitVector(obj)
            magnitude = obj.Magnitude;
            if (magnitude == 0)
                unit = TwoDVector(0, 0);
            else
                unit = TwoDVector(obj.X / magnitude, obj.Y / magnitude);
            end
        end
        
        %overloading operators
        function value = plus(obj1, obj2)
            value = TwoDVector(obj1.X + obj2.X, obj1.Y + obj2.Y);
        end
        
        function value = minus(obj1, obj2)
            value = TwoDVector(obj1.X - obj2.X, obj1.Y - obj2.Y);
        end
        
        function value = times(obj1, obj2)
            value = TwoDVector(obj1.X * obj2, obj1.Y * obj2);
        end
        
        function value = power(obj1, obj2)
            value = TwoDVector(obj1.X^obj2, obj1.Y^obj2);
        end
        
        function value = rdivide(obj1, obj2)
            value = TwoDVector(obj1.X/obj2, obj1.Y/obj2);
        end
        
        function value = uminus(obj)
            value = TwoDVector(-obj.X, -obj.Y);
        end
    end
    
end