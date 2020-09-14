clear all ;
close all ;
clc ;

%%% add the fold path and its subfold path to this matlab path 
addpath(genpath('./')) ;
addpath(genpath('ExtractContour')) ;
addpath(genpath('Saliency_Optimization')) ;
addpath('C:\Users\Patrick\Desktop\SVM\libsvm-3.24\matlab') % LIBSVM (Matlab version) existed dictionary

%%% read numbers of segments used in the paper
fid = fopen(fullfile('results_layer', 'myNsegs.txt'), 'r') ; % read the file .\results4\myNsegs.txt
Nimgs = 300 ; % number of images in BSDS300
[BSDS_INFO] = fscanf(fid, '%d %d \n', [2, Nimgs]) ; % BSDS_INFO conclude image index and number of segmentation
fclose(fid) ;
clear fid ;

%%% Path for saving labels
result_mat_path = 'results_layer\Label_mat\' ;
if ~exist(result_mat_path, 'dir')
    mkdir(result_mat_path) ;
end

%%% test
disp('=== start test ===') ;
load('train_model/model_boost_12345.mat') ;
for idx = 1:20
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
    save_path = 'results_layer\edge_100_' ;
    
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
    
    segments = RenewLabel(segments) ;

    %%% save and show results
    disp('=== start Save and Show Results ===') ;
    show_ = 0 ;
    save_ = 0 ;
    save_all = 1 ;
    save_show_seg(segments, img, show_, save_, save_all, img_name, save_path, result_mat_path) ; % save and show the red boundary image and the mean color image
    clear LabIm R0 edge_map FinalEdge complex_map textureImg SaliencyMap FCD ;
end