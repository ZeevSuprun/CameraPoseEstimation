function [rows,cols] = harris_corners(I)
%Not implemented by me. Source: https://www.youtube.com/watch?v=I_PkOXmzS8s

    [dx, dy] = meshgrid(-1:1, -1:1);
    Ix = conv2(double(I), dx, 'same');
    Iy = conv2(double(I), dy, 'same');

    % Gaussian filter
    sigma = 2;
    radius = 1;
    order = 2*radius + 1;
    threshold = 3000;
    
   dim = max(1, fix(6*sigma));
   m = dim; n = dim;
   [h1, h2] = meshgrid(-(m-1)/2:(m-1)/2, -(n-1)/2:(n-2)/2);
   hg = exp(-(h1.^2+h2.^2)/(2*sigma^2));
   [a,b] = size(hg);
   sum = 0;
   for i=1:a
       for j=1:b
            sum = sum+hg(i,j);
       end
   end
   g = hg./sum;
   
   Ix2 = conv2(double(Ix.^2), g, 'same');
   Iy2 = conv2(double(Iy.^2), g, 'same');
   Ixy = conv2(double(Ix.*Iy), g, 'same');
   
   R = (Ix2.*Iy2 - Ixy.^2)./(Ix2+Iy2 + eps);
   
   mx = myOrdFilt2(R, order);
   hp = (R==mx) & (R > threshold);
 
   [rows, cols] = find(hp);

end