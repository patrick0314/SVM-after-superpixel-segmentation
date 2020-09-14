% Performing mean_shift image segmentation using EDISON code implementation
% of Comaniciu's paper with a MEX wrapper from Shai Bagon. links at bottom
% of help
%
% Usage:
%   [S L] = msseg(I, hs, hr, M)
%    
% Inputs:
%   I  - original image in RGB or grayscale
%   hs - spatial bandwith for mean shift analysis
%   hr - range bandwidth for mean shift analysis
%   M  - minimum size of final output regions
%
% Outputs:
%   S  - segmented image
%   L  - resulting label map
%
% Links:
% Comaniciu's Paper
%  http://www.caip.rutgers.edu/riul/research/papers/abstract/mnshft.html
% EDISON code
%  http://www.caip.rutgers.edu/riul/research/code/EDISON/index.html
% Shai's mex wrapper code
%  http://www.wisdom.weizmann.ac.il/~bagon/matlab.html
%
% Author:
%  This file and re-wrapping by Shawn Lankton (www.shawnlankton.com)
%  Nov. 2007
%------------------------------------------------------------------------

function [S L] = msseg(Img, hs, hr, M)
    % check if img is gray image or color image
    % if img is a gray image, triple its layer
    gray = 0 ;
    if (size(Img, 3)==1)
        gray = 1 ;
        Img = repmat(Img, [1 1 3]) ;
    end
    
    % if there is not any input parameter, nargin will be 1
    if (nargin == 1)
        hs = 10 ; hr = 7 ; M = 30 ;
    end
    
    % performing MeanShift to the image
    % fimage  - the result in feature space
    % labels  - labels of regions [if steps==2]
    % modes   - list of all modes [if steps==2]
    % regSize - size, in pixels, of each region [if steps==2]
    % grad    - gradient map      [if steps==2 and synergistic]
    % conf    - confidence map    [if steps==2 and synergistic]
    [fimg labels modes regsize grad conf] = edison_wrapper(Img, @RGB2Luv, ...
      'SpatialBandWidth', hs, 'RangeBandWidth', hr, 'MinimumRegionArea', M, 'speedup', 3) ;
    
    S = fimg ; % S is the segmented image and is presented by Luv space
    %S = Luv2RGB(S) ;
    L = labels + 1 ; % L is the resulting label map
    
    % if initial img is a gray image, change the color result to the gray image
    if(gray == 1)
        S = rgb2gray(S);
    end
end
  
  
