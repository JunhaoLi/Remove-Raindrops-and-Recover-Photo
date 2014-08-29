%%

% readin the file
mask = double(imread('hehe_2_mask.jpg'));
original = double(imread('Lena512.png'));

% image decoonposition 
mu = 20;
[x,y] = size(original);
structure = reshape(SB_ATV(original, mu), x, y); %use PDE to get structure of image

% imshow the structure of image
figure;subplot(1,2,1);
imshow(structure,[]);

% imshow the texture of image
texture = original - structure;
subplot(1,2,2);
imshow(texture,[]);

% toddle the structure to mark the area for inpainting
[x,y,~] = size(structure);
structure_restore = structure;
 for i=1:x
        for j=1:y
            if isnan(mask(i,j))
                structure_restore(i,j) = NaN; 
            end
        end
 end
 
structure_restore = inpaint_nans(structure_restore,4);
    
figure
imshow(uint8(structure_restore),[]);
title 'Inpainted surface'