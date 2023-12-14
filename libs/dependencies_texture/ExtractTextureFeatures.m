function [textureFeatures, filteredImages] = ExtractTextureFeatures(image, maxFreq, numberOfFrequencies, numberOfOrientations, eta, gamma, k)


    %Input: image (grayscale image)
    %       maxFreq (max central frequency of the filter bank)
    %       numberOfFrequencies (number of frequencies)
    %       numberOfOrientations (number of orientations)
    %       eta, gamma (smoothing parameters)
    %       k (frequency spacing: 2 = octave, sqrt(2) = half octave)
    %
    %Output:   textureFeatures (mean and std of the absolute value of each transformed image)
    %          filteredImages (transformed images)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 

    bank = sg_createfilterbank(size(image), maxFreq, numberOfFrequencies, numberOfOrientations, 'eta', eta, 'gamma', gamma, 'k', k);


    filteredImages_raw = sg_filterwithbank(image,bank);

    normalize = 'Y';

    if normalize == 'Y'
        filteredImages = sg_resp2samplematrix(filteredImages_raw,'normalize',1);
    else
        filteredImages = sg_resp2samplematrix(filteredImages_raw,'normalize',0);
    end

    nImages = size(filteredImages);
    nImages = nImages(3);

    index = 1;
    for i = 1:nImages
        textureFeatures(index) = mean2(abs(filteredImages(:,:,i)));
        index = index + 1;
        textureFeatures(index) = std2(abs(filteredImages(:,:,i)));
        index = index + 1;
    end

end