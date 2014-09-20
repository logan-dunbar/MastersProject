if ~exist('bird_1_250', 'var')
    load('C:\Users\Logan Dunbar\Documents\MATLAB\MastersProject\VideoObjects\bird_1_250.mat');
    %load('C:\Users\Logan Dunbar\Documents\MATLAB\MastersProject\VideoObjects\bird_1_250_small.mat');
end

winSz = [21 21 21];

%video = bird_1_250_small(1:10,1:10,1:10);

%%%%%%%%%%%%%%%%%%%%
video = bird_1_250(180:280,415:700,11:31);
video = double(video);
tic
objs1 = FindStructuredObjects(video, winSz);
toc

% if ~exist('traffic', 'var')
%     load('C:\Users\Logan Dunbar\Documents\MATLAB\MastersProject\VideoObjects\traffic.mat');
% end
% 
% winSz = [21 21 21];
% 
% %%%%%%%%%%%%%%%%%%%%
% video = traffic(:,:,230:250);
% video = double(video);
% tic
% objs1 = FindStructuredObjects(video, winSz);
% toc

%%%%%%%%%%%%%%%%%%%%
% video = bird_1_250(140:280,315:700,31:80);
% tic
% objs2 = FindStructuredObjects(video, winSz);
% toc

% Window = CreateWindow(winSz);
% trajColSz = winSz(1);
% trajNeighbourIndices = [-trajColSz-1, -trajColSz, -trajColSz+1, -1, +1, trajColSz-1, trajColSz, trajColSz+1];

%windowVideo = video(40:60,139:159,1:21); %boat mid
%windowVideo = video(38:58,135:155,1:21); %boat tip
% windowVideo = video(68:88,135:155,1:21); %sea
% trajIndsCount = winSz(1)*winSz(2);
% for i = 1:trajIndsCount
%     trajPixelVals = windowVideo(Window.TrajInds(i,:));
%     pixelVal = windowVideo(11,11,11);
%     Pixel.ErrorMap(i) = ComputeError(pixelVal, trajPixelVals);
% end
% 
% for i = 1:trajIndsCount
%     pixelError = Pixel.ErrorMap(i);
%     neighbourPixelErrors = GetNeighbourPixelErrors(i, Pixel.ErrorMap, trajColSz, trajNeighbourIndices, trajIndsCount);
%     Pixel.GradientMap{i} = ComputeGradients(pixelError, neighbourPixelErrors);
% end
% 
% shortCircuitMap = zeros(1, trajIndsCount);
% Pixel.StopCountMap = zeros(1, trajIndsCount);
% %randomize to get more short circuits quicker
% for i = randperm(trajIndsCount)
%     [stopIndex, shortCircuitMap] = RunGradientDescent(i, Pixel.GradientMap, Pixel.ErrorMap, trajNeighbourIndices, shortCircuitMap);
%     Pixel.StopCountMap(stopIndex) = Pixel.StopCountMap(stopIndex) + 1;
% end

% %windowVideo = video(40:60,136:156,1:21); %boat mid
% windowVideo = video(38:58,131:151,1:21); %boat tip
% %windowVideo = video(68:88,135:155,1:21); %sea
% trajIndsCount = winSz(1)*winSz(2);
% for i = 1:trajIndsCount
%     trajPixelVals = windowVideo(Window.TrajInds(i,:));
%     pixelVal = windowVideo(11,11,11);
%     Pixel.ErrorMap(i) = ComputeError(pixelVal, trajPixelVals);
% end
% 
% for i = 1:trajIndsCount
%     pixelError = Pixel.ErrorMap(i);
%     neighbourPixelErrors = GetNeighbourPixelErrors(i, Pixel.ErrorMap, trajColSz, trajNeighbourIndices, trajIndsCount);
%     Pixel.GradientMap{i} = ComputeGradients(pixelError, neighbourPixelErrors);
% end
% 
% shortCircuitMap = zeros(1, trajIndsCount);
% Pixel.StopCountMap = zeros(1, trajIndsCount);
% %randomize to get more short circuits quicker
% for i = randperm(trajIndsCount)
%     [stopIndex, shortCircuitMap] = RunGradientDescent(i, Pixel.GradientMap, Pixel.ErrorMap, trajNeighbourIndices, shortCircuitMap);
%     Pixel.StopCountMap(stopIndex) = Pixel.StopCountMap(stopIndex) + 1;
% end