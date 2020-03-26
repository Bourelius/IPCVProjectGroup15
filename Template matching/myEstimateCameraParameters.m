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

figure;
imshow(frame); hold on;
out = insertMarker(frame,corners.Location,'x'); 
imshow(out);

%%
corners(4) = [];
worldPoints = [348,100;
               458,100;
               548,155;
               348,265];
worldPoints = single(worldPoints);
imagePoints = corners.Location;
% [cameraParams,imagesUsed,estimationErrors] = ...
%     estimateCameraParameters(imagePoints,worldPoints);

tformImageToWorld = estimateGeometricTransform(imagePoints,worldPoints,'projective');

%%
bannerIm = imread('C:\Users\Gebruiker\Pictures\banner00.jpg');
bannerImGray = rgb2gray(bannerIm);
worldPoints = [348,100;
               751,100;
               348,265;
               751,265];
bannerPoints = [0,0;
                1299,0;
                0,178;
                1299,178];
            
tformBannerToWorld = estimateGeometricTransform(bannerPoints,worldPoints,'projective');
tformBannerToImage= estimateGeometricTransform(bannerPoints,imagePoints,'projective');
warpedBannerToWorld = imwarp(bannerImGray,tformBannerToWorld);
figure;
imshow(warpedBannerToWorld);

warpedBannerImage = imwarp(bannerImGray,tformBannerToImage);

figure;
imshow(warpedBannerToWorld);













