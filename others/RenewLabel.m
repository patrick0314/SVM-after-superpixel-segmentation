function segments=RenewLabel(R1)
%RENEWLABEL renew the labels of segmented regions    

    segments=R1;
    maxL = max(segments(:));    
    minL = min(segments(:));    
    
    iL = 1;
    for k = minL : maxL
        if find(segments == k)           
           segments = (segments==k)*iL + (segments~=k).*segments;
           iL = iL + 1;            
        end        
    end  
end