function [cluster1] = myColourFilter(frame)
%COLOUR_FILTER Function to get most dominant colour segment
%   using L*a*b 
    lab_frame = rgb2lab(frame);

    ab = lab_frame(:,:,2:3);
    ab = im2single(ab);
    nColors = 5;
    % repeat the clustering 3 times to avoid local minima
    pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);

    % dominant segment = largest segment = cluster1
    mask1 = pixel_labels==1;
    cluster1 = frame .* uint8(mask1);
end

