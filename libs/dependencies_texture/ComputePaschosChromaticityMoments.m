function [MT, MD] = ComputePaschosChromaticityMoments(I, exponents, normalize)

	%Computes chromaticity moments
	%
    %Input:		I (colour image in xyY); 
    %           exponents (an N x 2 matrix, each row is a couple of exponents for x and y channels, respectively) 
	%Output:	MT (chromaticity moments - MT)
    %           MT (chromaticity moments - MD)
    %
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 

	nLevels = 100;
	minVal = 0;
	maxVal = 100;

	binCentresX = minVal:(maxVal - minVal)/(nLevels - 1):maxVal;
	binCentresY = minVal:(maxVal - minVal)/(nLevels - 1):maxVal;
	binStruct2D = cell([1 2]);
	binStruct2D{1} = binCentresX;
	binStruct2D{2} = binCentresY;

	I = round(maxVal*I);

	n_levels = 100;
	n_moments = size(exponents, 1);

	MT = zeros(1, n_moments);
	MD = zeros(1, n_moments);


	[rows cols channels] = size(I);

	%Create the chromaticity diagram
	firstColumn = reshape(I(:,:,1), rows*cols ,1);
	secondColumn = reshape(I(:,:,2), rows*cols ,1);
	CD = hist3([firstColumn, secondColumn], binStruct2D);

	%Make the diagram independent of the number of pixels
	CD = CD/(rows*cols);

	%Compute the trace of the chromaticity diagram
	CD_T = CD > 0;			
	

	%Compute the chromaticity moments
	count = 1;
	for i = 1:n_moments
		for x = 1:nLevels
			for y = 1:nLevels
				MT(1, i) = MT(1, i) + (binCentresX(x)^(exponents(i,1)))*(binCentresY(y)^(exponents(i,2)))*CD_T(x, y);
				MD(1, i) = MD(1, i) + (binCentresX(x)^(exponents(i,1)))*(binCentresY(y)^(exponents(i,2)))*CD(x, y);
			end
		end
	
		%Normalize if required
		if normalize == 'Y'
		
			%Normalizing factor - MT moments
			N_MT = 0;
			for x = 1:nLevels
				for y = 1:nLevels
					N_MT = N_MT + binCentresX(nLevels)^exponents(i,1) + binCentresY(nLevels)^exponents(i,2);	
				end
			end
		
			%Normalizing factor - MD moments
			N_MD = (binCentresX(nLevels)^exponents(i,1))*(binCentresY(nLevels)^exponents(i,2));						
				
			MT(1, i) = MT(1, i)/N_MT;
			MD(1, i) = MD(1, i)/N_MD;
		end
	
		count = count + 1;
	end
end