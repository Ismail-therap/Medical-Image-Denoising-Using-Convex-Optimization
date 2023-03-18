
% Load image
I =  imread('C:/Users/TA-3/Desktop/MATH 518 Project/Y1.jpg');

% Add noise
sigma = 0.1;
I_noisy = imnoise(I, 'gaussian', 0, sigma^2);


% % Denoise using ADMM
% lambda = 100;
% rho = .001;
% num_iters = 100;
% 
% I_denoised = admm(double(I_noisy)/255, lambda, rho, num_iters);
% % Display results
% figure;
% subplot(131); imshow(I); title('Original');
% subplot(132); imshow(I_noisy); title('Noisy');
% subplot(133); imshow(I_denoised); title('Denoised');
% 
% % Compute PSNR and SSIM values
% im_original = im2double(I);
% psnr_val = psnr(I_denoised,im_original);
% ssim_val = ssim(I_denoised,im_original);
% 
% disp(['PSNR = ',num2str(psnr_val)]);
% disp(['SSIM = ',num2str(ssim_val)]);







% Define the range of parameter values to search over
lambda_values = 0.1:1:10;
rho_values = 0.001:0.01:.1;
num_iter_values = 50:100;

% Initialize variables to store results
best_psnr = 0;
best_ssim = 0;
best_lambda = 0;
best_rho = 0;
best_num_iter = 0;

% Loop over all parameter combinations and evaluate PSNR and SSIM
for lambda = lambda_values
    for rho = rho_values
        for num_iter = num_iter_values
            % Call the ADMM function with the current parameter set
            denoised_img = admm(double(I_noisy)/255, lambda, rho, num_iter);
            % Evaluate PSNR and SSIM for the denoised image
            im_true = im2double(I);
            psnr_val = psnr(im_true, denoised_img);
            ssim_val = ssim(im_true, denoised_img);
            % Update best results if current values are better
            if psnr_val > best_psnr
                best_psnr = psnr_val;
                best_lambda = lambda;
                best_rho = rho;
                best_num_iter = num_iter;
            end
            if ssim_val > best_ssim
                best_ssim = ssim_val;
                best_lambda_ssim = lambda;
                best_rho_ssim = rho;
                best_num_iter_ssim = num_iter;
            end
        end
    end
end

% Display the best parameter set based on PSNR and SSIM
fprintf('Best parameter set based on PSNR: lambda = %.2f, rho = %.2f, num_iter = %d\n', best_lambda, best_rho, best_num_iter);
fprintf('Best parameter set based on SSIM: lambda = %.2f, rho = %.2f, num_iter = %d\n', best_lambda_ssim, best_rho_ssim, best_num_iter_ssim);



 % Denoise using ADMM
 lambda = best_lambda;
 rho = best_rho;
 num_iters = best_num_iter;


 I_denoised = admm(double(I_noisy)/255, lambda, rho, num_iters);
 % Display results
 figure;
 subplot(131); imshow(I); title('Original');
 subplot(132); imshow(I_noisy); title('Noisy');
 subplot(133); imshow(I_denoised); title('Denoised');
 
 % Compute PSNR and SSIM values
 im_original = im2double(I);
 psnr_val = psnr(I_denoised,im_original);
 ssim_val = ssim(I_denoised,im_original);
 
 disp(['PSNR = ',num2str(psnr_val)]);
 disp(['SSIM = ',num2str(ssim_val)]);

