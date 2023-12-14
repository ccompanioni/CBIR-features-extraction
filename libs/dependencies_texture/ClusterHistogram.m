function H = ClusterHistogram(h, lutName)

    %Computes rotationally-invariant features

    %Input:     h (LBP, CCR, etc. non-rotationally-invariant histogram)
    %           lutName (lookup table for rotationally-equivalent pattern)
    %Output:    H (rotationally-invariant features)
    %
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 
    
    LUT = lutRotInv(lutName);

    nbins = length(unique(LUT));

    H = zeros(1,nbins);

    for p = 1:length(h);
        r = LUT(p);
        H(r+1) =  H(r+1) + h(p);
    end

end
