# CameraPoseEstimation

In this project, feature detection was used to determine the intersections on a checkerboard (known calibration target), which was then used to estimate the camera pose. This project was written as part of a Computer Vision for Robotics course. This project did not allow the use of image processing libraries. 

## Part 1: Image Smoothing and Subpixel Feature Extraction

1. The image is blurred with a gaussian filter. 
2. The corners of the image are detected using a harris corner detector.
3. For each corner, the patch around the corner is examined for a cross junction using a saddle point detection function. See L. Lucchese and S. K. Mitra, “Using Saddle Points for Subpixel Feature Detection in Camera Calibration Targets,” in Proceedings of the Asia-Pacific Conference on Circuits and Systems (APCCAS), vol. 2, (Singapore), pp. 191–195, December 2002
4. The best 48 cross junctions are found. These correspond to the internal intersections of the checkerboard, not the bounding perimeter. 
5. The cross junction points are sorted in major row order. 

The relevant matlab files for this part are gaussian blur.m, which filters the supplied image, saddle point.m, which accepts a small image patch and attempts to find a saddle point, and cross junctions.m, which determines the image coordinates of each cross junction given an input image of the checkerboard. 

## Part 2: Camera Pose Estimation

1. Using the image-target correspondences and the known intrinsic callibration matrix, nonlinear least squares optimization procedure is used to compute an updated estimate of the camera pose. This is an example of the Perspective-n-Points problem. 
