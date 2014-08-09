function [vidOut] = ReshapeVideo(vidIn)
%RESHAPEVIDEO Summary of this function goes here
%   Detailed explanation goes here

    [m,n,t] = size(vidIn);
    vidOut = reshape(vidIn, m * n, t);

end