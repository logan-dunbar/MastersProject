function trajectory = MaxStopCountTrajectory(window)
%MAXSTOPCOUNTTRAJECTORY Summary of this function goes here
%   Detailed explanation goes here

maxStopCountIndex = 0;
maxStopCount = 0;
for i = 1:window.WinSz^2
    if (window.Trajectories(i).StopCount > maxStopCount)
        maxStopCount = window.Trajectories(i).StopCount;
        maxStopCountIndex = i;
    end
end

trajectory = window.Trajectories(maxStopCountIndex);

end

