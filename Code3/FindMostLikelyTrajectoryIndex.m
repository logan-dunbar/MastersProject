function SeedIndex = FindMostLikelyTrajectoryIndex(stopCountMap, threshold)
%FINDMOSTLIKELYTRAJECTORYINDEX Determines whether a trajectory has a stop
%count above a specified threshold and returns the index, otherwise nothing

% [maxStopCount, maxStopCountIndex] = max(stopCountMap);
% if maxStopCount > threshold
%     SeedIndex = maxStopCountIndex;
% else
%     SeedIndex = [];
% end

sortedStopCountMap = sort(stopCountMap, 'descend');
if(sortedStopCountMap(1) - sortedStopCountMap(2) > threshold)
    SeedIndex = find(stopCountMap == sortedStopCountMap(1), 1);
else
    SeedIndex = [];
end

