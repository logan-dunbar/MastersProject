function Window = CreateWindow(winSz)
%CREATETRAJECTORYINDICIES Creates the indices for each trajectory for the
%given window size

Window.PixelIndex = ceil(winSz/2);
Window.TrajInds(winSz(1)*winSz(2), winSz(3)) = 0;

% test = [];
for y = 1:winSz(1)
    for x = 1:winSz(2)
        yStart = y;
        yEnd = winSz(1) - (y-1);
        yStepSize = (yEnd-yStart)/(winSz(3)-1);
        
        xStart = x;
        xEnd = winSz(2) - (x-1);
        xStepSize = (xEnd-xStart)/(winSz(3)-1);
        
        for t = 1:winSz(3)
            yInd = yStart + (t-1)*yStepSize;
            xInd = xStart + (t-1)*xStepSize;
            
%             if yStart == 11 && xStart == 14
%                 test(t,1:2) = [yInd xInd];
%             end
            
            if yInd < Window.PixelIndex(1)
                yInd = ceil(yInd);
            else
                yInd = floor(yInd);
            end
            
            if xInd < Window.PixelIndex(2)
                xInd = ceil(xInd);
            else
                xInd = floor(xInd);
            end
            
            trajInd = sub2ind(winSz(1:2), y, x);
            Window.TrajInds(trajInd, t) = sub2ind(winSz, yInd, xInd, t);
        end
    end
end

end

