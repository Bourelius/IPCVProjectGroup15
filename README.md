# Virtual Advertising in football 

This project has been developed in the frame of the course "Image Processing and Computer Vision" at the University of Twente. The project authors are Edvin Bourelius (@Toffel2), Elisa Nguyen (@ElisaNguyen) and Sanjeet Vardam (@spvardam1998).

The repository contains the MATLAB Code and functions as well as the football video clips used to perform virtual banner advertising in football. The clips should depict the area in front of the goal. Field lines should be visible.

The system inserts a virtual banner at 60 degrees with regards to the field based on line detection using Hough Transform. Through the transform, 4 reference points are determined which are tracked and build the basis for the calculation of a projective geometric transform that represents the transformation from the world coordinate system to the image plane. By tracking these points, the banner is moved dynamically in accordance with the video. 
