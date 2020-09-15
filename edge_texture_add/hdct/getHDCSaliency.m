%%% use hdct
function E0 = getHDCSaliency(im)
    load(['tools/model_class.mat']) ;
    load(['tools/Model_all_1000_5.mat']) ;

    imlab = vl_xyz2lab(vl_rgb2xyz(im)) ; % change rgb image to Lab image
    Sp = vl_slic(im2single(imlab), sqrt(size(im,1)*size(im,2)/500), 100) ; % use SLIC superpixel
    [Sp N_Sp] = CheckSp(Sp) ; % re-order Sp and find number of superpixel
  
    % Extract features for initial saliency map    
    clear feat
    feat = zeros(75, N_Sp) ;
    [Features Locpixels distances] = LocationFeatures(Sp, N_Sp, im) ; feat(1:3, :) = Features ;
    [Features] = ColorFeatures(Sp, N_Sp, Locpixels, im, imlab, distances) ; feat(4:43, :) = Features ;
    [Features loc2] = HOGFeatures(im, N_Sp, feat) ; feat(44:74, :) = Features ;
    [Features] = SVF(im, Sp, N_Sp, Locpixels) ; feat(75, :) = Features ;
    
    scores = SQBMatrixPredict(modelclass, single(feat')) ; % score for each superpixel judging if it is foreground or background
    final_sp = zeros(N_Sp, 1) ;
    scores_sort = sort(scores, 'descend') ;
    fore_thre = min(0.75, scores_sort(25)) ; % foreground threshold
    back_thre = min(max(0.25, scores_sort(N_Sp-70)), fore_thre) ; % background threshold
    
    fore = find(scores >= fore_thre) ; % if score bigger than fore_thre, that superpixel belongs to foreground
    back = find(scores < back_thre) ; % if score smaller than back_thre, that superpixel belongs to background
    unk = find(scores >= back_thre & scores < fore_thre) ; % other superpixels are unknown
    
    im = im2double(im) ;

    [alpha TestDic] = GetResult(im, imlab, Sp, N_Sp, Locpixels, fore, back, feat(3, :)') ;
    
    final_sp = TestDic * alpha ;

    final = zeros(size(im, 1), size(im, 2)) ;
    for i = 1 : N_Sp
        final = final + (Sp==i) * final_sp(i) ;
	end

    final = (final>1) + (final>=0 & final<=1) .* final ; % let final = [0, 1] by delete nagetive number and let number > 1 to 1

    %% Location
    TriFeat = zeros(N_Sp, 50) ;
    nearest_fore = zeros(N_Sp, 25) ;  nearest_back = zeros(N_Sp, 25) ;
    for i = 1 : N_Sp
        [K, D] = knnsearch(feat(1:2,fore)', feat(1:2,i)', 'K', 25) ;
        nearest_fore(i,:) = fore(K) ;
        TriFeat(i, 1:25) = D ;
    end
    for i = 1 : N_Sp
        [K, D] = knnsearch(feat(1:2,back)', feat(1:2,i)', 'K', 25) ;
        nearest_back(i,:) = back(K) ;
        TriFeat(i, 26:50) = D ;
    end
    
    %% Colors
    ColFeat = zeros(N_Sp, 400) ;
    for i = 1 : N_Sp
        ColFeat(i, 1:25) = pdist2(feat(4,nearest_fore(i,:))', feat(4,i), 'euclidean')' ;
        ColFeat(i, 26:50) = pdist2(feat(5,nearest_fore(i,:))', feat(5,i), 'euclidean')' ;
        ColFeat(i, 51:75) = pdist2(feat(6,nearest_fore(i,:))', feat(6,i), 'euclidean')' ;
        ColFeat(i, 76:100) = pdist2(feat(7,nearest_fore(i,:))', feat(7,i), 'euclidean')' ;
        ColFeat(i, 101:125) = pdist2(feat(8,nearest_fore(i,:))', feat(8,i), 'euclidean')' ;
        ColFeat(i, 126:150) = pdist2(feat(9,nearest_fore(i,:))', feat(9,i), 'euclidean')' ;
        ColFeat(i, 151:175) = pdist2(feat(10,nearest_fore(i,:))', feat(10,i), 'euclidean')' ;
        ColFeat(i, 176:200) = pdist2(feat(11,nearest_fore(i,:))', feat(11,i), 'euclidean')' ;
    end
    
    for i = 1 : N_Sp
        ColFeat(i, 201:225) = pdist2(feat(4,nearest_back(i,:))', feat(4,i), 'euclidean')' ;
        ColFeat(i, 226:250) = pdist2(feat(5,nearest_back(i,:))', feat(5,i), 'euclidean')' ;
        ColFeat(i, 251:275) = pdist2(feat(6,nearest_back(i,:))', feat(6,i), 'euclidean')' ;
        ColFeat(i, 276:300) = pdist2(feat(7,nearest_back(i,:))', feat(7,i), 'euclidean')' ;
        ColFeat(i, 301:325) = pdist2(feat(8,nearest_back(i,:))', feat(8,i), 'euclidean')' ;
        ColFeat(i, 326:350) = pdist2(feat(9,nearest_back(i,:))', feat(9,i), 'euclidean')' ;
        ColFeat(i, 351:375) = pdist2(feat(10,nearest_back(i,:))', feat(10,i), 'euclidean')' ;
        ColFeat(i, 376:400) = pdist2(feat(11,nearest_back(i,:))', feat(11,i), 'euclidean')' ;
    end
    
    Feature2 = [TriFeat ColFeat] ;
    scores = SQBMatrixPredict(model, single(Feature2)) ; % score for each superpixel judging if it is foreground or background
    
    ress = zeros(size(im,1), size(im,2)) ;
    for i = 1 : N_Sp
        ress = ress + (Sp==i).*scores(i) ;
    end

    final_true = mat2gray(exp(0.5.*final) + exp(0.5*ress)) ;
    
    % imwrite(final_true, ['results/' images(zz).name(1:end-4) '.png'], 'png');
    E0 = final_true ;
end