function outImg = ViewZScores_old(obj)
    width = obj.VideoSz(2) - (obj.WindowSize - 1);
    height = obj.VideoSz(1) - (obj.WindowSize - 1);

    outImg = zeros(height, width);

    for i = 1:size(obj.Windows, 2)
        %temp = min(obj.Windows(i).ReshapeCoherence(:));
        %if (temp < 200)
        
            [row, col] = ind2sub([height,width], i);

            mn = mean(obj.Windows(i).ReshapeCoherence(:));
            sd = std(obj.Windows(i).ReshapeCoherence(:));

            minVal = min(obj.Windows(i).ReshapeCoherence(:));

            outImg(row, col) = abs((mn - minVal)/sd);
        %end
    end

    figure;
    imagesc(outImg);
end