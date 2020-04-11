function out = myMergeBannerToFrame(corners,trackedPoints,frame,bannerIm,blender,theta,imref, side)
%MYMERGEBANNERTOFRAME Merge the banner in the right geometric transform to
%current frame with shadow
                
    oldBannerCorners = [corners(1,:);corners(3,:)];
    newBannerCorners = [trackedPoints(1,:);trackedPoints(3,:)];

    tformOldToNew = estimateGeometricTransform(oldBannerCorners,newBannerCorners,'similarity');
    newCorners = transformPointsForward(tformOldToNew,corners);
    
    worldPoints = [0, 0;
               0, 550;
               2484, 0;
               2484, 550];
    if side==1
        bannerImCorners = [0,0; 0,size(bannerIm,1); size(bannerIm,2),0; size(bannerIm,2),size(bannerIm,1)];
    else
        bannerImCorners = [size(bannerIm,2),0; size(bannerIm,2),size(bannerIm,1);0,0; 0,size(bannerIm,1)];
    end
    bannerLocationWorld = [1500, -350;
               1500, -150;
               2500, -350;
               2500, -150];
    
    tformWorldToImage = estimateGeometricTransform(worldPoints,newCorners,'projective');
    bannerLocationImage = transformPointsForward(tformWorldToImage,bannerLocationWorld);
    
    shadowLocationImage = bannerLocationImage;
    tformShadow = estimateGeometricTransform(bannerImCorners,shadowLocationImage,'projective');
    
    if side==1
        bannerLocationImage(1,:) = myAnglePointCalculatorRight(theta, bannerLocationImage(2,:), bannerLocationImage(1,:));
        bannerLocationImage(3,:) = myAnglePointCalculatorRight(theta, bannerLocationImage(4,:), bannerLocationImage(3,:));
    else
        bannerLocationImage(1,:) = myAnglePointCalculatorLeft(theta, bannerLocationImage(1,:), bannerLocationImage(2,:));
        bannerLocationImage(3,:) = myAnglePointCalculatorLeft(theta, bannerLocationImage(3,:), bannerLocationImage(4,:));
    end  
    
    tformBannerToImage = estimateGeometricTransform(bannerImCorners,bannerLocationImage,'projective');
    
    warpedBanner = imwarp(bannerIm, tformBannerToImage, 'Outputview',imref);
    h = fspecial('gaussian',2,1);
    warpedBanner = imfilter(warpedBanner, h, 'replicate');
    
    mask = imwarp(true(size(bannerIm,1),size(bannerIm,2)),tformBannerToImage,'OutputView',imref);
    maskShadow = imwarp(true(size(bannerIm,1),size(bannerIm,2)),tformShadow,'OutputView',imref);
    maskShadow = not(maskShadow);
    M = ones(size(maskShadow));
    M(maskShadow==0) = 0.7;
    background(:,:,1) = double(frame(:,:,1)) .* M;
    background(:,:,2) = double(frame(:,:,2)) .* M;
    background(:,:,3) = double(frame(:,:,3)) .* M;
    
    mergedImages = step(blender,uint8(background), warpedBanner, mask);
    out = mergedImages;
end

