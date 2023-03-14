% Load image

clear;
close all;

% Load image
im_original =  imread('C:/Users/TA-3/Desktop/MATH 518 Project/Y1.jpg');
im_original = im2double(im_original);


% Add Gaussian noise
sigma = 0.1;
noise = sigma*randn(size(im_original));
im_noisy = im_original + noise;

% Parameters
lambda = 0.1;
alpha = 0.05;
max_iter = 100;
tol = 1e-5;
im_noisy = im_noisy;


denoised_img = proximal_gradient(im_noisy, lambda, alpha, max_iter,tol);


% Display results
%figure, imshow(denoised_img), title('Denoised image');

% Compute PSNR and SSIM
psnr_val = psnr(denoised_img, im_original, 1);
ssim_val = ssim(denoised_img, im_original);
fprintf('PSNR = %f dB\n', psnr_val);
fprintf('SSIM = %f\n', ssim_val);


% Display results
figure;
subplot(131); imshow(im_original); title('Original');
subplot(132); imshow(im_noisy); title('Noisy');
subplot(133); imshow(denoised_img); title('Denoised');

