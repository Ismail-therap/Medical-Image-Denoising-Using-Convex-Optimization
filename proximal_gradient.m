function denoised_img = proximal_gradient(im_noisy, lambda, alpha, max_iter,tol)
%Proximal gradient method for image denoising

%Inputs:
%im_noisy: Noisy input image
%lambda: Regularization parameter
%alpha: Proportionality constant for quadratic data term
%max_iter: Maximum number of iterations
%tol: Tolerance level for convergence

%Output:
%denoised_img: Denoised image using the proximal gradient method

% Proximal operator
prox_op = @(x, lambda, alpha) max(0, x - lambda*alpha) - max(0, -x - lambda*alpha);


% Proximal gradient descent
denoised_img = im_noisy;
err = zeros(max_iter, 1);

for i = 1:max_iter
    denoised_img_prev = denoised_img;
    
    % Gradient step
    grad = 2*(denoised_img - im_noisy) + 2*alpha*denoised_img;
    denoised_img = denoised_img - lambda*grad;
    
    % Proximal step
    denoised_img = prox_op(denoised_img, lambda, alpha);
    
    % Check convergence
    err(i) = norm(denoised_img(:) - denoised_img_prev(:)) / norm(denoised_img_prev(:));
    if err(i) < tol
        break;
    end
end



end
