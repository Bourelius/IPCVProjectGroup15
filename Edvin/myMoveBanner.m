function out = myMoveBanner(bannerPointsImage,trackedPoints,frame,bannerIm,blender)
%Edvin Bourelus
%2020-04-06
%newbannercorners is two of the trackedPoints
%oldBannerCorners is two from the warpedBanner
    bannerImGray = rgb2gray(bannerIm);
    bannerImCorners = [0,0;
                    0,size(bannerIm,1)
                    size(bannerIm,2),0;
                    size(bannerIm,2),size(bannerIm,1)];
                
    oldBannerCorners = [bannerPointsImage(2,:);bannerPointsImage(4,:)];
    newBannerCorners = [trackedPoints(1,:);trackedPoints(3,:)];
%     newBannerCorners = transformPointsForward(tformWorldToImage
%     frameWithMarkers = insertMarker(frame,oldBannerCorners,'Color','red','Size',6);
%     figure; imshow(frameWithMarkers);
%     frameWithMarkers = insertMarker(frame,newBannerCorners,'Color','red','Size',6);
%     figure; imshow(frameWithMarkers);
    tformOldToNew = estimateGeometricTransform(oldBannerCorners,newBannerCorners,'similarity');
    imagePoints = transformPointsForward(tformOldToNew,bannerPointsImage);
    
    
    tformBannerToImage = estimateGeometricTransform(bannerImCorners,imagePoints,'projective');
    
    imref = imref2d(size(frame));
    
    warpedBanner = imwarp(bannerImGray, tformBannerToImage, 'Outputview',imref);
%     figure;
%     imshow(warpedBanner,[]);
%     figure;
%     imshow(frame);
    mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
    mergedImages = step(blender,rgb2gray(frame), warpedBanner, mask);
    out = mergedImages;
end