% load video
load('bird_1_250.mat');

% rename video
vid = bird_1_250;
clearvars bird_1_250;

tau = 30;

[y, x, t] = size(vid);

len = floor(tau/2);

% v1 = vid(1:150,1:150,:);
% v2 = vid(351:500,1:150,:);

% for i=1:t-tau
%    v1mean(:,:,i) = mean(v1(:,:,i:i+tau), 3);
%    v2mean(:,:,i) = mean(v2(:,:,i:i+tau), 3);
% end

% for t=1:tau-t_win
%     for i=2:y-1
%         for j=2:x-1
%             patch = vid(i-1:i+1,j-1:j+1,:);
%             centerfft = fft(squeeze(patch(2,2,:)));
%             tot = 0;
%             for k=1:3
%                 for l=1:3
%                     if(~(k == 2 && l == 2))
%                         currentfft = fft(squeeze(patch(k,l,:)));
%                         tot = tot + sum((abs(centerfft(1:len)) - abs(currentfft(1:len))).^2);
%                     end
%                 end
%             end
%             mse_30(i,j) = tot/8;
%         end
%     end
% end

sea = [301 151];
land = [143 117];

firstlandpix = smooth(double(squeeze(vid(land(1),land(2),1:1+tau))));
firstlandpixfft = fft(firstlandpix);

firstseapix = smooth(double(squeeze(vid(sea(1),sea(2),1:1+tau))));
firstseapixfft = fft(firstseapix);
for k=2:t-tau
    pixland = smooth(double(squeeze(vid(land(1),land(2),k:k+tau))));
    pixlandfft = fft(pixland);
    pixcmpland(k-1) = sum((abs(firstlandpixfft(1:len)) - abs(pixlandfft(1:len))).^2);
    
    pixsea = smooth(double(squeeze(vid(sea(1),sea(2),k:k+tau))));
    pixseafft = fft(pixsea);
    pixcmpsea(k-1) = sum((abs(firstseapix(1:len)) - abs(pixseafft(1:len))).^2);
end