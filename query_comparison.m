clc; close all; clear all;
%%
restoredefaultpath;
addpath(genpath(fullfile('.','libs')));
%%
% Load features extracted from database
dt = load('features_Genre.mat');
qryDir = './pics/query_Genre/';

% dt = load('features_Style.mat');
% qryDir = './pics/query_Style/';

%%
imgDir = './pics/dataset_genre/';
fname = '871.jpg';
I = imread([qryDir fname]);
% Pre-processing step: Resize image
I = imresize(I,[100,100]);
V = rgb2gray(I);

% Features extraction from Query
%% Color - HSV Histogram
featHSV = hsvHistogram(I);

%% Texture - GLCM
%Number of gray-scale levels
G = 256;
%Define displacements
D = [1 0; 1 1; 0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1];
averageMatrices = 'Y';  %for rotation invariance
%Compute textural features
featGLCM = CooccurrenceFeatures(ComputeCooccurrenceMatrices(V, V, G, D, averageMatrices), G);

%% Texture - LBP
%Compute LBP features
featLBP = histoTP3x3(rgb2gray(I), 'LBP81ri');

%% Shape - FD
map = signatureSal(I);
% imgBW = map>0.8;
imgBW = im2bw(map,graythresh(map));
imgBW2 = bwareafilt(imgBW,1);
featFD = gfd(imgBW2,5,12)';
featFD = featFD./sum(featFD);

%%
% Fuse all features vector in one single vector
featALL = [featHSV,featGLCM,featLBP,featFD];
%featALL2 = [featHSV,featGLCM,featLBP];

%%
% Retrieve images using direct comparison of query vector with all features vector in dataset
tic;
dst_term = 'euclidean';
% dst_HSV = pdist2(dt.featHSV, featHSV, dst_term);
% dst_GLCM = pdist2(dt.featGLCM, featGLCM, dst_term);
% dst_LBP = pdist2(dt.featLBP, featLBP, dst_term);
% dst_FD = pdist2(dt.featFD, featFD, dst_term);
dst_ALL = pdist2(dt.featALL, featALL, dst_term);
dst_ALL = 1-dst_ALL./max(dst_ALL);
% dst_ALL2 = pdist2(dt.featALL2, featALL2, dst_term);
[dst,idx] = sort(dst_ALL,'descend');
queryIdx = idx(1);
dst = dst(2:end);
idx = idx(2:end);
toc;
%%
% Plot query and Top 5 retrieved paintings -- Direct comparison
f = figure;
subplot(2, 3, 1);
imshow(imread([qryDir fname]),[]); axis off;
title('Query');
for i=1:min(5,numel(idx))
    subplot(2, 3, i+1); 
    imshow(imread([imgDir dt.imgNames{idx(i)}]),[]);
    title([num2str(dst(i)) ' - ' dt.typeName{idx(i)}]);
    axis off;
end

