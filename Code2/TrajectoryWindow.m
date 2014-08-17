classdef TrajectoryWindow < handle
    %TRAJECTORYWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        WindowSize
        Indices
        PixelIndex
    end
    
    methods
        function obj = TrajectoryWindow(windowSize)
            obj.WindowSize = windowSize;
            
            obj.Indices = zeros(windowSize(1) * windowSize(2), windowSize(3));
            pixelIndex = [ceil(windowSize(1)/2) ceil(windowSize(2)/2) ceil(windowSize(3)/2)];
            obj.PixelIndex = sub2ind(windowSize, pixelIndex(1), pixelIndex(2), pixelIndex(3));
            
            stepSize = 1 / (pixelIndex(3) - 1);
            
            for y = 1:windowSize(1)
                for x = 1:windowSize(2)
                    t = 0;
                    for s = 0:stepSize:2
                        t = t + 1;
                        ind = sub2ind(windowSize(1:2), y, x);
                        y_ind = y + round((pixelIndex(1) - y) * s);
                        x_ind = x + round((pixelIndex(2) - x) * s);
                        obj.Indices(ind, t) = sub2ind(windowSize, y_ind, x_ind, t);
                    end
                end
            end
        end
    end
    
end

