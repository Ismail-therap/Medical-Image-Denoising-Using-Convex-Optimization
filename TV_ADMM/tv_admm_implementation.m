% Load image
img = imread('3 no.jpg');

img = im2double(img);

% Add noise to the image
noise_level = 0.2;
noise = noise_level*randn(size(img));
img_noisy = img + noise;

% Define parameter sets to evaluate
lambda_values = [0.1,0.5,1];
alpha_values = [0.5,1,1,1.5,1.8]; %Recommended that value ranges from 0.5 to 1.8
rho_values = [.01,.1, 1,10];

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
            fprintf('Parameters: lambda = %.2f, alpha = %.2f, rho = %d\n', lambda, alpha, rho)
            x = tv_admm(img_noisy(:), lambda, rho, alpha);
            x = reshape(x, size(img));
            
            % Evaluate PSNR and SSIM for the denoised image            
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
 
% Display the best parameter set based on PSNR and SSIM
fprintf('Best parameter set based on PSNR: lambda = %.2f, alpha = %.2f, rho = %d\n', best_lambda,best_alpha, best_rho);
fprintf('Best parameter set based on SSIM: lambda = %.2f, alpha = %.2f, rho = %d\n', best_lambda_ssim,best_alpha_ssim, best_rho_ssim);


% Compute PSNR and SSIM values
 psnr_val = psnr(denoised_img_psnr,img);
 ssim_val = ssim(denoised_img_ssim,img);
 
 disp(['PSNR = ',num2str(psnr_val)]);
 disp(['SSIM = ',num2str(ssim_val)]);

figure;
subplot(2,2,1); imshow(img); title('Original');
subplot(2,2,2); imshow(img_noisy); title(['Noisy (sigma = ', num2str(noise_level),')']); 
subplot(2,2,3); imshow(denoised_img_psnr); title(sprintf('PSNR: lambda = %.2f, alpha = %.2f, rho = %d\n', best_lambda,best_alpha, best_rho));
subplot(2,2,4); imshow(denoised_img_ssim); title(sprintf('SSIM: lambda = %.2f, alpha = %.2f, rho = %d\n', best_lambda_ssim,best_alpha_ssim, best_rho_ssim));
% Add a main title to the figure
sgtitle('TV ADMM');
