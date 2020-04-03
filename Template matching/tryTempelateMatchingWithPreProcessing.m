clear all;

vid = VideoReader('..\video4.mp4');

videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
%% enter the loop
vid.CurrentTime = 5;                                 
frame1 = readFrame(vid);
frame1 = rgb2gray(frame1);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
% cornerTemplate = imread('cropedCorner.png');
% oppositeCornerTemplate = imread('oppositeCorner.png');


frame1 = frame1 > 180;
frame1 = im2double(frame1);
frame1 = bwmorph(frame1,'skel','Inf');
corners = myTempelateMatcher(frame1,cornerCrossingTemplate);


figure;
imshow(frame1); hold on;
out = insertMarker(frame1,corners,'x'); 
imshow(out);