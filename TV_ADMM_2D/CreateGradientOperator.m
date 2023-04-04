function [ mD ] = CreateGradientOperator( numRows, numCols )

% Vertical Operator - T(numRows)
mT  = spdiags([ones(numRows - 1, 1), -ones(numRows - 1, 1)], [0, 1], numRows - 1, numRows);
mDv = kron(eye(numCols), mT);

% Vertical Operator - T(numCols)
mT  = spdiags([ones(numCols, 1), -ones(numCols, 1)], [0, 1], numCols - 1, numCols);
mDh = kron(mT, eye(numRows));

mD = [mDv; mDh];


end