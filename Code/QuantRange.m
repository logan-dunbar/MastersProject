classdef QuantRange
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Start
        Stop
        EndInclusive
    end
    
    properties (SetAccess = private)
        MidPoint
    end
    
    methods
        function obj = QuantRange(start, stop, endInclusive)
            obj.Start = start;
            obj.Stop = stop;
            obj.EndInclusive = endInclusive;
            
            obj.MidPoint = ((stop - start) / 2) + start;
        end
        
        function valueIsInRange = IsInRange(obj, value)
            if (value >= obj.Start && value < obj.Stop)
                    valueIsInRange = 1;
            elseif (value == obj.Stop && obj.EndInclusive)
                    valueIsInRange = 1;
            else
                valueIsInRange = 0;
            end
        end
    end
end

