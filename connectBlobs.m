%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% connectBlobs
% Connects two blobs if the rat is cut in two by the button cable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [binImg] = connectBlobs(binImg,c1,c2)
    %draw squares along the line from centroid to centroid. first starts
    %centered at the centroid, then moves half of its length over, etc,
    %until it reaches the other centroid. a lot of edge cases depending on
    %which position is larger (subtract postioning or add?). length of
    %square is variable
    %while loop to check if it has reached c2 yet, find the row and column 
    %min and max for square (if branches), then use binImg(xmin:xmax,ymin:ymax)=1
    side = 9;   %odd number
    half = floor(side/2);
    c1 = round(c1);
    c2 = round(c2);
    x = round(linspace(c1(1),c2(1),20));
    y = round(linspace(c1(2),c2(2),20));
    
    for i=1:length(x)
        top = y(i)-side;
        bottom = y(i);
        left = x(i)-side;
        right = x(i);
        if top <=0 
            top = 1;
        end
        if left <= 0 
            left = 1;
        end
        binImg(top:bottom,left:right) = 1;
    end

end