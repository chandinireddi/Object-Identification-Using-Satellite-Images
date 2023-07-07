clear all;
close all;
clc;

% Specify the full path to the image file
imageFilePath = 'C:\Users\chandini\Downloads\image.1.jpg';

% Inputting image
I = imread(imageFilePath);

% 1. Image preprocessing
II = rgb2gray(I);
IG = imresize(II, [512, 512]);
figure;
imshow(IG)

for i = 1:512
    for j = 1:512
        if 120 <= IG(i,j) 
            IG(i,j) = 255;
        end
        if 120 > IG(i,j)
            IG(i,j) = 0;
        end
    end
end
figure;
imshow(IG)

% 2. Road extraction

% Binarize the image by thresholding.
mask = IG > 30;

% Find the areas
props = regionprops(logical(mask), 'Area');
allAreas = sort([props.Area]);

% Extract only blobs larger than 25.
mask = bwareaopen(mask, 25);

% Get rid of white frame around outside border.
mask = imclearborder(mask);

% Mask image to produce a masked grayscale image.
maskedGrayImage = IG; % First initialize.
maskedGrayImage(~mask) = 0; % Now mask
figure;
imshow(maskedGrayImage);

IG = maskedGrayImage;
for ii = 1:4:512
    for jj = 1:4:512
        c = 0;
        for l = ii:ii+3
            for m = jj:jj+3
                if IG(l, m) == 255
                    c = c + 1;
                end
            end
        end
        if c >= 4
            for l = ii:ii+3
                for m = jj:jj+3
                    IG(l, m) = 255; 
                end
            end
        end
        if c < 4
            for l = ii:ii+3
                for m = jj:jj+3
                    IG(l, m) = 0; 
                end
            end
        end
    end
end
figure;
imshow(IG);
