function [segments, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map] = pre_merging(idx, BSDS_INFO)
    disp(['=== start train ', num2str(idx), ' ===']) ;
    %%% read image
    img_name = int2str(BSDS_INFO(1, idx)) ;
    img_loc = fullfile('BSDS300', 'images', 'test', [img_name, '.jpg']) ;    
    if ~exist(img_loc, 'file')
        img_loc = fullfile('BSDS300', 'images', 'train', [img_name, '.jpg']) ;
    end
    img = imread(img_loc) ;
    LabIm = applycform(img, makecform('srgb2lab')) ; % change the color space rgb to Lab
    
    %%% Basic Image Feature Construction
    disp('=== start Basic Image Feature Construction ===') ;
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
    disp('=== start Feature Enhancement ===') ;
    SaliencyMap = getHDCSaliency(img) ; % HDCT saliency map
    E = useSketchToken(img) ; % return sketch token detection result
    R0dct = dctR0(LabIm(:, :, 1), R0) ; % return DCT texture strength
    R0gradHist = gradHistR0(LabIm(:, :, 1), R0) ; % return gradient histogram texture result
    featureAdjustment ; % check whether to enhance each map and if yes, update the map

    %%% Superpixel Growing and Adaptive Region Merging
    disp('=== start Superpixel Growing and Adaptive Region Merging ===') ;
    [segments, Hist, HistDiff, area, Edge, DTex, LabIm, meanCC, textureImg, meanLGTex, SaliencyMap, meanSaliency, adj, LongContourMap25, LongContourMap80, edge_map] = RegionMerging(Nseg, R0, img, LabIm, edge_map, FinalEdge, complex_map, textureImg, SaliencyMap, FCD) ;
    
end