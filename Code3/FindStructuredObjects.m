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
Pixel.PixelIndex = 0;
for i=trajIndsCount:-1:1
    Pixel.GradientMap{i} = Gradients;
end
for i=pixelsSize(1)*pixelsSize(2)*pixelsSize(3):-1:1
    Pixels{i} = Pixel;
end
SeedPixels = [];

for t = 1+tHalfWin:vidSz(3)-tHalfWin
    tic;
    disp(['T: ', num2str(t-tHalfWin), ' of ', num2str(pixelsSize(3))]);
    tPixInd = t - tHalfWin;
    
    for x = 1+xHalfWin:vidSz(2)-xHalfWin
        disp(['  X: ', num2str(x-xHalfWin), ' of ', num2str(pixelsSize(2))]);
        xPixInd = x - xHalfWin;
        
        pixels = cell(pixelsSize(1),1);
        parfor y = 1:pixelsSize(1)
            yInd = y+yHalfWin;
            pixels{y} = Pixel;
            pixels{y}.PixelIndex = y;
            windowVideo = video(y:y+2*yHalfWin,x-xHalfWin:x+xHalfWin,t-tHalfWin:t+tHalfWin);
            
            for i = 1:trajIndsCount
                trajPixelVals = windowVideo(Window.TrajInds(i,:));
                pixels{y}.ErrorMap(i) = ComputeError(video(yInd, x, t), trajPixelVals);
            end
            
            for i = 1:trajIndsCount
                pixelError = pixels{y}.ErrorMap(i);
                neighbourPixelErrors = GetNeighbourPixelErrors(i, pixels{y}.ErrorMap, trajColSz, trajNeighbourIndices, trajIndsCount);
                pixels{y}.GradientMap{i} = ComputeGradients(pixelError, neighbourPixelErrors);
            end
            
            for i = 1:trajIndsCount
                stopIndex = RunGradientDescent(i, pixels{y}.GradientMap, pixels{y}.ErrorMap, trajNeighbourIndices);
                pixels{y}.StopCountMap(stopIndex) = pixels{y}.StopCountMap(stopIndex) + 1;
            end
            
            pixels{y}.SeedIndex = FindMostLikelyTrajectoryIndex(pixels{y}.StopCountMap, trajStopCountThreshold);
%             if ~isempty(Pixels(pixInd).SeedIndex)
%                 SeedPixels = [SeedPixels Pixels(pixInd)];
%             end
            
        end
        pixInds = bsxfun(@plus,(tPixInd-1)*pixelsSize(1)*pixelsSize(2) + (xPixInd-1)*pixelsSize(1), 1:pixelsSize(1));
        Pixels(pixInds) = pixels;
    end
    
    loopTime = toc;
    timeLeft = (pixelsSize(3) - (t-tHalfWin))*loopTime;
    
    disp(['Remaining: ', datestr(datenum(0,0,0,0,0,timeLeft),'HH:MM:SS')]);
end

for i = 1:numel(Pixels)
    if ~isempty(Pixels{i}.SeedIndex)
        SeedPixels = [SeedPixels Pixels{i}];
    end
end

parfor i = 1:numel(SeedPixels)
    VideoObjects{i} = CreateObject(SeedPixels(i), Pixels, pixelsSize, pixelNeighbourIndices, winSz);
end

VideoObjects = AmalgamateObjects(VideoObjects);

%FOR TESTING PURPOSES
%VideoObjects = Pixels;

end

