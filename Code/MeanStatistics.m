% load video
load('bird_1_250.mat');

% rename video
vid = bird_1_250;
clearvars bird_1_250;

t_win = 30;

[y, x, tau] = size(vid);

% v1 = vid(1:150,1:150,:);
% v2 = vid(351:500,1:150,:);

% for i=1:t-tau
%    v1mean(:,:,i) = mean(v1(:,:,i:i+tau), 3);
%    v2mean(:,:,i) = mean(v2(:,:,i:i+tau), 3);
% end
for t=1:tau-t_win
    for i=200:400
        for j=200:800
            patch = vid(i-1:i+1,j-1:j+1,t:t+t_win);
            tot = 0;
            for k=1:3
                for l=1:3
                    if(~(k == 2 && l == 2))
                        tot = tot + sum((squeeze(patch(2,2,:)) - squeeze(patch(k,l,:))).^2);
                    end
                end
            end
            mse_30(i,j,t) = tot;
        end
    end
end