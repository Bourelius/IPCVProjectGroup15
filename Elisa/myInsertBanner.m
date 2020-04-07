function out = myInsertBanner(corners,frame1, theta)
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
    
    %P1 and P3 are the points that have to be recalculated for 60°
    imagePoints(1,:) = myAnglePointCalculator(theta, imagePoints(2,:), imagePoints(1,:));
    imagePoints(3,:) = myAnglePointCalculator(theta, imagePoints(4,:), imagePoints(3,:));
    
    tformBannerToImage = estimateGeometricTransform(bannerPoints,imagePoints,'projective');
    tformShadow = estimateGeometricTransform(bannerPoints,bannerLocationImage,'projective');
    
    imref = imref2d(size(frame1));
    %Make blender object
    blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port'); 
    
    warpedImage2 = imwarp(bannerIm, tformBannerToImage, 'Outputview',imref);
%     figure(100)
%     imshow(warpedImage2)
    %Merge images with shadow
    mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
    
    maskShadow = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformShadow,'OutputView',imref);
    maskShadow = not(maskShadow);
    M = ones(size(maskShadow));
    M(maskShadow==0) = 0.5;
    background(:,:,1) = double(frame1(:,:,1)) .* M;
    background(:,:,2) = double(frame1(:,:,2)) .* M;
    background(:,:,3) = double(frame1(:,:,3)) .* M;
    
    mergedImages = step(blender,uint8(background), warpedImage2, mask);
    out = mergedImages;
end