function [new_corner] = myAnglePointCalculatorLeft(theta, bottom_corner, top_corner)
%MYANGLEPOINTCALCULATORLEFT calculating banner points to go up 60°
%   Detailed explanation goes here
    a = norm(bottom_corner - top_corner) / 2; 
    x = a * sind(2/3*(180-theta));
    h = x / sind(1/3*(180-theta));
    i = a * sind(90-(180-theta));
    j = a * cosd(90-(180-theta));
    
    new_corner(1) = top_corner(1) + i - h;
    new_corner(2) = top_corner(2) + j;

end

