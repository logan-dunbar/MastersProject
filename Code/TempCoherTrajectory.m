classdef TempCoherTrajectory < handle
    %TEMPCOHERTRAJECTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        StartPoint
        MidPoint
        EndPoint
        
        Indices
        
        Error
        Gradients
        StopCount
    end
    
    properties (Dependent = true)
        IndicesCount
    end
    
    methods
        function obj = TempCoherTrajectory(startPoint, midPoint)
            if (nargin > 0)
                obj.StartPoint = startPoint;
                obj.MidPoint = midPoint;
                obj.StopCount = 0;

                obj.PopulateIndices();

                obj.EndPoint = obj.Indices(end, :);
            end
        end
        
        function value = get.IndicesCount(obj)
           value = size(obj.Indices, 1);
        end
    end
    
    methods (Access = private)
        function PopulateIndices(obj)
            stepSize = 1 / (obj.MidPoint(3) - obj.StartPoint(3));
            
            for i = 0:stepSize:2
                y = obj.StartPoint(1) + round((obj.MidPoint(1) - obj.StartPoint(1)) * i);
                x = obj.StartPoint(2) + round((obj.MidPoint(2) - obj.StartPoint(2)) * i);
                z = obj.StartPoint(3) + round((obj.MidPoint(3) - obj.StartPoint(3)) * i);
                obj.Indices(z, :) = [y, x, z];
            end
        end
    end
end

