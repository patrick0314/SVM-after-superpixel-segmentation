%%% calculate the histogram of gradient for each superpixel, which its distribution of is informative on texture
function [E0, histR0All] = gradHistR0( imGray, R0 )
    result = zeros(size(R0)) ;
    histR0All = zeros(128, max(R0(:))) ;

    %imGray = rgb2gray(img);
    grad = get_gradient(imGray, 'sobel') ; % [h, w]
    %figure; imagesc( grad );
    borderDiscard = zeros(size(grad)) ;
    for regionIndex = 1 : max(R0(:))
        currentRegion = (R0 == regionIndex) ;
        se = strel('disk', 1) ; % according given shape, set a structuring element
        currentRegion = imerode(currentRegion, se) ; % according se, erode the image
        borderDiscard = currentRegion | borderDiscard; % return the empty space with 0 and non-empty space with 1
    end
    grad( ~borderDiscard ) = 0 ;
    gradQ = floor(grad ./ (max(max(grad))/128)) ;

    thre = 30 ; lowStop = 5 ;

    for regionIndex = 1 : max(max(R0))
        currentRegion = (R0 == regionIndex) ;
        se = strel('disk', 1) ;
        currentRegion = imerode(currentRegion, se) ;
        X = gradQ(currentRegion) ; % according eroded region, select its gradient
        X( X < lowStop ) = 0 ;
        if sum(X) == 0
            result(currentRegion) = 0 ;
            continue
        end
        histGrad = hist(X, 1:128) ; % hist gradient into 128 equalt space
        histGrad(1) = 0 ;
        histR0All(:, regionIndex) = histGrad ; % store each hist of each superpixel

        %[peakNum,peakPart] = max(histGrad);
        midPart = sum( histGrad(10:thre) ) / sum(histGrad) ;
        highPart = sum( histGrad(thre+1:128) ) / sum(histGrad) ;

        %result(currentRegion) = highPart * peakPart;
        %result(currentRegion) = highPart;
        result(currentRegion) = midPart;
    end
    %figure; imagesc( result );
    E0 = result ;

end
