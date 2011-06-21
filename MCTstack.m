function [out,thresh]=MCTstack(in)
% wrapper for Krishnan Padmanabhan's MCT algorithm to extend it to a stack of 
% images.
out=in*0;
thresh=[];

%for each image in the stack, apply MCT and store the computed threshold value
for N=1:size(in,3)
	[MCTimage, MCTrtv, MCTgtv, MCTbtv, MCTrcc, MCTgcc, MCTbcc, fbe] = MCT(in(:,:,N));
    out(:,:,N)=MCTimage;
    thresh=horzcat(thresh,MCTrtv);
end

%return the mean threshold value for the stack
thresh=mean(thresh);