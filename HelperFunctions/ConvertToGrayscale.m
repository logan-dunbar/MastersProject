function [ grayVideo ] = ConvertToGrayscale( obj, video )
%CONVERTTOGRAYSCALE Summary of this function goes here
%   Detailed explanation goes here
    videoFormat = get(obj, 'VideoFormat');
    if(strcmp(videoFormat,'RGB24'))
        vidSize = size(video);
        grayVideo = zeros(vidSize(1),vidSize(2), vidSize(4), 'uint8');
        for i = 1:vidSize(4)
            grayVideo(:,:,i) = rgb2gray(video(:,:,:,i));
        end 
    end

end