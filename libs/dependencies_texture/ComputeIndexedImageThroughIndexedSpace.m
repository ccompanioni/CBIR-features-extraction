function [indexedImage] = ComputeIndexedImageThroughIndexedSpace(I, indexedSpace)

	%Input:		I (colour image); 
    %           indexedSpace (pre-partitioned colour space) 
	%Output:	indexedImage (indexed image)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 

    [rows cols channels] = size(I);
    indexedImage = uint8(zeros(rows, cols ,1));

    for r = 1:rows
        for c = 1:cols
            indexedImage(r,c) = indexedSpace(I(r,c,1) + 1,I(r,c,2) + 1,I(r,c,3) + 1);
        end
    end

end