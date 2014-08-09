function outImg = ViewTempCoherWindows_old(obj)
    width = obj.VideoSz(2) - (obj.WindowSize - 1);
    height = obj.VideoSz(1) - (obj.WindowSize - 1);

    outImg = zeros(height*obj.WindowSize, width*obj.WindowSize);
    for j = 1:size(obj.Windows, 2)
        [row, col] = ind2sub([height,width], j);
        y_s = ((row-1) * obj.WindowSize) + 1;
        y_e = y_s + (obj.WindowSize - 1);

        x_s = ((col-1) * obj.WindowSize) + 1;
        x_e = x_s + (obj.WindowSize - 1);
        outImg(y_s:y_e,x_s:x_e) = log(obj.Windows(j).ReshapeCoherence);
    end

    figure;
    imagesc(outImg);
end
