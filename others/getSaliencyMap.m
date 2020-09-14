function [SaliencyMap, optwCtr] = getSaliencyMap(srcImg, idxImg)
    %%% 1. Parameter Settings
    doFrameRemoving = false ;
    useSP = true ; % You can set useSP = false to use regular grid for speed consideration

    %%% Pre-Processing: Remove Image Frames   
    if doFrameRemoving
        [noFrameImg, frameRecord] = removeframe(srcImg, 'sobel') ; % .\Saliency_Optimization\Funcs\removeframe
        [h, w, chn] = size(noFrameImg) ;
    else
        noFrameImg = srcImg ;
        [h, w, chn] = size(noFrameImg) ;
        frameRecord = [h, w, 1, h, 1, w];
    end
    
    %%% Segment input rgb image into patches (SP/Grid)
    if exist('idxImg', 'var')
        spNum = max(idxImg(:)) ;
        adjcMatrix = GetAdjMatrix(idxImg, spNum) ;
        pixelList = cell(spNum, 1) ;
        for n = 1:spNum
            pixelList{n} = find(idxImg == n) ;
        end
    else
        pixNumInSP = 600 ; % pixels in each superpixel
        spnumber = round( h * w / pixNumInSP ) ; % number of superpixel
        if useSP % SLIC
            [idxImg, adjcMatrix, pixelList] = SLIC_Split(noFrameImg, spnumber) ; % use SLIC super-pixel, idxImg is resulting region map
        else
            [idxImg, adjcMatrix, pixelList] = Grid_Split(noFrameImg, spnumber) ; % use Grid Seams super-pixel
        end
    end
    
    %%% Get super-pixel properties
    spNum = size(adjcMatrix, 1) ;
    meanRgbCol = GetMeanColor(noFrameImg, pixelList) ; % get mean color of every superpixel
    meanLabCol = colorspace('Lab<-', double(meanRgbCol)/255) ;
    meanPos = GetNormedMeanPos(pixelList, h, w) ; % get mean location of every superpixel
    bdIds = GetBndPatchIds(idxImg) ;
    colDistM = GetDistanceMatrix(meanLabCol) ; % difference of color between two superpixel
    posDistM = GetDistanceMatrix(meanPos) ; % difference of location between two superpixel
    [clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM) ;
    
    %%% Saliency Optimization
    [bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma) ; % estimate background prob., bdCon is boundary connectivity, bgWeight is giving a very large weight for very confident bg sps can get slightly
    wCtr = CalWeightedContrast(colDistM, posDistM, bgProb) ; % calculate background probability weighted contrast
    optwCtr = SaliencyOptimization(adjcMatrix, bdIds, colDistM, neiSigma, bgWeight, wCtr) ;
    SaliencyMap = SaveSaliencyMap(optwCtr, pixelList, frameRecord, true) ;

    
%     Uncomment the following lines to save more intermediate results.
%     smapName=fullfile(RES, strcat(noSuffixName, '_wCtr.png'));
%     SaveSaliencyMap(wCtr, pixelList, frameRecord, smapName, true);
%     smapName=fullfile(RES, strcat(noSuffixName,'_bgProb.png'));
%     SaveSaliencyMap(bgProb, pixelList, frameRecord, smapName, false, 1);
% 
%     Visualize BdCon, bdConVal = intensity / 30;
%     smapName=fullfile(BDCON, strcat(noSuffixName, '_bdCon_toDiv30.png'));
%     SaveSaliencyMap(bdCon * 30 / 255, pixelList, frameRecord, smapName, false);
end