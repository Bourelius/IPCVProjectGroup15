function [new_corner] = myAnglePointCalculatorRight(theta, bottom_corner, top_corner)
%MYANGLEPOINTCALCULATOR calculating banner points to go up 60° 
%
    a = norm(bottom_corner - top_corner) / 2; 
    x = a * sind(2/3 * theta);
    h = x / sind(1/3 * theta);
    i = a * sind(90 - theta);
    j = a * cosd(90 - theta);
    
    new_corner(1) = top_corner(1) + i - h;
    new_corner(2) = top_corner(2) - j;
end

