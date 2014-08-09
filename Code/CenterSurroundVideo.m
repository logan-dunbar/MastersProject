classdef CenterSurroundVideo < handle
    %CENTERSURROUNDVIDEO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    properties (SetAccess = private)
        Video
        OutSize
        InSize
        StepSize
        
        OutVideo
    end
    
    methods
        function obj = CenterSurroundVideo(video, outSize, inSize, stepSize)
            obj.Video = video;
            obj.OutSize = outSize;
            obj.InSize = inSize;
            obj.StepSize = stepSize;
            
            obj.ComputeOutVideo();
        end
    end
    
    methods (Access = private)
        function ComputeOutVideo(obj)
            y_max = size(obj.Video, 1);
            x_max = size(obj.Video, 2);
            t_max = size(obj.Video, 3);
            
            y_count = floor((y_max - obj.OutSize)/obj.StepSize) + 1;
            x_count = floor((x_max - obj.OutSize)/obj.StepSize) + 1;
            
            %y_count = floor(y_max/obj.StepSize);
            %x_count = floor(x_max/obj.OutSize);
            
            %y_max_out = y_count * obj.OutSize;
            %x_max_out = x_count * obj.OutSize;
            %t_max_out = t_max;
            
            inStartX = 1 + ((obj.OutSize - obj.InSize) / 2);
            inEndX = inStartX + (obj.InSize - 1);
            
            inStartY = 1 + ((obj.OutSize - obj.InSize) / 2);
            inEndY = inStartY + (obj.InSize - 1);
            
            inCount = obj.InSize^2;
            outCount = obj.OutSize^2 - inCount;
            
            obj.OutVideo = uint8(zeros(y_count, x_count, t_max));
            
            for t = 1:t_max
                for y = 1:y_count
                    for x = 1:x_count
                        outStartX = 1 + ((x - 1) * obj.StepSize);
                        outEndX = outStartX + (obj.OutSize - 1);

                        outStartY = 1 + ((y - 1) * obj.StepSize);
                        outEndY = outStartY + (obj.OutSize - 1);

                        outerPatch = obj.Video(outStartY:outEndY, outStartX:outEndX, t);

                        innerPatch = outerPatch(inStartY:inEndY, inStartX:inEndX);

                        innerSum = sum(innerPatch(:));
                        outerSum = sum(outerPatch(:)) - innerSum;

                        innerMean = innerSum / inCount;
                        outerMean = outerSum / outCount;

                        obj.OutVideo(y, x, t) = uint8(abs(outerMean - innerMean));
                    end
                end
            end
        end
    end
    
end























