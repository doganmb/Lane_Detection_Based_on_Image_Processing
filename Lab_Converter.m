classdef Lab_Converter
    methods (Static)
        function lab_binary = lab_thresh(lab_image)
            channel1Min = 0.800;
            channel1Max = 1.000;

            channel2Min = 0.000;
            channel2Max = 1.000;

            channel3Min = 0.100;
            channel3Max = 1.000;

            lab_binary = (lab_image(:,:,1) >= channel1Min ) & (lab_image(:,:,1) <= channel1Max) & ...
                (lab_image(:,:,2) >= channel2Min ) & (lab_image(:,:,2) <= channel2Max) & ...
                ((lab_image(:,:,3) >= channel3Min ) & (lab_image(:,:,3) <= channel3Max));

        end
        function lab_image = rgb_lab_converter(obj,or_img)
            if ~isa(or_img,'double')
                or_img = double(or_img)/255;
            end
            rows = size(or_img,1);
            cols = size(or_img,2);
            lab_image = zeros(rows,cols,3);

            color_seg_matris = [0.412453, 0.357580, 0.180423; 
                                0.212671, 0.715160, 0.072169; 
                                0.019334, 0.119193, 0.950227];
            rgb_pivot_img = zeros(rows,cols,3);
            rgb_pivot_img(:,:,1) = reshape(obj.rgb_Pivot(reshape(or_img(:,:,1),rows*cols,1)),rows,cols,1);
            rgb_pivot_img(:,:,2) = reshape(obj.rgb_Pivot(reshape(or_img(:,:,2),rows*cols,1)),rows,cols,1);
            rgb_pivot_img(:,:,3) = reshape(obj.rgb_Pivot(reshape(or_img(:,:,3),rows*cols,1)),rows,cols,1);

            XYZ = reshape((reshape(rgb_pivot_img,rows*cols,3)*color_seg_matris'),rows,cols,3);
            X = reshape(obj.find_ab(reshape(XYZ(:,:,1),rows*cols,1)/0.950456),rows,cols,1);
            Y = reshape(obj.find_ab(reshape(XYZ(:,:,2),rows*cols,1)),rows,cols,1);
            Z = reshape(obj.find_ab(reshape(XYZ(:,:,3),rows*cols,1)/1.088754),rows,cols,1);

            lab_image(:,:,1) = reshape(obj.find_l(reshape(XYZ(:,:,2),rows*cols,1)),rows,cols,1);
            lab_image(:,:,2) = 500*(X - Y);
            lab_image(:,:,3) = 200*(Y - Z);
            lab_image = rescale(lab_image);
        end

        function result = find_ab(t)
            array = zeros(size(t));
            array(t > 0.008856) = nthroot(t(t > 0.008856),3);
            array(t <= 0.008856) = 7.787*t(t <= 0.008856) + 16/116;
            result = array;
        end
        function result = find_l(t)
            array = zeros(size(t));
            array(t > 0.008856) = 116*nthroot(t(t > 0.008856),3)- 16;
            array(t <= 0.008856) = 903.3*t(t <= 0.008856);
            result = array;
        end
        function result = rgb_Pivot(color)
            array = zeros(size(color));
            array(color <= 0.04045) = (color(color <= 0.04045)/12.92);
            array(color > 0.04045) = power((color(color > 0.04045) + 0.055)/1.055, 2.4);
            result = array;
        end
    end 
end