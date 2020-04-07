clear all;

vid = VideoReader('C:\Users\Gebruiker\git\IPCVProjectGroup15\video4.mp4');
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
%% frame 1
vid.CurrentTime = 5;                                 
frame1 = readFrame(vid);
frame1 = rgb2gray(frame1);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
oppositeCornerTemplate = imread('oppositeCorner.png');

corners1 = myTemplateMatcher(frame1,cornerTemplate);
corners2 = myTemplateMatcher(frame1,cornerCrossingTemplate);
corners3 = myTemplateMatcher(frame1,oppositeCornerTemplate);
cornersframe1 = [corners1; corners2; corners3]; 

figure;
imshow(frame1); hold on;
out = insertMarker(frame1,cornersframe1.Location,'x'); 
imshow(out);
imwrite(frame1,'frame1_5sec_video4.png');

%% frame 2
vid.CurrentTime = 5.5;                                   
frame12 = readFrame(vid);
frame12 = rgb2gray(frame12);
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
oppositeCornerTemplate = imread('oppositeCorner.png');

corners1 = myTemplateMatcher(frame12,cornerTemplate);
corners2 = myTemplateMatcher(frame12,cornerCrossingTemplate);
corners3 = myTemplateMatcher(frame12,oppositeCornerTemplate);
cornersframe12 = [corners1; corners2; corners3]; 

figure;
imshow(frame12); hold on;
out = insertMarker(frame12,cornersframe12.Location,'x'); 
imshow(out);
imwrite(frame12,'frame1_55sec_video4.png');

%%

imageSize = [size(frame1,1),size(frame1,2)];
worldPoints = [358.3, 0;
               248.4, 160;
               541.6, 0;
               358.4, 0;
               651.6, 0; 
               541.6, 55];
imagePointsframe1 = double(cornersframe1.Location);
imagePointsframe12 = double(cornersframe12.Location);
imagePoints = cat(3,imagePointsframe1, imagePointsframe12);
[cameraParams,imagesUsed,estimationErrors] = ... 
    estimateCameraParameters(imagePoints,worldPoints,'ImageSize',imageSize);
%cameraMatrix = estimateCameraMatrix(imagePoints,worldPoints);

%tformImageToWorld = estimateGeometricTransform(imagePoints,worldPoints,'projective');

%%
worldPoints = [541.6, 0;
               541.6, 55;
               358.4, 0;
               358.4, 55];

%bannerLocationWorld = worldPoints;
% bannerLocationWorld = [651.6, 0;
%                651.6,165.0;
%                248.4, 0;
%                248.4, 165.0];

bannerLocationWorld = [358.4, 0;
               358.4,55;
               248.4, 0;
               248.4, 55];

%bannerLocationWorld = worldPoints;
           
imagePoints = zeros(4,2);
corners = cornersframe1;
sortedCorners = sortrows(corners.Location,2);
% imagePoints(1,:) = corners.Location(4,:);
% imagePoints(2,:) = corners.Location(3,:);          
% imagePoints(3,:) = corners.Location(1,:);           
% imagePoints(4,:) = corners.Location(6,:);
imagePoints(1,:) = sortedCorners(2,:);
imagePoints(2,:) = sortedCorners(3,:);  
imagePoints(3,:) = sortedCorners(4,:);          
imagePoints(4,:) = sortedCorners(5,:);

tformWorldToImage = estimateGeometricTransform(worldPoints,imagePoints,'projective');
bannerLocationImage = transformPointsForward(tformWorldToImage,bannerLocationWorld);


%%
[bannerIm,map,alpha] = imread('C:\Users\Gebruiker\Pictures\selfie.jpg');
bannerImGray = rgb2gray(bannerIm);
bannerPoints = [1299,0;
                    1299,178
                    0,0;
                    0,178];
% selfiePoints = [3456,0; 3456,4608; 0,0 ; 0 4608];

imagePoints = zeros(4,2);
corners = cornersframe1;
sortedCorners = sortrows(corners.Location,2);
% imagePoints(1,:) = corners.Location(4,:);
% imagePoints(2,:) = corners.Location(3,:);          
% imagePoints(3,:) = corners.Location(1,:);           
% imagePoints(4,:) = corners.Location(6,:);
% imagePoints(1,:) = sortedCorners(2,:);
% imagePoints(2,:) = sortedCorners(3,:);  
% imagePoints(3,:) = sortedCorners(4,:);          
% imagePoints(4,:) = sortedCorners(5,:);
imagePoints(1,:) = bannerLocationImage(1,:);
imagePoints(2,:) = bannerLocationImage(2,:);
imagePoints(3,:) = bannerLocationImage(3,:);         
imagePoints(4,:) = bannerLocationImage(4,:);


%tformBannerToWorld = estimateGeometricTransform(bannerPoints,worldPoints,'projective');
tformBannerToImage = estimateGeometricTransform(bannerPoints,imagePoints,'projective');
warpedBannerToImage = imwarp(bannerImGray,tformBannerToImage);
figure;
imshow(warpedBannerToImage);

% figure
% C = imfuse(frame1,warpedBannerToImage,'blend');
% imshow(C);


%% Part 1
% %Make tform object with corresponding points between 1 and 2
% tformBannerToImage = estimateGeometricTransform(p{2,1},p{1,2},'projective');
% %Warp bannerImGray towards domain of frame1
% bannerImGraywarp = imwarp(bannerImGray,tformBannerToImage);
% %imshow(bannerImGraywarp);
% imwrite(bannerImGraywarp,'bannerImGraywarp.jpg');

%Make tform1 object with identity transformation
tform1 = projective2d(eye(3));

%Find WorldLimits
sizeframe1 = size(frame1);
sizebannerImGray = size(bannerImGray);



%Creat imref object
%imref = imref2d(imageSize, xWorldLimits, yWorldLimits);
imref = imref2d(size(frame1));
%Make blender object
blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port'); 

%Warp images
warpedImage1 = imwarp(frame1, tform1, 'Outputview',imref);
warpedImage2 = imwarp(bannerImGray, tformBannerToImage, 'Outputview',imref);

%Merge images
mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
mergedImages = step(blender, warpedImage1, warpedImage2,mask);

imshow(mergedImages);










