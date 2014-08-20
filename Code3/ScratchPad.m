if ~exist('bird_1_250_small', 'var')
    load('C:\Users\Logan Dunbar\Documents\MATLAB\MastersProject\VideoObjects\bird_1_250_small.mat');
end

video = bird_1_250_small(:,:,1:100);
%video = bird_1_250_small(1:10,1:10,1:10);
winSz = [11 11 11];

%%%%%%%%%%%%%%%%%%%%
tic
objs = FindStructuredObjects(video, winSz);
toc