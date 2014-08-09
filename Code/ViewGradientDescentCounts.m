function [outErrorImg, outStopCountImg] = ViewGradientDescentCounts(obj)
%VIEWGRADIENTDESCENTCOUNTS Summary of this function goes here
%   Detailed explanation goes here

    width = obj.VideoSz(2) - (obj.WindowSize - 1);
    height = obj.VideoSz(1) - (obj.WindowSize - 1);

    outErrorImg = zeros(height*obj.WindowSize, width*obj.WindowSize);
    outStopCountImg = zeros(height*obj.WindowSize, width*obj.WindowSize);
    
    for j = 1:size(obj.Windows, 2)
        [row, col] = ind2sub([height,width], j);
        y_s = ((row-1) * obj.WindowSize) + 1;
        y_e = y_s + (obj.WindowSize - 1);

        x_s = ((col-1) * obj.WindowSize) + 1;
        x_e = x_s + (obj.WindowSize - 1);
        
        [errorImg, stopCountImg] = ErrorAndStopCount(obj.Windows(j));
        outErrorImg(y_s:y_e,x_s:x_e) = errorImg;
        outStopCountImg(y_s:y_e,x_s:x_e) = stopCountImg;
    end

end

function [errorImg, stopCountImg] = ErrorAndStopCount(window)
    errorImg = zeros(window.WinSz, window.WinSz);
    stopCountImg = zeros(window.WinSz, window.WinSz);
    for y = 1:window.WinSz
        for x = 1:window.WinSz
            errorImg(y, x) = window.Trajectories(y,x).Error;
            stopCountImg(y, x) = window.Trajectories(y,x).StopCount;
        end
    end
end

