clear all; close all; clc;

org_img = imread('images/test4.jpg');
if size(org_img,1) < 300
    org_img = imresize(org_img,2);
end

image = double(org_img);
HC = HLS_Converter;
hls_img = HC.im_converter(image);
org_filtered = HC.hls_color_filter(org_img,hls_img);
gray_filtered_img = 0.299*org_filtered(:,:,1) + 0.587*org_filtered(:,:,2) + 0.114*org_filtered(:,:,3);

CD = Canny_Detector;
canny_img = CD.im_converter(CD,gray_filtered_img,0);

roi_img = roi_maker(canny_img);

HT = Hough_Transformer;
[rs,left,right] = HT.Transform(HT,roi_img);

figure;
subplot(1,4,1);
imshow(org_img);title('Original Image');
subplot(1,4,2);
imshow(uint8(hls_img));title('HLS Image');
subplot(1,4,3);
imshow(org_filtered);title('Original Filtered Image');
subplot(1,4,4);
imshow(gray_filtered_img);title('Gray Image');

figure;
subplot(1,2,1);
imshow(canny_img);title('Canny Image');
subplot(1,2,2);
imshow(roi_img);title('Canny Roi Image');

figure;
imshow(org_img); title('Original Hough Image');
line([left(1,2),left(end,2)],[left(1,1),left(end,1)],'color','red','LineWidth',3);
line([right(1,2),right(end,2)],[right(1,1),right(end,1)],'color','red','LineWidth',3);

figure;hold on;
axis([0 181 min(min(rs)) max(max(rs))]);
for x = 1 : size(rs,1)
    plot(1:181,(rs(x,:)),"-");
end


