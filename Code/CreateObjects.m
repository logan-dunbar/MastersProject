function objects = CreateObjects(obj, seeds)
%CREATEOBJECTS Summary of this function goes here
%   Detailed explanation goes here

    objects = [];
    
    for seed = seeds
        objects = [objects MyObject(obj, seed)];
    end

    finished = false;
    while (~finished)
        for i = 1:length(objects) - 1
            startOver = false;
            
            obj1 = objects(i);
            for j = i+1:length(objects)
                obj2 = objects(j);
                
                combinedObj = CompareMyObjects(obj1,obj2);
                if (~isempty(combinedObj))
                    startOver = true;
                    break;
                end
            end
            
            if (startOver)
                objects(i) = combinedObj;
                objects(j) = [];
                break;
            end
        end
            
        if (i > length(objects) - 1)
            finished = true;
        end
    end
end

function combinedObj = CompareMyObjects(obj1, obj2)
    combinedObj = [];
    
    % Test overlapping
    mask = obj1.Mask & obj2.Mask;
    if (any(mask(:)))
        obj1Index = obj1.MeanTrajectoryIndex;
        obj2Index = obj2.MeanTrajectoryIndex;
        
        % Test starting points/trajectories are close enough
        if (abs(obj1Index(1)-obj2Index(1)) <= 1 && abs(obj1Index(2)-obj2Index(2)) <= 1)
            combinedObj = obj1;
            combinedObj.Mask = obj1.Mask | obj2.Mask;
            
            combinedObj.MeanTrajectoryIndices = [obj1.MeanTrajectoryIndices;obj2.MeanTrajectoryIndices];
        end
    end
end