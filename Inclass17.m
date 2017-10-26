% Akash Mitra
% am132

%In this folder, you will find two images img1.tif and img2.tif that have
%some overlap. Use two different methods to align them - the first based on
%pixel values in the original images and the second using the fourier
%transform of the images. In both cases, display your results. 

img1 = imread('img1.tif');
img2 = imread('img2.tif');

figure;
subplot(1,2,1); imshow(img1,[]);
subplot(1,2,2); imshow(img2,[]);

%Visualizing overlap without alignment
diffs = zeros(1,800);
for i = 1:800
    %find overlap pixels
    pix1 = img1(:,(end-i):end);
    pix2 = img2(:,1:(1+i));
    %store difference
    diffs(i) = sum(sum(abs(pix1-pix2)))/i;
end
figure; plot(diffs);
xlabel('Overlap'); ylabel('Mean Difference');

% Representing Pixel based Overlap
[~,overlap] = min(diffs);
img2_align = [zeros(800,size(img2,2)-overlap+1), img2];
imshowpair(img1,img2_align);

%Visualizing overlap AFTER alignment
diffs = zeros(1,800);
for i = 1:800
    %find overlap pixels
    pix1 = img1(:,(end-i):end);
    pix2 = img2_align(:,1:(1+i));
    %store difference
    diffs(i) = sum(sum(abs(pix1-pix2)))/i;
end
figure; plot(diffs);
xlabel('Overlap'); ylabel('Mean Difference');



%Fourier Transform

img1ft = fft2(img1);
img2ft = fft2(img2);
[nr, nc] = size(img2ft);
CC = ifft2(img1ft.*conj(img2ft));
CCabs = abs(CC);
figure;
imshow(CCabs,[]);

[row_shift col_shift] = find(CCabs == max(CCabs(:)));
% Changing shift to represent relative shifts
nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);
row_shift = nr(row_shift);
col_shift = nc(col_shift);

% Representing Fourier Transform Overlap
img_shift = zeros(size(img2)+[row_shift col_shift]);
img_shift((end-799):end,(end-799:end)) = img2;
imshowpair(img1,img_shift);



% Comparing overlap b/w Pixel based method and Fourier Transform overlap
subplot(1,2,1); imshowpair(img1,img2_align);
subplot(1,2,2); imshowpair(img1,img_shift);



