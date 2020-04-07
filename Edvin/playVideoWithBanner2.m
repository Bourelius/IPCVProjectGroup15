clear all;
close all;

vid = VideoReader('..\Videos\real_liverpool_1.mp4');
videoPlayer = vision.VideoPlayer('Position',[100 100 1080 680]);
%% initialize
vid.CurrentTime = 1;
i = 1;% Starts capturing video
frame = readFrame(vid);
% framegray = rgb2gray(frame);
% frameThresholded = framegray > 130;
% framegray = double(frameThresholded);
bannerIm = imread('..\UT_Logo_Black_EN.jpg');
[corners,theta] = myIntersectionFinder(frame);
blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port'); 
% [mergedImages,mask,warpedBanner,bannerCornerPoints] = myInsertBanner(corners,frame,blender,bannerIm);
% imshow(mergedImages,[]);
                                                % find some initial points
pointTracker = vision.PointTracker('MaxBidirectionalError',10,'BlockSize',[51 51]);
                                                % create a point tracker
initialize(pointTracker,corners,frame);% initialize with the initial frame

%% enter the loop
running = true;
while running
    frame = readFrame(vid);
%     framegray = rgb2gray(frame);
%     frameThresholded = framegray > 130;
%     framegray = double(frameThresholded);
    [trackedPoints,validity] = pointTracker(frame); % read new frame
    if sum(validity)<1                      % if too many points are lost
%         corners1 = myTemplateMatcher(frame,cornerTemplate);
%         corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
%         corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
%         corners = [corners1; corners2; corners3];
        [corners,theta] = myIntersectionFinder(frame);
        setPoints(pointTracker,corners); % set new points
        %out = myInsertBannerInFrame(corners,frame,validity);
    else
        %pause(0.01);
        
    end
    
    out = myMoveBanner2(corners,trackedPoints,frame,bannerIm,blender,theta);
    %out = myMoveBanner(bannerCornerPoints,trackedPoints,frame,bannerIm,blender);
%     imshow(out,[]);
    %out = insertMarker(frame,points,'Color','red','Size',6);
    videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    if vid.Currenttime == 15
         running = false;
    end
end

delete(vid);
    i=i+1;
