clear all;
close all;

% addpath('./Template matching/');
% addpath('./Videos/');
% addpath('./Preprocessing/');

banner = imread('../UT_Logo_Black_EN.jpg');

%% Read the video
vid = VideoReader('../real_liverpool_1.mp4');
output = VideoWriter('out2.mp4','MPEG-4');
videoPlayer = vision.VideoPlayer();
%vid.CurrentFrame = 12;
temp=0;
%% Loop through video
open(output)
while hasFrame(vid)
   frame1 = readFrame(vid);
   
    lab_frame = rgb2lab(frame1);

    ab = lab_frame(:,:,2:3);
    ab = im2single(ab);
    nColors = 5;
    % repeat the clustering 3 times to avoid local minima
    pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);

    % dominant segment = largest segment = cluster1
    mask1 = pixel_labels==1;
    frame = frame1 .* uint8(mask1);
   
   frame = rgb2gray(frame);
   frame = frame > 120;
   figure(); imshow(frame,[]);

%    sigma = 3;
%    frame_edge = ut_edge(frame, 'c', 's', sigma, 'h', [0.8 0.03]);
%    figure(); imshow(frame_edge,[]); 

      %figure(); imshow(im,[]); 
    % line detection
    im=frame;
    [H,T,R] = hough(im, 'Theta', 60:1:89);
    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(im,T,R,P,'FillGap', 20, 'MinLength',100);

    
    [H2,T2,R2] = hough(im, 'Theta', -85:1:-70);
    P2  = houghpeaks(H2,3,'threshold',ceil(0.7*max(H2(:))));
    lines2 = houghlines(im,T2,R2,P2,'FillGap', 50, 'MinLength',200);
    [a,i]=unique([lines2.theta]','rows');
    lines2=lines2(i);
%      figure(1);imshow(im), hold on
    %lines3=[lines2(1);lines2(7);lines2(8)];
    %lines3=lines3';
    max_len = 0;
%     for k = 1:length(lines)
%        xy = [lines(k).point1; lines(k).point2];
%        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%        m=(xy(2,2)-xy(1,2))/(xy(2,1)-xy(1,1));             
%        c=xy(2,2)-m*xy(2,1);             
%        plot([-c/m,(1080-c)/m],[0,1080],'LineWidth',1,'Color','red')
%     end
%     for k = 1:length(lines2)
%        xy = [lines2(k).point1; lines2(k).point2];
%        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%        m=(xy(2,2)-xy(1,2))/(xy(2,1)-xy(1,1));             
%        c=xy(2,2)-m*xy(2,1);             
%        plot([-c/m,(1080-c)/m],[0,1080],'LineWidth',1,'Color','blue')
%     end
    ints=zeros(length(lines)*length(lines2),2);
    i=1;
    for k=1:length(lines)
        for j=1:length(lines2)
            lin1=[lines(k).point1;lines(k).point2];
            lin2=[lines2(j).point1;lines2(j).point2];
            m1=(lin1(2,2)-lin1(1,2))/(lin1(2,1)-lin1(1,1)); 
            m2=(lin2(2,2)-lin2(1,2))/(lin2(2,1)-lin2(1,1)); 
            c1=lin1(2,2)-m1*lin1(2,1);
            c2=lin2(2,2)-m2*lin2(2,1);
            x=(c2-c1)/(m1-m2);
            y=m1*x+c1;
            ints(i,:)=[x,y];
             plot(x,y, 'x', 'MarkerSize', 10, 'LineWidth', 2,'Color','yellow');
            i=i+1;
        end
    end
    sorted=sortrows(ints,2);
    corners=[sorted(1,:);sorted(2,:);sorted(4,:);sorted(5,:)];
    out=myInsertBannerInFrame(corners,frame1);
%     tform=estimateGeometricTransform(corners,bannerPoints,'projective');
%     out=imwarp(banner,tform);
    figure(10)
    imshow(out)
    writeVideo(output,out);
temp=temp+1

end
close(output);