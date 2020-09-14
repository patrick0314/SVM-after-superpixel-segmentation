function meanTex=getMeanTex(segments,textureImg)
% Output:
%    meanTex: (TexNumxRegionNum) mean of each texture in each region
    maxL = max(segments(:)) ;
    numTexImg = length(textureImg) ;
    meanTex = zeros(numTexImg, maxL) ;
    for i = 1:maxL
        if find(segments==i)
            loc = (segments==i) ;
            s = sum(loc(:)) ; % number of pixel in superpixel
            for k = 1:numTexImg
                meanTex(k, i)= sum(textureImg{k}(loc)) / s ;
            end
        end
    end
end