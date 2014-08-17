function [objects] = FindObjects(video, windowSize)
%FindObjects Computes temporally coherent objects from a given video and
%windowSize

objects = [];
video = double(video);

if (any(~mod(windowSize,2)))
    disp('Even dimension for window is not allowed');
    return;
end

traj = TrajectoryWindow(windowSize);
vidSz = size(video);

halfWin = floor(windowSize/2);
trajIndexLength = windowSize(1)*windowSize(2);

pixelMapSize = vidSz - (2*halfWin);
pixelMap(pixelMapSize(1), pixelMapSize(2), pixelMapSize(3)) = Pixel();

% Column-wise
% Pixel map column size
M = pixelMapSize(1);
neighbours = [(-M-1), -M, (-M+1), -1, 1, (M-1), M, (M+1)];

% Window column size
N = windowSize(1);
windowNeighbours = [(-N-1), -N, (-N+1), -1, 1, (N-1), N, (N+1)];
                
% Loop time
totTime = int2str(pixelMapSize(3));
totX = int2str(pixelMapSize(2));
index = 0;
for t = (1+halfWin(3)):(vidSz(3)-halfWin(3))
    disp(horzcat('At Time: ', int2str(t-halfWin(3)), ' of ', totTime));
    timeT = cputime;
    
    % Loop x
    for x = (1+halfWin(2)):(vidSz(2)-halfWin(2))
        disp(horzcat('At X: ', int2str(x-halfWin(2)), ' of ', totX));
        timeX = cputime;
        
        % Loop y
        for y = (1+halfWin(1)):(vidSz(1)-halfWin(1))
            index = index + 1;
            vidCube = video((y-halfWin(1)):(y+halfWin(1)), (x-halfWin(2)):(x+halfWin(2)), (t-halfWin(3)):(t+halfWin(3)));
            pixel = Pixel(windowSize(1:2));
            
            for i = 1:trajIndexLength
                trajVals = vidCube(traj.Indices(i,:));
                pixelVal = vidCube(traj.PixelIndex);
                
                % To allow log(ErrorMap) (1 +)
                pixel.ErrorMap(i) = 1 + sum(bsxfun(@power, bsxfun(@minus, trajVals, pixelVal), 2));
            end
            
            for i = 1:trajIndexLength
                refError = pixel.ErrorMap(i);
                neighbourErrors = repmat(refError, 1, 8);
                
                % refer code/{TempCoherWindow:ComputeGradients, MyObject:ComputeMask}
                % changed grads to be column-wise to keep consistent with matlab
                if (i <= N) % Left
                    if (mod(i, N) == 1) % Top
                        neighbourErrors(5) = pixel.ErrorMap(i+windowNeighbours(5));
                        neighbourErrors(7) = pixel.ErrorMap(i+windowNeighbours(7));
                        neighbourErrors(8) = pixel.ErrorMap(i+windowNeighbours(8));
                    elseif (mod(i, N) == 0) % Bottom
                        neighbourErrors(4) = pixel.ErrorMap(i+windowNeighbours(4));
                        neighbourErrors(6) = pixel.ErrorMap(i+windowNeighbours(6));
                        neighbourErrors(7) = pixel.ErrorMap(i+windowNeighbours(7));
                    else % Middle
                        neighbourErrors(4) = pixel.ErrorMap(i+windowNeighbours(4));
                        neighbourErrors(5) = pixel.ErrorMap(i+windowNeighbours(5));
                        neighbourErrors(6) = pixel.ErrorMap(i+windowNeighbours(6));
                        neighbourErrors(7) = pixel.ErrorMap(i+windowNeighbours(7));
                        neighbourErrors(8) = pixel.ErrorMap(i+windowNeighbours(8));
                    end
                elseif (i > trajIndexLength - N) % Right
                    if (mod(i, N) == 1) % Top
                        neighbourErrors(2) = pixel.ErrorMap(i+windowNeighbours(2));
                        neighbourErrors(3) = pixel.ErrorMap(i+windowNeighbours(3));
                        neighbourErrors(5) = pixel.ErrorMap(i+windowNeighbours(5));
                    elseif (mod(i, N) == 0) % Bottom
                        neighbourErrors(1) = pixel.ErrorMap(i+windowNeighbours(1));
                        neighbourErrors(2) = pixel.ErrorMap(i+windowNeighbours(2));
                        neighbourErrors(4) = pixel.ErrorMap(i+windowNeighbours(4));
                    else % Middle
                        neighbourErrors(1) = pixel.ErrorMap(i+windowNeighbours(1));
                        neighbourErrors(2) = pixel.ErrorMap(i+windowNeighbours(2));
                        neighbourErrors(3) = pixel.ErrorMap(i+windowNeighbours(3));
                        neighbourErrors(4) = pixel.ErrorMap(i+windowNeighbours(4));
                        neighbourErrors(5) = pixel.ErrorMap(i+windowNeighbours(5));
                    end
                else % Middle
                    if (mod(i, N) == 1) % Top
                        neighbourErrors(2) = pixel.ErrorMap(i+windowNeighbours(2));
                        neighbourErrors(3) = pixel.ErrorMap(i+windowNeighbours(3));
                        neighbourErrors(5) = pixel.ErrorMap(i+windowNeighbours(5));
                        neighbourErrors(7) = pixel.ErrorMap(i+windowNeighbours(7));
                        neighbourErrors(8) = pixel.ErrorMap(i+windowNeighbours(8));
                    elseif (mod(i, N) == 0) % Bottom
                        neighbourErrors(1) = pixel.ErrorMap(i+windowNeighbours(1));
                        neighbourErrors(2) = pixel.ErrorMap(i+windowNeighbours(2));
                        neighbourErrors(4) = pixel.ErrorMap(i+windowNeighbours(4));
                        neighbourErrors(6) = pixel.ErrorMap(i+windowNeighbours(6));
                        neighbourErrors(7) = pixel.ErrorMap(i+windowNeighbours(7));
                    else % Middle
                        neighbourErrors(1) = pixel.ErrorMap(i+windowNeighbours(1));
                        neighbourErrors(2) = pixel.ErrorMap(i+windowNeighbours(2));
                        neighbourErrors(3) = pixel.ErrorMap(i+windowNeighbours(3));
                        neighbourErrors(4) = pixel.ErrorMap(i+windowNeighbours(4));
                        neighbourErrors(5) = pixel.ErrorMap(i+windowNeighbours(5));
                        neighbourErrors(6) = pixel.ErrorMap(i+windowNeighbours(6));
                        neighbourErrors(7) = pixel.ErrorMap(i+windowNeighbours(7));
                        neighbourErrors(8) = pixel.ErrorMap(i+windowNeighbours(8));
                    end
                end
                
                pixel.GradientMap(i).GradArray = bsxfun(@minus, neighbourErrors, refError);
            end
            
            for i = 1:trajIndexLength
                stopIndices = i;
                activeTrajInds = i;
                activeCheckedTrajInds = i;
                
                while ~isempty(activeTrajInds)
                    loop_active_traj = activeTrajInds;
                    for ind = loop_active_traj;
                        activeTrajInds(activeTrajInds == ind) = [];
                        
                        minGrad = min(pixel.GradientMap(ind).GradArray);
                        minGradInds = pixel.GradientMap(ind).GradArray == minGrad;
                        
                        if (minGrad >= 0)
                            stopIndices = [stopIndices ind];
                            %pixel.StopCountMap(ind) = pixel.StopCountMap(ind) + 1;
                        else
                            %C = setdiff(A,B) returns the data in A that is not in B.
                            newInds = bsxfun(@plus, ind, windowNeighbours(minGradInds));
                            activeTrajInds = [activeTrajInds setdiff(newInds, activeCheckedTrajInds)];
                            activeCheckedTrajInds = [activeCheckedTrajInds activeTrajInds];
                        end
                    end
                end
                
                minError = pixel.ErrorMap(stopIndices(1));
                minTrajectoryErrorInd = 1;
                for j = 2:size(stopIndices, 2)
                    if (pixel.ErrorMap(stopIndices(j)) < minError)
                        minError = pixel.ErrorMap(stopIndices(j));
                        minTrajectoryErrorInd = j;
                    end
                end
                
                %pixel.MostLikelyTrajectory = trajectoryErrors(minTrajectoryErrorInd);
                stopIndex = stopIndices(minTrajectoryErrorInd);
                pixel.StopCountMap(stopIndex) =  pixel.StopCountMap(stopIndex) + 1;
            end
            
            maxStopCount = 0;
            maxStopCountIndex = 0;
            for i = 1:trajIndexLength
                if (pixel.StopCountMap(i) > maxStopCount)
                    maxStopCount = pixel.StopCountMap(i);
                    maxStopCountIndex = i;
                end
            end
            
            pixel.MostLikelyTrajectoryIndex = maxStopCountIndex;
            pixelMap(index) = pixel;
        end % y
        
        disp(horzcat('1 loop X: ', num2str(cputime - timeX, '%0.2f'), 's'));
    end % x
    
    % Will want to tweak this/come up with a better way
%     thresholdCount = trajIndexLength * 0.9;
%     seeds = [];
%     for i = (t-halfWin(3)-1)*pixelMapSize(1)*pixelMapSize(2) + 1:(t-halfWin(3))*pixelMapSize(1)*pixelMapSize(2)
%         if (pixelMap(i).StopCountMap((pixelMap(i).MostLikelyTrajectoryIndex)) > thresholdCount)
%             seeds = [seeds i];
%         end
%     end
    
    disp(horzcat('1 loop of T: ', num2str(cputime - timeT, '%0.2f'), 's'));
end % t

objects = pixelMap;
end

