classdef Pixel < handle
    %PIXEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ErrorMap
        GradientMap
        StopCountMap
        MostLikelyTrajectoryIndex
    end
    
    methods
        function obj = Pixel(mapSize)
            if (nargin > 0)
                obj.ErrorMap = zeros(mapSize);
                obj.GradientMap = Gradients.empty;
                obj.GradientMap(mapSize(1), mapSize(2)) = Gradients();
                obj.StopCountMap = zeros(mapSize);
%                 obj.StopCountMap = TrajectoryError.empty;
%                 obj.StopCountMap(mapSize(1), mapSize(2)) = TrajectoryError();
            end
        end
    end
    
end

