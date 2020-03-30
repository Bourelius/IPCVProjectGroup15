clear all;

vid = VideoReader('C:\Users\Gebruiker\git\IPCVProjectGroup15\video4.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
%% frame 1
vid.CurrentTime = 5;                                   % Starts capturing video
frame = readFrame(vid);
frame = rgb2gray(frame);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
oppositeCornerTemplate = imread('oppositeCorner.png');

corners1 = myTemplateMatcher(frame,cornerTemplate);
corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
cornersFrame1 = [corners1; corners2; corners3]; 

figure;
imshow(frame); hold on;
out = insertMarker(frame,cornersFrame1.Location,'x'); 
imshow(out);

%% frame 2
vid.CurrentTime = 5.5;                                   % Starts capturing video
frame = readFrame(vid);
frame = rgb2gray(frame);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
oppositeCornerTemplate = imread('oppositeCorner.png');

corners1 = myTemplateMatcher(frame,cornerTemplate);
corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
corners3 = myTemplateMatcher(frame,oppositeCornerTemplate);
cornersFrame2 = [corners1; corners2; corners3]; 

figure;
imshow(frame); hold on;
out = insertMarker(frame,cornersFrame2.Location,'x'); 
imshow(out);

%%


worldPoints = [358.3, 0;
               248.4, 160;
               541.6, 0;
               358.4, 0;
               651.6, 0; 
               541.6, 55];
imagePointsFrame1 = double(cornersFrame1.Location);
imagePointsFrame2 = double(cornersFrame2.Location);
imagePoints = cat(3,imagePointsFrame1, imagePointsFrame2);
%[cameraParams,imagesUsed,estimationErrors] = ... 
 %   estimateCameraParameters(imagePoints,worldPoints);
%cameraMatrix = estimateCameraMatrix(imagePoints,worldPoints);

%tformImageToWorld = estimateGeometricTransform(imagePoints,worldPoints,'projective');

%%
[bannerIm,map,alpha] = imread('C:\Users\Gebruiker\Pictures\banner00.jpg');
bannerImGray = rgb2gray(bannerIm);
bannerPoints = [0,0;
                1299,0;
                0,178;
                1299,178];

imagePoints = zeros(4,2);
corners = cornersFrame1;
imagePoints(1,:) = corners.Location(4,:);
imagePoints(2,:) = corners.Location(3,:);          
imagePoints(3,:) = corners.Location(1,:);           
imagePoints(4,:) = corners.Location(6,:);


%tformBannerToWorld = estimateGeometricTransform(bannerPoints,worldPoints,'projective');
tformBannerToImage = estimateGeometricTransform(bannerPoints,imagePoints,'projective');
warpedBannerToImage = imwarp(bannerImGray,tformBannerToImage);
figure;
imshow(warpedBannerToImage);

% figure
% C = imfuse(frame,warpedBannerToImage,'blend');
% imshow(C);


%% Part 1
% %Make tform object with corresponding points between 1 and 2
% tformBannerToImage = estimateGeometricTransform(p{2,1},p{1,2},'projective');
% %Warp bannerImGray towards domain of frame
% bannerImGraywarp = imwarp(bannerImGray,tformBannerToImage);
% %imshow(bannerImGraywarp);
% imwrite(bannerImGraywarp,'bannerImGraywarp.jpg');

%Make tform1 object with identity transformation
tform1 = projective2d(eye(3));

%Find WorldLimits
sizeframe = size(frame);
sizebannerImGray = size(bannerImGray);
[xlims(1,:), ylims(1,:)] = outputLimits(tform1,[1 sizeframe(1)],[1 sizeframe(2)]);
[xlims(2,:), ylims(2,:)] = outputLimits(tformBannerToImage,[1 sizebannerImGray(1)],[1 sizebannerImGray(2)]);
xMin = min(xlims(:));
yMin = min(ylims(:));
xMax = max(xlims(:));
yMax = max(ylims(:));
width = round(xMax - xMin);
height = round(yMax - yMin);
imageSize = [height width];
xWorldLimits = [xMin xMax];
yWorldLimits = [yMin yMax];

%Creat imref object
imref = imref2d(imageSize, xWorldLimits, yWorldLimits);
%Make blender object
blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port'); 

%Warp images
warpedImage1 = imwarp(frame, tform1, 'Outputview',imref);
warpedImage2 = imwarp(bannerImGray, tformBannerToImage, 'Outputview',imref);

%Merge images
mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
mergedImages = step(blender, warpedImage1, warpedImage2,mask);

imshow(mergedImages);










