function ColourCentiles = ComputeColourCentiles(I, centileValues, normalize);

    %Computes colour centiles (percentiles)

    %Input:     I (colour image)
    %           centileValues (centile values, should be in [0 100])
    %           normalize (if 'Y' normalize output vector to sum 1)
    %Output:    Colour centiles
    %
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 


	[rows cols channels] = size(I);

	nValues = length(centileValues);

	ColourCentiles = zeros(1,0);

	for c = 1:channels
	
		CC = zeros(1,0);
	
		%serialize
		serializedImageValues = reshape(I(:,:,c),1,rows*cols);
	
		for v = 1:nValues
			CC = horzcat(CC, prctile(serializedImageValues, centileValues(v)));
		end
	
		%Normalize values
		if normalize == 'Y'
			CC = double(CC)/sum(CC);
		end
    
		ColourCentiles = horzcat(ColourCentiles, CC);
	end
	
end




