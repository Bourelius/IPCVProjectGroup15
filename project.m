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
%p_old = goal_posts_points;
p_old = [goal_posts_points; corners.Location];
initialize(pointTracker,p_old,frame1);

%% initial tform
tform = projective2d();

%% loop through video and track points 
while hasFrame(vid)                             % Infinite loop to continuously detect the face
    frame = readFrame(vid);
    frame = rgb2gray(frame);                    % 
    [points,validity] = pointTracker(frame);    % track the points
    if sum(validity)<5 
        
        if max(points(2,1)<(points(1,1)+10), points(2,1)>(points(1,1)-10)) % if points are not above each other anymore
            if norm(points(1) - points(2)) <120
                goal_posts_points = goalPostDetector(frame);
            end
        end
                      % if too many points are lost
        corners1 = myTemplateMatcher(frame,cornerTemplate);
        corners2 = myTemplateMatcher(frame,cornerCrossingTemplate);
        corners = [corners1; corners2]; 
        
        points = [goal_posts_points; corners.Location];
        setPoints(pointTracker,points); % set new points
    end
    p_new  = points;   
    
    %estimate geometric transform, first check if points matched to each
    %other correctly
%     if size(p_new) < size(p_old)
%         for i = 1:1:size(validity)
%             if validity(i) == 0         % lost the point
%                 p_
%             end
%         end
%     elseif size(p_new) > size(p_old)
%         
%     end
    
    
%     tform_new = estimateGeometricTransform(p_old,p_new,'projective');
%     tform.T = tform_new.T * tform.T; 
%     banner_warp = imwarp(banner, tform);
%     imshow(banner_warp, []);
    
    %insert markers and play
    out = insertMarker(frame,points(validity, :),'s', 'Size', 10);
    step(videoPlayer, out);
    p_old = points;
end

release(videoPlayer);
