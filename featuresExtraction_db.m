clc; close all; clear all;
%%
restoredefaultpath;
addpath(genpath(fullfile('.','libs')));
%%
load('color_Genre.mat');
% load('color_Style.mat');

imgDir = '../test/';
%%
num = length(imgNames); 
featALL=[]; featALL2=[]; featFD=[]; featLBP=[]; featGLCM=[]; featHSV=[];
for i=1:num
fname = imgNames{i};   
disp(['Processing ... ' num2str(i) ' of ' num2str(num) ' : ' fname]);
I = imread([imgDir fname]);
I = imresize(I, [100,100]);
%%
% Feature extraction from paintings dataset ~ 5000 images
V = rgb2gray(I);
%% Color - HSV Histogram
featHSV(i,:) = hsvHistogram(I);
%% Texture - GLCM
%Number of gray-scale levels
G = 256;
%Define displacements
D = [1 0; 1 1; 0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1];
averageMatrices = 'Y';  %for rotation invariance
%Compute textural features
featGLCM(i,:) = CooccurrenceFeatures(ComputeCooccurrenceMatrices(V, V, G, D, averageMatrices), G);
%% Texture - LBP
%Compute LBP features
featLBP(i,:) = histoTP3x3(V, 'LBP81ri');
%%
%% Shape - FD
map = signatureSal(I);
imgBW = im2bw(map,graythresh(map));
imgBW2 = bwareafilt(imgBW,1);
featFD(i,:) = gfd(imgBW2,5,12)';
featFD(i,:) = featFD(i,:)./sum(featFD(i,:));
%%
featALL(i,:) = [featHSV(i,:),featGLCM(i,:),featLBP(i,:),featFD(i,:)];
featALL2(i,:) = [featHSV(i,:),featGLCM(i,:),featLBP(i,:)];
end
%%
X = featALL';

% build 5 hash tables, using 12-bit keys, under the simple LSH scheme
% lshStruct=lsh('lsh',5,12,size(X,1),X);
lshStruct=lsh('lsh',3,6,size(X,1),X);
%%
save('features_Genre.mat','imgNames','typeName','featHSV','featGLCM','featLBP','featFD','featALL','featALL2','lshStruct');
% save('features_Style.mat','imgNames','typeName','featHSV','featGLCM','featLBP','featFD','featALL','featALL2','lshStruct');