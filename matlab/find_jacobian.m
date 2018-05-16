function [J] = find_jacobian(K, Ec, Wpt)
%  FIND_JACOBIAN Determine Jacobian for NLS camera pose optimization.
%   Not my code, given by the prof.
%
%   [J] = FIND_JACOBIAN(K, Ec, Wpt) computes the Jacobian of image plane point
%   with respect to the current camera pose estimate and given a single world
%   point.
%
%   Inputs:
%   -------
%    K    - 3x3 camera intrinsic calibration matrix.
%    Ec   - 4x4 homogenous pose matrix, current guess for camera pose.
%    Wpt  - 3x1 world point on calibration target (one of n).
%
%   Outputs:
%   --------
%    J  - 2x6 Jacobian matrix (columns are tx, ty, tz, r, p, q).

%--- FILL ME IN ---

Hwc = Ec;
P = Wpt;

R  = Hwc(1:3, 1:3);
dx = P - Hwc(1:3, 4);

l = K*R'*dx;
g = l(3);

p = l(1:2)/g;  % Scale by depth and discard last row.

dldP = K*R.';

% Translation - using above result.
dldH(1:3, 1:3) = -dldP;

% Rotation.
[dRdr, dRdp, dRdq] = dcm_jacob_rpy(R);

dldH(1:3, 4) = K*dRdr'*dx;
dldH(1:3, 5) = K*dRdp'*dx;
dldH(1:3, 6) = K*dRdq'*dx;

dgdH = dldH(3, :);

dpdH = (g*dldH - l*dgdH)/(g^2);
dpdH = dpdH(1:2, :);  % Discard last row.
%------------------
J = dpdH;

end
