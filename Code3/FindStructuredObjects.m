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
% pixelNeighbourIndicesFront = pixelNeighbourIndicesMid - (pixelsSize(1)*pixelsSize(2));
% pixelNeighbourIndicesBack = pixelNeighbourIndicesMid + (pixelsSize(1)*pixelsSize(2));
% pixelNeighbourIndices = [pixelNeighbourIndicesFront, pixelNeighbourIndicesMid, pixelNeighbourIndicesBack];
pixelNeighbourIndices = pixelNeighbourIndicesMid;

FrameObjects = {};

% Pre-allocate all the things!
Gradients = zeros(1,8);
Pixel.ErrorMap = zeros(1,trajIndsCount);
%Pixel.ErrorMap(trajIndsCount) = 0;
Pixel.StopCountMap = zeros(1,trajIndsCount);
%Pixel.StopCountMap(trajIndsCount) = 0;
Pixel.SeedIndex = [];
Pixel.PixelIndex = 0;
for i=trajIndsCount:-1:1
    Pixel.GradientMap{i} = Gradients;
end

%for t = 1+tHalfWin:vidSz(3)-tHalfWin
list = 11:8:30;
for t = 1:pixelsSize(3)
    %t = list(temp);
    
    tTime = tic;
    disp(['T: ', num2str(t), ' of ', num2str(pixelsSize(3))]);
    
    
    % Per frame allocation
    SeedPixels = [];
    Pixels = cell(pixelsSize(1),pixelsSize(2));
    for i=pixelsSize(1)*pixelsSize(2):-1:1
        Pixels{i} = Pixel;
    end

    parfor x = 1:pixelsSize(2)
    %for x = 1+xHalfWin:vidSz(2)-xHalfWin
        xTime = tic;
%         disp(['   X: ', num2str(x-xHalfWin), ' of ', num2str(pixelsSize(2))]);
%         xPixInd = x - xHalfWin;
        disp(['   X: ', num2str(x), ' of ', num2str(pixelsSize(2))]);
        
            % Per frame allocation
        %SeedPixels = [];
        ColumnPixels = cell(pixelsSize(1), 1);
        for i=pixelsSize(1):-1:1
            ColumnPixels{i} = Pixel;
        end
        
        
        %for y = 1+yHalfWin:vidSz(1)-yHalfWin
        for y = 1:pixelsSize(1)
        %for y = 247:vidSz(1)-yHalfWin
%             yPixInd = y - yHalfWin;
%             framePixInd = sub2ind(pixelsSize(1:2), yPixInd, xPixInd);
            framePixInd = sub2ind(pixelsSize(1:2), y, x);
            
%             Pixels{y, x}.PixelIndex = framePixInd;
            ColumnPixels{y}.PixelIndex = framePixInd;
            windowVideo = video(y:y+2*yHalfWin,x:x+2*xHalfWin,t:t+2*tHalfWin);
            
            %can vectorize this
            for i = 1:trajIndsCount
                trajPixelVals = windowVideo(Window.TrajInds(i,:));
                pixelVal = windowVideo(1+yHalfWin, 1+xHalfWin, 1+tHalfWin);
%                 Pixels{y, x}.ErrorMap(i) = ComputeError(pixelVal, trajPixelVals);
                ColumnPixels{y}.ErrorMap(i) = ComputeError(pixelVal, trajPixelVals);
            end
            
            for i = 1:trajIndsCount
%                 pixelError = Pixels{y, x}.ErrorMap(i);
%                 neighbourPixelErrors = GetNeighbourPixelErrors(i, Pixels{y, x}.ErrorMap, trajColSz, trajNeighbourIndices, trajIndsCount);
%                 Pixels{y, x}.GradientMap{i} = ComputeGradients(pixelError, neighbourPixelErrors);
                pixelError = ColumnPixels{y}.ErrorMap(i);
                neighbourPixelErrors = GetNeighbourPixelErrors(i, ColumnPixels{y}.ErrorMap, trajColSz, trajNeighbourIndices, trajIndsCount);
                ColumnPixels{y}.GradientMap{i} = ComputeGradients(pixelError, neighbourPixelErrors);
            end
            
            shortCircuitMap = zeros(1, trajIndsCount);
            %randomize to get more short circuits quicker
            for i = randperm(trajIndsCount)
            %for i = 253;
                %disp(['y: ',num2str(y), ' i: ', num2str(i)]);
%                 [stopIndex, shortCircuitMap] = RunGradientDescent(i, Pixels{y, x}.GradientMap, Pixels{y, x}.ErrorMap, trajNeighbourIndices, shortCircuitMap);
%                 Pixels{y, x}.StopCountMap(stopIndex) = Pixels{y, x}.StopCountMap(stopIndex) + 1;
                [stopIndex, shortCircuitMap] = RunGradientDescent(i, ColumnPixels{y}.GradientMap, ColumnPixels{y}.ErrorMap, trajNeighbourIndices, shortCircuitMap);
                ColumnPixels{y}.StopCountMap(stopIndex) = ColumnPixels{y}.StopCountMap(stopIndex) + 1;
            end
            
%             Pixels{y, x}.SeedIndex = FindMostLikelyTrajectoryIndex(Pixels{y, x}.StopCountMap, trajStopCountThreshold);
%             if ~isempty(Pixels{y, x}.SeedIndex)
%                 SeedPixels = [SeedPixels Pixels{y, x}];
%             end
            ColumnPixels{y}.SeedIndex = FindMostLikelyTrajectoryIndex(ColumnPixels{y}.StopCountMap, trajStopCountThreshold);
            if ~isempty(ColumnPixels{y}.SeedIndex)
                SeedPixels = [SeedPixels ColumnPixels{y}];
            end
        end
        
        Pixels(:, x) = ColumnPixels;
        xTimeLeft = (pixelsSize(2) - x)*toc(xTime);
        disp(['    X Took: ', datestr(datenum(0,0,0,0,0,toc(xTime)),'HH:MM:SS'), ' - Remaining: ', datestr(datenum(0,0,0,0,0,xTimeLeft),'HH:MM:SS')]);
    end

%     for i = 1:numel(Pixels)
%         if ~isempty(Pixels{i}.SeedIndex)
%             SeedPixels = [SeedPixels Pixels{i}];
%         end
%     end
    
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

