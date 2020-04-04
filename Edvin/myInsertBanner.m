function out = myInsertBanner(corners,frame1)
    bannerIm = imread('..\UT_Logo_Black_EN.jpg');
    bannerImGray = rgb2gray(bannerIm);
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

    imagePoints = zeros(4,2);
    %sortedCorners = sortrows(corners,2);
    imagePoints(1,:) = corners(1,:);
    imagePoints(2,:) = corners(2,:);  
    imagePoints(3,:) = corners(3,:);          
    imagePoints(4,:) = corners(4,:);
    
    tformWorldToImage = estimateGeometricTransform(worldPoints,imagePoints,'projective');
    bannerLocationImage = transformPointsForward(tformWorldToImage,bannerLocationWorld);
    
    imagePoints(1,:) = bannerLocationImage(1,:);
    imagePoints(2,:) = bannerLocationImage(2,:);
    imagePoints(3,:) = bannerLocationImage(3,:);         
    imagePoints(4,:) = bannerLocationImage(4,:);
    
    tformBannerToImage = estimateGeometricTransform(bannerPoints,imagePoints,'projective');
    
    imref = imref2d(size(frame1));
    %Make blender object
    blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port'); 
    
    warpedImage2 = imwarp(bannerImGray, tformBannerToImage, 'Outputview',imref);
%     figure(100)
%     imshow(warpedImage2)
    %Merge images
    mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
    mergedImages = step(blender,rgb2gray(frame1), warpedImage2, mask);
    out = mergedImages;
end