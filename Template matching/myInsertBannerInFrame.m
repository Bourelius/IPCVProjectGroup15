function out = myInsertBannerInFrame(corners,frame1,validity)
    bannerIm = imread('C:\Users\Gebruiker\Pictures\selfie.jpg');
    bannerImGray = rgb2gray(bannerIm);
    worldPoints = [541.6, 0;
               541.6, 55;
               358.4, 0;
               358.4, 55];
%     bannerPoints = [1299,0;
%                     1299,178
%                     0,0;
%                     0,178];
    bannerPoints = [3456,0; 3456,4608; 0,0; 0,4608];
    bannerLocationWorld = [ 558.4, -35;
                            558.4,0;
                            448.4, -35;
                            448.4, 0 ];
    
    imagePoints = zeros(4,2);
    [sortedCorners,indexes] = sortrows(corners,2);
    
    if validity(indexes(4)) == 0
        worldPoints = [541.6, 0;
              651.6, 0;
               358.4, 0;
               358.4, 55];
        imagePoints(1,:) = sortedCorners(2,:);
        imagePoints(2,:) = sortedCorners(3,:);  
        imagePoints(3,:) = sortedCorners(1,:);          
        imagePoints(4,:) = sortedCorners(5,:);
    else
        imagePoints(1,:) = sortedCorners(2,:);
        imagePoints(2,:) = sortedCorners(3,:);  
        imagePoints(3,:) = sortedCorners(4,:);          
        imagePoints(4,:) = sortedCorners(5,:);
    end
    
     if validity(indexes(5)) == 0
        worldPoints = [541.6, 0;
                       541.6, 55;
                       358.4, 0;
                       651.6, 0];
        imagePoints(1,:) = sortedCorners(2,:);
        imagePoints(2,:) = sortedCorners(3,:);  
        imagePoints(3,:) = sortedCorners(4,:);          
        imagePoints(4,:) = sortedCorners(1,:);
    else
        imagePoints(1,:) = sortedCorners(2,:);
        imagePoints(2,:) = sortedCorners(3,:);  
        imagePoints(3,:) = sortedCorners(4,:);          
        imagePoints(4,:) = sortedCorners(5,:);
    end
    
    [tformWorldToImage,~,~,status] = estimateGeometricTransform(worldPoints,imagePoints,'projective');
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