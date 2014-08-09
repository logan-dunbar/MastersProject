% load video
load('bird_1_250.mat');

% rename video
vid = bird_1_250;
clearvars bird_1_250;

win = 20;
overlap = 10;

[y, x, t] = size(vid);

% calculate x & y steps
ysteps = floor(y/(win-overlap))-1;
xsteps = floor(x/(win-overlap))-1;

% create Tukey window to mitigate spectral leakage
w = window2(win,win,@tukeywin);

% loop over y
for j = 0:ysteps - 2

    % loop over x
    for i = 0:xsteps - 2
        
        % calculate start and end points of video
        v1_sx = (i*(win-overlap))+1;
        v1_ex = v1_sx+win-1;
        
        v1_sy = (j*(win-overlap))+1;
        v1_ey = v1_sy+win-1;
        
        v2_sx = ((i+1)*(win-overlap))+1;
        v2_ex = v2_sx+win-1;
        
        v2_sy = (j*(win-overlap))+1;
        v2_ey = v2_sy+win-1;
        
        % get windows
        v1 = vid(v1_sy:v1_ey,v1_sx:v1_ex,1:win);
        v2 = vid(v2_sy:v2_ey,v2_sx:v2_ex,1:win);
        
        % calculate mean in x-direction
        v1mx = squeeze(mean(v1,2));
        v2mx = squeeze(mean(v2,2));

        % remove mean and window
        v1mx = (v1mx - mean(mean(v1mx))*ones(win,win)).*w;
        v2mx = (v2mx - mean(mean(v2mx))*ones(win,win)).*w;

        % fft2 the videos
        v1mxfft = fft2(v1mx);
        v2mxfft = fft2(v2mx);

        % MSE of the spectrums along x-direction
        D(j+1,i+1) = sum(sum((abs(v1mxfft) - abs(v2mxfft)).^2));
    end
end

% results x-direction
figure;imagesc(D);

% loop over x
for i = 0:xsteps - 2

    % loop over y
    for j = 0:ysteps - 2
        
        % calculate start and end points of video
        v1_sx = (i*(win-overlap))+1;
        v1_ex = v1_sx+win-1;
        
        v1_sy = (j*(win-overlap))+1;
        v1_ey = v1_sy+win-1;
        
        v2_sx = (i*(win-overlap))+1;
        v2_ex = v2_sx+win-1;
        
        v2_sy = ((j+1)*(win-overlap))+1;
        v2_ey = v2_sy+win-1;
        
        % get windows
        v1 = vid(v1_sy:v1_ey,v1_sx:v1_ex,1:win);
        v2 = vid(v2_sy:v2_ey,v2_sx:v2_ex,1:win);
        
        % calculate mean in y-direction
        v1mx = squeeze(mean(v1,1));
        v2mx = squeeze(mean(v2,1));

        % remove mean and window
        v1mx = (v1mx - mean(mean(v1mx))*ones(win,win)).*w;
        v2mx = (v2mx - mean(mean(v2mx))*ones(win,win)).*w;

        % fft2 the videos
        v1mxfft = fft2(v1mx);
        v2mxfft = fft2(v2mx);

        % MSE of the spectrums along x-direction
        E(j+1,i+1) = sum(sum((abs(v1mxfft) - abs(v2mxfft)).^2));
    end
end

% results y-direction
figure;imagesc(E);

Dnorm = (D - min(min(D)))/(max(max(D)) - min(min(D)));
Enorm = (E - min(min(E)))/(max(max(E)) - min(min(E)));

F = Dnorm.*Enorm;
figure;imagesc(F);
clearvars -except D E F;