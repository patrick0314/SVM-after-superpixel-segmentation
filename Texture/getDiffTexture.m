function [DTex,meanTex]=getDiffTexture(textureImg,segments)
    
    maxL=max(segments(:));
    numTexImg=length(textureImg);
    meanTex=inf(numTexImg,maxL);
    for i=1:maxL
        if find(segments==i)
            loc= segments==i;
            s= sum(loc(:));
            for k= 1: numTexImg
                meanTex(k,i)= sum(textureImg{k}(loc))/s;
            end
        end
    end
    % compute the difference 
    DTex=pdist3(meanTex,meanTex); % DTex:0~1, smaller -> more similar
    
end


function D=pdist3(x,y)

    sz=size(x,2);
    d1=abs(x(1,:)'*ones(1,sz)-ones(sz,1)*y(1,:)).^2;
    for a=2:size(x,1)
        d1=d1+abs(x(a,:)'*ones(1,sz)-ones(sz,1)*y(a,:)).^2;
    end
    D=d1.^.5;
    
end
        
        
       
    