%%
% Retrieve images using indexing by LSH
X = dt.featALL';
lshStruct=lsh('lsh',2,5,size(X,1),X);
tic;
[idsSIMPLE,~]=lshlookup(featALL',X,lshStruct,'k',size(X,2));
idsSIMPLE = idsSIMPLE(2:end);
toc;

% Plot query and Top 5 retrieved paintings -- Indexing by LSH
figure;
subplot(2, 3, 1);
imshow(imread([qryDir fname]),[]); axis off;
title('Query');
for i=1:min(5,numel(idsSIMPLE))
    subplot(2, 3, i+1); 
    imshow(imread([imgDir dt.imgNames{idsSIMPLE(i)}]),[]);
    title(['top ' num2str(i) ' - ' dt.typeName{idsSIMPLE(i)}]);
    axis off;
end
%%
statsIdx = idx; % idx , idsSIMPLE result of system index of images retrived 
targets = ismember(dt.typeName(statsIdx),dt.typeName(queryIdx));
relevant_IDs = find(targets==1);
numRel = numel(relevant_IDs);
pre = (1:numRel) ./ relevant_IDs;
rec = (1:numRel) / numRel;

% Plot Precision_Recall curve and ROC curve -- Direct comparison
% figure;
% plot(rec, pre, 'b.-');
% xlabel('rec');
% ylabel('pre');
% title('pre-rec Curve - Direct Comparison');
% axis([0 1 0 1.05]); %// Adjust axes for better viewing
% grid;

numNonRel = sum(targets==0);
fpr = zeros(1,numel(rec));
for i=1:numel(rec)
    fpr(i)= (relevant_IDs(i)-i)/numNonRel;
end

% figure;
% plot(fpr, rec, 'b.-');
% xlabel('FPR');
% ylabel('tpr/rec');
% title('ROC Curve - Direct Comparison');
% axis([0 1 0 1.05]); %// Adjust axes for better viewing
% grid;

% Plot Precision_Recall curve and ROC curve (Interpolate 11 points) -- Direct comparison
rec11 = 1:-0.1:0;
pre11 = zeros(1,11);
fpr11 = zeros(1,11);
for i=1:numel(rec11)
   pre11(i) = max(pre((rec >=rec11(i))));
   fpr11(i) = min(fpr((rec >=rec11(i))));
end
figure;
plot(rec11, pre11, 'b.-');
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve (11-Points) - Direct Comparison');
axis([0 1 0 1.05]); %// Adjust axes for better viewing
grid;

figure;
plot(fpr11, rec11, 'b.-');
xlabel('1-Specificity');
ylabel('Sensitivity');
title('ROC Curve (11-Points) - Direct Comparison');
axis([0 1 0 1.05]); %// Adjust axes for better viewing
grid;

% Compute Presicion, Recall and AUC
targetsTop = targets(1:5);
relevant_IDsTop = find(targetsTop==1);
preTop = numel(relevant_IDsTop) / 5;
recTop = numel(relevant_IDsTop) / numRel;

display(['AUC of ROC curve - Direct = ' num2str(trapz(fpr, rec))]);

display(['Top 5 - Direct: Rec = ' num2str(recTop) ...
    ', Pre = ' num2str(preTop)]);
%%
% Plot Precision_Recall curve and ROC curve -- Indexing by LSH
statsIdx = idsSIMPLE; % idx , idsSIMPLE
targets = ismember(dt.typeName(statsIdx),dt.typeName(queryIdx));
relevant_IDs = find(targets==1);
numRel = numel(relevant_IDs);
pre = (1:numRel) ./ relevant_IDs;
rec = (1:numRel) / numRel;
% figure;
% plot(rec, pre, 'b.-');
% xlabel('rec');
% ylabel('pre');
% title('pre-rec Curve - Hashing Comparison');
% axis([0 1 0 1.05]); %// Adjust axes for better viewing
% grid;

% numNonRel = sum(targets==0);
% fpr = zeros(1,numel(rec));
% for i=1:numel(rec)
%     fpr(i)= (relevant_IDs(i)-i)/numNonRel;
% end

% figure;
% plot(fpr, rec, 'b.-');
% xlabel('FPR');
% ylabel('tpr/rec');
% title('ROC Curve - Hashing Comparison');
% axis([0 1 0 1.05]); %// Adjust axes for better viewing
% grid;

% Plot Precision_Recall curve and ROC curve (Interpolate 11 points) -- Indexing by LSH
rec11 = 1:-0.1:0;
pre11 = zeros(1,11);
fpr11 = zeros(1,11);
for i=1:numel(rec11)
   pre11(i) = max(pre((rec >=rec11(i))));
   fpr11(i) = min(fpr((rec >=rec11(i))));
end
figure;
plot(rec11, pre11, 'b.-');
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve (11-Points) - Hashing Comparison');
axis([0 1 0 1.05]); %// Adjust axes for better viewing
grid;

figure;
plot(fpr11, rec11, 'b.-');
xlabel('FPR');
ylabel('tpr/rec');
title('ROC Curve (11-points) - Hashing Comparison');
axis([0 1 0 1.05]); %// Adjust axes for better viewing
grid;

% Compute Presicion, Recall and AUC
targetsTop = targets(1:5);
relevant_IDsTop = find(targetsTop==1);
preTop = numel(relevant_IDsTop) / 5;
recTop = numel(relevant_IDsTop) / numRel;

display(['AUC of ROC curve - Hashing = ' num2str(trapz(fpr, rec))]);

display(['Top 5 - Hashing: Rec = ' num2str(recTop) ...
    ', Pre = ' num2str(preTop)]);