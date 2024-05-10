function shadowImage=object_insertion(RGBimage,object,depthMap, xo, yo, dv)

% Normalize and resize object and depth map
object = imresize(object,[50 50]);
depthMap = double(rgb2gray(depthMap)); % Convert to grayscale if not already
depthMap = mat2gray(depthMap); % Normalize to range [0, 1]

% Scaling factors based on depth
maxScale = 1; % Maximum scale factor
minScale = 0.1; % Minimum scale factor
scaleFactors = minScale + (maxScale - minScale) * (1 - depthMap); % Inverse scaling
averageScaleFactor = mean(scaleFactors, 'all');

% Process the object mask
threshold = 10;
objectMask = rgb2gray(object) > threshold;
objectMask = imfill(objectMask, 'holes');
objectMask = bwareaopen(objectMask, 50);
se = strel('disk', 5);
objectMask = imclose(objectMask, se);
objectMask = imfill(objectMask, 'holes');
objectMask = imopen(objectMask, strel('disk', 3));

% Resize the object and mask
resizedObject = imresize(object, averageScaleFactor);
resizedMask = imresize(objectMask, averageScaleFactor);

% Calculate placement coordinates
[ySize, xSize, ~] = size(RGBimage);
objectHeight = size(resizedMask, 1);
objectWidth = size(resizedMask, 2);
xOffset = xo;
yOffset = yo;
placementY = max(1, min(yOffset, ySize - objectHeight));
placementX = max(1, min(xOffset, xSize - objectWidth));

% Check bounds
if placementY + objectHeight - 1 > ySize || placementX + objectWidth - 1 > xSize
    error('Object dimensions exceed image bounds after scaling and placement adjustments.');
end

% Shadow properties
sphereCenterX = placementX + objectWidth / 2;
sphereCenterY = placementY + objectHeight / 2;
figure;
for i=1:size(dv,1)
lightDirection = dv(i,:); % Light coming from top-right
lightDistance = 200;

% Calculate shadow position and dimensions
shadowLength = lightDistance / 2;
shadowWidth = size(resizedMask, 2) * 0.7;
shadowAngle = atan2(lightDirection(2), lightDirection(1)) * 180 / pi;
shadowX = sphereCenterX + lightDistance * lightDirection(1);
shadowY = sphereCenterY + lightDistance * lightDirection(2);

% Draw and rotate shadow
ellipse = imellipse(gca, [shadowX - 210, shadowY + 2*shadowLength, shadowWidth, shadowLength*0.7]);
setFixedAspectRatioMode(ellipse, true);
rotate(ellipse, [0 1 0], -shadowAngle, [shadowX, shadowY]);

% Apply shadow mask
drawnow;
shadowMask = createMask(ellipse, imshow(RGBimage));
shadowImage = RGBimage;
for k = 1:3
    channel = shadowImage(:,:,k);
    channel(shadowMask) = channel(shadowMask) * 0.8;
    shadowImage(:,:,k) = channel;
end

% Place the object into the image with shadow
for k = 1:3
    channel = shadowImage(placementY:placementY+objectHeight-1, placementX:placementX+objectWidth-1, k);
    objectChannel = resizedObject(:, :, k);
    channel(resizedMask) = objectChannel(resizedMask);
    shadowImage(placementY:placementY+objectHeight-1, placementX:placementX+objectWidth-1, k) = channel;
end

% Display the final image
imshow(shadowImage);
hold on
end
end
