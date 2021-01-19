function [perspective_image, color_window_img, hists] =  perspective_converter(bin_img,inverse)
    image = uint8((bin_img > 0)*255);
    [rows,cols,k] = size(image);
    
    if inverse == 1
        X1 = 450 ; Y1 = 580; % Source Points
        X2 = 700; Y2 = 190;
        X3 = 450 ; Y3 = 730;
        X4 = 700 ; Y4 = 1160;

        x1 = 10; y1 = 380;   % Destination Points
        x2 = 720; y2 = 380; 
        x3 = 10; y3 = 950;   
        x4 = 720; y4 = 950;
    else
        x1 = 450 ; y1 = 580; % Source Points
        x2 = 700; y2 = 190;
        x3 = 450 ; y3 = 730;
        x4 = 700 ; y4 = 1160;

        X1 = 10; Y1 = 380;   % Destination Points
        X2 = 720; Y2 = 380; 
        X3 = 10; Y3 = 950;   
        X4 = 720; Y4 = 950;
    end
    P = [X1;Y1;X2;Y2;X3;Y3;X4;Y4];

    Q = [x1, y1, 1, 0, 0, 0, -X1*x1, -X1*y1;
         0, 0, 0, x1, y1, 1, -Y1*x1, -Y1*y1;
         x2, y2, 1, 0, 0, 0, -X2*x2, -X2*y2;
         0, 0, 0, x2, y2, 1, -Y2*x2, -Y2*y2;
         x3, y3, 1, 0, 0, 0, -X3*x3, -X3*y3;
         0, 0, 0, x3, y3, 1, -Y3*x3, -Y3*y3;
         x4, y4, 1, 0, 0, 0, -X4*x4, -X4*y4;
         0, 0, 0, x4, y4, 1, -Y4*x4, -Y4*y4];

    M = Q\P;
    perspective_img = zeros(rows,cols);
    
    for i=1:rows
        for j=1:cols
            X = round((M(1)*i + M(2)*j + M(3))/(M(7)*i + M(8)*j + 1));
            Y = round((M(4)*i + M(5)*j + M(6))/(M(7)*i + M(8)*j + 1));
            if inverse == 1
                if (X>0 && X<rows && Y>0 && Y<cols) 
                    perspective_img(X,Y) = image(i,j);
                end
            elseif ( X > X1 && X < X4 && Y > Y1 && Y < Y4)
                perspective_img(X,Y) = image(i,j);
            end     
        end
    end

    param = 7;
    for x=1 : rows-param
        for y=1 : cols-param
            if perspective_img(x,y) == 0 
                perspective_img(x,y) = mean(mean(nonzeros((perspective_img(x:x+param ,y:y+param)))));
            end
        end
    end
    
    perspective_img(isnan(perspective_img)) = 0;
    pers_hist = sum(perspective_img);
    left_hist = [];
    for i = 1 : round(rows/12)-1 : rows - round(rows/12)
        total = sum(perspective_img(i:i + round(rows/12),1:(cols/2)));
        left_hist(end+1) = find(total == max(total),1);
    end
    right_hist = [];
    for i = 1 : round(rows/12)-1 : rows - round(rows/12)
        total = sum(perspective_img(i:i + round(rows/12),(cols/2):cols));
        right_hist(end+1) = find(total == max(total),1) + cols/2;
    end

    RGB_Image = uint8(zeros(rows,cols,3));
    RGB_Image(:,1:cols/2,1) = perspective_img(:,1:cols/2)*255;
    RGB_Image(:,cols/2+1:cols,3) =  perspective_img(:,cols/2+1:cols)*255;
    
    color_window_img = RGB_Image;
    perspective_image = perspective_img;
    hists = [left_hist;right_hist];

end