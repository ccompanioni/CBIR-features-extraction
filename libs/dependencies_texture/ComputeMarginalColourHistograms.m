function [h1, h2, h3] = ComputeMarginalColourHistograms(I, binsStructure);

	%nBins is a 3 x 3 matrix
	%1st row: min_1 max_1 nBins_1
	%2nd row: min_2 max_2 nBins_2
	%3rd row: min_3 max_3 mBins_3

	[rows cols channels] = size(I);

	%I = colour image (input)
	%n1, n2 and n3 = levels of each marginal histogram
	I = double(I);

	h1 = hist(reshape(I(:,:,1), 1, rows*cols), binsStructure(1,1):(binsStructure(1,2) - binsStructure(1,1))/(binsStructure(1,3) - 1):binsStructure(1,2))/(rows*cols);
	h2 = hist(reshape(I(:,:,2), 1, rows*cols), binsStructure(2,1):(binsStructure(2,2) - binsStructure(2,1))/(binsStructure(2,3) - 1):binsStructure(2,2))/(rows*cols);
	h3 = hist(reshape(I(:,:,3), 1, rows*cols), binsStructure(3,1):(binsStructure(3,2) - binsStructure(3,1))/(binsStructure(3,3) - 1):binsStructure(3,2))/(rows*cols);

end