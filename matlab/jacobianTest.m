K = [564.9 0 337.3; 0 564.3 226.5; 0 0 1];
C_cam = [0.960656116714365,-0.249483426036932,0.122056730876061;-0.251971275568189,-0.967721063070012,0.005140075795822;0.116834505638601,-0.035692635424156,-0.992509815603182];
t_cam = [0.201090356081375;0.114474051344464;1.193821106321156];
Ec = eye(4,4);
Ec(1:3,1:3) = C_cam;
Ec(1:3,4) = t_cam;
Wpt = [0.0635000000000000, 0, 0]';
J = find_jacobian(K, Ec, Wpt)

%%

Wpts_file = 'Wpts.mat';
I1 = imread('../images/target_01.png');
bounds_file = 'bounds.mat';
load(bounds_file);
load(Wpts_file);
Ipts = cross_junctions(I1, bpoly1, Wpts);


pose_estimate_nlopt(Ec, Ipts, Wpts)
