function [ D ] = TimeLaggedComparison(vidName)
%TIMELAGGEDCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

    load(strcat('C:\Users\Logan Dunbar\Documents\MATLAB\MastersProject\VideoObjects\', vidName, '.mat'));

    vid = eval(vidName);
    clearvars eval(vidName);

    %sz_x,sz_y,sz_t,steps,n,tau
    params = ExpParams(10,10,50,5,10,50);

    [vid_y,vid_x,vid_t] = size(vid);
    
    x_steps = (floor(vid_x/params.WinSz_x) - 2);
    y_steps = floor(vid_y/params.WinSz_y) - 2;
    
    %for t = 1:params.tau
        %for y = 1:y_steps
           for x = 1:x_steps
               dt1 = WindowDT(vid(1:10, x*params.WinSz_x + 1:(x+1)*(params.WinSz_x), 1:50), params.N);
               dt2 = WindowDT(vid(1:10, x*params.WinSz_x + 1-5:(x+1)*(params.WinSz_x)-5, 1:50), params.N);
               dt1.CalculateDT();
               dt2.CalculateDT();
               D(x,1,1) = dt1.KLDivStateSpace(dt2);
               D(x,1,2) = dt2.KLDivStateSpace(dt1);
           end
        %end
    %end
end

