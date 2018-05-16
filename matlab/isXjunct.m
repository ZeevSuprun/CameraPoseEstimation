function [ result ] = isXjunct( I, pt, rad )
%Inputs: 
%I: image
%pt: coordinates of points in (row, col) form.
%rad: 1/2 the width of the slider window.
% returns the odds (non-normalized) of it being an Xjunction.

%need to get the sum of the values of the 4 corners around the point within
%the slider window.
pt = flip(pt);

topRow = min(pt(1) + rad, size(I,1));
botRow = max(pt(1) - rad, 1);
rightCol = min(pt(2) + rad, size(I,2));
leftCol = max(pt(2) - rad, 1);

Anw = sum(sum(I(pt(1):topRow, leftCol:pt(2))));
Ane = sum(sum(I(pt(1):topRow, pt(2):rightCol)));
Asw = sum(sum(I(botRow:pt(1), leftCol:pt(2))));
Ase = sum(sum(I(botRow:pt(1), pt(2):rightCol)));

quadrants = sort([Anw, Ane, Asw, Ase]);

M = quadrants(3) + quadrants(4);
n = quadrants(1) + quadrants(2);

%the bigger this number is, the more likely it is to be an Xjunction.
%(if I just return a boolean it'll give me more than 48 points)
result = M/n - 2;

end

