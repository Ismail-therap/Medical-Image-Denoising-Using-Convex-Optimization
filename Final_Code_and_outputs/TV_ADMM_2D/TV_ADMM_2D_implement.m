tic % start the timer

% Load image
mI = imread('C:/Users/TA-3/Desktop/MATH 518 Project/TV_ADMM/Data_or_Images/No_tumor/case_1.png');

original = imresize(mI, [512 512]); % resize the image to 515 by 512 pixels
mI = imresize(mI, [512 512]); % resize the image to 515 by 512 pixels
mI = rgb2gray(mI);
mI = im2double(mI);


% Add noise to the image
noise_level = 0.05;
noise = noise_level*randn(size(mI));
img_noisy = mI + noise;

numRows = size(mI, 1);
numCols = size(mI, 2);

mY = img_noisy;
vY = mY(:);



vXInit  = zeros(numRows * numCols, 1);
% Generate the Diff Operator (2D Gradient) by Finite Differences
mD = CreateGradientOperator(numRows, numCols);
vX = vXInit;


% Define parameter sets to evaluate
lambda_values = [0.01,0.1,0.5];
rho_values = [0.001,0.01,.1, 1];
numIterations = 100;

% Initialize variables to store results
best_ssim = 0;
best_lambda = 0;
best_rho = 0;




% Loop over all parameter combinations and evaluate PSNR and SSIM
for paramLambda = lambda_values
    for paramRho = rho_values
            % Call the ADMM function with the current parameter set
            [vX,objval] = SolveProxTvAdmm( vX, vY, mD, paramLambda,paramRho, numIterations);
            denoised_image = repmat(reshape(vX, numRows, numCols), [1, 1, 3]);

            % Evaluate SSIM for the denoised image            
            ssim_val = ssim(im2double(original),denoised_image);

             if ssim_val > best_ssim
                 best_ssim = ssim_val;
                 best_lambda_ssim = paramLambda;
                 best_rho_ssim = paramRho;
             end
    end
end


% Denoise using SSIM
paramLambda = best_lambda_ssim;
paramRho = best_rho_ssim;
  
 
vXInit  = zeros(numRows * numCols, 1);
% Generate the Diff Operator (2D Gradient) by Finite Differences
mD = CreateGradientOperator(numRows, numCols);
vX = vXInit;
[vX,objval] = SolveProxTvAdmm( vX, vY, mD, paramLambda,paramRho, numIterations);
denoised_img_ssim = repmat(reshape(vX, numRows, numCols), [1, 1, 3]);

 
% Display the best parameter set based on PSNR and SSIM
fprintf('Best parameter set based on SSIM: lambda = %.2f, rho = %d\n', best_lambda_ssim, best_rho_ssim);


% SSIM values

ssim_val = ssim(im2double(original),denoised_img_ssim);
disp(['SSIM = ',num2str(ssim_val)]);

figure('Position', [0 0 900 300]);

% Set the position and size of each subplot
subplot('Position', [0.03, 0.10, 0.30, 0.80]); imshow(im2double(original)); title('Original');
subplot('Position', [0.37, 0.10, 0.30, 0.80]); imshow(img_noisy); title(['Noisy (sigma = ', num2str(noise_level),')']); 
subplot('Position', [0.70, 0.10, 0.30, 0.80]); imshow(denoised_img_ssim); title(sprintf('lam = %.2f, rho = %d', best_lambda_ssim, best_rho_ssim));

objval

elapsed_time = toc; % stop the timer and get the elapsed time in seconds
elapsed_time_minutes = elapsed_time / 60; % convert to minutes
fprintf('Elapsed time: %.2f minutes\n', elapsed_time_minutes); % display the result