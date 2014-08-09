function [ D ] = CenterSurroundCompare( vid, n)
%CENTERSURROUNDCOMPARE Summary of this function goes here
%   Detailed explanation goes here

[y,x,~] = size(vid);

y_start = floor(y*3/8);
y_end = y - y_start;
x_start = floor(x*3/8);
x_end = x - x_start;

cent_vid = vid(y_start:y_end, x_start:x_end, :);

win1 = WindowDT(vid, n, size(cent_vid, 2));
win2 = WindowDT(cent_vid, n);

win1.CalculateDT();
win2.CalculateDT();

D(1) = win1.KLDivStateSpace(win2);
D(2) = win2.KLDivStateSpace(win1);


end

