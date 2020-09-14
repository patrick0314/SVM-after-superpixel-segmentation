function meanSaliency=getMeanSV(SaliencyMap,seg)
    % return the number of the probability of being foreground
    % the larger the number is, the more probability it can be foreground
    maxL=max(seg(:));
    meanSaliency=zeros(maxL,1);
    for i=1:maxL
        if find(seg==i)
            loc= find(seg==i);
            meanSaliency(i)= sum(SaliencyMap(loc))/length(loc);
        end
    end
end