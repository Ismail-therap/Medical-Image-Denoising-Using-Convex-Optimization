
function [ vX ] = ProxL1( vX, lambdaFactor )
% Soft Thresholding
vX = max(vX - lambdaFactor, 0) + min(vX + lambdaFactor, 0);

end