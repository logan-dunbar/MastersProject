function [ D ] = SelfEvolvedCompare( vid, winSz )
%SELFEVOLVEDCOMPARE Summary of this function goes here
%   Detailed explanation goes here

win1 = WindowDT(vid(:,:,1:winSz), 7);
win1.CalculateDT();
for i = 1:size(vid, 3) - winSz + 1
    win2 = WindowDT(vid(:,:,i:i+winSz-1), 7);
    win2.CalculateDT();
    D(i) = (win1.KLDivStateSpace(win2) + win2.KLDivStateSpace(win1))*0.5;
end

end

