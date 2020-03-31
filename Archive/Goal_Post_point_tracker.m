clear variables;
close all;

banner = imread('../UT_Logo_Black_EN.jpg');
ban_pts=[[size(banner,2),0];[size(banner,1),size(banner,2)];[0,0];[0,size(banner,1)]];
%% Read the video
vid = VideoReader('../Videos/video3.mp4');
output = VideoWriter('../out.mp4','MPEG-4');
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520],'Name','Point tracker');
vid.CurrentTime = 0;

% %% Go through each frame and determine the goal post lines for each frame
% figure(1);
% 
% while hasFrame(vid)
%     frame=readFrame(vid);
%     b=rgb2gray(frame);            %bring frame to grayscale                    %apply a threshold
%     a=imreconstruct(b>100,b>130);
%     %figure(2)
%     se=strel('diamond',1);
%     a=imerode(a,se);
%     %imshow(a)
%     BW=edge(a,'canny');           %edge detection of thresholded image
%     %figure(3)
%     %imshow(BW)
%     %line detection within certain orientation degrees
%     [H,T,R] = hough(BW,'Theta',-85:1:-70); 
%     P  = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
%     lines = houghlines(BW,T,R,P,'MinLength',100);
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
pts=zeros(6,2);
%% initialize points of goal post of first frame
currentTime = 1;
while hasFrame(vid) 
    theta=[-10:1:5;-85:1:-70;65:1:80];
    %% Extracting Poles
    frame = readFrame(vid); 
    frame_gray = rgb2gray(frame);
    frame_pole = frame_gray>200;
    frame_pole_edge = edge(frame_pole,'canny');
    
    [H,T,R] = hough(frame_pole_edge,'Theta',theta(1,:));
    P  = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
    lines_pole = houghlines(frame_pole_edge,T,R,P,'MinLength',150);
    figure(1)
    imshow(frame),hold on;
    temp=zeros(length(lines_pole),1);
    pts=zeros(4,2);
    for i = 1:length(lines_pole)
       xy = [lines_pole(i).point1; lines_pole(i).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       %lines_length(i) = norm(lines(i).point1 - lines(i).point2);
       temp(i)=sqrt(xy(2,1)^2+xy(2,2)^2);
       pts(2*i-1,:)=xy(1,:);
       pts(2*i,:)=xy(2,:);
    end
    
%     tform=estimateGeometricTransform(ban_pts,pts,'affine');
%     figure(2)
%     imshow(imwarp(banner,tform));
    pole_rho=max(temp);

    %% Extracting lines
    frame_lines=imreconstruct(frame_gray>100,frame_gray>130);
    se=strel('diamond',1);
    frame_lines=imerode(frame_lines,se);
    %frame1 = frame1>240;
    frame_lines_edge = edge(frame_lines,'canny');
    a=zeros(10,1)
    t=1;
    for j=2:3
        [H,T,R] = hough(frame_lines_edge,'Theta',theta(j,:));
        P  = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
        lines = houghlines(frame_lines_edge,T,R,P,'MinLength',200);
          
        for i = 1:length(lines)
            xy = [lines(i).point1; lines(i).point2];
            if sqrt(xy(2,1)^2+xy(2,2)^2)>pole_rho+10
            plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
            %lines_length(i) = norm(lines(i).point1 - lines(i).point2);
            
            end
        end
%         i_longest_line = find(max(lines_length)); 
%         % consider goal post to be longest line detected and other goal post to be
%         % +- 20 px tbd
%         pts(2*j-1,:) = lines(i_longest_line).point1; 
%         pts(2*j,:) = lines(i_longest_line).point2;
    end
    
%    create pointTracker
%     frame1 = rgb2gray(read(vid, currentTime));
%     pointTracker = vision.PointTracker();
%     initialize(pointTracker,pts,frame1);
%     p_old = pts;

end
% loop through video and track points 
% while hasFrame(vid)                             % Infinite loop to continuously detect the face
%     frame = readFrame(vid);
%     frame = rgb2gray(frame);                    % 
%     [points,validity] = pointTracker(frame);    % track the points
% %     if max(points(:,1)<(points(1,1)+10), points(:,1)>(points(1,1)-10)) % if points are not above each other anymore
% %         frame_n = frame>200;
% %         frame_n_edge = edge(frame_n,'canny');
% %         [H,T,R] = hough(frame_n_edge,'Theta',-10:1:10);
% %         P  = houghpeaks(H,5,'threshold',ceil(0.5*max(H(:))));
% %         lines = houghlines(frame_n_edge,T,R,P,'MinLength',20);
% %         
% %         for i = 1:length(lines)
% %             lines_length(i) = norm(lines(i).point1 - lines(i).point2);
% %         end
% %         i_longest_line = find(max(lines_length));
% %         points(1,:) = lines(i_longest_line).point1; 
% %         points(2,:) = lines(i_longest_line).point2;
% %         setPoints(pointTracker,points); % set new points
% %     end
%     p_new  = points;   
%     
%     %estimate geometric transform
% %     tform = estimateGeometricTransform(p_old,p_new,'similarity');
% %     banner_warp = imwarp(banner, tform);
% %     imshow(banner_warp, []);
%     out = insertMarker(frame,points(validity, :),'s', 'Size', 10);
%     videoPlayer(out);
%     p_old = points;
% end

