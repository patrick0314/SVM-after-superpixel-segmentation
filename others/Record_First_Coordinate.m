function [ output ] = Record_First_Coordinate( labels )

    R0 = labels ;
    maxL = max(R0(:)) ; % max region label
    minL = min(R0(:)) ; % min region label
    
        
    for k = minL : maxL
        [idx idy] = find(R0==k) ;
        FCD{k}(1) = idx(1) ;
        FCD{k}(2) = idy(1) ;
        clear idx idy 
    end  
    
    clear maxL minL k 

    output = FCD ;

end

