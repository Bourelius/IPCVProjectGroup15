function out = myInsertBanner(corners,frame1, theta,side)
    bannerIm = imread('..\UT_Logo_Black_EN.jpg');
    bannerImGray = rgb2gray(bannerIm);

    worldPoints = [0, 0; 0, 360; 550, 0; 550, 360];
    bannerLocationWorld = [550, -200; 550, 0; 1000, -200; 1000, 0];

    if side==1
        bannerPoints = [0,0; 0,size(bannerIm,1); size(bannerIm,2),0; size(bannerIm,2),size(bannerIm,1)];
    else
        bannerPoints = [size(bannerIm,2),0; size(bannerIm,2),size(bannerIm,1);0,0; 0,size(bannerIm,1)];
    end

    imagePoints = corners;
    
    tformWorldToImage = estimateGeometricTransform(worldPoints,imagePoints,'projective');
    bannerLocationImage = transformPointsForward(tformWorldToImage,bannerLocationWorld);
    
    imagePoints = bannerLocationImage;
    
    %P1 and P3 are the points that have to be recalculated for 60°
    if side==1
        imagePoints(1,:) = myAnglePointCalculatorRight(theta, imagePoints(2,:), imagePoints(1,:));
        imagePoints(3,:) = myAnglePointCalculatorRight(theta, imagePoints(4,:), imagePoints(3,:));
    else
        imagePoints(1,:) = myAnglePointCalculatorLeft(theta, imagePoints(1,:), imagePoints(2,:));
        imagePoints(3,:) = myAnglePointCalculatorLeft(theta, imagePoints(3,:), imagePoints(4,:));
    end    
    tformBannerToImage = estimateGeometricTransform(bannerPoints,imagePoints,'projective');
    tformShadow = estimateGeometricTransform(bannerPoints,bannerLocationImage,'projective');
    
    imref = imref2d(size(frame1));
    %Make blender object
    blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port'); 
    
    warpedImage2 = imwarp(bannerIm, tformBannerToImage, 'Outputview',imref);
    h = fspecial('gaussian', 3, 3);
    warpedImage2 = imfilter(warpedImage2, h, 'replicate');
%     figure(100)
%     imshow(warpedImage2)
    %Merge images with shadow
    mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
    
    maskShadow = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformShadow,'OutputView',imref);
    maskShadow = not(maskShadow);
    M = ones(size(maskShadow));
    M(maskShadow==0) = 0.7;
    background(:,:,1) = double(frame1(:,:,1)) .* M;
    background(:,:,2) = double(frame1(:,:,2)) .* M;
    background(:,:,3) = double(frame1(:,:,3)) .* M;
    mergedImages = step(blender,uint8(background), warpedImage2, mask);
    out = mergedImages;
end