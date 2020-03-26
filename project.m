clear variables;
close all;

addpath('./Template matching/');
addpath('./Goal Post detection/');

banner = imread('UT_Logo_Black_EN.jpg');

%% Read the video
vid = VideoReader('Videos/video4.1.mp4');
output = VideoWriter('Videos/out.mp4','MPEG-4');
videoPlayer = vision.VideoPlayer();
vid.CurrentTime = 1;

%% Go through each frame and determine the goal post lines for each frame
%im=imread('test.jpg');
% figure;
% i=1;
% running=true;
% while hasFrame(vid)
%     frame=readFrame(vid);
%     b=rgb2gray(frame);            %bring frame to grayscale
%     b=b>200;                      %apply a threshold
%     BW=edge(b,'canny');           %edge detection of thresholded image
%     %line detection within certain orientation degrees
%     [H,T,R] = hough(BW,'Theta',-10:1:10); 
%     P  = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
%     lines = houghlines(BW,T,R,P,'MinLength',20);
%     %show the line in frame
%     imshow(frame), hold on
%     max_len = 0;
%     for k = 1:length(lines)
%        xy = [lines(k).point1; lines(k).point2];
%        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%        % Plot beginnings and ends of lines
%        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%        % Determine the endpoints of the longest line segment
%        len = norm(lines(k).point1 - lines(k).point2);
%        if ( len > max_len)
%           max_len = len;
%           xy_long = xy;
%        end
%        drawnow 
%     end
% 
% end

%% initialize points of goal post of first frame
currentTime = 1;
frame1 = read(vid, currentTime); 
frame1 = rgb2gray(frame1);
goal_posts_points = goalPostDetector(frame1);

%% find corners through templates
currentTime = 1;
frame1 = rgb2gray(read(vid, currentTime));
cornerCrossingTemplate = imread('cropedLineCrossing.png');
cornerTemplate = imread('cropedCorner.png');
template = cornerCrossingTemplate;
corners1 = myTemplateMatcher(frame1,cornerTemplate);
corners2 = myTemplateMatcher(frame1,cornerCrossingTemplate);
corners = [corners1; corners2]; 

%% create pointTracker and initialize

pointTracker = vision.PointTracker();
p_old = [goal_posts_points; corners.Location];
initialize(pointTracker,p_old,frame1);

%% loop through video and track points 
while hasFrame(vid)                             % Infinite loop to continuously detect the face
    frame = readFrame(vid);
    frame = rgb2gray(frame);                    % 
    [points,validity] = pointTracker(frame);    % track the points
    if max(points(2,1)<(points(1,1)+10), points(2,1)>(points(1,1)-10)) % if points are not above each other anymore
        goal_posts_points = goalPostDetector(frame);
    end
    %if sum(validity)<5                   % if too many points are lost
        corners1 = myTemplateMatcher(frame,cornerTemplate);
        corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
        corners = [corners1; corners2]; 
    %end
    points = [goal_posts_points; corners.Location];
    setPoints(pointTracker,points); % set new points
    p_new  = points;   
    
    %estimate geometric transform
%     tform = estimateGeometricTransform(p_old,p_new,'projective');
%     banner_warp = imwarp(banner, tform);
%     imshow(banner_warp, []);
    
    %insert markers and play
    out = insertMarker(frame,points(validity, :),'x', 'Size', 10);
%     videoPlayer(out);
    step(videoPlayer, out);
    p_old = points;
end

release(videoPlayer);
