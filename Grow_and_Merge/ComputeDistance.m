function D=ComputeDistance(L1,L2,DiffTable,edgeMap,meanLGTex,meanCC,complex_map,L_border,L_interior,LongContourMap)


    adjBorder= get_Adj_Border( L_border, L1, L2);
    GradInd=find(adjBorder);
    EdgeRate=sum(LongContourMap(GradInd))/length(GradInd);
 
    L1_border_length=length(find(L_border==L1));
    L2_border_length=length(find(L_border==L2));
    contact_rate=length(GradInd)*0.5/min( L1_border_length, L2_border_length);
    
    EdgeStrength=sum(edgeMap(GradInd))/length(GradInd);
    vecT1=meanLGTex(:,L1); vecT2=meanLGTex(:,L2);
    DTex=sqrt(sum(abs(vecT1-vecT2).^2));
    HistDist=DiffTable(L1,L2);
    
    RCL_L1=getComplexityLevel(L1,L_interior,complex_map);
    RCL_L2=getComplexityLevel(L2,L_interior,complex_map);
    RCL=RCL_L1*RCL_L2;
    DistA=abs(meanCC(2,L1)-meanCC(2,L2));
    DistB=abs(meanCC(3,L1)-meanCC(3,L2));
    
    ThreEdge=0.1;
    if contact_rate<=0.1 && EdgeRate>0.025
        complexFlag=0;
    else
        complexFlag=1;
    end
        
    %complex region
    if DTex<0.2 && complexFlag
        if RCL==9
            ThreEdge=ThreEdge+0.2; %0.2
        elseif RCL==6
            ThreEdge=ThreEdge+0.15; %0.15
        elseif RCL==4
            ThreEdge=ThreEdge+0.11; %0.11
        end
    end
        
    if (HistDist<=0.5 || (DistA+DistB)<10)
        if DTex<=0.05
            ThreEdge=ThreEdge+0.04; 
        elseif DTex<0.11 
            ThreEdge=ThreEdge+0.025;
        elseif DTex<=0.2 
            ThreEdge=ThreEdge+0.015;
        end
    end
    if HistDist<=0.11
        ThreEdge=ThreEdge+0.015;
    end
    
    if EdgeStrength<=ThreEdge 
        D.color=HistDist;
        D.tex=DTex;
        D.score=D.color*0.5+D.tex*3;
        D.edge=EdgeRate;
        D.contact_rate=contact_rate;
    else
        D.color=inf;
        D.tex=inf;
        D.score=inf;
        D.edge=inf;
        D.contact_rate=0;
    end
end