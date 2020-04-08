close all;

vid = VideoReader('..\Videos\real_liverpool_1.mp4');
videoPlayer = vision.VideoPlayer();
%% initialize
vid.CurrentTime = 2;                                   % Starts capturing video
frame = readFrame(vid);
frame = myROISelector(frame);
% framegray = rgb2gray(frame);
% frameThresholded = framegray > 130;
% framegray = double(frameThresholded);
% cornerCrossingTemplate = imread('cropedLineCrossing.png');
% cornerTemplate = imread('cropedCorner.png');
% oppositeCornerTemplate = imread('oppositeCorner.png');
% corners1 = myTemplateMatcher(frame,cornerTemplate);
% corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
% corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
%corners = [corners1; corners2; corners3];
[corners, theta] = myIntersectionFinder(frame);

                                                % find some initial points
pointTracker = vision.PointTracker('MaxBidirectionalError',5);
                                                % create a point tracker
initialize(pointTracker,corners,frame);% initialize with the initial frame

%% enter the loop
i=1;
while running
    frame = read(vid,i);
%     framegray = rgb2gray(frame);
%     frameThresholded = framegray > 130;
%     framegray = double(frameThresholded);
    [points,validity] = pointTracker(frame); % read new frame
    sum(validity)
    if sum(validity)<3                      % if too many points are lost
%         corners1 = myTemplateMatcher(frame,cornerTemplate);
%         corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
%         corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
%         corners = [corners1; corners2; corners3];
        corners = myIntersectionFinder(frame);
        setPoints(pointTracker,corners); % set new points
        %out = myInsertBannerInFrame(corners,frame,validity);
    else
        pause(0.04166);
        
    end
    
    out = myInsertBanner(points,frame, theta);
    %out = insertMarker(frame,points,'Color','red','Size',6);
    videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    if vid.Currenttime == 15
         running = false;
    end
i=i+1;
end

delete(vid);