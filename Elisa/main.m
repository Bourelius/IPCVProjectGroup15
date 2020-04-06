clear all;
close all;

addpath('./Template matching/');
addpath('./Videos/');
addpath('./Preprocessing/');

banner = imread('../UT_Logo_Black_EN.jpg');

%% Read the video
vid = VideoReader('../Videos/india_bangladesh_1.mp4');
output = VideoWriter('out.mp4','MPEG-4');
videoPlayer = vision.VideoPlayer();
vid.CurrentTime = 1;

%% Loop through video

while hasFrame(vid)
   frame1 = readFrame(vid);
   frame = myROISelector(frame1);
   figure(2); imshow(frame, []);
   [corners, theta] = myIntersectionFinder(frame);
   out=myInsertBanner(corners,frame1, theta);
        bannerPoints = [0,0;
                    0,size(banner,2)
                    size(banner,1),0;
                    size(banner,1),size(banner,2)];
    figure(10)
    imshow(out)
 break  

 end