function VideoObjects = FindStructuredObjects(video, winSz)
%FINDSTRUCTUREDOBJECTS Finds and segments structured video objects from a
%video given a window size

video = double(video);

VideoObjects = [];
StopCountThreshold = 0.75;
ErrorThreshold = winSz(3) * 4^2; %~deviation of 4 pixels for each frame

%%%%%%%%%%%%%%%%%%%%

vidSz = size(video);
pixelsSize = vidSz - 2*floor(winSz/2); % doesn't deal with edges

yHalfWin = floor(winSz(1)/2);
xHalfWin = floor(winSz(2)/2);
tHalfWin = floor(winSz(3)/2);

% Create the window indices
Window = CreateWindow(winSz);

trajIndsCount = winSz(1)*winSz(2);
trajStopCountThreshold = trajIndsCount * StopCountThreshold;

trajColSz = winSz(1);
trajNeighbourIndices = [-trajColSz-1, -trajColSz, -trajColSz+1, -1, +1, trajColSz-1, trajColSz, trajColSz+1];

pixelColSz = pixelsSize(1);
pixelNeighbourIndicesMid = [-pixelColSz-1, -pixelColSz, -pixelColSz+1, -1, 0, +1, pixelColSz-1, pixelColSz, pixelColSz+1];
pixelNeighbourIndices = pixelNeighbourIndicesMid;

FrameObjects = {};

% Pre-allocate all the things!
Gradients = zeros(1,8);
Pixel.ErrorMap = zeros(1,trajIndsCount);
Pixel.StopCountMap = zeros(1,trajIndsCount);
Pixel.SeedIndex = [];
Pixel.PixelIndex = 0;
for i=trajIndsCount:-1:1
    Pixel.GradientMap{i} = Gradients;
end

for t = 1:pixelsSize(3)
    tTime = tic;
    disp(['T: ', num2str(t), ' of ', num2str(pixelsSize(3))]);
    
    % Per frame allocation
    SeedPixels = [];
    Pixels = cell(pixelsSize(1),pixelsSize(2));
    for i=pixelsSize(1)*pixelsSize(2):-1:1
        Pixels{i} = Pixel;
    end

    parfor x = 1:pixelsSize(2)
        xTime = tic;
        disp(['   X: ', num2str(x), ' of ', num2str(pixelsSize(2))]);
        
        % Per column allocation
        ColumnPixels = cell(pixelsSize(1), 1);
        for i=pixelsSize(1):-1:1
            ColumnPixels{i} = Pixel;
        end
        
        
        for y = 1:pixelsSize(1)
            ColumnPixels{y}.PixelIndex = sub2ind(pixelsSize(1:2), y, x);
            windowVideo = video(y:y+2*yHalfWin,x:x+2*xHalfWin,t:t+2*tHalfWin);
            
            %can vectorize this
            for i = 1:trajIndsCount
                trajPixelVals = windowVideo(Window.TrajInds(i,:));
                pixelVal = windowVideo(1+yHalfWin, 1+xHalfWin, 1+tHalfWin);
                ColumnPixels{y}.ErrorMap(i) = ComputeError(pixelVal, trajPixelVals);
            end
            
            for i = 1:trajIndsCount
                pixelError = ColumnPixels{y}.ErrorMap(i);
                neighbourPixelErrors = GetNeighbourPixelErrors(i, ColumnPixels{y}.ErrorMap, trajColSz, trajNeighbourIndices, trajIndsCount);
                ColumnPixels{y}.GradientMap{i} = ComputeGradients(pixelError, neighbourPixelErrors);
            end
            
            shortCircuitMap = zeros(1, trajIndsCount);
            %randomize to get more short circuits quicker
            for i = randperm(trajIndsCount)
                [stopIndex, shortCircuitMap] = RunGradientDescent(i, ColumnPixels{y}.GradientMap, ColumnPixels{y}.ErrorMap, trajNeighbourIndices, shortCircuitMap);
                ColumnPixels{y}.StopCountMap(stopIndex) = ColumnPixels{y}.StopCountMap(stopIndex) + 1;
            end
            
            ColumnPixels{y}.SeedIndex = FindMostLikelyTrajectoryIndex(ColumnPixels{y}.StopCountMap, trajStopCountThreshold);
            if ~isempty(ColumnPixels{y}.SeedIndex)
                SeedPixels = [SeedPixels ColumnPixels{y}];
            end
        end
        
        % sliced for parfor
        Pixels(:, x) = ColumnPixels;
        xTimeLeft = (pixelsSize(2) - x)*toc(xTime);
        disp(['    X Took: ', datestr(datenum(0,0,0,0,0,toc(xTime)),'HH:MM:SS'), ' - Remaining: ', datestr(datenum(0,0,0,0,0,xTimeLeft),'HH:MM:SS')]);
    end
    
    disp('Creating objects...');
    pixelObjects = {};
    for i = 1:numel(SeedPixels)
        pixelObjects{i} = CreateObject(SeedPixels(i), Pixels, pixelsSize(1:2), pixelNeighbourIndices, winSz, ErrorThreshold);
    end
    disp('Objects created.');
    
    disp('Amalgamating objects...');
    FrameObjects{t} = AmalgamateObjects(pixelObjects);
    disp('Objects amalgamated...');
    
    loopTime = toc(tTime);
    timeLeft = (pixelsSize(3) - t)*loopTime;
    
    disp(['Remaining: ', datestr(datenum(0,0,0,0,0,timeLeft),'HH:MM:SS')]);
end
% 
% parfor i = 1:numel(SeedPixels)
%     VideoObjects{i} = CreateObject(SeedPixels(i), Pixels, pixelsSize, pixelNeighbourIndices, winSz);
% end
% 
% VideoObjects = AmalgamateObjects(VideoObjects);

%FOR TESTING PURPOSES
VideoObjects = FrameObjects;

end

