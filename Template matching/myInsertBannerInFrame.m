function out = myInsertBannerInFrame(corners,frame1)
    bannerIm = imread('C:\Users\Gebruiker\Pictures\banner00.jpg');
    bannerImGray = rgb2gray(bannerIm);
    worldPoints = [541.6, 0;
               541.6, 55;
               358.4, 0;
               358.4, 55];
    bannerPoints = [1299,0;
                    1299,178
                    0,0;
                    0,178];
    bannerLocationWorld = [ 658.4, -55;
                            658.4,0;
                            548.4, -55;
                            548.4, 0 ];

    imagePoints = zeros(4,2);
    sortedCorners = sortrows(corners,2);
    imagePoints(1,:) = sortedCorners(2,:);
    imagePoints(2,:) = sortedCorners(3,:);  
    imagePoints(3,:) = sortedCorners(4,:);          
    imagePoints(4,:) = sortedCorners(5,:);
    
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

    %Merge images
    mask = imwarp(true(size(bannerImGray,1),size(bannerImGray,2)),tformBannerToImage,'OutputView',imref);
    mergedImages = step(blender,frame1, warpedImage2, mask);
    out = mergedImages;
end