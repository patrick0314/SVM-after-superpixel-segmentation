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

%%% lists to save each evaluation and file to save all evaluation
PRI_all = zeros(Nimgs, 1) ;
VoI_all = zeros(Nimgs, 1) ;
GCE_all = zeros(Nimgs, 1) ;
BDE_all = zeros(Nimgs, 1) ;
fid_out = fopen(fullfile('results', 'Evaluations.txt'), 'w') ;
%{
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

%}
%%% test
disp('=== start test ===') ;
for idx = 1:100
    %%% read image
    disp(['=== test ', num2str(idx), ' ===']) ;
    img_name = int2str(BSDS_INFO(1, idx)) ;
    img_loc = fullfile('BSDS300', 'images', 'test', [img_name, '.jpg']) ;    
    if ~exist(img_loc, 'file')
        img_loc = fullfile('BSDS300', 'images', 'train', [img_name, '.jpg']) ;
    end
    img = imread(img_loc) ;
    LabIm = applycform(img, makecform('srgb2lab')) ; % change the color space rgb to Lab 
    
    %%% build the path for saving results 
    save_path = 'results\' ;
    
    %%% Basic Image Feature Construction
    para.hs = 5; para.hr = 7; para.M = 100 ;
    [S, initial_seg] = msseg(double(img), para.hs, para.hr, para.M) ; % [S, L]: S for segmented image and L for resulting label map
    R0 = double(initial_seg) ; % label map by MeanShift superpixel
    clear initial_seg ;
    SaliencyMapOld = getSaliencyMap(img) ;
    [edge_map, FinalEdge, complex_map, textureImg] = GetBasicInfo(img) ; % edge_map by structed edge detection, FinalEdge by gradientmap + edge_map, textureImg for the normalized texture map
    R0 = R0post(R0, img, edge_map) ; % check whether to post-process, and return img after superpixel post-processing
    [FCD] = Record_First_Coordinate(R0) ; % FCD: the index of first pixel within every super-pixel
    Nseg = BSDS_INFO(2, idx) ; % Read number of segments
    
    %%% Feature enhancement
    SaliencyMap = getHDCSaliency(img) ; % HDCT saliency map
    E = useSketchToken(img) ; % return sketch token detection result
    R0dct = dctR0(LabIm(:, :, 1), R0) ; % return DCT texture strength
    R0gradHist = gradHistR0(LabIm(:, :, 1), R0) ; % return gradient histogram texture result
    featureAdjustment ; % check whether to enhance each map and if yes, update the map

    %%% Superpixel Growing and Adaptive Region Merging
    [segments, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map] = RegionMerging(Nseg, R0, img, LabIm, edge_map, FinalEdge, complex_map, textureImg, SaliencyMap, FCD) ;

    %%% test
    disp(['# of original segments: ', num2str(max(max(segments)))]) ;
    
    %%% SVM segmentation by model 1
    break_while = false ;
    tmp = segments ;
    while (max(max(tmp)) > 150) && ~(break_while)
        [label_test, features_test, contact_rate, dSV] = SVM_seg_1(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_1(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
        disp(['# of model_1 segments: ', num2str(max(max(tmp)))]) ;
    end
    
    %%% SVM segmentation by model 2
    break_while = false ;
    while (max(max(tmp)) > 100) && ~(break_while)
        [label_test, features_test, contact_rate, dSV] = SVM_seg_2(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model_2) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_2(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
        disp(['# of model_2 segments: ', num2str(max(max(tmp)))]) ;
    end
    
    %%% SVM segmentation by model 3
    break_while = false ;
    while (max(max(tmp)) > 75) && ~(break_while)
        [label_test, features_test, contact_rate, dSV] = SVM_seg_3(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model_3) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_3(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
        disp(['# of model_3 segments: ', num2str(max(max(tmp)))]) ;
    end
    
    %%% SVM segmentation by model 4
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
    
    %%% SVM segmentation by model 5
    break_while = false ;
    while (max(max(tmp)) > min((2*Nseg+5), 35)) && ~(break_while)
        [label_test, features_test, contact_rate, dSV] = SVM_seg_5(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
        [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model_5) ;
        [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_5(segments, d_values, 1, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
        disp(['# of model_5 segments: ', num2str(max(max(tmp)))]) ;
    end
    [label_test, features_test, contact_rate, dSV] = SVM_seg_5(segments,idx,BSDS_INFO,HistDiff,area,Edge,DTex,meanCC,adj,meanSaliency) ;
    [predicted, accuracy, d_values] = svmpredict(label_test, features_test, model_5) ;
    [segments,tmp,Hist,HistDiff,area,Edge,DTex,meanCC,meanLGTex,meanSaliency,adj,break_while] = SVM_image_5(segments, d_values, 2, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map, contact_rate, dSV) ;
    disp(['# of model_5 segments: ', num2str(max(max(tmp)))]) ;
    
    segments = RenewLabel(segments) ;

    %%% save and show results
    disp('=== start Save and Show Results ===') ;
    show_ = 0 ;
    save_ = 0 ;
    save_all = 1 ;
    save_show_seg(segments, img, show_, save_, save_all, img_name, save_path, result_mat_path) ; % save and show the red boundary image and the mean color image
    clear LabIm R0 edge_map FinalEdge complex_map textureImg SaliencyMap FCD ;
    
    %%% evaluate segmentation
    [gt_imgs, ~] = view_gt_segmentation(img, BSDS_INFO(1, idx), save_path, img_name, 0) ;
    clear img ;
    out_vals = eval_segmentation(segments, gt_imgs) ; % ./Evals/eval_segmentaion.m, return all criterions for image segmentation
    clear gt_imgs ;
    fprintf('%6s: %2d %9.6f, %9.6f, %9.6f, %9.6f \n', img_name, Nseg, out_vals.PRI, out_vals.VoI, out_vals.GCE, out_vals.BDE) ;
    
    PRI_all(idx) = out_vals.PRI ;
    VoI_all(idx) = out_vals.VoI ;
    GCE_all(idx) = out_vals.GCE ;
    BDE_all(idx) = out_vals.BDE ;
    fprintf(fid_out, '%6d %9.6f, %9.6f, %9.6f, %9.6f \r\n', BSDS_INFO(1, idx), PRI_all(idx), VoI_all(idx), GCE_all(idx), BDE_all(idx)) ;
   
end

%%% write the evaluation into Evaluations.txt
fprintf('Mean: %14.6f, %9.6f, %9.6f, %9.6f \n', mean(PRI_all), mean(VoI_all), mean(GCE_all), mean(BDE_all)) ;
fprintf(fid_out,'Mean: %10.6f, %9.6f, %9.6f, %9.6f \r\n', mean(PRI_all), mean(VoI_all), mean(GCE_all), mean(BDE_all)) ;
fclose(fid_out);