function [MergeR,IsSeed,IsUpdated]=UpdateMergeSet(r,MergeR,numSeeds,IsSeed,seedsL)

    IsUpdated=0;
    for rr=setdiff(1:numSeeds,r)
        if  intersect(MergeR{r},MergeR{rr})
            MergeR{r}=unique([MergeR{r},MergeR{rr}]); 
            MergeR{rr}=[];
            IsSeed(seedsL(rr))=0;
            IsUpdated=1;% have updated -> check whole MergeR again
        end
    end
       
end