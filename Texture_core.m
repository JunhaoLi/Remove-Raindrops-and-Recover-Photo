function [ New_img ] = Wenli( Img,Img_tag )
%This function use texture matching method to patch texture

img_size = size(Img);
num_unknown = sum(sum(Img_tag==255));
New_tag=Img_tag;
New_img = Img;
count = 0;
first = 1;
pre_num = 0;
while (first == 1 ||num_unknown>0)
    %find a repair pixel on boundary
    if (first ==1)
        first = 0;
    end
    for i = 1:img_size(1)
        for j = 1:img_size(2)
            isedge = 0;
            if (New_tag(i,j)==255)
                if(New_tag(i,j+1)~=255 || New_tag(i,j-1)~=255 ||New_tag(i-1,j) ~=255 ||New_tag(i+1,j)~=255 )
                    isedge = 1;
                end
                if (isedge == 1)
                    [New_img,New_tag] = Wenli_processing(i,j,New_img,New_tag);
                end
            end   
        end
    end
    num_unknown = sum(sum(New_tag==255));
    disp(num_unknown);
end
end

