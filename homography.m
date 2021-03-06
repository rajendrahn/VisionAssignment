function H =  homography(image1, image2)

% Find SIFT keypoints for each image
[~, des1, loc1] = sift(image1);
[~, des2, loc2] = sift(image2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end
j = 0;
for i = 1: size(des1,1)
  if (match(i) > 0)
      j = j + 1;
      X1i = loc1(i, 1);
      Y1i = loc1(i, 2);
      X2i = loc2(match(i),1);
      Y2i = loc2(match(i),2);
      A(j,:) = [-X1i, -Y1i, -1, 0, 0, 0, X2i*X1i, X2i*Y1i, X2i];
      j = j + 1;
      A(j, :) = [ 0, 0, 0, -X1i, -Y1i, -1, Y2i*X1i, Y2i*Y1i, Y2i];
  end
end

[~,~,V] = svd(A);

H = V(:,end);
H = reshape(H,3,3);
H = H';

end