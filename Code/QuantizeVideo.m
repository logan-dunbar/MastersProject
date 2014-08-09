function [ newVideo ] = QuantizeVideo( video, numPoints )
%QUANTIZEVIDEO Summary of this function goes here
%   Detailed explanation goes here
vidSz = size(video);
video = video(:);

i = 0;
count = 1;
step = 255 / numPoints;
while (i < 255)
    start = i;
    stop = i + step;
    endInclusive = 0;
    if (stop == 255)
        endInclusive = 1;
    end
    
    ranges(count) = QuantRange(start, stop, endInclusive);
    
    i = i + step;
    count = count + 1;
end

newVideo = zeros(size(video));
for j=1:size(video,1)
    for k=1:size(ranges,2)
       range = ranges(k); 
       if (range.IsInRange(video(j)))
           newVideo(j) = range.MidPoint;
           break;
       end
    end
end

newVideo = reshape(newVideo, vidSz);
end

