function [ vX,objval] = SolveProxTvAdmm( vX, vY, mD, paramLambda,paramRho, numIterations )

objval = zeros(size(1,2),numIterations);
mX = zeros(size(vY, 1), numIterations);

mI = speye(size(vY, 1));
mC = decomposition(mI + paramRho * (mD.' * mD), 'chol');

vZ = ProxL1(mD * vX, paramLambda / paramRho);
vU = mD * vX - vZ;

mX(:, 1) = vX;

for i = 2:numIterations
    
    vX = mC \ (vY + (paramRho * mD.' * (vZ - vU)));
    vZ = ProxL1(mD * vX + vU, paramLambda / paramRho);
    vU = vU + mD * vX - vZ;
    
    mX(:, i) = vX;
    objval(i) = objective(vY, paramLambda, vX, mD);   
    objval(i)
end


end


