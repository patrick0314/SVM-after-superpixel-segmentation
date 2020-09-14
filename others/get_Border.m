function [ output ] = get_Border( label )

    %Inputs
    [X, Y]=size(label);

    %Build outputs
    imgMasks=reshape(label,X,Y);

    %Outline segments
    imgSeg=imgMasks;
    if X*Y == 1
        [fx,fy]=deal([]);
    elseif X == 1
        fx=[];
        fy=gradient(imgSeg);
    elseif Y == 1
        fx=gradient(imgSeg);
        fy=[];    
    else
        [fx,fy]=gradient(imgSeg);
    end
    xcont=find(fx);
    ycont=find(fy);

    segOutline=ones(X,Y);
    segOutline(xcont)=0;
    segOutline(ycont)=0;

    output = ~segOutline;
end

