%%% R0 post for large area 
function R0new = R0post( R0, img, edge_map )
    isR0post = false ;
    blockMean = zeros(100, 3) ;
    blockStd = zeros(100, 3) ;
    dx = floor(size(img, 1)/10) ;
    dy = floor(size(img, 2)/10) ;
    for ix = 1:10
        for iy = 1:10
            currentsmallBlock = img( (ix-1)*dx+1:ix*dx, (iy-1)*dy+1:iy*dy, :) ; % x, y segment into 10 block, and select each block in order
            blockMean( (ix-1)*10 + iy, :) = reshape(mean(mean(currentsmallBlock)), 1, []) ;
            blockStd( (ix-1)*10 + iy, :) = std( double([reshape(currentsmallBlock(:,:,1), [], 1), ...
                                                        reshape(currentsmallBlock(:,:,2), [], 1), ...
                                                        reshape(currentsmallBlock(:,:,3), [], 1)] )) ;
        end
    end
    stdOfMean = std(blockMean) ; % standard deviation in three color channels of all blocks' means
    meanOfStd = mean(blockStd) ; % mean of all blocks' standard deviations in three color channels
    minOfStd = min(blockStd) ; % minimum of blocks' standard deviations
    maxOfStd = max(blockStd) ; % maximum of blocks' standard deviations
    
    % check whether to post-process
    if max(stdOfMean) < 50 && max(meanOfStd) < 32 && max(minOfStd) < 1
        isR0post = true;
    end
    if  32.5 > max(stdOfMean) && max(stdOfMean) > 30 && 30 > min(meanOfStd) && min(meanOfStd) > 29 && min(minOfStd) < 12.5
        isR0post = true;
    end
    if 37 > max(stdOfMean) && max(stdOfMean) > 36 && 25 > min(meanOfStd) && min(meanOfStd) > 23 && min(minOfStd) < 4
        isR0post = true;
    end
    if 45 > max(stdOfMean) && max(stdOfMean) > 44 && 10 > min(meanOfStd) && min(meanOfStd) > 9 && min(minOfStd) < 3
        isR0post = true;
    end
    if 22 > max(stdOfMean) && max(stdOfMean) > 21 && 16 > min(meanOfStd) && min(meanOfStd) > 15 && min(minOfStd) < 2.5
        isR0post = true;
    end
    
    if isR0post
        R0new = zeros(size(R0)) ; 
        s = regionprops(R0, 'area') ; % area of each superpixel
        R0area = cat(1, s.Area) ; % change s to list
        newLabelInd = max(R0(:)) + 1 ;
        for regionInd = 1:max(R0(:))
            if R0area(regionInd) < 40000
                R0new( R0 == regionInd ) = regionInd ; % if area of superpixel is not too large, unchange
                continue ;
            end
            %%% if area superpixel is too large
            labelOri = (R0 == regionInd) ;
            se = strel('disk', 2) ;
            A = imerode(labelOri, se) ;
            B = edge_map .* A ;
            C = B > 0.15 ; % check if there is an edge in the superpixel
            labelNew = labelOri ;
            labelNew(C) = 0 ;
            se = strel('disk', 3) ;
            A2 = imerode(labelNew, se) ;
            A22 = imdilate(A2, se) ;
            labelNewSplit = bwlabel(A22, 4) ;
            splitRegionNum = max(labelNewSplit(:)) ;
            if splitRegionNum == 1 % no split
                R0new( R0 == regionInd ) = regionInd ;
                continue;
            end
            splitLabel = zeros(size(labelNewSplit, 1), size(labelNewSplit, 2), splitRegionNum) ;
            for splitInd = 1 : splitRegionNum
                temp = labelNewSplit == splitInd ;
                splitLabel(:, :, splitInd) = temp ;
            end
            se = strel('disk',1);
            for splitInd = 1 : splitRegionNum
                splitLabel(:, :, splitInd) = imdilate(splitLabel(:, :, splitInd), se) & labelOri ;
            end
            temp = labelOri.*(splitRegionNum+1) ;
            for splitInd = 1 : splitRegionNum
                temp(splitLabel(:,:,splitInd)==splitInd) = splitInd ;
            end
            temp( temp==splitRegionNum+1 ) = splitRegionNum ;
            R0new( temp == 1 ) = regionInd ;
            for splitInd = 2 : splitRegionNum
                R0new( temp == splitInd ) = newLabelInd ;
                newLabelInd = newLabelInd + 1 ;
            end
        end
        R0new = RenewLabel(R0new) ;
    else
        R0new = R0 ;
    end
end
