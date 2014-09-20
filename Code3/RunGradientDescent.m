function [StopIndex, ShortCircuitMap] = RunGradientDescent(startIndex, gradientMap, errorMap, trajNeighbourIndices, shortCircuitMap)
%RUNGRADIENTDESCENT Takes a start index and a gradient map and tries to
%walk down the map until it finds a local minimum, then returns that index

pathId = 1;
path.currentInd = [];
path.parentInds = [];
path.id = pathId;
path.nextInds = startIndex;
Paths = path;
while ~isempty([Paths.nextInds])
    %disp(num2str(numel([Paths.nextInds])));
    loopPaths = Paths;
    for path = loopPaths
        if numel(path.nextInds) == 1
            % only 1 ind, stay with same path
            path.parentInds = [path.parentInds path.currentInd];
            path.currentInd = path.nextInds;
            path.nextInds = computeNextInds(path.currentInd);
            Paths([Paths.id] == path.id) = path;
            
            if isempty(path.nextInds)
                % stopped, so update the short circuit map
                shortCircuitMap(path.parentInds) = path.currentInd;
            end
        elseif numel(path.nextInds) > 1
            % spawn new paths for each end
            for nextInd = path.nextInds
                alreadyActivePathInds = [Paths.currentInd] == nextInd;
                if any(alreadyActivePathInds)
                    for id = [Paths(alreadyActivePathInds).id]
                        Paths([Paths.id] == id).parentInds = unique([Paths([Paths.id] == id).parentInds path.currentInd]);
                    end
                else
                    pathId = pathId + 1;
                    newPath = path;
                    newPath.id = pathId;
                    newPath.parentInds = [path.parentInds path.currentInd];
                    newPath.currentInd = nextInd;
                    newPath.nextInds = computeNextInds(newPath.currentInd);
                    Paths = [Paths newPath];
                end
            end
            
            % kill old path
            Paths([Paths.id] == path.id) = [];
        end
    end
end

minError = errorMap(Paths(1).currentInd);
minIndex = 1;
for i = 2:numel(Paths)
    if (errorMap(Paths(1).currentInd) < minError)
        minError = errorMap(Paths(1).currentInd);
        minIndex = i;
    end
end

shortCircuitMap(Paths(minIndex).parentInds) = Paths(minIndex).currentInd;
StopIndex = Paths(minIndex).currentInd;
ShortCircuitMap = shortCircuitMap;


    function nextInds = computeNextInds(currentIndex)
        if (shortCircuitMap(currentIndex) > 0)
            nextInds = shortCircuitMap(currentIndex);
        else
            [ytmp xtmp] = ind2sub([21 21], currentIndex);
            grads = gradientMap{currentIndex};
            minGrad = min(gradientMap{currentIndex});
            minGradInds = gradientMap{currentIndex} == minGrad;
            if minGrad >= 0
                nextInds = [];
            else
                nextInds = bsxfun(@plus, currentIndex, trajNeighbourIndices(minGradInds));
            end
        end
    end

% activeInds = startIndex;
% checkedInds = activeInds;
% stopInds = activeInds;
% 
% while ~isempty(activeInds)
%     loopInds = activeInds;
%     for ind = loopInds
%         
%         
%         activeInds(activeInds == ind) = [];
%         
%         minGrad = min(gradientMap{ind});
%         minGradInds = gradientMap{ind} == minGrad;
%         if minGrad >= 0
%             stopInds = [stopInds ind];
%         else
%             newInds = unique(bsxfun(@plus, ind, trajNeighbourIndices(minGradInds)));
%             
%             % this is apparently faster than ismember()
%             loopNewInds = newInds;
%             for newInd = loopNewInds;
%                 if any(checkedInds == newInd)
%                     newInds(newInds == newInd) = [];
%                 end
%             end
%             activeInds = [activeInds newInds];
%             checkedInds = [checkedInds newInds];
%             
% %             newUncheckedInds = newInds(~ismember(newInds, checkedInds));
% %             activeInds = [activeInds newUncheckedInds];
% %             checkedInds = [checkedInds newUncheckedInds];
%         end
%     end
% end
% 
% [minError, minErrorStopIndex] = min(errorMap(stopInds));
% StopIndex = stopInds(minErrorStopIndex);

% minError = errorMap(stopInds(1));
% StopIndex = 1;
% for i = 2:numel(stopInds)
%     if errorMap(stopInds(i)) < minError
%         minError = errorMap(stopInds(i));
%         StopIndex = stopInds(i);
%     end
% end

end

