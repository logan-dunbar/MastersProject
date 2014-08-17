function VideoObjects = FindStructuredObjects(video, winSz)
%FINDSTRUCTUREDOBJECTS Finds and segments structured video objects from a
%video given a window size

video = double(video);

VideoObjects = [];
StopCountThreshold = 0.9;

%%%%%%%%%%%%%%%%%%%%

vidSz = size(video);
pixelsSize = vidSz - 2*floor(winSz/2); % doesn't deal with edges

yHalfWin = floor(winSz(1)/2);
xHalfWin = floor(winSz(2)/2);
tHalfWin = floor(winSz(3)/2);

Window = CreateWindow(winSz);
trajIndsCount = winSz(1)*winSz(2);
trajStopCountThreshold = trajIndsCount * StopCountThreshold;

trajColSz = winSz(1);
trajNeighbourIndices = [-trajColSz-1, -trajColSz, -trajColSz+1, -1, +1, trajColSz-1, trajColSz, trajColSz+1];

pixelColSz = pixelsSize(1);
pixelNeighbourIndicesMid = [-pixelColSz-1, -pixelColSz, -pixelColSz+1, -1, 0, +1, pixelColSz-1, pixelColSz, pixelColSz+1];
pixelNeighbourIndicesFront = pixelNeighbourIndicesMid - (pixelsSize(1)*pixelsSize(2));
pixelNeighbourIndicesBack = pixelNeighbourIndicesMid + (pixelsSize(1)*pixelsSize(2));
pixelNeighbourIndices = [pixelNeighbourIndicesFront, pixelNeighbourIndicesMid, pixelNeighbourIndicesBack];

% Pre-allocate all the things!
Gradients(8) = 0;
Pixel.ErrorMap(trajIndsCount) = 0;
Pixel.StopCountMap(trajIndsCount) = 0;
Pixel.SeedIndex = [];
for i=trajIndsCount:-1:1
    Pixel.GradientMap{i} = Gradients;
end
for i=pixelsSize(1)*pixelsSize(2)*pixelsSize(3):-1:1
    Pixels(i) = Pixel;
end
SeedPixels = [];

for t = 1+tHalfWin:vidSz(3)-tHalfWin
    tPixInd = t - tHalfWin;
    
    for x = 1+xHalfWin:vidSz(2)-xHalfWin
            xPixInd = x - xHalfWin;
            
        for y = 1+yHalfWin:vidSz(1)-yHalfWin
            yPixInd = y - yHalfWin;
            
            windowVideo = video(y-yHalfWin:y+yHalfWin,x-xHalfWin:x+xHalfWin,t-tHalfWin:t+tHalfWin);
            
            pixInd = sub2ind(pixelsSize, yPixInd, xPixInd, tPixInd);
            Pixels(pixInd).PixelIndex = pixInd;
            
            for i = 1:trajIndsCount
                trajPixelVals = windowVideo(Window.TrajInds(i,:));
                Pixels(pixInd).ErrorMap(i) = ComputeError(video(x, y, t), trajPixelVals);
            end
            
            for i = 1:trajIndsCount
                pixelError = Pixels(pixInd).ErrorMap(i);
                neighbourPixelErrors = GetNeighbourPixelErrors(i, Pixels(pixInd).ErrorMap, trajColSz, trajNeighbourIndices, trajIndsCount);
                Pixels(pixInd).GradientMap{i} = ComputeGradients(pixelError, neighbourPixelErrors);
            end
            
            for i = 1:trajIndsCount
                stopIndex = RunGradientDescent(i, Pixels(pixInd).GradientMap, Pixels(pixInd).ErrorMap, trajNeighbourIndices);
                Pixels(pixInd).StopCountMap(stopIndex) = Pixels(pixInd).StopCountMap(stopIndex) + 1;
            end
            
            Pixels(pixInd).SeedIndex = FindMostLikelyTrajectoryIndex(Pixels(pixInd).StopCountMap, trajStopCountThreshold);
            if ~isempty(Pixels(pixInd).SeedIndex)
                SeedPixels = [SeedPixels Pixels(pixInd)];
            end
        end
    end
end

for i = 1:numel(SeedPixels)
    VideoObjects{i} = CreateObject(SeedPixels(i), Pixels, pixelsSize, pixelNeighbourIndices);
end

%FOR TESTING PURPOSES
%VideoObjects = Pixels;

end
