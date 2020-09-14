function output=getComplexityLevel(k,L_interior,complex_map)
%GETCOMPLEX get the complexity of a region 

    idx=find(L_interior==k);
    idx1 = find(complex_map(L_interior == k) >= 70 );
    %[idx2 idy2] = find(C0(F_interior == k) >= 120);
    idx3 = find(complex_map(L_interior == k) < 40 );
    complexity_rate = length(idx1) / (length(idx)); % length(idx)= the size of L_interior of the kth region
    complexity_rate = uint8(complexity_rate*100);
    complexity_rate_simple = length(idx3) / (length(idx));
    complexity_rate_simple = uint8(complexity_rate_simple*100);
    if complexity_rate <= 50
        if complexity_rate_simple >= 50
            region_complexity_level = 1;
        end
        if complexity_rate_simple < 50
            region_complexity_level = 2;
        end    
    else
        region_complexity_level = 3;
    end
    output=region_complexity_level;
    
end

