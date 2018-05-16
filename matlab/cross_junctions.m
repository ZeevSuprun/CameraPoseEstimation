function [Ipts] = cross_junctions(I, boundPoly, Wpts)
% CROSS_JUNCTIONS Find cross-junctions in image with subpixel accuracy.
%
%   [Ipts] = CROSS_JUNCTION(I, boundPoly, Wpts) locates a series of cross- 
%   junction points on a planar calibration target, where the target is
%   bounded in the image by the specified 4-sided polygon. The number of
%   cross-junctions identified should be equal to the number of world points.
%
%   Note also that the world and image points must be in *correspondence*,
%   that is, the first world point should map to the first image point, etc.
%
%   Inputs:
%   -------
%    I          - Image (grayscale, double or integer class).
%    boundPoly  - 2x4 array defining bounding polygon for target (clockwise).
%                 ordered as [col;row] / [x;y] 
%    Wpts       - 3xn array of world points (in 3D, on calibration target).
%
%   Outputs:
%   --------
%    Ipts  - 2xn array of cross-junctions (x, y), relative to the upper left
%            corner of I.

%Image with only the chessboard in it. Not rotated though.
%Ib = I(min_y:max_y, min_x:max_x,:);
Ib = I;
%size of window used to check for duplicate saddle points.
wndSize = 13;

[corner_rows, corner_cols] = harris_corners(Ib);
detected_corners = [corner_cols, corner_rows];
%size(detected_corners)

%detected_corners is nx2 matrix in the form of [x, y].
%but this gives lots of duplicate corners.
%Removing duplicate corners:
sliderSize = 21;
xJunct = [];
for i = 1:size(detected_corners,1)
    duplicate = false;
    for j = 1:size(xJunct,1)
       if(norm(detected_corners(i,:) - xJunct(j,:)) < wndSize)
           %this detected corner is too close to an earlier detected
           %corner, it is a duplicate.
           duplicate = true;
           break;
       end
    end
    if(~duplicate) && inpolygon(detected_corners(i,1),detected_corners(i,2),boundPoly(1,:),boundPoly(2,:))
        %if it's not a duplicate and it's in the polygon.
        xJunct =[xJunct ; detected_corners(i,:)];
    end  
end

%Use x junction detection as described in the paper to get the best 48
%points.
numCorners = size(xJunct,1);
xJunctProb = zeros(numCorners,1);

for i = 1:numCorners
    xJunctProb(i) = isXjunct(Ib, xJunct(i,:), sliderSize);
end

%xJunct(index(1)) = most likely to be an xJunction.
[~, index] = sort(xJunctProb, 'descend');

best48 = zeros(48, 2);
for i = 1:48
    best48(i,:) = xJunct(index(i),:);
end

xJunct = best48;
%I now have the 48 x-junctions.

saddles = zeros(size(xJunct));
sliderSize = 13;
for i = 1:size(xJunct,1)
    %[row, col] at the center of the subwindow.
    pt = flip(xJunct(i,:));
    topRow = min(pt(1) + sliderSize, size(Ib,1));
    botRow = max(pt(1) - sliderSize, 1);
    rightCol = min(pt(2) + sliderSize, size(Ib,2));
    leftCol = max(pt(2) - sliderSize, 1);
    
    subWindow = I(botRow:topRow, leftCol:rightCol);
    sp_sub = saddle_point(subWindow);
    %need to store the saddle point in image coords instead of subwindow
    %coords.
    %Note that saddles needs to be in (x,y) form
    if(~isnan(sp_sub))    
        saddles(i,:) = [leftCol + sp_sub(1), botRow + sp_sub(2)];
    end
    
end


%Ipts is 2xN
Ipts_temp = saddles';
Ipts = zeros(size(Ipts_temp));

%rearrange Ipts into row major order:
%getting the 4 corners in homogenous form.
p1 = [boundPoly(:,1); 1];
p2 = [boundPoly(:,2); 1];
p3 = [boundPoly(:,3); 1];
p4 = [boundPoly(:,4); 1];
%points are ordered as [x;y;1] 

%find the 4 bounding lines:

%in homogenous form, line between p1 and p2 = p1xp2.
topLine = cross(p1, p2);
%normalize.
topLine = topLine/norm(topLine(1:2));
%same thing to get the bottom, left and right lines.
botLine = cross(p3, p4);
botLine = botLine/norm(botLine(1:2));

leftLine = cross(p4, p1);
leftLine = leftLine/norm(leftLine(1:2));
rightLine = cross(p2, p3);
rightLine = rightLine/norm(rightLine(1:2));

%get the distance to each bounding line of each point in the form of a
%vertical and horizontal distance ratio.

%add an extra 2 rows to Ipts
extended_pts = [Ipts_temp; zeros(2,size(Ipts_temp,2))];

for i = 1:size(Ipts_temp,2)
   pt = [extended_pts(1:2, i); 1];
   topDist = dot(topLine, pt);
   botDist = dot(botLine, pt);
   %in the third row is the vertical distance ratio.
   extended_pts(3,i) = topDist/(topDist + botDist);
   leftDist = dot(leftLine, pt);
   rightDist = dot(rightLine, pt);
   %in the 4th row is the horizontal distance ratio.
   extended_pts(4,i) = leftDist/(rightDist + leftDist);
   
end

%sort by vertical distance first.
%need to transpose inputs and results to sort the columns.
extended_pts = sortrows(extended_pts',3)';


% sort each set of 8 points by distance from the left line
sortedPts = zeros(2, size(extended_pts,2));
for i = 1:8:size(extended_pts,2)
    sortedCols = sortrows(extended_pts(:, i:i+7)',4)';
    sortedPts(:,i:i+7) = sortedCols(1:2,:);
end

Ipts = sortedPts;


%imshow(Ib);
%hold on
%scatter(xJunct(:,1), xJunct(:,2), 'ro');
%scatter(saddles(:,1), saddles(:,2), 'r*');
%%plot the points with a line through them to make sure they are the
%%correct order.
%plot(Ipts(1,1:8), Ipts(2,1:8), 'yo-')


end
