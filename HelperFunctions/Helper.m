classdef Helper
    %HELPER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function outVid = ResizeVideo (inVid, scale)
            dim = ndims(inVid);
            vid_sz = size(inVid);
            
            width = ceil(vid_sz(2)*scale);
            height = ceil(vid_sz(1)*scale);
            
            % 1 frame came in
            if (dim == 2)
                outVid = imresize(inVid, scale);
            elseif (dim == 3)
                outVid = zeros(height, width, vid_sz(end));
                for i=1:vid_sz(end)
                       outVid(:,:,i) = imresize(squeeze(inVid(:,:,i)),scale);
                end
            elseif(dim == 4)
                outVid = zeros(height, width, vid_sz(3), vid_sz(end));
                for i=1:vid_sz(end)
                    outVid(:,:,:,i) = imresize(squeeze(inVid(:,:,:,i)), scale);
                end
            end
        end
        
        function dataOut = ScaleData(dataIn, minVal, maxVal)
            dataOut = dataIn - min(dataIn(:));
            dataOut = (dataOut/range(dataOut(:)))*(maxVal-minVal);
            dataOut = dataOut + minVal;
        end
    end
    
end

