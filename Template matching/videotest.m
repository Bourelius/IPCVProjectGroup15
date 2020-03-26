<<<<<<< HEAD
clear all;

vid = VideoReader('../video1.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
%% initialize
vid.CurrentTime = 0;                                   % Starts capturing video
frame = readFrame(vid);
frame = rgb2gray(frame);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
template = cornerCrossingTemplate;
corners1 = myTemplateMatcher(frame,cornerTemplate);
corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
corners = [corners1; corners2]; 

                                                % find some initial points
pointTracker = vision.PointTracker('MaxBidirectionalError',20);
                                                % create a point tracker
initialize(pointTracker,corners.Location,frame);% initialize with the initial frame

%% enter the loop
running = true;
while running
    frame = readFrame(vid);
    %frame = myLineDetector(frame);
    frame = rgb2gray(frame);
    [points,validity] = pointTracker(frame); % read new frame
    if sum(validity)<10                      % if too many points are lost
        corners1 = myTemplateMatcher(frame,cornerTemplate);
        corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
        corners = [corners1; corners2];
        setPoints(pointTracker,corners.Location); % set new points
    end
    
    out = insertMarker(frame,corners.Location,'o');
    videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    if vid.Currenttime == 320
         running = false;
    end
end

=======
clear all;

vid = VideoReader('C:\Users\Gebruiker\git\IPCVProjectGroup15\video4.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
%% initialize
vid.CurrentTime = 5;                                   % Starts capturing video
frame = readFrame(vid);
frame = rgb2gray(frame);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
template = cornerCrossingTemplate;
corners1 = myTemplateMatcher(frame,cornerTemplate);
corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
corners = [corners1; corners2]; 

                                                % find some initial points
pointTracker = vision.PointTracker('MaxBidirectionalError',20);
                                                % create a point tracker
initialize(pointTracker,corners.Location,frame);% initialize with the initial frame

%% enter the loop
running = true;
while running
    frame = readFrame(vid);
    %frame = myLineDetector(frame);
    frame = rgb2gray(frame);
    [points,validity] = pointTracker(frame); % read new frame
    if sum(validity)<10                      % if too many points are lost
        corners1 = myTemplateMatcher(frame,cornerTemplate);
        corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
        corners = [corners1; corners2];
        setPoints(pointTracker,corners.Location); % set new points
    end
    
    out = insertMarker(frame,corners.Location,'o');
    videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    if vid.Currenttime == 320
         running = false;
    end
end

>>>>>>> refs/remotes/origin/master
delete(vid);