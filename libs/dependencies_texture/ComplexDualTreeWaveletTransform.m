function [featureVector] = ComplexDualTreeWaveletTransform(I, numberOfScales)

    %Dual-tree Complex Wavelet Transform
    
    %Input:     I (single channel image)
    %           numberOfScale (number of scales for DT-CWT)
    %Output:    featureVector (feature vector)
    %
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 

    featureVector = [];

    %Convert to double
    I = double(I)/255;

    [Faf, Fsf] = FSfarras;
    [af, sf] = dualfilt1;
    w = cplxdual2D(I, numberOfScales, Faf, af);
    
    for s = 1:numberOfScales
        
        %For orientation arrangement see: cplxdual2D_plots
        AVG = [];
        STD = [];
        
        for k = 1:2
            for d = 1:3
                AVG = [AVG, mean2(abs(w{s}{1}{k}{d} + i*w{s}{2}{k}{d}))];
            end
        end
        for k = 1:2
            for d = 1:3
                STD = [STD, std2(abs(w{s}{1}{k}{d} + i*w{s}{2}{k}{d}))];
            end
        end
        
        %Average for rotation-invariance
        featureVector = [featureVector mean(AVG) mean(STD)];
    end

end