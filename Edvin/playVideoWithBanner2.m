clear all;
close all;

vid = VideoReader('../real_liverpool_1.mp4');
output = VideoWriter('out2.mp4','MPEG-4');

%% enter the loop
open(output)
while hasFrame(vid)
    frame = readFrame(vid);
    corners = myIntersectionFinder(frame); 
    out = myInsertBanner(corners,frame);
    %out = insertMarker(frame,points,'Color','red','Size',6);
    %videoPlayer(out);      % Empty the memory buffer that stored acquired frames
    writeVideo(output,out);
end

close(output);
