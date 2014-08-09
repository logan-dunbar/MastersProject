function outImg = CollateTempCoherWindows(obj, winSz)
    vidSz = size(obj.Video);
    
    width = vidSz(2) - (obj.WindowSize - 1);
    height = vidSz(1) - (obj.WindowSize - 1);
    
    outImg = zeros(width*obj.WindowSize, height*obj.WindowSize);
    for w = 1:width
        for h = 1:height
            index = sub2ind([width,height], h, w);
            
            innerImg = log(obj.Windows(index).ReshapeCoherence);
            
            %will change to use winSz
            if (w > 1 && w < width && h > 1 && h < width)
                ind1_1 = sub2ind([width,height], h-1, w-1);
                ind1_2 = sub2ind([width,height], h-1, w);
                ind1_3 = sub2ind([width,height], h-1, w+1);
                ind2_1 = sub2ind([width,height], h, w-1);
                %ind2_2 which is same as starting point
                ind2_3 = sub2ind([width,height], h, w+1);
                ind3_1 = sub2ind([width,height], h+1, w-1);
                ind3_2 = sub2ind([width,height], h+1, w);
                ind3_3 = sub2ind([width,height], h+1, w+1);
                
                innerImg = innerImg .* log(obj.Windows(ind1_1).ReshapeCoherence);
                innerImg = innerImg .* log(obj.Windows(ind1_2).ReshapeCoherence);
                innerImg = innerImg .* log(obj.Windows(ind1_3).ReshapeCoherence);
                innerImg = innerImg .* log(obj.Windows(ind2_1).ReshapeCoherence);
                innerImg = innerImg .* log(obj.Windows(ind2_3).ReshapeCoherence);
                innerImg = innerImg .* log(obj.Windows(ind3_1).ReshapeCoherence);
                innerImg = innerImg .* log(obj.Windows(ind3_2).ReshapeCoherence);
                innerImg = innerImg .* log(obj.Windows(ind3_3).ReshapeCoherence);
            end
            
            y_s = ((h-1) * obj.WindowSize) + 1;
            y_e = y_s + (obj.WindowSize - 1);

            x_s = ((w-1) * obj.WindowSize) + 1;
            x_e = x_s + (obj.WindowSize - 1);

            outImg(y_s:y_e,x_s:x_e) = innerImg;
            %outImg(y_s:y_e,x_s:x_e) = log(innerImg);
        end
    end
end