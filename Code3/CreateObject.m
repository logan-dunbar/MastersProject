function SeedObject = CreateObject(seedPixel, pixels, pixelsSize, pixelNeighbourIndices, winSz)
%CREATEOBJECT Creates an object mask associated with a seed pixel

[y,x] = ind2sub(winSz, seedPixel.SeedIndex);
SeedObject.AvgTrajectoryIndices = [y,x];
SeedObject.Mask = false(pixelsSize);
activeInds = seedPixel.PixelIndex;
checkedInds = activeInds;

while ~isempty(activeInds)
    SeedObject.Mask(activeInds) = true;
    
    tempNeighbourIndices = pixelNeighbourIndices;
    for ind = activeInds
        [y, x, t] = ind2sub(pixelsSize, ind);
        %front face
        if t == 1;
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(1)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(2)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(3)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(4)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(5)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(6)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(7)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(8)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(9)) = [];
        end
        %back face
        if t == pixelsSize(3)
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(19)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(20)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(21)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(22)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(23)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(24)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(25)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(26)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(27)) = [];
        end
        %top face
        if y == 1
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(1)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(4)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(7)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(10)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(13)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(16)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(19)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(22)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(25)) = [];
        end
        %bottom face
        if y == pixelsSize(1)
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(3)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(6)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(9)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(12)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(15)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(18)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(21)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(24)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(27)) = [];
        end
        %left face
        if x == 1
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(1)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(2)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(3)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(10)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(11)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(12)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(19)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(20)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(21)) = [];
        end
        %right face
        if x == pixelsSize(2)
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(7)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(8)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(9)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(16)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(17)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(18)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(25)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(26)) = [];
            tempNeighbourIndices(tempNeighbourIndices == pixelNeighbourIndices(27)) = [];
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
        if pixels(ind).ErrorMap(seedPixel.SeedIndex) < pixels(seedPixel.PixelIndex).ErrorMap(seedPixel.SeedIndex)*1.5
            activeInds = [activeInds ind];
        end
    end
    
    checkedInds = [checkedInds newInds];
end

end

