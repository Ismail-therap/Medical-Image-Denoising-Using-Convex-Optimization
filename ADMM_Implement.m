
% Load image
I =  imread('C:/Users/TA-3/Desktop/MATH 518 Project/Y1.jpg');

% Add noise
sigma = 0.1;
I_noisy = imnoise(I, 'gaussian', 0, sigma^2);


% Denoise using ADMM
lambda = 100;
rho = .001;
num_iters = 100;

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
