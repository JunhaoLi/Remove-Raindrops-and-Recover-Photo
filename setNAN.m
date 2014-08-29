function mask2 = setNAN(mask,c,r,k)
% Get boundaries
mask2 = zeros(size(mask,1),size(mask,2));
left = 1;
right = size(mask,2);
up = 1;
down = size(mask,1);
% Masking
for i = 1:size(c,1)
    % Boundary judge
    % In the middle
    if(c(i,2)-k*r(i)>=up && c(i,2)+k*r(i)<=down && c(i,1)-k*r(i)>=left && c(i,1)+k*r(i)<=right)
        for xx = (c(i,2)-k*r(i)):(c(i,2)+k*r(i))
            for yy = (c(i,1)-k*r(i)):(c(i,1)+k*r(i))
                mask2(xx,yy) = 1;
            end
        end
    end
end
end

