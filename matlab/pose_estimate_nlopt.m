function [E] = pose_estimate_nlopt(Eg, Ipts, Wpts)
%  POSE_ESTIMATE_NLOPT Estimate camera pose from 2D-3D correspondences via NLS.
%
%   [E] = POSE_ESTIMATE_NLOPT(Eg, Ipts, Wpts) performs a nonlinear least squares 
%   optimization procedure to determine the best estimate of the camera pose in 
%   the calibration target frame, given 2D-3D point correspondences.
%
%   Inputs:
%   -------
%    Eg    - 4x4 homogenous pose matrix, initial guess for camera pose.
%    Ipts  - 2xn array of cross-junction points (with subpixel accuracy).
%    Wpts  - 3xn array of world points (one-to-one correspondence with image).
%
%   Outputs:
%   --------
%    E  - 4x4 homogenous pose matrix, estimate of camera pose in target frame.

%--- FILL ME IN ---

maxIter = 100;
%rotation matrix.
K = [564.9 0 337.3; 0 564.3 226.5; 0 0 1];
H = Eg;
%damping factor
lambda = 1;
epsilon = 1e-2;
%only a limited number of iterations.
for n = 1:maxIter
   %calculating A and B.
   A = zeros(6);
   b = zeros(6,1);
   p = H(1:3,4);
   for i = 1:size(Ipts,2)
       %J is 2x6
       J = find_jacobian(K, H, Wpts(:,i));
       A = A + J'*J;
       fi = H*[Wpts(:,i);1];
       %difference between transformed world point and corresponding image
       %point.
       r = Ipts(:,i) - fi(1:2);
       b = b + J'*r;
    
   end
   %update position.
   deltaP = b\(A + lambda*eye(6).*diag(A));
   %first 3 elements are pos, next 3 elements are roll, pitch, yaw.
   %update p with new position.
   p = p + deltaP(1:3)';
   H(1:3,4) = p;
   %update H with new rotation.
   H(1:3,1:3) = dcm_from_rpy(deltaP(4:6));
   
   %if it reached a local equilibrium, stop updating.
   if norm(deltaP) < epsilon
       break
   end
end

E = H;

%------------------

end
