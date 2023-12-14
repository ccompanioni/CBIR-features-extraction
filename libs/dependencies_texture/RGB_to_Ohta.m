function I1_I2_I3 = RGB_to_Ohta(I);

	%Input:		I (RGB colour image)
	%Output:	I1_I2_I3 (colour image in Ohta's colour space)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 
    
	[rows cols channels] = size(I);

	I = double(I);


	for r = 1:rows
		for c = 1:cols
			I1_I2_I3(r,c,1) = (I(r,c,1) + I(r,c,2) + I(r,c,3))/3;
			I1_I2_I3(r,c,2) = (I(r,c,1) - I(r,c,3))/2;
			I1_I2_I3(r,c,3) = (2*I(r,c,2) - I(r,c,1) - I(r,c,3))/4;
		end
	end

end
