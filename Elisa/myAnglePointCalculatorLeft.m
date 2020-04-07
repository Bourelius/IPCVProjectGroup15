function [new_corner] = myAnglePointCalculatorLeft(theta, bottom_corner, top_corner)
%MYANGLEPOINTCALCULATORLEFT calculating banner points to go up 60°
%   Detailed explanation goes here
    a = norm(bottom_corner - top_corner) / 2; 
    x = a * sind(180-theta);
    i = x / sind(1/3*theta);
    h = i * cosd(1/3*theta);
    
    new_corner(1) = top_corner(1) - h;
    new_corner(2) = top_corner(2) + x;

end

