function [side] = mySideClassifier(frame)
%MYSIDECLASSIFIER detects which side of the football field is viewed
%   based on number of non black pixels left or right

    n_c = size(frame,2);
    left = frame(:, 1:n_c/2);
    right = frame(:, n_c/2+1:n_c+1);
    
    if sum(left(:)~= 0) > sum(right(:) ~= 0)
        side = 1;
    else
        side = 2;
    end
end

