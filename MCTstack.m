function [out,thresh]=MCTstack(in)
% wrapper for Krishnan Padmanabhan's MCT algorithm to estend it to a stack of 
% images.
out=in*0;
thresh=[];

%for each image in the stack, apply MCT and store the computed threshold value
for N=1:size(in,3)
    m=MCT(in(:,:,N));
    out(:,:,N)=m.image;
    thresh=horzcat(thresh,m.tv);
end

%return the mean threshold value for the stack
thresh=mean(thresh);