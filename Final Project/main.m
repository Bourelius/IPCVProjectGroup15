clear variables;
close all;

%% Open video and advertisement

vid = VideoReader('..\Videos\video3.mp4');
videoPlayer = vision.VideoPlayer('Position',[100 100 1080 680]);
bannerIm = imread('..\UT_Logo_Black_EN.jpg');
%output = VideoWriter('virtual_ad_2.mp4','MPEG-4');

%% Initialize video capturing
vid.CurrentTime = 0;
frame = readFrame(vid); %first frame

%% ROI detection
frame_roi = myROISelector(frame);

%% Side classification
side = mySideClassifier(frame_roi); %1 is right, 2 is left

%% Initialize points and parameters based on first frame
pointTracker = vision.PointTracker('MaxBidirectionalError',10,'BlockSize',[41 41]);
blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port');
imref = imref2d(size(frame));

[corners,theta] = myIntersectionFinder(frame_roi, side);
initialize(pointTracker,corners,frame);% initialize with the initial frame

%% Looping through the video
running = true;
%open(output);
while hasFrame(vid)
   frame = readFrame(vid);
   [trackedPoints,validity] = pointTracker(frame); % read new frame
   
   if sum(validity)<2                      % if too many points are lost   
        frame_roi = myROISelector(frame);
        [corners,theta] = myIntersectionFinder(frame_roi, side);
        setPoints(pointTracker,corners); % set new points
   end

    out = myMergeBannerToFrame(corners,trackedPoints,frame,bannerIm,blender,theta,imref, side);
    %videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    if vid.Currenttime == 15
         running = false;
    end
    %writeVideo(output, out);
break
end
%close(output);

