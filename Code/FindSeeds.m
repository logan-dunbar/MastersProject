function seeds = FindSeeds(obj)
%FINDSEEDS Summary of this function goes here
%   Detailed explanation goes here

totalCount = obj.WindowSize^2;
thresholdCount = ceil(totalCount * 0.9);

seeds = [];
for i = 1:size(obj.Windows, 2);
    maxTrajectory = MaxStopCountTrajectory(obj.Windows(i));
    if (maxTrajectory.StopCount > thresholdCount)
        seeds = [seeds i];
    end
end

end