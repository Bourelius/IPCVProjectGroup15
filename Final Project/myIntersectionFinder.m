function [corners, theta] = myIntersectionFinder(frame,side)

    %frame_hsv = rgb2hsv(frame);
    %im=frame_hsv(:,:,3)>0.6 & frame_hsv(:,:,2)<0.5;
    frame_hsl=rgb2hsl(rescale(frame));
    %frame = localcontrast(frame);
    % line detection
    im = frame_hsl(:,:,3)>0.4;
    figure(4);imshow(im), hold on
    
    theta={[-75:1:-61;75:1:89];[65:1:79;-89:1:-75]};
    [H2,T2,R2] = hough(edge(im,'approxcanny'), 'Theta', theta{side}(1,:));
    P2  = houghpeaks(H2,3,'threshold',ceil(0.3*max(H2(:))),'NHoodSize',[101 3]);
    lines2 = houghlines(im,T2,R2,P2,'FillGap',50, 'MinLength',100);
    [~,i]=unique([lines2.theta]','rows');
    lines2=lines2(i);
    

    temp_c=0;
    for k = 1:length(lines2)
        xy = [lines2(k).point1; lines2(k).point2];
        %plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

        m=(xy(2,2)-xy(1,2))/(xy(2,1)-xy(1,1));             
        c=xy(2,2)-m*xy(2,1);             
        plot([-c/m,(1080-c)/m],[0,1080],'LineWidth',1,'Color','blue')
        if temp_c==0
            temp_c=c;
            temp_m=m;
        end
        if temp_c>c
           temp_c=c; 
           temp_m=m;
        end
    end
    temp_b=(1080-temp_c)/temp_m;
    temp_c1=temp_m*1920+temp_c;

    if side ==1
        im=rgb2gray(insertShape(mat2gray(im),'FilledPolygon',[0 0 0 temp_c temp_b 1080 1920 1080 1920 0],'color','black','opacity',1))>0;
    else
        im=rgb2gray(insertShape(mat2gray(im),'FilledPolygon',[0 0 0 temp_c 1920 temp_c1 1920 0],'color','black','opacity',1))>0;    
    end

    [H,T,R] = hough(im, 'Theta', theta{side}(2,:));
    P  = houghpeaks(H,20,'threshold',ceil(0.4*max(H(:))),'NHoodSize',[101 7]);
    lines = houghlines(im,T,R,P, 'Fillgap',80,'MinLength',100);
    temp=100*[lines.rho]+[lines.theta];
    [~,i1]=unique(temp','rows');
    lines=lines(i1);
    
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',5,'Color','green');

        m=(xy(2,2)-xy(1,2))/(xy(2,1)-xy(1,1));             
        c=xy(2,2)-m*xy(2,1);             
        plot([-c/m,(1080-c)/m],[0,1080],'LineWidth',1,'Color','red')
    end

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
        %if (x > 0) && (y > 0)
            ints(i,:)=[x,y];
%         else 
%             ints(i,:)=[10000,10000];
        %end
        plot(x,y, 'x', 'MarkerSize', 10, 'LineWidth', 2,'Color','yellow');
        i=i+1;
    end
    end
    sorted=sortrows(ints,2);
    %corners=sorted;
    corners=[sorted(1,:);sorted(2,:);sorted(4,:);sorted(5,:)];
    theta = lines(1).theta;

end