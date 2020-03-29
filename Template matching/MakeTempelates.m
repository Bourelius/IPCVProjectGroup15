clear all;

vid = VideoReader('C:\Users\Gebruiker\git\IPCVProjectGroup15\video4.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,1020,680],'Name','Point tracker');
%% initialize
vid.CurrentTime =4;                                   % Starts capturing video
frame = readFrame(vid);
frame = rgb2gray(frame);
I = imcrop(frame);
imwrite(I,'oppositeCorner.png');