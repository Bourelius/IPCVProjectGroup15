function [point_c] = myAnglePointCalculator(theta, a_point, b_point)
%UNTITLED calculating banner points to go up 60° 
%   calculating angle between "horizontal" line and a vertical line
%   assume this angle to be 90°
%   calculate point c according to new triangle drawn
%   theta is angle of the banner border line to point origin
%   a_point is left point, b_point is right point that shall be moved
    alpha = 1/3 * theta;
    hypotenuse = norm(b_point - a_point);
    point_c(1) = a_point(1) - hypotenuse*cosd(90+alpha);
    point_c(2) = a_point(2) - hypotenuse*sind(90+alpha);
end