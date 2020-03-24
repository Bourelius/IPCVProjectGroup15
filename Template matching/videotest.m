clear all;

vid = VideoReader('clip.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
%% initialize
vid.CurrentTime = 315;                                   % Starts capturing video
frame = readFrame(vid);
frame = rgb2gray(frame);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
template = cornerCrossingTemplate;
corners = myTemplateMatcher(frame,template); 
                                                % find some initial points
pointTracker = vision.PointTracker('MaxBidirectionalError',50);
                                                % create a point tracker
initialize(pointTracker,corners.Location,frame);% initialize with the initial frame

%% enter the loop
running = true;
while running
    frame = readFrame(vid);
    %frame = myLineDetector(frame);
    frame = rgb2gray(frame);
    [points,validity] = pointTracker(frame); % read new frame
    if sum(validity)<20                      % if too many points are lost
        corners = myTemplateMatcher(frame,template); 
        setPoints(pointTracker,corners.Location); % set new points
    end
    
    out = insertMarker(frame,corners.Location,'o');
    videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    if vid.Currenttime == 320
         running = false;
    end
end

delete(vid);