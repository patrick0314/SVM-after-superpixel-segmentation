function  meanCC=getMeanLab(LabIm, R0)
%GETMEANLAB extract the mean Lab of each superpixel
%   Input:
%       LabIm - An image in Lab color space
%       R0 -  A segmented image. All pixels in each region are labeled
%              by an integer.
%   Output: 
%       meanCC - 3x(# of regions) matrix. Mean color of each region   

    maxL=max(R0(:));
    CC1=LabIm(:,:,1);      CC2=LabIm(:,:,2);      CC3=LabIm(:,:,3);
    meanCC1=zeros(1,maxL); meanCC2=zeros(1,maxL); meanCC3=zeros(1,maxL);
    for k=1:maxL
        ind=find(R0==k);
        s=length(ind);
        if s>0
        meanCC1(k)=sum(CC1(ind))/s;
        meanCC2(k)=sum(CC2(ind))/s;
        meanCC3(k)=sum(CC3(ind))/s;
        end
    end
    meanCC=[meanCC1;meanCC2;meanCC3];
end