function transformedVector = TrasformFeatureVectorFFT(featureVector, nFreqs, vectorType);

    %Applies DFT normalization to Gabor features for rotation invariance
    %
	%Input:		featureVector (Gabor features)
    %           nFreqs (number of frequencies of the Gabor filter bank)
    %           vectorType (type of feature vector: 'MV' = mean + std, 'M' = mean only)
    %           
	%Output:	transformedVector (DFT transformed, rotationally-invariant feature vector)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 

    transformedVector = zeros(0,0);
    transformedSnippet = zeros(0,0);

    if vectorType == 'MV'
	
        nOrnts = size(featureVector, 2)/(2*nFreqs);
		
        meanValues = ExtractMeanValuesFromFeatureDatabase(featureVector);
        stdValues = ExtractStdValuesFromFeatureDatabase(featureVector);
    

        for i = 1:nFreqs

            %Mean values
            vectorSnippet = meanValues((1 + (i-1)*nOrnts):(i*nOrnts));
            transformedSnippet = TransformVectorSnippetFFT(vectorSnippet);
            transformedVector = horzcat(transformedVector, transformedSnippet);
		
            %Standard dev
            vectorSnippet = stdValues((1 + (i-1)*nOrnts):(i*nOrnts));
            transformedSnippet = TransformVectorSnippetFFT(vectorSnippet);
            transformedVector = horzcat(transformedVector, transformedSnippet);
		

        end
    elseif vectorType == 'M'
        for i = 1:nFreqs
		
            nOrnts = size(featureVector, 2)/(nFreqs);

            meanValues = featureVector;
		
            %Mean values
            vectorSnippet = meanValues((1 + (i-1)*nOrnts):(i*nOrnts));
            transformedSnippet = TransformVectorSnippetFFT(vectorSnippet);
            transformedVector = horzcat(transformedVector, transformedSnippet);
	
        end      
    end

end

