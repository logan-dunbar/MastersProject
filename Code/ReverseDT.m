function [ output_args ] = ReverseDT( input_args )
%REVERSEDT Summary of this function goes here
%   Detailed explanation goes here

if (~exist('bird_1_250', 'var'))
    load('bird_1_250.mat');
end

[y, x, t] = size(bird_1_250);

w_time = 25;
w_space = 8;

vid1 = zeros(w_space^2, w_time);
vid2 = zeros(w_space^2, w_time);

for i = 1:(t - 2*w_time) %(1 + w_time):(1 + t - w_time)
    for j = 1:x/w_space
        for k = 1:y/w_space
            
            vid1 = bird_1_250( k:(k + w_space - 1), j:(j + w_space - 1), (i + w_time):(i + 2*w_time - 1));
            vid2 = bird_1_250( k:(k + w_space - 1), j:(j + w_space - 1), i:(i + w_time - 1));
            vid2 = flipdim(vid2, 3);
            
            input.Video = ReshapeVideo(vid1);
        end
    end
end

a = 1;