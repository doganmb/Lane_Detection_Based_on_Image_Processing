classdef Hough_Transformer
   properties
    rows;
    cols;
   end
   methods (Static)
       function [rs,left,right] = Transform(obj,img)
            global rows;
            global cols;
            [rows,cols] = size(img);
            all_eq = zeros(rows*cols,181);
            count = 1;
            tetas = 0:1:180;
            for i = round(rows/2) : rows
                for j = 100 : cols 
                    if img(i,j) == 255 | img(i,j) == 1
                        all_eq(count,:) = round(i*cosd(tetas) + j*sind(tetas));
                        count = count + 1;
                    end
                end
            end
            all_eq(count:end,:) = [];
            rs = all_eq;
            [left,right] = obj.find_max_cords(obj,all_eq);
       end
       function res = formula(teta,x,r)
            res = round(-(cosd(teta)/sind(teta))*x+(r/sind(teta))); 
       end
       function [left,right] = find_max_cords(obj,all_eq)
            global rows;
            global cols;
            temp_size1 = 0;
            temp_rs1 = 0;
            temp_value1 = 0;
            for i = 1 : 91
                mod = mode(all_eq(:,i));
                number = sum(all_eq(:,i)==mod);
                if temp_size1 < number
                    temp_rs1 = i;
                    temp_size1 = number;
                    temp_value1 = mod;
                end
            end
            temp_size2 = 0;
            temp_rs2 = 0;
            temp_value2 = 0;
            for i = 91 : 181
                mod = mode(all_eq(:,i));
                number = sum(all_eq(:,i)==mod);
                if temp_size2 < number
                    temp_rs2 = i;
                    temp_size2 = number;
                    temp_value2 = mod;
                end
            end
            count = 1;
            cords1 = zeros(rows,2);
            for i = round(rows/4) : rows
               y = obj.formula(temp_rs1,i,temp_value1);
               if (0 < y) && (y< cols)
                   cords1(count,:) = [i,y];
                   count = count + 1;
               end
            end
            cords1(count:end,:) = [];
            count = 1;
            cords2 = zeros(rows,2);
            for i = round(rows/4) : rows
               y = obj.formula(temp_rs2,i,temp_value2);
               if (0 < y) && (y < cols)
                   cords2(count,:) = [i,y];
                   count = count + 1;
               end
            end
            cords2(count:end,:) = [];
            if size(cords1,1) < size(cords2,1)
                min_cords = size(cords1,1);
            else
                min_cords = size(cords2,1);
            end
            for i = 1 : min_cords 
              if cords1(i,2) < cords2(i,2) 
                  cords1(1:i-1,:) = [];
                  cords2(1:i-1,:) = [];
                  break;
              end
            end
            left = cords1;
            right = cords2;
            
       end
   end 
end