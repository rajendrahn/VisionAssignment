function HW1_7()

Hmodel = [];
load('Hmodel.mat');

originalimage = imread('goi1_downsampled.jpg');
transformedImage = reverseWarp(originalimage, Hmodel);

homographyTransform = homography(originalimage,transformedImage);
homographyTransform = homographyTransform/homographyTransform(3,3);

resultImage1 = reverseWarp(originalimage, homographyTransform);

originalimage2 = imread('goi2_downsampled.jpg');
homographyTransform = homography(originalimage,originalimage2);
homographyTransform = homographyTransform/homographyTransform(3,3); 
resultImage2 = reverseWarp(originalimage, homographyTransform);

figure
subplot(1,3,1)
imshow(originalimage)
subplot(1,3,2)
imshow(transformedImage)
subplot(1,3,3)
imshow(resultImage1)

figure
subplot(1,3,1)
imshow(originalimage)
subplot(1,3,2)
imshow(originalimage2)
subplot(1,3,3)
imshow(resultImage2)
end


% inverse mapping function
function warpedImage = reverseWarp(originalImage, transform)
inverseTransform = inv(transform); %taking inverse once hence not using A/b
imageSize = size(originalImage);
warpedImage = uint8(zeros(imageSize));
for x = 1 : size(warpedImage,1)
    for y = 1 : size(warpedImage,2)
        location = inverseTransform*[x;y;1];
        location = round(location);%Nearest Neighbour
        location(1) = location(1) / location(3);
        location(2) = location(2) / location(3);
        if location(1) > 0 && location(2) > 0 && location(1) <= imageSize(1) && location(2) <= imageSize(2)
            warpedImage(x,y) = originalImage(location(1),location(2));
        end
    end
end
end