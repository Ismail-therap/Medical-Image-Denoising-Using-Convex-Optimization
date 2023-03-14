function x = admm(y, lambda, rho, num_iters)
% ADMM algorithm for image denoising

% Inputs:
% y: noisy input image
% lambda: regularization parameter
% rho: augmented Lagrangian parameter
% num_iters: number of iterations

% Outputs:
% x: denoised image

% Define proximal operators
prox_g = @(x, lambda) max(0, 1-lambda./max(1e-15, abs(x))) .* x;
prox_f = @(x) fft2(x);
prox_f_t = @(x) real(ifft2(x));

% Initialize variables
x = y;
z = zeros(size(x));
u = zeros(size(x));

% ADMM iterations
for i = 1:num_iters
    % x-update using FFT
    x = prox_f_t(prox_f(x) + rho*(prox_f_t(z - u) - y));
    
    % z-update using shrinkage
    z = prox_g(x + u, lambda/rho);
    
    % dual variable update
    u = u + x - z;
    
end


end
