function roi_img = roi_maker(img)
    
    [rows,cols,k] = size(img);
    
    upper_y = round(rows*3/5);
    upper_x1 = round((cols*2)/5);
    upper_x2 = round((cols*3)/5);

    xs = [round(cols/9)  upper_x1 upper_x2  round(cols*8/9)];
    ys = [rows  upper_y upper_y  rows];

    mask = poly2mask(xs,ys,rows,cols);
%     imshow(mask);
    if k > 1
        new_img = zeros(rows,cols,k);
        for i = 1 : k
            new_img(:,:,i) = img(:,:,i).*uint8(mask);
        end
    else
        if isa(img,'logical') 
            new_img = img.*mask;
        elseif isa(img,'double')
            new_img = img.*double(mask);
        else
            new_img = img.*uint8(mask);     
        end
    end
    roi_img = new_img;
end
