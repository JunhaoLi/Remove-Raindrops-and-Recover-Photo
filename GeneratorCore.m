function [img_out, img_tag] = GeneratorCore(img)
% Find raindrop location, generate mask, masked img
% Get image
I = img;

% Set boundaries
Rmin = 1;
Rmax = 10;
% Find all the bright circles in the image
[centersBright, radiiBright] = imfindcircles(I,[Rmin Rmax], ...
    'ObjectPolarity','bright');
% Find all the dark circles in the image
[centersDark, radiiDark] = imfindcircles(I, [Rmin Rmax], ...
    'ObjectPolarity','dark');

% % Plot bright circles in blue
% viscircles(centersBright, radiiBright.*1.5,'EdgeColor','b');
% % Plot dark circles in dashed red boundaries
% viscircles(centersDark, radiiDark.*1.5,'LineStyle','--');
% figure;
% viscircles(centersBright, radiiBright.*1.5,'EdgeColor','b');
% % Plot dark circles in dashed red boundaries
% viscircles(centersDark, radiiDark.*1.5,'LineStyle','--');
% title('Detection result');
% grid on;


% Normalization
cB = round(centersBright);
rB = round(radiiBright);
cD = round(centersDark);
rD = round(radiiDark);

% Generate Mask
mask = ones(size(I,1),size(I,2));
mask2 = setNAN(mask,[cB;cD],[rB;rD],2);
% figure; subplot(1,2,1);imshow(mask2);
% imwrite(mask2, './mask_B.bmp', 'BMP');
iii = I;
title('Tagged image');


% Apply filtering
for a = 1:size(I,1)
    for b = 1:size(I,2)
        if(mask2(a,b) == 1)
            iii(a,b) = 255;
        end
    end
end
% subplot(1,2,2); imshow(iii)
img_out = uint8(iii);
img_tag = uint8(255*mask2);
grid on;
title('Detect result');

end

