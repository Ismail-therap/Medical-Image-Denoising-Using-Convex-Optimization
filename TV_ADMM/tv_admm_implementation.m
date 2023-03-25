% Load image
img = imread('C:/Users/TA-3/Desktop/MATH 518 Project/No_tumor/case_2.jpg');
img = im2double(img);

% Add noise to the image
noise_level = 0.1;
noise = noise_level*randn(size(img));
img_noisy = img + noise;

% % Parameters for TV denoising
% lambda = 0.1;
% rho = 1;
% alpha = 1.8;
% 
% % Apply TV denoising using ADMM
% [x, ~] = tv_admm(img_noisy(:), lambda, rho, alpha);
% 
% % Reshape the denoised image
% x = reshape(x, size(img));
% 
% 
% % Display images
% figure;
% subplot(1,3,1); imshow(img); title('Original Image');
% subplot(1,3,2); imshow(img_noisy); title('Noisy Image');
% subplot(1,3,3); imshow(x); title('Denoised Image');
% 
% 
% psnr_val = psnr(img, x);
% ssim_val = ssim(img, x);



%%%%%%%%%%%%%%%%%%%%


% Define parameter sets to evaluate
lambda_values = [0.1,0.5,1];
alpha_values = [0.5,1, 1.5, 1.8];
rho_values = [.001,.01,.1, 1];
%param_set = combvec(lambda_list, alpha_list,rho_list);

% Initialize results matrices
% psnr_results = zeros(size(param_set, 2), 1);
% ssim_results = zeros(size(param_set, 2), 1);


% Initialize variables to store results
best_psnr = 0;
best_ssim = 0;
best_lambda = 0;
best_rho = 0;
best_alpha = 0;





% Loop over all parameter combinations and evaluate PSNR and SSIM
for lambda = lambda_values
    for rho = rho_values
        for alpha = alpha_values
            % Call the ADMM function with the current parameter set
            %denoised_img = admm(double(I_noisy)/255, lambda, rho, num_iter);
            fprintf('Parameters: lambda = %.2f, alpha = %.2f, rho = %d\n', lambda, alpha, rho)
            x = tv_admm(img_noisy(:), lambda, rho, alpha);
            x = reshape(x, size(img));
            
            % Evaluate PSNR and SSIM for the denoised image
            %im_true = im2double(I);
            
            psnr_val = psnr(x, img);
            ssim_val = ssim(x, img);
            % Update best results if current values are better
            if psnr_val > best_psnr
                best_psnr = psnr_val;
                best_lambda = lambda;
                best_rho = rho;
                best_alpha = alpha;
            end
            if ssim_val > best_ssim
                best_ssim = ssim_val;
                best_lambda_ssim = lambda;
                best_rho_ssim = rho;
                best_alpha_ssim = alpha;
            end
        end
    end
end


 % Denoise using PSNR
 lambda = best_lambda;
 rho = best_rho;
 alpha = best_alpha;
 x = tv_admm(img_noisy(:), lambda, rho, alpha);
 denoised_img_psnr = reshape(x, size(img));

 
 % Denoise using ADMM
 lambda = best_lambda_ssim;
 rho = best_rho_ssim;
 alpha = best_alpha_ssim;
 x = tv_admm(img_noisy(:), lambda, rho, alpha);
 denoised_img_ssim = reshape(x, size(img));
 
 
 
 
%  % Denoise image using best parameter set based on PSNR
% lambda = lambda_psnr;
% rho = alpha_psnr;
% alpha = rho_psnr;
% [x, ~] = tv_admm(img_noisy(:), lambda, rho, alpha);
% denoised_img_psnr = reshape(x, size(img));
% 
% % Denoise image using best parameter set based on SSIM
% lambda = lambda_ssim;
% rho = alpha_ssim;
% alpha = rho_ssim;
% [x, ~] = tv_admm(img_noisy(:), lambda, rho, alpha);
% denoised_img_ssim = reshape(x, size(img));
%  
% 
% % Loop through parameter sets
% for i = 1:size(param_set, 3)
%     % Get current parameter values
%     lambda = param_set(1, i);
%     alpha = param_set(2, i);
%     rho = param_set(3, i);
%    
%     % Apply TV denoising using ADMM
%     fprintf('Parameters: lambda = %.2f, alpha = %.2f, rho = %d\n', lambda, alpha, rho)
%     [x, ~] = tv_admm(img_noisy(:), lambda, rho, alpha);
%     
%     % Evaluate denoised image using PSNR and SSIM
%     % x = denoised image
%     % img = original image
%     x = reshape(x, size(img));
%     psnr_results(i) = psnr(x, img);
%     ssim_results(i) = ssim(x, img);
% end
% 
% % Find parameter set with highest PSNR and SSIM
% [max_psnr, idx_psnr] = max(psnr_results);
% [max_ssim, idx_ssim] = max(ssim_results);
% 
% % Get corresponding parameter values
% lambda_psnr = param_set(1, idx_psnr);
% alpha_psnr = param_set(2, idx_psnr);
% rho_psnr = param_set(3, idx_psnr);
% 
% lambda_ssim = param_set(1, idx_ssim);
% alpha_ssim = param_set(2, idx_ssim);
% rho_ssim = param_set(2, idx_ssim);







% Display the best parameter set based on PSNR and SSIM
fprintf('Best parameter set based on PSNR: lambda = %.2f, alpha = %.2f, rho = %d\n', lambda_psnr, alpha_psnr, rho_psnr);
fprintf('Best parameter set based on SSIM: lambda = %.2f, alpha = %.2f, rho = %d\n', lambda_ssim, alpha_ssim, rho_ssim);


% Compute PSNR and SSIM values
 psnr_val = psnr(denoised_img_psnr,img);
 ssim_val = ssim(denoised_img_ssim,img);
 
 disp(['PSNR = ',num2str(psnr_val)]);
 disp(['SSIM = ',num2str(ssim_val)]);

figure;
subplot(2,2,1); imshow(img); title('Original');
subplot(2,2,2); imshow(img_noisy); title(['Noisy (sigma = ', num2str(noise_level),')']); 
subplot(2,2,3); imshow(denoised_img_psnr); title(sprintf('PSNR: lambda = %.2f, alpha = %.2f, rho = %d\n', lambda_psnr, alpha_psnr, rho_psnr));
subplot(2,2,4); imshow(denoised_img_ssim); title(sprintf('SSIM: lambda = %.2f, alpha = %.2f, rho = %d\n', lambda_ssim, alpha_ssim, rho_ssim));
% Add a main title to the figure
sgtitle('TV ADMM');
