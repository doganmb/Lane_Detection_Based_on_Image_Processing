function [inverse_points,new_hist] = hist_point_inverser(hists)
    for i = 1 : 12
       if hists(1,i) == 1
          bigs = find(hists(1,:)>1);
          if i < bigs(1)
            hists(1,i) = hists(1,bigs(1)) + (hists(1,bigs(1)) - hists(1,bigs(2))); 
          elseif i == 12
             hists(1,i) = hists(1,i-1) + (hists(1,i-1) - hists(1,i-2));
          else
            if size(find(bigs>i),2) > 0
                take = bigs(find(bigs>i));
                hists(1,i) = round((hists(1,i-1) + hists(1,take(1)))/2);
            else
                hists(1,i) = hists(1,i-1) + (hists(1,i-1) - hists(1,i-2));
            end
          end
       end
       if hists(2,i) == 641
          bigs = find(hists(2,:)>641);
          if i < bigs(1) 
            hists(2,i) = hists(2,bigs(1)) + (hists(2,bigs(1)) - hists(2,bigs(2)));
          elseif i == 12
             hists(2,i) = hists(2,i-1) + (hists(2,i-1) - hists(2,i-2));
          else
            if size(find(bigs>i),2) > 0
                take = bigs(find(bigs>i));
                hists(2,i) = round((hists(2,i-1) + hists(2,take(1)))/2);
            else
                hists(2,i) = hists(2,i-1) + (hists(2,i-1) - hists(2,i-2));
            end
          end
       end
    end

    X1 = 450 ; Y1 = 580; % Destination Points
    X2 = 700; Y2 = 190;
    X3 = 450 ; Y3 = 730;
    X4 = 700 ; Y4 = 1160;

    x1 = 10; y1 = 380;   % Source Points
    x2 = 720; y2 = 380; 
    x3 = 10; y3 = 950;   
    x4 = 720; y4 = 950;
    
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
    
    inversed_left = zeros(12,2);
    inversed_right = zeros(12,2);
    count = 1;
    for i=1:round(720/12)-1:720 - round(720/12)
            X = round((M(1)*i + M(2)*hists(1,count) + M(3))/(M(7)*i + M(8)*hists(1,count) + 1));
            Y = round((M(4)*i + M(5)*hists(1,count) + M(6))/(M(7)*i + M(8)*hists(1,count) + 1));
            inversed_left(count,:) = [X,Y];
            X = round((M(1)*i + M(2)*hists(2,count) + M(3))/(M(7)*i + M(8)*hists(2,count) + 1));
            Y = round((M(4)*i + M(5)*hists(2,count) + M(6))/(M(7)*i + M(8)*hists(2,count) + 1));
            inversed_right(count,:) = [X,Y];
            count = count + 1;
    end
    inverse_points = [inversed_left ;flip(inversed_right)];
    new_hist = hists;
end