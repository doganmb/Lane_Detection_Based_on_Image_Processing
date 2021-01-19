classdef Canny_Detector
    methods (Static)
        function canny_img = im_converter(obj,img,gui)
            img = double(img);
            [rows,cols] = size(img);
            kernel_size = 3;
            gauss_f = obj.gauss_2d(kernel_size,2);
            filtered_image = img;
            for i = 1:rows - 4
                for j = 1: cols - 4
                    filtered_image(i,j) = sum(img(i:i+4,j:j+4).*gauss_f,"all");
                end
            end
            % filtered_image = conv2(img,gauss_f,'same');
            if gui == 1
                figure;
                subplot(1,2,1);
                imshow(uint8(filtered_image));
            end
            
            % Sobel
            gradient_x = [-1 0 1;
                          -2 0 2; 
                          -1 0 1];
            gradient_y = [-1 -2 -1; 
                           0 0 0; 
                          1 2 1];
            gradient_img = zeros(rows,cols);
            kernel_size = 2;

            for i = 1 : rows - kernel_size
                for j = 1 : cols - kernel_size
                    gx = sum(sum(filtered_image(i:i+2,j:j+2)*gradient_x));
                    gy = sum(sum(filtered_image(i:i+2,j:j+2)*gradient_y));
                    gradient_img(i,j) = sqrt(gx^2 + gy^2); 
                end
            end

            %  Threshold
            gradient_img = gradient_img - min(min(gradient_img));
            gradient_img = gradient_img/max(max(gradient_img));
            gradient_img = imbinarize(gradient_img,"global");
            
            if gui == 1
                subplot(1,2,2);
                imshow(gradient_img);
            end
            
            % Erode
            smoot_img = double(gradient_img);
            erode_filter = [0,1,0;1,1,1;0,1,0];
            for i = 1 : rows - 2
                for j = 1 : cols - 2
                    ef = sum(sum(smoot_img(i:i+2,j:j+2).*erode_filter));
                    smoot_img(i,j) = round(ef/9);
                end
            end
            % Dilate
            dilate_filter = [1,1,1;1,1,1;1,1,1] * 3;
            for i = 1 : rows - 2
                for j = 1 : cols - 2
                    ef = sum(sum(smoot_img(i:i+2,j:j+2).*dilate_filter));
                    smoot_img(i,j) = round((ef)/9);
                end
            end
            smoot_img(smoot_img >= 1) = 255;
            canny_img = smoot_img;
            
        end
        function filter = gauss_2d(N,sigma)
           [x,y]=meshgrid(round(-N/2):round(N/2), round(-N/2):round(N/2));
           filter=exp(-x.^2/(2*sigma^2)-y.^2/(2*sigma^2));
           filter=filter./sum(filter(:));
        end
        function sobel_im = sobel_converter(img)
            [rows,cols,k] = size(img);
            if k > 1
                img = 0.299*img(:,:,1) + 0.587*img(:,:,2) + 0.114*img(:,:,3);
            end
            % Sobel
            gradient_x = [-1 0 1;
                          -2 0 2; 
                          -1 0 1];
            gradient_y = [-1 -2 -1; 
                           0 0 0; 
                          1 2 1];
            gradient_img = zeros(rows,cols);
            kernel_size = 2;

            for i = 1 : rows - kernel_size
                for j = 1 : cols - kernel_size
                    gx = sum(sum(img(i:i+2,j:j+2)*gradient_x));
                    gy = sum(sum(img(i:i+2,j:j+2)*gradient_y));
                    gradient_img(i,j) = sqrt(gx^2 + gy^2); 
                end
            end
            gradient_img = gradient_img - min(min(gradient_img));
            gradient_img = gradient_img/max(max(gradient_img));
            sobel_im = gradient_img; 
        end
    end
end