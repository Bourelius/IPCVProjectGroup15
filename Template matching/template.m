close all;
clear all; 

vid = VideoReader('../video4.mp4');

videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
%% Load frame
vid.CurrentTime = 5;
frame = readFrame(vid);
im = im2double(frame);
im = rgb2gray(im);
figure(10);
imshow(im);
% I = imcrop;
% imwrite(I,'cropedCorner.png');
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
oppositeCornerTemplate = imread('oppositeCorner.png');
templateSize = size(cornerTemplate);
height = templateSize(2);
width = templateSize(1);

%%
correlationOutput = normxcorr2(oppositeCornerTemplate,im);
figure;
imshow(correlationOutput);

% Find out where the normalized cross correlation image is brightest.
[maxCorrValue, maxIndex] = maxk(abs(correlationOutput(:)),10);
[yPeak, xPeak] = ind2sub(size(correlationOutput),maxIndex);
corrPeaks = [xPeak, yPeak]; 
corr_offset = [(xPeak-size(cornerCrossingTemplate,2)) (yPeak-size(cornerCrossingTemplate,1))];
offset = corrPeaks-corr_offset;
corrPeaks = corrPeaks - offset./2;

lastPeak = [0,0];
for i = 1:1:length(corrPeaks)
    currentPeak = corrPeaks(i,:);
    diff = norm(currentPeak - lastPeak)
    if diff < 100
        corrPeaks(i,:) = [-1 -1];
    end
    lastPeak = currentPeak;
end

figure;
imshow(im); hold on;
for i = 1:1:length(corrPeaks)
    if corrPeaks(i,:) ~= -1
        out = insertMarker(im,corrPeaks,'x'); 
         imshow(out);
    drawnow
    end
end

%% 

corners1 = myTemplateMatcher(im,cornerTemplate);
corners2 = myTemplateMatcher(im,cornerCrossingTemplate);
corners = [corners1; corners2];

