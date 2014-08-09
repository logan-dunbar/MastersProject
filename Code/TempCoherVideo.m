classdef TempCoherVideo < handle
    %TEMPCOHERVIDEO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Video
        WindowSize
        
        Windows
    end
    
    properties (Dependent = true)
        VideoSz
    end
    
    methods
        function obj = TempCoherVideo(video, windowSize)
            obj.Video = video;
            obj.WindowSize = windowSize;
            obj.Windows = TempCoherWindow.empty;
            
            obj.ComputeWindows();
        end
    end
    
    methods
        function value = get.VideoSz(obj)
           value = size(obj.Video); 
        end
        
        function outImg = ViewTempCoherWindows(obj)
            width = obj.VideoSz(2) - (obj.WindowSize - 1);
            height = obj.VideoSz(1) - (obj.WindowSize - 1);

            outImg = zeros(width*obj.WindowSize, height*obj.WindowSize);
            for j = 1:size(obj.Windows, 2)
                [row, col] = ind2sub([width,height], j);
                y_s = ((row-1) * obj.WindowSize) + 1;
                y_e = y_s + (obj.WindowSize - 1);

                x_s = ((col-1) * obj.WindowSize) + 1;
                x_e = x_s + (obj.WindowSize - 1);
                outImg(y_s:y_e,x_s:x_e) = log(obj.Windows(j).ReshapeCoherence);
            end
            
            figure;
            imagesc(outImg);
        end
        
        function outImg = ViewZScores(obj)
            width = obj.VideoSz(2) - (obj.WindowSize - 1);
            height = obj.VideoSz(1) - (obj.WindowSize - 1);

            outImg = zeros(width, height);

            for i = 1:size(obj.Windows, 2)
                [row, col] = ind2sub([width,height], i);

                mn = mean(obj.Windows(i).ReshapeCoherence(:));
                sd = std(obj.Windows(i).ReshapeCoherence(:));

                minVal = min(obj.Windows(i).ReshapeCoherence(:));

                outImg(row, col) = abs((mn - minVal)/sd);
            end

            figure;
            imagesc(outImg);
        end
    end
    
    methods (Access = private)
        function ComputeWindows(obj)
            video = obj.Video;
            halfWin = floor(obj.WindowSize / 2);
            
            totTime = int2str(obj.VideoSz(3));
            totX = int2str(obj.VideoSz(2));
            index = 1;
            for t = 1 + halfWin : obj.VideoSz(3) - halfWin
                disp(horzcat('At Time: ', int2str(t), ' of ', totTime));
                for x = 1 + halfWin : obj.VideoSz(2) - halfWin
                    disp(horzcat('At Y: ', int2str(x), ' of ', totX));
                    time = cputime;
                    for y = 1 + halfWin : obj.VideoSz(1) - halfWin
                        windowVideo = video(y-halfWin:y+halfWin, x-halfWin:x+halfWin, t-halfWin:t+halfWin);
                        obj.Windows(index) = TempCoherWindow(windowVideo);
                        index = index + 1;
                    end
                    disp(horzcat('Took ', num2str(cputime - time, '%0.2f'), ' for a loop across x '));
                end
            end
        end
        
%         function ComputeOutVideo(obj)
%             video = obj.Video;
%             window = obj.Window;
%             vidSize = size(obj.Video);
%             halfWin = floor(obj.WindowSize / 2);
%             
%             layerCount = size(obj.StartingPoints, 1);
%             outVideo = zeros([layerCount vidSize]);
%             
%             totLayers = int2str(layerCount);
%             totTime = int2str(vidSize(3));
%             totY = int2str(vidSize(1));
%             for n = 1:layerCount;
%                 disp(horzcat('In Layer: ', int2str(n), ' of ', totLayers));
%                 
%                 for t = 1 + halfWin : vidSize(3) - halfWin
%                     
%                     disp(horzcat('At Time: ', int2str(t), ' of ', totTime));
%                     for y = 1 + halfWin : vidSize(1) - halfWin
%                         
%                         %disp(horzcat('At Y: ', int2str(y), ' of ', totY));
%                         for x = 1 + halfWin : vidSize(2) - halfWin
%                             windowVideo = video(y-halfWin:y+halfWin, x-halfWin:x+halfWin, t-halfWin:t+halfWin);
%                             outVideo(n, y, x, t) = window.CalculateCoherence(windowVideo, n);
%                         end
%                     end
%                 end
%             end
%             
%             obj.OutVideo = outVideo;
%         end
    end
    
end

