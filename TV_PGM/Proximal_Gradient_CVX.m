% Load image
img = imread('C:/Users/TA-3/Desktop/MATH 518 Project/No_tumor/case_2.jpg');
img = im2double(img);

% Add noise to the image
noise_level = 0.1;
noise = noise_level*randn(size(img));
img_noisy = img + noise;

% Flatten the image into a vector
y = img_noisy(:);

% Set up the Diff Operator (1D Gradient) by Finite Differences
n = numel(y);
D = spdiags([-ones(n,1) ones(n,1)], [0 1], n-1, n);

% Set up parameters for TV denoising problem
lambda = 0.1; % regularization parameter

% Solve the TV denoising problem using CVX
cvx_begin
    variable x(n);
    minimize(0.5*sum_square(x - y) + lambda*norm(D*x,1));
cvx_end

% Reshape the solution vector into an image
img_denoised = reshape(x, size(img));

% Display the results
subplot(1,3,1);
imshow(img);
title('Original Image');

subplot(1,3,2);
imshow(img_noisy);
title('Noisy Image');

subplot(1,3,3);
imshow(img_denoised);
title('Denoised Image');


