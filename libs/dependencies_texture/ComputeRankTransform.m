function RT = ComputeRankTransform(I);

    %Computes the rank transform of an image
    
    %Input:     I (one-channel image)
    %Output:    RT (rank transform)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 
    
    [rows cols] = size(I);

    nPixels = rows*cols;

    I = reshape(I, 1, nPixels);
    [sorted, indices] = sort(I, 'descend');
    RT(indices(1:nPixels)) = 1:nPixels;
    RT = reshape(RT, rows, cols);

end