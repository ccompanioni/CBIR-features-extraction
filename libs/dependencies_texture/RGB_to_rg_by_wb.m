function rg_by_wb = RGB_to_rg_by_wb(I);

    %Input: I (RGB image)
    %
    %Output: rg_by_wb (image in the rg_by_wb colour space)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 
    
    [rows cols channels] = size(I);

    I = double(I);
    I = I/255;

    %Convert to the rg_by_wb space 
    rg_by_wb = zeros(rows, cols, channels);
    P = [1 -1 0; -1 -1 2; 1 1 1];	%conversion matrix

    rg_max = 1;
    rg_min = -1;
    by_max = 2;
    by_min = -2;
    wb_max = 3;
    wb_min = 0;

    for r = 1:rows
        for c = 1:cols
            rg_by_wb(r,c,:) = P*[I(r,c,1); I(r,c,2); I(r,c,3)];
		
            rg_by_wb(r,c,1) = (rg_by_wb(r,c,1) - rg_min)/(rg_max - rg_min);
            rg_by_wb(r,c,2) = (rg_by_wb(r,c,2) - by_min)/(by_max - by_min);
            rg_by_wb(r,c,3) = (rg_by_wb(r,c,3) - wb_min)/(wb_max - wb_min);
        end
    end

    %Rescale and discretize
    rg_by_wb = round(255*rg_by_wb);
    rg_by_wb = uint8(rg_by_wb);

end