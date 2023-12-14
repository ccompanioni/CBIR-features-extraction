function rgb = RGB_to_rgb(I);

	%Input:		I (RGB colour image)
	%Output:	rgb (rgb colour image)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 
	
	[rows cols channels] = size(I);

	I = double(I);

	%Convert to the rgb space through KUKKONEN-2001 formula
	rgb = zeros(rows, cols, channels);

	for r = 1:rows
		for c = 1:cols
			if (sum(I(r,c,:)) == 0)
				rgb(r,c,1) = 0;
				rgb(r,c,2) = 0;
				rgb(r,c,3) = 0;
			else
				rgb(r,c,1) = I(r,c,1)/(I(r,c,1) + I(r,c,2) + I(r,c,3));
				rgb(r,c,2) = I(r,c,2)/(I(r,c,1) + I(r,c,2) + I(r,c,3));
				rgb(r,c,3) = I(r,c,3)/(I(r,c,1) + I(r,c,2) + I(r,c,3));
			end
		end
	end
end