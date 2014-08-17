function SeedIndex = FindMostLikelyTrajectoryIndex(stopCountMap, threshold)
%FINDMOSTLIKELYTRAJECTORYINDEX Determines whether a trajectory has a stop
%count above a specified threshold and returns the index, otherwise nothing

[maxStopCount, maxStopCountIndex] = max(stopCountMap);
if maxStopCount > threshold
    SeedIndex = maxStopCountIndex;
else
    SeedIndex = [];
end

end

