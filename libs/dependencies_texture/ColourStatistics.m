function [featureVector] = ColourStatistics(I, colourSpace) 

	%Input:		I (colour image in sRGB)
	%			colourSpace (if 'Lab' image is converted into Lab, otherwise does nothing)
	%Output:	featureVector (mean + std + standardized moments from 2nd to 5th order for each channel)
    %
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 


    H = zeros(3,256);
    binStructure = [];

    if colourSpace == 'Lab'
		 
		%Convert to Lab
		C = makecform('srgb2lab');
        I = applycform(I,C);
        I = lab2double(I);
		
        binStructure = [0 100 256; -128.0 127.0 256; -128.0 127.0 256];
        [H(1,:), H(2,:), H(3,:)] = ComputeMarginalColourHistograms(I, binStructure);
    else
        I = double(I);
        binStructure = [0 255 256; 0 255 256; 0 255 256];
        [H(1,:), H(2,:), H(3,:)] = ComputeMarginalColourHistograms(I, binStructure);
    end
    
    MV = zeros(0,0);
    STDV = zeros(0,0);
    HIST_MOMENTS = zeros(0,0);

    [rows cols channels] = size(I);

    for i = 1:channels
        %Mean
        MV = horzcat(MV, mean2(I(:,:,i)));
        
        %Standard deviation
        STDV = horzcat(STDV, std2(I(:,:,i)));

        %Moments from 2 to 5th order
        for o = 3:5
            HIST_MOMENTS = horzcat(HIST_MOMENTS, ComputeMoment(H(i,:), binStructure(i,:), o, MV(i), STDV(i)));   
        end
    end

    featureVector = [MV, STDV, HIST_MOMENTS];
end

function M = ComputeMoment(H, binStructure, order, m, v)
    
    H = H/sum(H);

    L = length(H);
    M = 0;
    values = binStructure(1):(binStructure(2) - binStructure(1))/(binStructure(3) - 1):binStructure(2);
        
    for l = 1:L
        M = M + ((values(l) - m)^order)*H(l);
    end
    
    %Compute standardized moments
    M = M/(v^order);
end