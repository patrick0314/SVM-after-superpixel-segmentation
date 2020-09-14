function [output,meanLGTex,LabHist,area]=Merge02(segments,targetL,LongContourMap,meanLGTex,LabHist,area)

 
    adj=FindNeighbor(segments);  
    L_border = get_L_Border( segments );
    numLabel=length(targetL);
    MergeR=cell(numLabel,1);
    SimTable=getSimTable(segments,LabHist,area,adj);
    for i=1:numLabel
        MergeR{i}=[];
        L1=targetL(i);
        if find(segments==L1)                 
           [Histval,L2]=max(SimTable(L1,:));
           if Histval>=0.3
               vecT1=meanLGTex(:,L1); vecT2=meanLGTex(:,L2);
               Dtex=sqrt(sum(abs(vecT1-vecT2).^2));
               if Dtex<0.25
                   adjBorder= get_Adj_Border( L_border, L1, L2);
                   GradInd=find(adjBorder);
                   EdgeRate=sum(LongContourMap(GradInd))/length(GradInd);
                   L1_border_length=length(find(L_border==L1));
                   L2_border_length=length(find(L_border==L2));
                   contact_rate=length(GradInd)*0.5/min( L1_border_length, L2_border_length);
                   if EdgeRate<=0.3 && contact_rate>=0.07
                       MergeR{i}=[L1,L2];
                   end
               end
           end
            
        end
    end

    % update merging sets
    for r=1:numLabel
        if ~isempty(MergeR{r})
            check=1;
            while check  % have merged -> check whole MergeR again
                [MergeR,check]=UpdateMergeSet_v2(r,MergeR,numLabel);
            end
        end           
    end
    % update region      
    for r=1: numLabel
        if ~isempty(MergeR{r})           
            for ii=2:length(MergeR{r})
                loc= segments==MergeR{r}(ii);
                segments(loc)=MergeR{r}(1);
            end
        end
    end  
    clear MergeR
    output=segments;
end

