function FindPeaks(obj)
%FINDPEAKS Summary of this function goes here
%   Detailed explanation goes here

    for j = 1:size(obj.Windows, 2)
    %for j = 1:50
        disp(horzcat('At Window: ', int2str(j), ' of ', int2str(size(obj.Windows, 2))));
        for start_y = 1:obj.WindowSize
            for start_x = 1:obj.WindowSize
                y = start_y;
                x = start_x;
                
                ended = false;
                while (~ended)
                    [ended, y, x] = GradientDescent(obj.Windows(j).Trajectories(y, x), y, x);
                end
            end
        end
        
        %could set the MaxStopCountTrajectory here
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

