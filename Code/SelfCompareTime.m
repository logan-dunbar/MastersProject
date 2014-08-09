function [ D ] = SelfCompareTime( vid, winSz )
%SELFCOMPARETIME Summary of this function goes here
%   Detailed explanation goes here

for i = 2:size(vid, 3) - winSz + 1
    win1 = WindowDT(vid(:,:,i:i+winSz - 1), 7);
    win2 = WindowDT(vid(:,:,i-1:i-1+winSz - 1), 7);
    win1.CalculateDT();
    win2.CalculateDT();
    D(i-1) = (win1.KLDivStateSpace(win2) + win2.KLDivStateSpace(win1))*0.5;
end

end

