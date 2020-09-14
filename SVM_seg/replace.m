function [data] = replace(data)
    [x, y] = size(data) ;
    for i = 1:x
        for j = 1:y
            if isinf(data(i, j))
                data(i, j) = 100000 ;
            elseif isnan(data(i, j))
                data(i, j) = 100000 ;
            end
        end
    end
end