function [pt] = saddle_point(I)
% SADDLE_POINT Locate saddle point in an image patch.
%
%   [pt] = SADDLE_POINT(I) finds the subpixel center of a cross-junction in the 
%   image patch I, by blurring the patch, fitting a hyperbolic paraboloid to 
%   it, and then finding the critical point of that paraboloid.
%
%   Note that the location of 'p' is relative to (0.5, 0.5) at the upper left 
%   corner of the patch, i.e., the pixels are treated as covering an area of
%   one unit square.
%
%   Inputs:
%   -------
%    I  - mxn image patch (grayscale, double or integer class).
%
%   Outputs:
%   --------
%    pt  - 2x1 subpixel location of saddle point in I (x, y coords).
%
% References:
%
%   L. Lucchese and S. K. Mitra, "Using Saddle Points for Subpixel Feature
%   Detection in Camera Calibration Targets," in Proc. Asia-Pacific Conf.
%   Circuits and Systems (APCCAS'02), vol. 2, (Singapore), pp. 191-195,
%   Dec. 2002.

m = size(I,1); % # of rows
n = size(I,2); % # of cols

%Apply gaussian blur to image fragment.
sigma = 1.5;
wndSize = 3;
Ib = gaussian_blur(I, wndSize,sigma);

%Generating X matrix.
% [y1, x1] = meshgrid(1:m, 1:n);
% x1 = reshape(x1, m*n, 1);
% y1 = reshape(y1, m*n, 1);
% X1 = [x1.^2, x1.*y1, y1.^2, x1, y1, ones(size(x1))];

%Generating X matrix.
i = 1;
X = zeros(m*n, 6);
realval = zeros(m*n,1);
for y = 1:m
    for x = 1:n
        X(i,:) = [x^2, x*y, y^2, x, y, 1];
        realval(i) = Ib(y, x);
        i = i + 1;
    end
end

%each row of X is a "training example". (a combination of X and Y)

%use the normal equation to get the thetas that minimize Err
theta = pinv(X'*X)*X'*realval;
%theta = pinv(X)*realval;
%theta = [a b c d e f]

%find critical point of that paraboloid.
A =[2*theta(1), theta(2); theta(2), 2*theta(3)];
b = [theta(4); theta(5)];
pt = -A\b;


end









