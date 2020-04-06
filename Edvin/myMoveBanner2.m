function out = myMoveBanner2(corners,trackedPoints,frame,bannerIm,blender,theta)
%Edvin Bourelus
%2020-04-06
%newbannercorners is two of the trackedPoints
%oldBannerCorners is two from the warpedBanner
    bannerImGray = rgb2gray(bannerIm);
    bannerImCorners = [0,0;
                    0,size(bannerIm,1)
                    size(bannerIm,2),0;
                    size(bannerIm,2),size(bannerIm,1)];
                
    %oldBannerCorners = [corners(2,:);corners(4,:)];
    oldBannerCorners = [corners(1,:);corners(3,:)];
    newBannerCorners = [trackedPoints(1,:);trackedPoints(3,:)];
%     newBannerCorners = transformPointsForward(tformWorldToImage
%     frameWithMarkers = insertMarker(frame,oldBannerCorners,'Color','red','Size',6);
%     figure; imshow(frameWithMarkers);
%     frameWithMarkers = insertMarker(frame,newBannerCorners,'Color','red','Size',6);
%     figure; imshow(frameWithMarkers);
    tformOldToNew = estimateGeometricTransform(oldBannerCorners,newBannerCorners,'similarity');
    newCorners = transformPointsForward(tformOldToNew,corners);
    
    worldPoints = [0, 0;
               0, 360;
               550, 0;
               550, 360];
    bannerPoints = [0,0;
                    0,size(bannerIm,1)
                    size(bannerIm,2),0;
                    size(bannerIm,2),size(bannerIm,1)];
    bannerLocationWorld = [550, -200;
               550, 0;
               1000, -200;
               1000, 0];
    
    tformWorldToImage = estimateGeometricTransform(worldPoints,newCorners,'projective');
    bannerLocationImage = transformPointsForward(tformWorldToImage,bannerLocationWorld);
    shadowLocationImage = bannerLocationImage;
    bannerLocationImage(1,:) = myAnglePointCalculator(theta, bannerLocationImage(2,:), bannerLocationImage(1,:));
    bannerLocationImage(3,:) = myAnglePointCalculator(theta, bannerLocationImage(4,:), bannerLocationImage(3,:));
    
%     tformBannerToImage = estimateGeometricTransform(bannerPoints,bannerLocationImage,'projective');
%     
%     imref = imref2d(size(frame));
%     
%     warpedBanner = imwarp(bannerImGray, tformBannerToImage, 'Outputview',imref);
% %     figure(100)
% %     imshow(warpedImage2)
%     %Merge images
%     mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
%     mergedImages = step(blender,rgb2gray(frame), warpedBanner, mask);
%     out = mergedImages;
%     
      
    tformBannerToImage = estimateGeometricTransform(bannerPoints,bannerLocationImage,'projective');
    tformShadow = estimateGeometricTransform(bannerPoints,shadowLocationImage,'projective');
    
    imref = imref2d(size(frame));
   
    warpedBanner = imwarp(bannerImGray, tformBannerToImage, 'Outputview',imref);

    mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
    maskShadow = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformShadow,'OutputView',imref);
    maskShadow = not(maskShadow);
    M = ones(size(maskShadow));
    M(maskShadow==0) = 0.3;
    background = rgb2gray(frame) .* uint8(M);
    mergedImages = step(blender,background, warpedBanner, mask);
    out = mergedImages;
end