clear variables;
close all;

%% Read the video
vid = VideoReader('../../video1.mp4');
output = VideoWriter('../../out.mp4','MPEG-4');
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
vid.CurrentTime = 0;

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
frame1 = frame1>200;
frame1_edge = edge(frame1,'canny');
[H,T,R] = hough(frame1_edge,'Theta',-10:1:10);
P  = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
lines = houghlines(frame1_edge,T,R,P,'MinLength',20);

for i = 1:length(lines)
    lines_length(i) = norm(lines(i).point1 - lines(i).point2);
end
i_longest_line = find(max(lines_length)); 
% consider goal post to be longest line detected and other goal post to be
% +- 20 px tbd
goal_post(1,:) = lines(i_longest_line).point1; 
goal_post(2,:) = lines(i_longest_line).point2;
%create pointTracker
frame1 = rgb2gray(read(vid, currentTime));
pointTracker = vision.PointTracker();
initialize(pointTracker,goal_post,frame1);
open(output)
%% loop through video and track points 
while hasFrame(vid)                             % Infinite loop to continuously detect the face
    frame = readFrame(vid);
    frame = rgb2gray(frame);                    % 
    [points,validity] = pointTracker(frame);    % track the points
%     if sum(validity)<40                         % if too many points are lost
%         corners = detectMinEigenFeatures(rgb2gray(frame),'MinQuality',0.001); 
%         setPoints(pointTracker,corners.Location); % set new points
%     end
        
    out = insertMarker(frame,points(validity, :),'s', 'Size', 30);
    
    writeVideo(output,out);
    %videoPlayer(out);
end
close(output)
