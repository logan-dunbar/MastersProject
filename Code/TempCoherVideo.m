classdef TempCoherVideo < handle
    %TEMPCOHERVIDEO The temporal coherent video object, with segmented objs
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Video
        WindowSize
        
        Windows
        Seeds
        MyObjects
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
        
        function PostProcessObjects(obj)
            obj.FindSeeds();
            obj.CreateMyObjects();
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
        
        function FindSeeds(obj)
            totalCount = obj.WindowSize^2;
            thresholdCount = ceil(totalCount * 0.9);
            
            obj.Seeds = [];
            for i = 1:size(obj.Windows, 2);
                maxTrajectory = MaxStopCountTrajectory(obj.Windows(i));
                if (maxTrajectory.StopCount > thresholdCount)
                    obj.Seeds = [obj.Seeds i];
                end
            end
        end
        
        function CreateMyObjects(obj)
            obj.MyObjects = [];
            
            for seed = obj.Seeds
                obj.MyObjects = [obj.MyObjects MyObject(obj, seed)];
            end
            
            finished = false;
            while (~finished)
                for i = 1:length(obj.MyObjects) - 1;
                    startOver = false;
                    
                    obj1 = obj.MyObjects(i);
                    for j = i+1:length(obj.MyObjects)
                        obj2 = obj.MyObjects(j);
                        
                        combinedObj = CompareMyObjects(obj1,obj2);
                        if (~isempty(combinedObj))
                            startOver = true;
                            break;
                        end
                    end
                    
                    if (startOver)
                        obj.MyObjects(i) = combinedObj;
                        obj.MyObjects(j) = [];
                        break;
                    end
                end
                
                if (isempty(obj.MyObjects) || i >= length(obj.MyObjects) - 1)
                    finished = true;
                end
            end
        end
    end
end

function combinedObj = CompareMyObjects(myObj1, myObj2)
combinedObj = [];

% Test overlapping
mask = myObj1.Mask & myObj2.Mask;
if (any(mask(:)))
    obj1Index = myObj1.MeanTrajectoryIndex;
    obj2Index = myObj2.MeanTrajectoryIndex;
    
    % Test starting points/trajectories are close enough
    if (abs(obj1Index(1)-obj2Index(1)) <= 1 && abs(obj1Index(2)-obj2Index(2)) <= 1)
        combinedObj = myObj1;
        combinedObj.Mask = myObj1.Mask | myObj2.Mask;
        
        combinedObj.MeanTrajectoryIndices = [myObj1.MeanTrajectoryIndices;myObj2.MeanTrajectoryIndices];
    end
end
end