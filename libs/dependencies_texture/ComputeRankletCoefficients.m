function [RC, RC_DFT] = ComputeRankletCoefficients(I, minWindowSize, maxWindowSize, step, directions, directionSizes, circularInterpolation, interChannels)

    %Input:     I (colour image)
    %           minWindowSize (size of the smallest scanning window)
    %           maxWindowSize (size of the biggest scanning window)
    %           step (step from minWindowSize and max WindowSize)
    %
    %           directions (vector containing directions of linear and diagonal subdivisions)
    %           e.g.: directions = {'0' '30' '60' '0D' '30D'} = three
    %           linear subdivisions ('0' '30' '60') and two diagonal
    %           subdivisions ('0D' '30D')
    %
    %           directionSizes (vector containing the number of linear and diagonal subdivisions)
    %           e.g.: in the above example directionSizes = [3 2]
    %
    %           circularInterpolation (if 'Y' uses circular interpolation)
    %
    %           interChannels (if 'Y' computes inter-channel features)
    %Output:    RC (ranklet coefficients, non-rotationally-invariant)
    %           RC_DFT (ranklet coefficients, rotationally-invariant)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 


    [rows cols channels] = size(I);
    nDirections = length(directions);	%number of directions

    counter = 1;

    RC = zeros(1,0);
    RC_DFT = zeros(1,0);

    for S = minWindowSize:step:maxWindowSize
        W = zeros(S, S, channels);
        switch channels
            case 1
                rankletCoefficients = zeros((rows - S + 1), (cols - S + 1), nDirections);
            case 3
                combinations = nchoosek(1:channels,2);
                nCombinations = size(combinations,1);
                rankletCoefficients = zeros((rows - S + 1), (cols - S + 1), nDirections, channels + nCombinations);
        end
        for i = 1:(rows - S + 1)
            for j = 1:(cols - S + 1)
            
                %Do circular interpolation if required
                switch channels
                    case 1
                        if circularInterpolation == 'Y'
                            W = FromSquareToCircular(I(i:i+S-1,j:j+S-1));
                        else
                            W = I(i:i+S-1,j:j+S-1);
                        end

                    case 3
                        if circularInterpolation == 'Y'
                            for c = 1:channels
                                W(:,:,c) = FromSquareToCircular(I(i:i+S-1,j:j+S-1,c));
                            end
                        else
                            for c = 1:channels
                                W(:,:,c) = I(i:i+S-1,j:j+S-1,c);
                            end
                        end
                end
			
                counter = 1;
                switch channels
				
                    case 1,
                        RT = ComputeRankTransform(W);
                        for d = 1:nDirections
                            rankletCoefficients(i,j,d) = ComputeRankletCoefficient(RT, directions(d));
                        end
                    case 3,
                        %Intra-channel
                        for c = 1:channels
                            RT = ComputeRankTransform(W(:,:,c));
                            for d = 1:nDirections
                                rankletCoefficients(i,j,d,counter) = ComputeRankletCoefficient(RT, directions(d));
                            end
                            counter = counter + 1;
                        end
					
                        %Inter-channel
                        if interChannels == 'Y'
                            for nc = 1:nCombinations
                                for d = 1:nDirections
                                    rankletCoefficients(i,j,d,counter) = ComputeCrossRankletCoefficient(W(:,:,combinations(nc,1)), W(:,:, combinations(nc,2)), directions(d));
                                end
                                counter = counter + 1;
                            end

                        end
                end
            end
        end
    
        switch channels
            case 1
			
                directionsCounter = 1;
                for dg = 1:length(directionSizes)
                    featureCounter = 1;
                    startDirection = directionsCounter;
                    for d = startDirection:(startDirection + directionSizes(dg) - 1)
                        RC_mean(featureCounter) = mean2(rankletCoefficients(:,:,d));
                        RC_std(featureCounter) = std2(rankletCoefficients(:,:,d));
                        directionsCounter = directionsCounter + 1;
                        featureCounter = featureCounter + 1;
                    end
				
                    RC = horzcat(RC, RC_mean);
                    RC = horzcat(RC, RC_std);
                    RC_mean_DFT = TransformVectorSnippetFFT(RC_mean);
                    RC_std_DFT = TransformVectorSnippetFFT(RC_std);
                    RC_DFT = horzcat(RC_DFT, RC_mean_DFT);
                    RC_DFT = horzcat(RC_DFT, RC_std_DFT);
				
                    RC_mean = zeros(0,0);
                    RC_std = zeros(0,0);
                end
			
            case 3
                for c = 1:(counter - 1)
				
                    directionsCounter = 1;
                    for dg = 1:length(directionSizes)
                        featureCounter = 1;
                        startDirection = directionsCounter;
                        for d = startDirection:(startDirection + directionSizes(dg) - 1)
                            RC_mean(featureCounter) = mean2(rankletCoefficients(:,:,d,c));
                            RC_std(featureCounter) = std2(rankletCoefficients(:,:,d,c));
                            directionsCounter = directionsCounter + 1;
                            featureCounter = featureCounter + 1;
                        end
					
                        RC = horzcat(RC, RC_mean);
                        RC = horzcat(RC, RC_std);
                        RC_mean_DFT = TransformVectorSnippetFFT(RC_mean);
                        RC_std_DFT = TransformVectorSnippetFFT(RC_std);
                        RC_DFT = horzcat(RC_DFT, RC_mean_DFT);
                        RC_DFT = horzcat(RC_DFT, RC_std_DFT);	
					
                        RC_mean = zeros(0,0);
                        RC_std = zeros(0,0);
					
                    end

                end
        end
    end
end
