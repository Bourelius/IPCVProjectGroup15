function [C_point] = myAnglePointCalculator(theta, A_point, B_point)
%UNTITLED calculating banner points to go up 60° 
%   calculating angle between "horizontal" line and a vertical line
%   assume this angle to be 90°
%   calculate point c according to new triangle drawn
%   theta is angle of the banner border line to point origin
%   a_point is left point, b_point is right point that shall be moved
%     alpha = 1/3 * theta;
%     hypotenuse = norm(B_point - A_point);
%     C_point(1) = A_point(1) - hypotenuse*cosd(90+alpha);
%     C_point(2) = A_point(2) - hypotenuse*sind(90+alpha);
    a = norm(A_point - B_point) / 2; 
    x = a * sind(2/3 * theta);
    h = x / sind(1/3 * theta);
    i = a * sind(90 - theta);
    j = a * cosd(90 - theta);
    
    C_point(1) = B_point(1) + i - h;
    C_point(2) = B_point(2) - j;
end

