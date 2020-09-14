function E0 = dctR0( imGray, R0 )
    result = zeros(size(R0)) ;
    lowSuppress = 9 ;
    for regionIndex = 1 : max(max(R0))
        currentRegion = (R0 == regionIndex) ;
        regionMean = mean( imGray(currentRegion) ) ; % imGray(currentRegion) is a list for color with region == regionIndex
        [x,y] = find(R0 == regionIndex) ;
        reformRectRegion = imGray ;
        reformRectRegion(~currentRegion) = regionMean ;
        reformRectRegion = reformRectRegion( min(x):max(x), min(y):max(y) ) ;
        regionDCT = dct2(reformRectRegion) ; %  returns the two-dimensional discrete cosine transform of A which contains the discrete cosine transform coefficients (k1,k2)
        regionDCT(1:lowSuppress, 1:lowSuppress) = 0 ;
        result(currentRegion) = mean(mean(abs(regionDCT))) ;

    end

    result2 = result ;
    max2 = max(max(result2)) ;
    if max2 == 0 
        max2 = 1 ;
    end
    result2( result2 < max2/2 ) = 0 ;

    E0 = result2 ./ max2 ; % TBD all zero cases+++++++++++++++
end
