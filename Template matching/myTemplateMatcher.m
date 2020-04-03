function corners = myTemplateMatcher(im,template)
%     templateSize = size(template);
%     height = templateSize(2);
%     width = templateSize(1);
%     
    correlationOutput = normxcorr2(template,im);

    % Find out where the normalized cross correlation image is brightest.
    [~, maxIndex] = maxk(abs(correlationOutput(:)),10);
    [yPeak, xPeak] = ind2sub(size(correlationOutput),maxIndex);
    %peaks = [yPeak-height, xPeak-width]; % correct for size difference 
    %corners = peaks;
    corrPeaks = [xPeak, yPeak]; 
    corr_offset = [(xPeak-size(template,2)) (yPeak-size(template,1))];
    offset = corrPeaks-corr_offset;
    corrPeaks = corrPeaks - offset./2;
    
    %corrPeaks = uniquetol(corrPeaks,'ByRows',100);
    for i = 1:1:length(corrPeaks)
        peak = corrPeaks(i,:);
        for n = i+1:1:length(corrPeaks)
            currentPeak = corrPeaks(n,:);
            diff = norm(currentPeak - peak);
            if diff < 100
                corrPeaks(n,:) = [-1 -1];
            end
            lastPeak = currentPeak;
        end
    end
    corrPeaks(corrPeaks == [-1 -1]) = [ ];
    corrPeaks = reshape(corrPeaks,size(corrPeaks,2)/2,2);
    
    corners = corrPeaks;
    corners = cornerPoints(corners);
end