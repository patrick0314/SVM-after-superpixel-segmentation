function [MergeR,IsUpdated]=UpdateMergeSet_v2(r,MergeR,numLabel)

    IsUpdated=0;
    for rr=setdiff(1:numLabel,r)
        if  intersect(MergeR{r},MergeR{rr})
            MergeR{r}=unique([MergeR{r},MergeR{rr}]); 
            MergeR{rr}=[];
            IsUpdated=1;% have updated -> check whole MergeR again
        end
    end

end