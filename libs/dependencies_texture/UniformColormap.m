function map = UniformColormap(nLevels)

	%Input:		nLevels (number of equal cubes into which the unit cube is partitioned)
	%Output:	centroids of each cube
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 

	nDivisions = round(nLevels^(1/3));
	map = zeros(nDivisions^3 ,3);

	counter = 1;
	for c1 = 1:nDivisions
		for c2 = 1:nDivisions
			for c3 = 1:nDivisions
				map(counter,:) = [1/(2*nDivisions) + (c1 - 1)/nDivisions,...
								  1/(2*nDivisions) + (c2 - 1)/nDivisions,...
								  1/(2*nDivisions) + (c3 - 1)/nDivisions];
				counter = counter + 1;
			end
		end
	end

end