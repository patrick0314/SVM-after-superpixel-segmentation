clear all ;
close all ;
clc ;

%%% add the fold path and its subfold path to this matlab path 
addpath(genpath('./')) ;
addpath(genpath('ExtractContour')) ;
addpath(genpath('Saliency_Optimization')) ;
addpath('libsvm') % LIBSVM (Matlab version) existed dictionary

load('train_model/model_boost_12345.mat') ;

%%% read numbers of segments used in the paper
fid = fopen(fullfile('results', 'myNsegs.txt'), 'r') ; % read the file .\results4\myNsegs.txt
Nimgs = 300 ; % number of images in BSDS300
[BSDS_INFO] = fscanf(fid, '%d %d \n', [2, Nimgs]) ; % BSDS_INFO conclude image index and number of segmentation
fclose(fid) ;
clear fid ;

%%% Path for saving labels
result_mat_path = 'results\Label_mat\' ;
if ~exist(result_mat_path, 'dir')
    mkdir(result_mat_path) ;
end

%%% train
label_all = [] ;
features_all = [] ;
for idx = [3,5,6,7,8]
    [segments, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map] = pre_merging(idx, BSDS_INFO) ;
    
    %%% label & feature
    disp('=== label & feature get ===') ;
    [label, features, contact_rate, dSV] = SVM_seg_1(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
    label_all = cat(1, label_all, label) ;
    features_all = cat(1, features_all, features) ;
end
%%% model train
disp('=== train model ===') ;
model = boost(label_all, features_all) ;
save('train_model/model_1.mat') ;

%%% train model 2
label_all = [] ;
features_all = [] ;
for idx = [3,4,5,6,7,8]
    [segments, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map] = pre_merging(idx, BSDS_INFO) ;
    
    %%% label & feature
    tmp = segments ;
    break_while = false ;
    while (max(max(tmp)) > 150) && ~(break_while)
        disp('=== label & feature get ===') ;
        [label, features, contact_rate, dSV] = SVM_seg_1(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label, features, model) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_1(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
    end
    
    disp('=== label & feature get 2 ===') ;
    [label, features, contact_rate, dSV] = SVM_seg_2(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
    label_all = cat(1, label_all, label) ;
    features_all = cat(1, features_all, features) ;
end
%%% model train 2
disp('=== train model 2 ===') ;
model_2 = boost(label_all, features_all) ;
save('train_model/model_2.mat') ;

%%% train model 3
label_all = [] ;
features_all = [] ;
for idx = [1,3,4,5,6,7,8]
    [segments, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map] = pre_merging(idx, BSDS_INFO) ;
    
    %%% label & feature
    tmp = segments ;    
    break_while = false ;
    while (max(max(tmp)) > 150) && ~(break_while)
        disp('=== label & feature get ===') ;
        [label, features, contact_rate, dSV] = SVM_seg_1(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label, features, model) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_1(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
    end
    break_while = false ;
    while (max(max(tmp)) > 100) && ~(break_while)
        disp('=== label & feature get 2 ===') ;
        [label, features, contact_rate, dSV] = SVM_seg_2(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label, features, model) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_2(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
    end
    
    disp('=== label & feature get 3 ===') ;
    [label, features, contact_rate, dSV] = SVM_seg_3(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
    label_all = cat(1, label_all, label) ;
    features_all = cat(1, features_all, features) ;
end
%%% model train 3
disp('=== train model 3 ===') ;
model_3 = boost(label_all, features_all) ;
save('train_model/model_3.mat') ;

%%% train model 4
label_all = [] ;
features_all = [] ;
for idx = [1,3,4,5,6,7]
    [segments, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map] = pre_merging(idx, BSDS_INFO) ;
    
    %%% label & feature
    break_while = false ;
    tmp = segments ;
    while (max(max(tmp)) > 150) && ~(break_while)
        disp('=== label & feature get ===') ;
        [label, features, contact_rate, dSV] = SVM_seg_1(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label, features, model) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_1(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
    end
    break_while = false ;
    while (max(max(tmp)) > 100) && ~(break_while)
        disp('=== label & feature get 2 ===') ;
        [label, features, contact_rate, dSV] = SVM_seg_2(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label, features, model) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_2(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
    end
    break_while = false ;
    while (max(max(tmp)) > 75) && ~(break_while)
        [label_test, features_test, contact_rate, dSV] = SVM_seg_3(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model_3) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_3(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
        disp(['# of model_3 segments: ', num2str(max(max(tmp)))]) ;
    end
    
    disp('=== label & feature get 4 ===') ;
    [label, features, contact_rate, dSV] = SVM_seg_4(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
    label_all = cat(1, label_all, label) ;
    features_all = cat(1, features_all, features) ;
end
%%% model train 4
disp('=== train model 4 ===') ;
model_4 = boost(label_all, features_all) ;
save('train_model/model_4.mat') ;

%%% train model 5
label_all = [] ;
features_all = [] ;
for idx = [1,2,3,4,6]
    [segments, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map] = pre_merging(idx, BSDS_INFO) ;
    
    %%% label & feature
    break_while = false ;
    tmp = segments ;
    while (max(max(tmp)) > 150) && ~(break_while)
        disp('=== label & feature get ===') ;
        [label, features, contact_rate, dSV] = SVM_seg_1(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label, features, model) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_1(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
    end
    break_while = false ;
    while (max(max(tmp)) > 100) && ~(break_while)
        disp('=== label & feature get 2 ===') ;
        [label, features, contact_rate, dSV] = SVM_seg_2(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label, features, model) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_2(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
    end
    break_while = false ;
    while (max(max(tmp)) > 75) && ~(break_while)
        [label_test, features_test, contact_rate, dSV] = SVM_seg_3(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model_3) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_3(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
        disp(['# of model_3 segments: ', num2str(max(max(tmp)))]) ;
    end
    break_while = false ;
    while (max(max(tmp)) > 55) && ~(break_while)
        [label_test, features_test, contact_rate, dSV] = SVM_seg_4(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model_4) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_4(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
        disp(['# of model_4 segments: ', num2str(max(max(tmp)))]) ;
    end
    break_while = false ;
    while (max(max(tmp)) > 40) && ~(break_while)
        [label_test, features_test, contact_rate, dSV] = SVM_seg_4(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model_4) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_4_2(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
        disp(['# of model_4 segments: ', num2str(max(max(tmp)))]) ;
    end
    
    disp('=== label & feature get 5 ===') ;
    [label, features, contact_rate, dSV] = SVM_seg_5(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
    label_all = cat(1, label_all, label) ;
    features_all = cat(1, features_all, features) ;
end
%%% model train 5
disp('=== train model 5 ===') ;
model_5 = boost(label_all, features_all) ;
save('train_model/model_5.mat') ;

%%% save model.mat
save('train_model/model_boost_12345.mat') ;