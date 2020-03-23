clear variables;
close all;

%% Read the video
vid = VideoReader('video1.mp4');

videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
vid.CurrentTime = 0;

%% Go through each frame
%im=imread('test.jpg');
i=1;
running=true;
while hasFrame(vid)
    frame=readFrame(vid);
    b=rgb2gray(frame);            %bring frame to grayscale
    b=b>200;                      %apply a threshold
    BW=edge(b,'canny');           %edge detection of thresholded image
    %line detection within certain orientation degrees
    [H,T,R] = hough(BW,'Theta',-10:1:10); 
    P  = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
    lines = houghlines(BW,T,R,P,'MinLength',20);
    %show the line in frame
    figure, imshow(frame), hold on
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end

end