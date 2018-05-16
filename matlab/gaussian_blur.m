function [Ib] = gaussian_blur(I, wndSize, sigma)
% GAUSSIAN_BLUR Smooth image with symmetric Gaussian filter.
%
%   [Ib] = GAUSSIAN_BLUR(I, wndSize, sigma) produces a filtered image Ib 
%   from I using a square Gaussian kernel with window size wndSize.
%
%   Inputs:
%   -------
%    I        - mxn intensity image.
%    wndSize  - Kernel window size (square, odd number of pixels).
%    sigma    - Standard deviation of Gaussian (pixels, symmetric).
%
%   Outputs:
%   --------
%    Ib  - mxn filtered output image, of same size and class as I.

%kernel window size is w*w where w is an odd #.

%Gaussian filtering:
%G(x,y;sigma) = 1/(2*pi*sigma^2)*exp(-(x^2+y^2)/(2*sigma^2))

% Construct Gaussian Kernel
[h1, h2] = meshgrid(-(wndSize-1)/2:(wndSize-1)/2, -(wndSize-1)/2:(wndSize-1)/2);
%h1 is from 5 rows of -2 to 2. h2 = h1'
%Gaussian function
hg = exp(-(h1.^2+h2.^2)/(2*sigma^2));  
[a,b] = size(hg);
s = 0;
for i=1:a
    for j=1:b
        s = s+hg(i,j);
    end
end

h = hg./s;
%Apply filter.
Ib = (conv2(I(:,:,1), h, 'same'));

%cast Ib to the same class as I, if it isn't already.
if (~isequal(class(Ib), class(I)))
    Ib = cast(Ib, class(I));
end

end
