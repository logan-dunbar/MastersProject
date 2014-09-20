function SeedObject = CreateObject(seedPixel, pixels, frameSize, pixelNeighbourIndices, winSz, ErrorThreshold)
%CREATEOBJECT Creates an object mask associated with a seed pixel

[y,x] = ind2sub(winSz, seedPixel.SeedIndex);
SeedObject.AvgTrajectoryIndices = [y,x];
SeedObject.Mask = false(frameSize);
activeInds = seedPixel.PixelIndex;
checkedInds = activeInds;

while ~isempty(activeInds)
    SeedObject.Mask(activeInds) = true;
    
    tempNeighbourIndices = pixelNeighbourIndices;
    
    for ind = activeInds
        [y, x] = ind2sub(frameSize, ind);
        % Top
        if y == 1
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(1)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(4)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(7)) = [];
        end
        % Left
        if x == 1
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(1)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(2)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(3)) = [];
        end
        % Bottom
        if y == frameSize(1)
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(3)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(6)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(9)) = [];
        end
        % Right
        if x == frameSize(2)
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(7)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(8)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(9)) = [];
        end
    end
    
    newInds = unique(bsxfun(@plus, activeInds', tempNeighbourIndices));
    newInds = newInds(:)';
    loopNewInds = newInds;
    for newInd = loopNewInds;
        if any(checkedInds == newInd)
            newInds(newInds == newInd) = [];
        end
    end
    
    
    activeInds = [];
    for ind = newInds
        %need to fix the magic number based on window size
        %if pixels{ind}.ErrorMap(seedPixel.SeedIndex) < pixels{seedPixel.PixelIndex}.ErrorMap(seedPixel.SeedIndex) + 250
        if pixels{ind}.ErrorMap(seedPixel.SeedIndex) < ErrorThreshold
            activeInds = [activeInds ind];
        end
    end
    
    checkedInds = [checkedInds newInds];
end

end

