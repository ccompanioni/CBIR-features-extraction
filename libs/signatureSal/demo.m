clc; close all; clear all;
%%
img = imread('lena.jpg');
map = signatureSal(img);
% imgBW = map>=0.7;
imgBW = im2bw(map,graythresh(map));

figure, imshow(img,[]);
figure, imshow(map,[]);
figure, imshow(imgBW,[]);

figure, imshow(uint8(imgBW).*rgb2gray(img),[]);