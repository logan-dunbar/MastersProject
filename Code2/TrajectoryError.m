classdef TrajectoryError
    %PIXELERROR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Error
        StopCount
    end
    
    methods
        function obj = TrajectoryError(index, error)
            if (nargin > 0)
                obj.Index = index;
                obj.Error = error;
                obj.StopCount = 0;
            end
        end
    end
    
end

