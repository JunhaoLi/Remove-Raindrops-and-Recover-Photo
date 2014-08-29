function [ Best_patch,x_center,y_center ] = Compare(x,y,Tag_img,T_patch,P_patch,thre)
%This function uses MSE to get the best patch matching
patch_size = size(T_patch);

x_center = -1;
y_center = -1;
minMSE = inf;

for i = 3:6
    for j = 3:6
        %not itself
        if (i ~= 5 && j ~= 5 && Tag_img(x+i-4,y+i-4)~=255 )
            a_patch = P_patch(i-2:i+2,j-2:j+2);
            %threshold test
            if (sum(sum(a_patch ~= 255))>thre)
                %get MSE
                MSE_current = GetMSE(a_patch,T_patch);
                %compare and update
                if(minMSE>MSE_current)
                    minMSE = MSE_current;
                    x_center = i;
                    y_center = j;
                end
            end
        end
    end
end

Best_patch = P_patch(x_center-2:x_center+2,y_center-2:y_center+2);

end

