clear all;
close all;

vid = VideoReader('..\real_liverpool_1.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,1020,680],'Name','Point tracker');
%% initialize
vid.CurrentTime = 5;                                   % Starts capturing video
frame = readFrame(vid);

mask = (frame(:,:,1) > 100) & (frame(:,:,2) > 255) & (frame(:,:,3) > 20);
maskedRgbImage = bsxfun(@times, frame, cast(mask, 'like', frame));
imshow(maskedRgbImage);