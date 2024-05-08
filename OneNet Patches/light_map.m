clc;
clear all;
close all;

load('predictions.mat');  % Ensure lightColors contains the average RGB values
lightColors= [predictions(:,:,1),predictions(:,:,2),predictions(:,:,3)]*255;
% Read the original image
I = imread('6.png');

% Get the size of the image
[rows, cols, channels] = size(I);

% Define the size of each patch
patchSize =100;  % You can change this value to experiment with different patch sizes

% Initialize the light map image
lightMap = zeros(rows, cols, 3, 'uint8');

% Counter for accessing rows in lightColors
colorIndex = 1;

% Loop over the image in blocks of patchSize x patchSize to fill the light map
for i = 1:patchSize:rows
    for j = 1:patchSize:cols
        % Extract the end points for the current patch
        endRow = min(i+patchSize-1, rows);
        endCol = min(j+patchSize-1, cols);

        % Assign the average color to each patch in the light map
        lightMap(i:endRow, j:endCol, 1) = uint8(lightColors(colorIndex, 1));
        lightMap(i:endRow, j:endCol, 2) = uint8(lightColors(colorIndex, 2));
        lightMap(i:endRow, j:endCol, 3) = uint8(lightColors(colorIndex, 3));

        % Increment the color index
        colorIndex = colorIndex + 1;
    end
end

% Display the original and the light map images
figure;
subplot(1, 2, 1);
imshow(I);
title('Original Image');

subplot(1, 2, 2);
imshow(lightMap);
title('Light Map');

% Optionally, apply Gaussian filtering to smooth the light map and display it
smoothedLightMap = imgaussfilt3(lightMap, 0.1);
figure;
imshow(smoothedLightMap);
title('Smoothed Light Map');

% Optionally, save the light map image
imwrite(lightMap, 'lightMap.png');
imwrite(smoothedLightMap, 'smoothedLightMap.png');
