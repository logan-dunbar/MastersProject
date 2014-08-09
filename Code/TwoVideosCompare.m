function [ D ] = TwoVideosCompare( vid1, vid2, winSz )
%TWOVIDEOSCOMPARE Summary of this function goes here
%   Detailed explanation goes here

for i = 1:size(vid1, 3) - winSz + 1
    win1 = WindowDT(vid1(:,:,i:i+winSz-1), 7);
    win2 = WindowDT(vid2(:,:,i:i+winSz-1), 7);
    win1.CalculateDT();
    win2.CalculateDT();
    D(i) = (win1.KLDivStateSpace(win2) + win2.KLDivStateSpace(win1))*0.5;
end

end

