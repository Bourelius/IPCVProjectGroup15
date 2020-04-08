close all;

vid = VideoReader('C:\Users\Gebruiker\git\IPCVProjectGroup15\video4.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,1020,680],'Name','Point tracker');
%% initialize
vid.CurrentTime = 5;                                   % Starts capturing video
frame = readFrame(vid);
frame = rgb2gray(frame);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
oppositeCornerTemplate = imread('oppositeCorner.png');
corners1 = myTemplateMatcher(frame,cornerTemplate);
corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
corners = [corners1; corners2; corners3]; 

                                                % find some initial points
pointTracker = vision.PointTracker('MaxBidirectionalError',5);
                                                % create a point tracker
initialize(pointTracker,corners.Location,frame);% initialize with the initial frame

%% enter the loop
running = true;
while running
    frame = readFrame(vid);
    %frame = myLineDetector(frame);
    frame = rgb2gray(frame);
    [points,validity] = pointTracker(frame); % read new frame
    if sum(validity)<5                      % if too many points are lost
        corners1 = myTemplateMatcher(frame,cornerTemplate);
        corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
        corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
        corners = [corners1; corners2; corners3]; 
        setPoints(pointTracker,corners.Location); % set new points
    else
        pause(0.04166);
        
    end
    
    out = insertMarker(frame,points(validity, :),'+');
    videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    if vid.Currenttime == 30
         running = false;
    end
end

=======

clear all;
close all;

vid = VideoReader('C:\Users\Gebruiker\git\IPCVProjectGroup15\video4.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,1020,680],'Name','Point tracker');
%% initialize
vid.CurrentTime = 5;                                   % Starts capturing video
frame = readFrame(vid);
frame = rgb2gray(frame);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
oppositeCornerTemplate = imread('oppositeCorner.png');
corners1 = myTemplateMatcher(frame,cornerTemplate);
corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
corners = [corners1; corners2; corners3]; 

                                                % find some initial points
pointTracker = vision.PointTracker('MaxBidirectionalError',5);
                                                % create a point tracker
initialize(pointTracker,corners.Location,frame);% initialize with the initial frame

%% enter the loop
running = true;
while running
    frame = readFrame(vid);
    %frame = myLineDetector(frame);
    frame = rgb2gray(frame);
    [points,validity] = pointTracker(frame); % read new frame
    if sum(validity)<5                      % if too many points are lost
        corners1 = myTemplateMatcher(frame,cornerTemplate);
        corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
        corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
        corners = [corners1; corners2; corners3]; 
        setPoints(pointTracker,corners.Location); % set new points
    else
        pause(0.04166);
        
    end
    
    out = insertMarker(frame,points(validity, :),'+');
    videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    if vid.Currenttime == 30
         running = false;
    end
end

delete(vid);

