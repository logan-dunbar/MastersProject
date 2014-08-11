classdef TempCoherWindow < handle
    %TEMPCOHERWINDOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Trajectories
        WinSz
        Video
        MaxStopCountTrajectory
    end
    
    properties (Dependent = true)
    end
    
    methods
        % coord running down y first and across x (to allow for reshape)
        function obj = TempCoherWindow(video)
            %change this to allow winSz_x,  winSz_y, winSz_t
            obj.WinSz = size(video, 1);
            obj.Video = video;
            obj.PopulateTrajectories();
            obj.CalculateCoherence();
            obj.ComputeGradients();
            obj.FindPeaks();
            obj.PopulateMaxStopCountTrajectory();
        end
    end
    
    methods (Access = private)
        function PopulateTrajectories(obj)
            %create a trajectory for every pixel in window
            obj.Trajectories = TempCoherTrajectory.empty;
            midPoint = repmat(ceil(obj.WinSz/2), 1, 3);
            for y = 1:obj.WinSz
                for x = 1:obj.WinSz
                    obj.Trajectories(y, x) = TempCoherTrajectory([y x 1], midPoint);
                end
            end
        end
        
        function CalculateCoherence(obj)
            for y = 1:obj.WinSz
                for x = 1:obj.WinSz
                    trajectory = obj.Trajectories(y, x);
                    midPointValue = obj.Video(trajectory.MidPoint(1), trajectory.MidPoint(2), trajectory.MidPoint(3));
                    
                    % to prevent -infinity when log-ing to view
                    trajectory.Error = 1;
                    for j = 1:trajectory.IndicesCount
                        indices = trajectory.Indices(j, :);
                        value = obj.Video(indices(1), indices(2), indices(3));
                        trajectory.Error = trajectory.Error + (midPointValue - value)^2;
                    end
                end
            end
        end
        
        function ComputeGradients(obj)
            for y = 1:obj.WinSz
                for x = 1:obj.WinSz
                    trajectory = obj.Trajectories(y,   x  );
                    error_2_2 = trajectory.Error;
                    
                    % so that it will equate to 0 when at the edge
                    error_1_1 = error_2_2;
                    error_1_2 = error_2_2;
                    error_1_3 = error_2_2;
                    error_2_1 = error_2_2;
                    error_2_3 = error_2_2;
                    error_3_1 = error_2_2;
                    error_3_2 = error_2_2;
                    error_3_3 = error_2_2;
                    
                    if (y == 1)
                        if (x == 1)
                            error_2_3 = obj.Trajectories(y,   x+1).Error;
                            error_3_2 = obj.Trajectories(y+1, x  ).Error;
                            error_3_3 = obj.Trajectories(y+1, x+1).Error;
                        elseif (x == obj.WinSz)
                            error_2_1 = obj.Trajectories(y,   x-1).Error;
                            error_3_1 = obj.Trajectories(y+1, x-1).Error;
                            error_3_2 = obj.Trajectories(y+1, x  ).Error;
                        else
                            error_2_1 = obj.Trajectories(y,   x-1).Error;
                            error_2_3 = obj.Trajectories(y,   x+1).Error;
                            error_3_1 = obj.Trajectories(y+1, x-1).Error;
                            error_3_2 = obj.Trajectories(y+1, x  ).Error;
                            error_3_3 = obj.Trajectories(y+1, x+1).Error;
                        end
                    elseif (y == obj.WinSz)
                        if (x == 1)
                            error_1_2 = obj.Trajectories(y-1, x  ).Error;
                            error_1_3 = obj.Trajectories(y-1, x+1).Error;
                            error_2_3 = obj.Trajectories(y,   x+1).Error;
                        elseif (x == obj.WinSz)
                            error_1_1 = obj.Trajectories(y-1, x-1).Error;
                            error_1_2 = obj.Trajectories(y-1, x  ).Error;
                            error_2_1 = obj.Trajectories(y,   x-1).Error;
                        else
                            error_1_1 = obj.Trajectories(y-1, x-1).Error;
                            error_1_2 = obj.Trajectories(y-1, x  ).Error;
                            error_1_3 = obj.Trajectories(y-1, x+1).Error;
                            error_2_1 = obj.Trajectories(y,   x-1).Error;
                            error_2_3 = obj.Trajectories(y,   x+1).Error;
                        end
                    else
                        if (x == 1)
                            error_1_2 = obj.Trajectories(y-1, x  ).Error;
                            error_1_3 = obj.Trajectories(y-1, x+1).Error;
                            error_2_3 = obj.Trajectories(y,   x+1).Error;
                            error_3_2 = obj.Trajectories(y+1, x  ).Error;
                            error_3_3 = obj.Trajectories(y+1, x+1).Error;
                        elseif (x == obj.WinSz)
                            error_1_1 = obj.Trajectories(y-1, x-1).Error;
                            error_1_2 = obj.Trajectories(y-1, x  ).Error;
                            error_2_1 = obj.Trajectories(y,   x-1).Error;
                            error_3_1 = obj.Trajectories(y+1, x-1).Error;
                            error_3_2 = obj.Trajectories(y+1, x  ).Error;
                        else
                            error_1_1 = obj.Trajectories(y-1, x-1).Error;
                            error_1_2 = obj.Trajectories(y-1, x  ).Error;
                            error_1_3 = obj.Trajectories(y-1, x+1).Error;
                            error_2_1 = obj.Trajectories(y,   x-1).Error;
                            error_2_3 = obj.Trajectories(y,   x+1).Error;
                            error_3_1 = obj.Trajectories(y+1, x-1).Error;
                            error_3_2 = obj.Trajectories(y+1, x  ).Error;
                            error_3_3 = obj.Trajectories(y+1, x+1).Error;
                        end
                    end
                    
                    trajectory.Gradients(1) = error_2_2 - error_1_1;
                    trajectory.Gradients(2) = error_2_2 - error_1_2;
                    trajectory.Gradients(3) = error_2_2 - error_1_3;
                    trajectory.Gradients(4) = error_2_2 - error_2_1;
                    %middle
                    trajectory.Gradients(5) = error_2_2 - error_2_3;
                    trajectory.Gradients(6) = error_2_2 - error_3_1;
                    trajectory.Gradients(7) = error_2_2 - error_3_2;
                    trajectory.Gradients(8) = error_2_2 - error_3_3;
                end
            end
        end
        
        function FindPeaks(obj)
            for start_y = 1:obj.WinSz
                for start_x = 1:obj.WinSz
                    y = start_y;
                    x = start_x;
                    
                    ended = false;
                    while (~ended)
                        [ended, y, x] = GradientDescent(obj.Trajectories(y, x), y, x);
                    end
                end
            end
        end
        
        function PopulateMaxStopCountTrajectory(obj)
            maxStopCountIndex = 0;
            maxStopCount = 0;
            for i = 1:obj.WinSz^2
                if (obj.Trajectories(i).StopCount > maxStopCount)
                    maxStopCount = obj.Trajectories(i).StopCount;
                    maxStopCountIndex = i;
                end
            end
            
            obj.MaxStopCountTrajectory = obj.Trajectories(maxStopCountIndex);
        end
    end
    
end

function [ended, y, x] = GradientDescent(trajectory, y, x)
    ended = false;

    [maxGradient, i] = max(trajectory.Gradients);
    if (maxGradient > 0)
        switch (i)
            case 1
                y = y - 1;
                x = x - 1;
            case 2
                y = y - 1;
            case 3
                y = y - 1;
                x = x + 1;
            case 4
                x = x - 1;
                %middle
            case 5
                x = x + 1;
            case 6
                y = y + 1;
                x = x - 1;
            case 7
                y = y + 1;
            case 8
                y = y + 1;
                x = x + 1;
        end
    else
        trajectory.StopCount = trajectory.StopCount + 1;
        ended = true;
    end
end

