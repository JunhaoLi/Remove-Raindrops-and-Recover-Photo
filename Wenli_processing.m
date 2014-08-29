function [ New_img,New_tag ] = Wenli_processing( i,j,Img,Tag_img)
%This function process a pixel for texture matching

%threshold of effective pixels in a patch
thre_1 = 5;

T_patch = zeros(5,5);
img_size = size(Img);
if (i<2 || i>img_size(1)-2 ||j<2 || j>img_size(2)+2)
    return;
end
T_patch = Img(i-2:i+2,j-2:j+2);

P_patch = zeros(9,9);
P_patch = Img(i-4:i+4,j-4:j+4);

[Best_patch,x_center,y_center] = Compare(i,j,Tag_img,T_patch,P_patch,5);
New_tag = Tag_img;
New_img = Img;

%match
size_T = size(T_patch);
for x = 1:size_T(1)
    for y = 1:size_T(2)
        if(Tag_img(i+x-3,j+y-3)==255 && Tag_img(i+x+x_center-8,j+y+y_center-8) ~=255) %can be replaced
            New_img(i+x-3,j+y-3) = New_img(i+x+x_center-8,j+y+y_center-8);
            New_tag(i+x-3,j+y-3) = 0;
        end
    end
end

end

