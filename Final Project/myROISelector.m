function [cluster] = myROISelector(frame)
%MYROISELECTOR Function to get most dominant colour segment
%   using L*a*b and HSV colour space

    I = rgb2hsv(frame);
    % Define thresholds for 'Hue'. Modify these values to filter out different range of colors.
    channel1Min = 0.110;
    channel1Max = 0.130;
    % Define thresholds for 'Saturation'
    channel2Min = 0.600;
    channel2Max = 1.000;
    % Define thresholds for 'Value'
    channel3Min = 0.400;
    channel3Max = 1.000;
    % Create mask based on chosen histogram thresholds
    BW = ( (I(:,:,1) >= channel1Min) &(I(:,:,1) <= channel1Max) ) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    % Initialize output masked image based on input image.
    maskedRGBimage = frame;
    % Set background pixels where BW is false to zero.
    maskedRGBimage(repmat(BW,[1 1 3])) = 0;

    lab_frame = rgb2lab(maskedRGBimage);
    
    ab = lab_frame(:,:,2:3);
    ab = im2single(ab);
    nColors = 3;
    % repeat the clustering 3 times to avoid local minima
    pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);

    % dominant segment = largest segment = cluster1
    mask1 = pixel_labels==1;

    mask2 = pixel_labels==2;
    mask3 = pixel_labels==3;
    
    if sum(mask1(:)) > sum(mask2(:)) && sum(mask1(:)) > sum(mask3(:))
        final_mask = mask1;
    elseif sum(mask2(:)) > sum(mask1(:)) && sum(mask2(:)) > sum(mask3(:))  
        final_mask = mask2;
    elseif sum(mask3(:)) > sum(mask1(:)) && sum(mask3(:)) > sum(mask2(:))
        final_mask = mask3;
    end
    
    cluster = frame .* uint8(final_mask);

end

