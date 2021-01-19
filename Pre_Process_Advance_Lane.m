clear all; close all; clc;

org_img = imread('images/test7.jpg');
if size(org_img,1) < 300
    org_img = imresize(org_img,2);
end
image = double(org_img);
[rows,cols,k] = size(image);

LC = Lab_Converter;
lab_img = LC.rgb_lab_converter(LC,image);
lab_binary = LC.lab_thresh(lab_img);

HC = HLS_Converter;
hls_img = HC.im_converter(image);
org_filtered = HC.hls_color_filter(org_img,hls_img);
gray_filtered_img = 0.299*org_filtered(:,:,1) + 0.587*org_filtered(:,:,2) + 0.114*org_filtered(:,:,3);
hls_binary = imbinarize(gray_filtered_img,"adaptive");

CD = Canny_Detector; % Canny uygulanmýyor sadece sobel fonksiyonu kullanýlýyor
sobel_img = CD.sobel_converter(image);
sobel_thresh = imbinarize(sobel_img,"adaptive");

combined = sobel_thresh & hls_binary & lab_binary;
combined_roi_img = roi_maker(combined);

[perspective_image, color_perspective_img, hists] = perspective_converter(combined_roi_img,0);

[founded_lanes,hists] = hist_point_inverser(hists);

mask = poly2mask(founded_lanes(:,2),founded_lanes(:,1),rows,cols);
green_mask_img = org_img;
green_k = green_mask_img(:,:,2);
green_k(mask) = 255;
green_mask_img(:,:,2) = green_k;

figure;
subplot(3,3,1);
imshow(org_img);title('Original Image');
subplot(3,3,2);
imshow(uint8(hls_img));title('HLS Image');
subplot(3,3,3);
imshow(hls_binary);title('HLS Binary Image');
subplot(3,3,4);
imshow(org_img);title('Original Image');
subplot(3,3,5);
imshow(sobel_img);title('Sobel Image');
subplot(3,3,6);
imshow(sobel_thresh);title('Sobel Thresh Image');
subplot(3,3,7);
imshow(org_img);title('Original Image');
subplot(3,3,8);
imshow(lab_img);title('Lab Image');
subplot(3,3,9);
imshow(lab_binary);title('Lab Binary Image');

figure;
subplot(1,2,1);
imshow(combined); title('Combined Image');
subplot(1,2,2);
imshow(combined_roi_img);title('Combined Roi Image');

figure; 
imshow(uint8(perspective_image));title('Perspective Image');

figure;
subplot(2,1,1);hold on;
imshow(color_perspective_img);title('Sliding Windows');
for i = 1 : 12
    if hists(1,i) > 1
        rectangle('Position', [hists(1,i)-50, (i-1)*round(rows/12), 100, round(rows/12)], 'EdgeColor', 'g', 'LineWidth', 2);
    end
    if hists(2,i) > cols/2 + 1
        rectangle('Position', [hists(2,i)-50, (i-1)*round(rows/12), 100, round(rows/12)], 'EdgeColor', 'g', 'LineWidth', 2);
    end
end
subplot(2,1,2);
plot(sum(perspective_image));
figure;
imshow(green_mask_img);title('Final Image');

