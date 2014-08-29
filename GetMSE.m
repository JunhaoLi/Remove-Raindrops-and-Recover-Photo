function [ Mse_val ] = GetMSE(a_patch,T_patch)
%This function gets MSE error of two matrix
%255 is not included in the matrix

Mse_val = 0;
count = 0;
size_patch = size(a_patch);
for i = 1:size_patch(1)
    for j = 1:size_patch(2)
        if (T_patch(i,j) ~= 255 && a_patch(i,j)~=255)
            Mse_val = Mse_val+ (T_patch(i,j)-a_patch(i,j))^2;
            count = count +1;
        end
    end
end

Mse_val = Mse_val/count;
end