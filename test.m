% inverse mapping function

function test()

f = @(x, T) tran(x,T);

% maketform arguments
ndims_in = 2;
ndims_out = 2;
forward_mapping = [];
inverse_mapping = f;
Hmodel = [];
load('Hmodel.mat');
tform = maketform('custom', ndims_in, ndims_out, ...
    forward_mapping, inverse_mapping, Hmodel);

body = imread('goi1_downsampled.jpg');
body2 = imtransform(body, tform);

H = homography(body,body2);
H = H/H(3,3);
tform = maketform('custom', ndims_in, ndims_out, ...
    forward_mapping, inverse_mapping, H);


body3 = imtransform(body, tform);

body4 = imread('goi2_downsampled.jpg');

H = homography(body,body4);
H = H/H(3,3); 
tform = maketform('custom', ndims_in, ndims_out, ...
    forward_mapping, inverse_mapping, H);
body5 = imtransform(body, tform);

subplot(1,5,1)
imshow(body)
subplot(1,5,2)
imshow(body2)

subplot(1,5,3)
imshow(body3)

subplot(1,5,4)
imshow(body4)

subplot(1,5,5)
imshow(body5)
end

function y = tran(x, T)
if size(x,1) == 1  
x=x';
x=[x;1];
y=T.tdata*x;
y = y/y(3,1);
y(3,:) = [];
y = y';
else
    y = x;
end
end