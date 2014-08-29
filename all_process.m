%Read in file
clc;
close all;
clear all;
Origin = imread('another_gray.bmp');

%generate detected image and tag image
[Img, Img_tag] = GeneratorCore(Origin); %use Hough transform to detect rain and tag area

mu = 20;
Origin_resize = double(imresize(Origin,[max(size(Origin)),max(size(Origin))]));
[x,y] = size(Origin_resize);
Structure_img = reshape(SB_ATV(Origin_resize, mu), x, y); %use PDE to get structure information

figure;subplot(1,2,1);
imshow(Structure_img,[]);
title('Structure Image');

Texture_img = Origin_resize-Structure_img;
subplot(1,2,2);
imshow(Texture_img,[0,255]);
title('Texture Image');

mask = imresize(Img_tag,[max(size(Origin)),max(size(Origin))]);

%Use texture patch to repair image
[New_i] = Texture_core(double(Structure_img),double(mask));
figure;
imshow(New_i,[0,255]);