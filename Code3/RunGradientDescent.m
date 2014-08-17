function StopIndex = RunGradientDescent(startIndex, gradientMap, errorMap, trajNeighbourIndices)
%RUNGRADIENTDESCENT Takes a start index and a gradient map and tries to
%walk down the map until it finds a local minimum, then returns that index

activeInds = startIndex;
checkedInds = activeInds;
stopInds = activeInds;

while ~isempty(activeInds)
    loopInds = activeInds;
    for ind = loopInds
        activeInds(activeInds == ind) = [];
        
        minGrad = min(gradientMap{ind});
        minGradInds = gradientMap{ind} == minGrad;
        if minGrad >= 0
            stopInds = [stopInds ind];
        else
            newInds = unique(bsxfun(@plus, ind, trajNeighbourIndices(minGradInds)));
            
            % this is apparently faster than ismember()
            loopNewInds = newInds;
            for newInd = loopNewInds;
                if any(checkedInds == newInd)
                    newInds(newInds == newInd) = [];
                end
            end
            activeInds = [activeInds newInds];
            checkedInds = [checkedInds newInds];
            
%             newUncheckedInds = newInds(~ismember(newInds, checkedInds));
%             activeInds = [activeInds newUncheckedInds];
%             checkedInds = [checkedInds newUncheckedInds];
        end
    end
end

[minError, minErrorStopIndex] = min(errorMap(stopInds));
StopIndex = stopInds(minErrorStopIndex);

% minError = errorMap(stopInds(1));
% StopIndex = 1;
% for i = 2:numel(stopInds)
%     if errorMap(stopInds(i)) < minError
%         minError = errorMap(stopInds(i));
%         StopIndex = stopInds(i);
%     end
% end

end

