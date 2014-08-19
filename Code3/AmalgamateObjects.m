function VideoObjects = AmalgamateObjects(VideoObjects)
%AMALGAMATEOBJECTS Amalgamates the video objects based on whether their
%bitmasks intersect and whether their trajectories are close enough

finished = false;
%iStart = 1;
while ~finished
    for i = 1:numel(VideoObjects)-1
        startOver = false;
        obj1 = VideoObjects{i};
        for j = i+1:numel(VideoObjects)
            obj2 = VideoObjects{j};
            combinedObj = CompareObjects(obj1, obj2);
            if ~isempty(combinedObj)
                startOver = true;
                break;
            end
        end
        
        if startOver
            VideoObjects{i} = combinedObj;
            VideoObjects(j) = [];
            
            % check this, might need to start from begin again
            %iStart = i;
            break;
        end
    end
    
    if isempty(VideoObjects) || i == numel(VideoObjects)
        finished = true;
    end
end

end

function CombinedObj = CompareObjects(obj1, obj2)
CombinedObj = [];

% Test overlapping
overlappingMask = obj1.Mask & obj2.Mask;
if any(overlappingMask(:))
    obj1MeanTrajectoryIndex = mean(obj1.AvgTrajectoryIndices, 1);
    obj2MeanTrajectoryIndex = mean(obj2.AvgTrajectoryIndices, 1);
    
    % Test starting points/trajectories are close enough
    if abs(obj1MeanTrajectoryIndex(1)-obj2MeanTrajectoryIndex(1)) <= 1 && abs(obj1MeanTrajectoryIndex(2)-obj2MeanTrajectoryIndex(2)) <= 1
        CombinedObj = obj1;
        CombinedObj.Mask = obj1.Mask | obj2.Mask;
        CombinedObj.AvgTrajectoryIndices = [obj1.AvgTrajectoryIndices;obj2.AvgTrajectoryIndices];
    end
end
end

