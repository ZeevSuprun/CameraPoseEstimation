%% Testing saddle point detection.
imgFile = './I.mat';
%imgSrc = 'https://www.dropbox.com/s/uu4m0dddzeg7q83/P2P1I5.mat?dl=1';
%urlwrite(imgSrc, imgFile);
load(imgFile); % Load I.
% Saddle point is at 11.3464, 11.3464 - we allow 1.5 pixels of 'shift'.
x = saddle_point(I);
d = norm(x - [11.3464; 11.3464]);

%% Testing Cross junctions

% Load variables
wpts_file = 'wpts.mat';
bounds_file = 'bounds.mat';
cj_pts_file = 'cj_pts.mat';
%image_url = 'https://raw.githubusercontent.com/Olimoyo/ROB501-Cody/master/project_02/target_01.png?raw=true';
wpts_src = 'https://github.com/Olimoyo/ROB501-Cody/blob/master/project_02/Wpts.mat?raw=true';
bounds_src = 'https://github.com/Olimoyo/ROB501-Cody/blob/master/project_02/bounds.mat?raw=true';
%cj_pts_src = 'https://github.com/Olimoyo/ROB501-Cody/blob/master/project_02/cj_pts_image_01.mat?raw=true';

I1 = imread('../images/target_01.png');
I2 = imread('../images/target_02.png');
I3 = imread('../images/target_03.png');
I4 = imread('../images/target_04.png');
I5 = imread('../images/target_05.png');

n = 3;


%cj_pts_src = strcat(cj_base_str, cj_pts_list(n,:));
cj_pts_src = strcat('https://github.com/Olimoyo/ROB501-Cody/blob/master/project_02/cj_pts_image_0',char(string(n)),'.mat?raw=true');
         
urlwrite(wpts_src, wpts_file);
load(wpts_file);
urlwrite(bounds_src, bounds_file);
load(bounds_file);
urlwrite(cj_pts_src, cj_pts_file);
load(cj_pts_file);

I = I3;
bpoly = bpoly3;


cross_junctions(I, bpoly, Wpts);
hold on
scatter(cj_pts(1,:), cj_pts(2,:), 'g*');
plot(cj_pts(1,1:8), cj_pts(2,1:8), 'go');

%%
% Test pts
test_cj_pts = cross_junctions(I, bpoly, Wpts);
cj_size = size(test_cj_pts);
err = sum(sum(abs(cj_pts - test_cj_pts)))/cj_size(2)
% Each cross junction points should be within 2 pixels
if err <2
pass = 1;
else
pass = 0;
end
assert(isequal(1, pass))