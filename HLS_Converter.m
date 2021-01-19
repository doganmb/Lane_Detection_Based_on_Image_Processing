classdef HLS_Converter
   methods (Static)
       function hls_img = im_converter(image)
            image = image/255;
            [rows, cols, index] = size(image);
            
            L = zeros(rows,cols);
            S = zeros(rows,cols);
            H = zeros(rows,cols);

            for i = 1:rows
                for j = 1:cols
                    Vmax = max(image(i,j,:));
                    Vmin = min(image(i,j,:));
                    L(i,j) = (Vmax + Vmin) / 2;
                    if Vmax == Vmin
                        S(i,j) = 0;
                    elseif L(i,j) < 0.5
                        S(i,j) = (Vmax - Vmin) / (Vmax + Vmin);
                    elseif L(i,j) >= 0.5
                        S(i,j) = (Vmax - Vmin) / (2 - (Vmax + Vmin));
                    end
                    if Vmax == image(i,j,1)
                        H(i,j) = (image(i,j,2) - image(i,j,3))/(Vmax - Vmin); 
                    elseif Vmax == image(i,j,2)
                        H(i,j) = 120 + (60*(image(i,j,3) - image(i,j,1)))/(Vmax - Vmin);
                    elseif Vmax == image(i,j,3)
                        H(i,j) = 240 + (60*(image(i,j,1) - image(i,j,2)))/(Vmax - Vmin);
                    end
                end
            end
            
            H(H<0) = H(H<0) + 360;
            L = L*255;
            S = S*255;
            H = H/2;
            HLS_fthresh = zeros(rows,cols,3);
            HLS_fthresh(:,:,1) = H;
            HLS_fthresh(:,:,2) = L;
            HLS_fthresh(:,:,3) = S;
            
            hls_img = HLS_fthresh;
            
       end
       function filtered_img = hls_color_filter(org_img,hls_im)
            yellow_filter = (hls_im(:,:,1)<=40 & hls_im(:,:,3)>=100);
            white_filter = (hls_im(:,:,2)>200);
            back1 = org_img;
            back2 = org_img;
            back1(:,:,1) = uint8(yellow_filter) .* back1(:,:,1);
            back1(:,:,2) = uint8(yellow_filter) .* back1(:,:,2);
            back1(:,:,3) = uint8(yellow_filter) .* back1(:,:,3);
            back2(:,:,1) = uint8(white_filter) .* back2(:,:,1);
            back2(:,:,2) = uint8(white_filter) .* back2(:,:,2);
            back2(:,:,3) = uint8(white_filter) .* back2(:,:,3);
            filtered_img = back1 + back2;
       end
   end
end