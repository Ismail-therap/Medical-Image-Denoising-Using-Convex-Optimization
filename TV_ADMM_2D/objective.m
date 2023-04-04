% Objective Function
% hObjFun = @(vX) (0.5 * sum( (vX - vY) .^ 2)) + (paramLambda * sum(abs(mD * vX)));


function obj = objective(vY, paramLambda, vX, mD)
    obj = (0.5 * sum( (vX - vY) .^ 2)) + (paramLambda * sum(abs(mD * vX))) ; 
end

