clear all;

vid = VideoReader('video4.mp4');

videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
%% enter the loop
vid.CurrentTime = 5;                                 
frame1 = readFrame(vid);
frame1 = rgb2gray(frame1);
cornerCrossingTemplate = imread('C:\Users\Gebruiker\git\IPCV\IPCVProjectGroup15\Template matching\cropedLineCrossing');
% cornerTemplate = imread('cropedCorner.png');
% oppositeCornerTemplate = imread('oppositeCorner.png');

im = im2double(imread('frame.tif'));
im = rgb2gray(im);
figure(1);
imshow(im,[],'InitialMagnification',200);

%% enhance lines


line_enhanced = fibermetric(frame1,2);
corners = myTempelateMatcher(line_enhanced,cornerCrossingTemplelate);

% show
figure(2);
imshow(line_enhanced,[],'InitialMagnification',200);
title('line strenght = largest eigenvalue of hessian matrix')
%% detect lines
% determine threshold by defining a percentile
percentile = 10/100;                                            % define percentile
line_ordered = sort(line_enhanced(:),'descend');                  % order line feature
thresh = line_ordered(round(percentile*length(line_ordered)));  % determine threshold
imline = line_enhanced>thresh;                                    % apply threshold
figure(4)
imshow(imline,[],'InitialMagnification',200);

%% find line segments with minimum length 
len = 35;
imacc = false(size(im));                            % initialize with empty accu array
% figure(5);
for deg=0:3:180          %% loop over all angles:
    bline = strel('line',len,deg);                  % create a structuring element with angulated line segment
    imdir = imdilate(imerode(imline,bline),bline);  % apply opening: 
%     subplot(1,2,1);                                 %     pixels where the line segment fits in the image,
%     imshow(imdir);                                  %     this line segment is reconstructed at that pixel position
%     title([num2str(deg) ' degrees']);
    imacc = imacc | imdir;                          % accumulate all found segments
%     subplot(1,2,2)
%     imshow(imacc,[]);
%     title('accumulator')
    drawnow
end
imskel = bwmorph(imacc>0,'skel','Inf');             % skeltonize the results

% show image with a color overlay
ind = find(imskel>0);
imred = im;
imred(ind) = 1;                                     % show line elements in red  
imgreen = im;
imgreen(ind) = 0;
imcol = cat(3,imred,imgreen,imgreen);
figure;
imshow(imcol,[],'InitialMagnification',200);

%% detect some bifurcations
% bhit = [0 0 0 0;0 1 1 1;0 1 0 0;0 1 0 0];    % create the hit mask
% bmiss = [0 0 0 0; 1 0 0 0; 1 0 1 1; 1 0 1 1];  % create the miss mask
% figure;
% imshow(bhit-bmiss,[],'InitialMagnification',3000); % show
% imhitmiss = bwhitmiss(imskel,bhit,bmiss);         % apply
% imhitmiss = imdilate(imhitmiss,ones(5));
% imshow(imhitmiss);
%% show image with a color overlay
% ind = find(imhitmiss);
% imred(ind) = 0;
% imgreen(ind) = 1;
% imblue = imgreen;
% imblue(ind) = 0;
% imcol = cat(3,imred,imgreen,imblue);             % show the dots in green
% figure;
% imshow(imcol,[],'InitialMagnification',200);

%% Harris
imskel = im2double(imskel);
corners = detectHarrisFeatures(imskel,'FilterSize',25);
out = insertMarker(imskel,corners.Location,'o');
imshow(out);
