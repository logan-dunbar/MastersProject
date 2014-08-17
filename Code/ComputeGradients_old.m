function ComputeGradients_old(obj)
%COMPUTEGRADIENTS Summary of this function goes here
%   Detailed explanation goes here

windowCount = size(obj.Windows, 2);
    winCountStr = int2str(windowCount);
    for j = 1:windowCount
        disp(horzcat('At Window: ', int2str(j), ' of ', winCountStr));
        for y = 1:obj.WindowSize
            for x = 1:obj.WindowSize
                trajectory = obj.Windows(j).Trajectories(y,   x  );
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
                        error_2_3 = obj.Windows(j).Trajectories(y,   x+1).Error;
                        error_3_2 = obj.Windows(j).Trajectories(y+1, x  ).Error;
                        error_3_3 = obj.Windows(j).Trajectories(y+1, x+1).Error;
                    elseif (x == obj.WindowSize)
                        error_2_1 = obj.Windows(j).Trajectories(y,   x-1).Error;
                        error_3_1 = obj.Windows(j).Trajectories(y+1, x-1).Error;
                        error_3_2 = obj.Windows(j).Trajectories(y+1, x  ).Error;
                    else
                        error_2_1 = obj.Windows(j).Trajectories(y,   x-1).Error;
                        error_2_3 = obj.Windows(j).Trajectories(y,   x+1).Error;
                        error_3_1 = obj.Windows(j).Trajectories(y+1, x-1).Error;
                        error_3_2 = obj.Windows(j).Trajectories(y+1, x  ).Error;
                        error_3_3 = obj.Windows(j).Trajectories(y+1, x+1).Error;
                    end
                elseif (y == obj.WindowSize)
                    if (x == 1)
                        error_1_2 = obj.Windows(j).Trajectories(y-1, x  ).Error;
                        error_1_3 = obj.Windows(j).Trajectories(y-1, x+1).Error;
                        error_2_3 = obj.Windows(j).Trajectories(y,   x+1).Error;
                    elseif (x == obj.WindowSize)
                        error_1_1 = obj.Windows(j).Trajectories(y-1, x-1).Error;
                        error_1_2 = obj.Windows(j).Trajectories(y-1, x  ).Error;
                        error_2_1 = obj.Windows(j).Trajectories(y,   x-1).Error;
                    else
                        error_1_1 = obj.Windows(j).Trajectories(y-1, x-1).Error;
                        error_1_2 = obj.Windows(j).Trajectories(y-1, x  ).Error;
                        error_1_3 = obj.Windows(j).Trajectories(y-1, x+1).Error;
                        error_2_1 = obj.Windows(j).Trajectories(y,   x-1).Error;
                        error_2_3 = obj.Windows(j).Trajectories(y,   x+1).Error;
                    end
                else
                    if (x == 1)
                        error_1_2 = obj.Windows(j).Trajectories(y-1, x  ).Error;
                        error_1_3 = obj.Windows(j).Trajectories(y-1, x+1).Error;
                        error_2_3 = obj.Windows(j).Trajectories(y,   x+1).Error;
                        error_3_2 = obj.Windows(j).Trajectories(y+1, x  ).Error;
                        error_3_3 = obj.Windows(j).Trajectories(y+1, x+1).Error;
                    elseif (x == obj.WindowSize)
                        error_1_1 = obj.Windows(j).Trajectories(y-1, x-1).Error;
                        error_1_2 = obj.Windows(j).Trajectories(y-1, x  ).Error;
                        error_2_1 = obj.Windows(j).Trajectories(y,   x-1).Error;
                        error_3_1 = obj.Windows(j).Trajectories(y+1, x-1).Error;
                        error_3_2 = obj.Windows(j).Trajectories(y+1, x  ).Error;
                    else
                        error_1_1 = obj.Windows(j).Trajectories(y-1, x-1).Error;
                        error_1_2 = obj.Windows(j).Trajectories(y-1, x  ).Error;
                        error_1_3 = obj.Windows(j).Trajectories(y-1, x+1).Error;
                        error_2_1 = obj.Windows(j).Trajectories(y,   x-1).Error;
                        error_2_3 = obj.Windows(j).Trajectories(y,   x+1).Error;
                        error_3_1 = obj.Windows(j).Trajectories(y+1, x-1).Error;
                        error_3_2 = obj.Windows(j).Trajectories(y+1, x  ).Error;
                        error_3_3 = obj.Windows(j).Trajectories(y+1, x+1).Error;
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
end

