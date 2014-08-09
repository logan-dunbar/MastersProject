% this script creates 4 demo videos:
% [demo_sq] is a white square on a black background moving from top left to bottom right
% [demo_crc] is a white circle on a black background moving from top left to bottom right
% [demo_sq_still] is a white square on a black background stationary in the middle
% [demo_crc_still] is a white circle on a black background stationary in the middle

demo_width = 200;
demo_height = 200;
demo_time = 250;

% odd for the circle
block_width = 51;
block_height = 51;

demo_sq = uint8(zeros(demo_width, demo_height, demo_time));
demo_crc = uint8(zeros(demo_width, demo_height, demo_time));
demo_sq_still = uint8(zeros(demo_width, demo_height, demo_time));
demo_crc_still = uint8(zeros(demo_width, demo_height, demo_time));

square = ones(block_width, block_height).*255;
mid = ceil(block_width/2);
radius = floor(block_width/2);
circle_mask = imcircle2(block_width, block_width, mid, mid, radius);
circle = square .* circle_mask;

for i=1:demo_time
    %x and y start and end points
    x_s = i;
    x_e = i + (block_width - 1);
    y_s = i;
    y_e = i + (block_height - 1);
    
    % x and y end points of the block/circle
    x_e_b = block_width;
    y_e_b = block_height;
    
    % we are out of the frame
    if (x_s > demo_width || y_s > demo_height)
        break;
    end
    
    % a portion out of the frame
    if (x_e > demo_width)
        x_e = demo_width;
        x_e_b = (demo_width + 1) - x_s;
    end
    
    if (y_e > demo_height)
        y_e = demo_height;
        y_e_b = (demo_height + 1) - y_s;
    end
    
    demo_sq(y_s:y_e, x_s:x_e, i) = square(1:y_e_b,1:x_e_b);
    demo_crc(y_s:y_e, x_s:x_e, i) = circle(1:y_e_b,1:x_e_b);
end

% x and y start for the block in the still demo
still_s_x = floor((demo_width - block_width)/2);
still_s_y = floor((demo_height - block_height)/2);

demo_sq_still(still_s_x+1:still_s_x+block_width, still_s_y+1:still_s_y+block_height,:) = repmat(square, [1 1 demo_time]);
demo_crc_still(still_s_x+1:still_s_x+block_width, still_s_y+1:still_s_y+block_height,:) = repmat(circle, [1 1 demo_time]);


clearvars demo_width demo_height demo_time block_width block_height x_s x_e y_s y_e i circle circle_mask mid radius square still_s_x still_s_y x_e_b y_e_b;