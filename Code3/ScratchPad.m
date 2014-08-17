if ~exist('bird_1_250_small', 'var')
    load('C:\Users\Logan Dunbar\Documents\MATLAB\MastersProject\VideoObjects\bird_1_250_small.mat');
end

video = bird_1_250_small(1:25,1:25,1:25);
winSz = [5 5 5];

%%%%%%%%%%%%%%%%%%%%
tic
objs = FindStructuredObjects(video, winSz);
toc