function h = CCRColour(X, indexedSpace, ccrType)

	%Input:		X (colour image)
	%			indexedSpace (partitioned colour space)
    %           ccrType (type of CCR operator. Can be: 'CCR3x3', 'CCR81ri', 'CCR81riu')
	%Output:	h (N-1 concatenated CCR histograms, where N is the number of levels into which the colour space is partitioned)
    %
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 

    nLevels = double(max(max(max(indexedSpace))) + 1);

    % Coeficients used in bilinear interpolation
    center  =  (1-1/sqrt(2))^2;
    corner  =  (1/sqrt(2))^2;
    diagon  =  (1-1/sqrt(2))*(1/sqrt(2));

    % Conversion to avoid errors when using sort, unique...
    X = double(X);

    % Image size
    [L M C] = size(X);
		

    histCodesCCR81 = zeros((nLevels-1),512);
    count = 0;
    for l = 2:(L-1)
        for m = 2:(M-1)

            %Get the 3x3 window
            XNE = X(l-1,m-1,:);
            XN = X(l-1,m,:);
            XNW = X(l-1,m+1,:);
            XE = X(l,m-1,:);
            X0 = X(l,m,:);
            XW = X(l,m+1,:);
            XSE = X(l+1,m-1,:);
            XS = X(l+1,m,:);
            XSW = X(l+1,m+1,:);
		
            %Interpolate
            if (~strcmp(ccrType, 'CCR3x3'))
                XNE = round(corner*XNE + center*X0 + diagon*XE + diagon*XN); 
                XNW = round(corner*XNW + center*X0 + diagon*XW + diagon*XN); 
                XSE = round(corner*XSE + center*X0 + diagon*XE + diagon*XS); 
                XSW = round(corner*XSW + center*X0 + diagon*XW + diagon*XS);
            end
			
            WIN3x3 = uint8(round([XNE XN XNW; XE X0 XW; XSE XS XSW]));
			
            %Compute the indexed window
            WIN3x3_INDEXED = ComputeIndexedImageThroughIndexedSpace(WIN3x3, indexedSpace);

            for i = uint8(1):uint8((nLevels - 1))
                ccr_code = 256*(WIN3x3_INDEXED(3,1) == (i - 1)) + 128*(WIN3x3_INDEXED(3,2) == (i - 1))  + 64*(WIN3x3_INDEXED(3,3) == (i - 1)) +...
                        		 32*(WIN3x3_INDEXED(2,1) == (i - 1)) + 16*(WIN3x3_INDEXED(2,2) == (i - 1)) + 8*(WIN3x3_INDEXED(2,3) == (i - 1)) +...
                    			 4*(WIN3x3_INDEXED(1,1) == (i - 1)) + 2*(WIN3x3_INDEXED(1,2) == (i - 1)) + (WIN3x3_INDEXED(1,3) == (i - 1));
                histCodesCCR81(i,ccr_code + 1) = histCodesCCR81(i,ccr_code + 1) + 1;
            end
            count = count + 1;
        end
    end

    %Reorder histograms
    switch ccrType
        case 'CCR3x3'
            h = histCodesCCR81;
        case 'CCR81ri'
            lut81 = lutRotInv('CCR81ri');
            nbins = length(unique(lut81));
            histCodesCCR81ri = zeros(nLevels-1,nbins);
            for i = 1:(nLevels - 1)
                for p = 1:size(histCodesCCR81,2);
                    r = lut81(p);
                    histCodesCCR81ri(i,r+1) = histCodesCCR81ri(i,r+1) + histCodesCCR81(i,p);
                end
            end
            histCodesCCR81ri = reshape(histCodesCCR81ri', 1, size(histCodesCCR81ri,2)*(nLevels-1));
            h = histCodesCCR81ri;
        case 'CCR81riu'
            lut81 = lutRotInv('CCR81riu2');
            nbins = length(unique(lut81));
            histCodesCCR81riu = zeros(nLevels-1,nbins);
            for i = 1:(nLevels - 1)
                for p = 1:size(histCodesCCR81,2);
                    r = lut81(p);
                    histCodesCCR81riu(i,r+1) =  histCodesCCR81riu(i,r+1) + histCodesCCR81(i,p);
                end
            end
            histCodesCCR81riu = reshape(histCodesCCR81riu', 1, size(histCodesCCR81riu,2)*(nLevels-1));
            histCodesCCR81ri = zeros(nLevels,nbins);
        	h = histCodesCCR81riu;
    end
	
end


