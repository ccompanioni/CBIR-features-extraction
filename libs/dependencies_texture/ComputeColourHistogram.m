function h = ComputeColourHistogram(I, nBins)

	%Input:		I (multichannel image)
	%			nBins (number of bins for each channel)
	%Output:	h (colour histogram)
    %
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 

	[rows cols channels] = size(I);
	binSpan = 256./(nBins);

	h = zeros(nBins);

	for r = 1:rows
		for c = 1:cols
			position = zeros(1,3);
			for ch = 1:channels
				m = mod(I(r,c,ch), binSpan(ch));
				position(1, ch) = (I(r,c,ch) - m)/binSpan(ch) + 1;
			end
			h(position(1,1), position(1,2), position(1,3)) = h(position(1,1), position(1,2), position(1,3)) + 1;
		end
	end

	%Serialize output
	h = reshape(h, 1, prod(nBins));

	%Normalize output
	h = h/sum(h);

end



