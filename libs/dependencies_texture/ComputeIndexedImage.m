function [indexedImage] = ComputeIndexedImage(I, map, distanceType)

	%Input:		I (input image)
	%			map (centroids of the cubes into which the unit cube is partitioned. Use UniformColormap to compute it)
	%			distanceType (distance used to find the nearest representative colour)
	%Output:	indexedImage (indexed image)
    %
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 

	I = double(I);
	map = 255*double(map);

	rows = size(I,1);
	cols = size(I,2);
	map_length = size(map,1);

	indexedImage = zeros(rows, cols);


	for r = 1:rows
		for c = 1:cols
        
			R = I(r,c,1);
			G = I(r,c,2);
			B = I(r,c,3);       
			max_distance = 255*sqrt(3);
        
			for m = 1:map_length
				switch distanceType
					case 'euclidean'
						distance = sqrt((R - map(m,1))^2 + (G - map(m,2))^2 + (B - map(m,3))^2);
					case 'cityblock'
						distance = abs(R - map(m,1)) + abs(G - map(m,2)) + abs(B - map(m,3));
					otherwise
						distance = sqrt((R - map(m,1))^2 + (G - map(m,2))^2 + (B - map(m,3))^2);
				end
            
				if distance < max_distance;
					indexedImage(r,c) = m - 1;
					max_distance = distance;
				end
            
			end
		end
	end

end