function [ c_mask ] = imcircle2(w,h,cx,cy,r)
%IMCIRCLE2 Summary of this function goes here
%   Detailed explanation goes here

[x,y]=meshgrid(-(cx-1):(w-cx),-(cy-1):(h-cy));

c_mask = ((x.^2+y.^2)<=r^2);

end

