close all;

banner = imread('../UT_Logo_Black_EN.jpg');

%% Read the video
vid = VideoReader('../Videos/real_liverpool_1.mp4');
output = VideoWriter('out.mp4','MPEG-4');
videoPlayer = vision.VideoPlayer();
vid.CurrentTime = 3;

%% Loop through video
i=5;

while hasFrame(vid)
   frame1 = read(vid,i);
   frame = myROISelector(frame1);
   side = mySideClassifier(frame);
   
   
   [corners, theta] = myIntersectionFinder(frame,side);
   out=myInsertBanner(corners,frame1, theta, side);
        bannerPoints = [0,0;
                    0,size(banner,2)
                    size(banner,1),0;
                    size(banner,1),size(banner,2)];
    figure(10)
    imshow(out)
break  
i=i+1;
 end