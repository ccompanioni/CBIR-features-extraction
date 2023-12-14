function [H] = histoTP3x3(X, mapping)


    % Computes the histogram of 3x3 texture patterns of a single channel texture image
    % using the palette defined by "mapping"
    %
    % [H] = histoTP3x3(X, mapping)
    %
    % Input:
    %   X        -  Single channel texture image (at least 3x3 pixels)
    %   mapping  -  Type of pattern mapping
    %
    % Output:
    %   H        -  Histogram of palette patterns
    %Authors:   Francesco Bianconi, Antonio Fernández
    %Version:   1.0
    %Date:      Nov 16, 2011 

    % X = X(:,:,1);

    % Conversion to avoid errors when using sort, unique...
    X = double(X);

    % Image size
    [L M] = size(X);


    for i=1:3
        for j=1:3
            eval(['X' num2str(i) num2str(j) '=zeros(L+2,M+2);'])
            eval(['X' num2str(i) num2str(j) '(4-i:L+3-i,4-j:M+3-j)=X;'])
        end
    end

    % Coeficients used in bilinear interpolation
    sqrt_2 = 1.4142; 
    center  =  (1-1/sqrt_2)^2;
    corner  =  (1/sqrt_2)^2;
    diagon  =  (1-1/sqrt_2)*(1/sqrt_2);

    %Weights used in bilinear interpolation
    [pN, pNE, pE, pSE, pS, pSW, pW, pNW, p0] = deal(zeros(L+2,M+2));

    pN = diagon*X12 ;
    pS = diagon*X32 ;
    pE = diagon*X23 ;
    pW = diagon*X21 ;

    pNE = X13 ;
    pNW = X11 ;
    pSE = X33 ;
    pSW = X31 ;

    p0 = center*X22 ;

    switch mapping
        case 'LBP3x3'
            nPatterns = 2^8;
            X0 = 128*(X33>=X22) + 64*(X32>=X22) + 32*(X31>=X22) + ...
                16*(X21>=X22) +  8*(X11>=X22) +  4*(X12>=X22) + ...
                2*(X13>=X22) +    (X23>=X22);
		   
            % Computes and normalizes the histogram
            H = sum(hist(X0(3:L,3:M),0:nPatterns-1),2)' / ((L-2)*(M-2));
		
        case 'LBP81ri'
            nPatterns = 2^8;
					
            X33 = round(corner*pSE + pS + pE + p0);
            X31 = round(corner*pSW + pS + pW + p0);
            X11 = round(corner*pNW + pN + pW + p0);
            X13 = round(corner*pNE + pN + pE + p0);
		
            X0 = 128*(X33>=X22) + 64*(X32>=X22) + 32*(X31>=X22) + ...
                16*(X21>=X22) +  8*(X11>=X22) +  4*(X12>=X22) + ...
                2*(X13>=X22) +    (X23>=X22);
		   
            % Computes and normalizes the histogram
            H = sum(hist(X0(3:L,3:M),0:nPatterns-1),2)' / ((L-2)*(M-2));
            H = ClusterHistogram(H, 'LBP81ri');
		
        case 'LBP81rini'
            nPatterns = 2^8;
		
            X0 = 128*(X33>=X22) + 64*(X32>=X22) + 32*(X31>=X22) + ...
                  16*(X21>=X22) +  8*(X11>=X22) +  4*(X12>=X22) + ...
                   2*(X13>=X22) +    (X23>=X22);
		   
            % Computes and normalizes the histogram
            H = sum(hist(X0(3:L,3:M),0:nPatterns-1),2)' / ((L-2)*(M-2));
            H = ClusterHistogram(H, 'LBP81ri');
		
        case 'RCG81ri'
            nPatterns = 2^8;
					
            X33 = round(corner*pSE + pS + pE + p0);
            X31 = round(corner*pSW + pS + pW + p0);
            X11 = round(corner*pNW + pN + pW + p0);
            X13 = round(corner*pNE + pN + pE + p0);
		
            X0 = 128*(abs(X22 - X11) >= abs(X11 - X12)) + 64*(abs(X22 - X12) >= abs(X12 - X13)) + 32*(abs(X22 - X13) >= abs(X13 - X23)) + ...
                  16*(abs(X22 - X23) >= abs(X23 - X33)) +  8*(abs(X22 - X33) >= abs(X33 - X32)) + 4*(abs(X22 - X32) >= abs(X32 - X31)) + ...
                   2*(abs(X22 - X31) >= abs(X31 - X21)) +    (abs(X22 - X21) >= abs(X21 - X11));
		   
            % Computes and normalizes the histogram
            H = sum(hist(X0(3:L,3:M),0:nPatterns-1),2)' / ((L-2)*(M-2));
            H = ClusterHistogram(H, 'LBP81ri');
		
        case 'RCG81rini'
            nPatterns = 2^8;
		
            X0 = 128*(abs(X22 - X11) >= abs(X11 - X12)) + 64*(abs(X22 - X12) >= abs(X12 - X13)) + 32*(abs(X22 - X13) >= abs(X13 - X23)) + ...
                  16*(abs(X22 - X23) >= abs(X23 - X33)) +  8*(abs(X22 - X33) >= abs(X33 - X32)) + 4*(abs(X22 - X32) >= abs(X32 - X31)) + ...
                   2*(abs(X22 - X31) >= abs(X31 - X21)) +    (abs(X22 - X21) >= abs(X21 - X11));
		   
            % Computes and normalizes the histogram
            H = sum(hist(X0(3:L,3:M),0:nPatterns-1),2)' / ((L-2)*(M-2));
            H = ClusterHistogram(H, 'LBP81ri');

        case 'CCR3x3'
            nPatterns = 2^9;
            h = sum(hist(double(X),0:nPatterns-1),2);
            h = h/sum(h);
            entropy =  cumsum(-h.*log2(h+(h==0)));
            T       =  sum( (entropy/entropy(1,end))  <= 0.5 ) - 1;            

            X0 = 256*(X11>=T) + 128*(X12>=T) + 64*(X13>=T) + ...
                  32*(X21>=T) +  16*(X22>=T) +  8*(X23>=T) + ...
                   4*(X31>=T) +   2*(X32>=T) +    (X33>=T);
		   
            % Computes and normalizes the histogram
            H = sum(hist(X0(3:L,3:M),0:nPatterns-1),2)' / ((L-2)*(M-2));
    
        case 'ILBP3x3'
            nPatterns = 2^9;
            Xav = (X11 + X12 + X13 + X21 + X22 + X23 + X31 + X32 + X33)/9;

            X0 = 256*(X22>=Xav) + 128*(X11>=X22) + 64*(X12>=X22) + ...
                  32*(X13>=X22) +  16*(X23>=X22) +  8*(X33>=X22) +  ...
                   4*(X32>=X22) +   2*(X31>=X22) +    (X21>=X22);
		   
            % Computes and normalizes the histogram
            H = sum(hist(X0(3:L,3:M),0:nPatterns-1),2)' / ((L-2)*(M-2));


        otherwise
            error('Invalid mapping')
    end
end