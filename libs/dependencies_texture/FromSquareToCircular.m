function C = FromSquareToCircular(I)

    %Converts a square window into a circolar neighbourhood through
    %linear interpolation
    %
    %Input: I (square window)
    %
    %Output: C interpolated circular window
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 

	[rows cols levels] = size(I);
	
	C = zeros(rows, cols, levels);
	
	for l = 1:levels
		C(:,:,l) = FromSquareToCircular_(I(:,:,l));
	end
	
end

function C_OUT = FromSquareToCircular_(I)

	[rows cols] = size(I);

	C_OUT = zeros(rows, cols);

	I = double(I);

	if rows ~= cols
		error('Pattern must be square')
	end

	sqrt_2 = sqrt(2);
	sqrt_2_div_2 = sqrt_2/2;


	switch rows
		case 2,
			C = zeros(2,2);
			[X,Y] = meshgrid(-0.5:0.5);
			nPoints = 4;
			radius = 0.5;
			XI = radius*cos((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 + pi/4));
			YI = radius*sin((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 + pi/4));
			C([1 2 4 3]) = interp2(X,Y,I,XI,YI, '*linear');
        
%         mesh(X,Y,I)
%         hold on
%         plot3(XI,YI,C([1 2 4 3]),'ro')

        
		case 3,
			C = zeros(3,3);
			[X,Y] = meshgrid(-1:1);
			nPoints = 8;
			radius = 1;
			XI = radius*cos((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2));
			YI = radius*sin((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2));
			C([1 2 3 6 9 8 7 4]) = interp2(X,Y,I,XI,YI, '*linear');   
        
%       mesh(X,Y,I)
%       hold on
%       plot3(XI,YI,C([1 2 3 6 9 8 7 4]),'ro')
        
			C(2,2) = I(2,2);
        
		case 4,
			C = zeros(4,4);
			[X,Y] = meshgrid(-1.5:1.5);
			nPoints = 12;
			radius = 1.5;
			XI = radius*cos((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - 2*pi/15));
			YI = radius*sin((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - 2*pi/15));
			C([1 2 3 4 8 12 16 15 14 13 9 5]) = interp2(X,Y,I,XI,YI, '*linear');
        
%       mesh(X,Y,I)
%       hold on
%       plot3(XI,YI,C([1 2 3 4 8 12 16 15 14 13 9 5]),'ro')

        
			C(2:3,2:3) = FromSquareToCircular_(I(2:3,2:3));
     
		case 5,
			C = zeros(5,5);
			[X,Y] = meshgrid(-2:2);
			nPoints = 16;
			radius = 2;
			XI = radius*cos((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - pi/8));
			YI = radius*sin((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - pi/8));
			C([1 2 3 4 5 10 15 20 25 24 23 22 21 16 11 6]) = interp2(X,Y,I,XI,YI, '*linear');
        
%         mesh(X,Y,I)
%         hold on
%         plot3(XI,YI,C([1 2 3 4 5 10 15 20 25 24 23 22 21 16 11 6]),'ro')
        
			C(2:4,2:4) = FromSquareToCircular_(I(2:4,2:4));
        
		case 6,
			C = zeros(6,6);
			[X,Y] = meshgrid(-2.5:2.5);
			nPoints = 20;
			radius = 2.5;
			XI = radius*cos((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - 3*pi/20));
			YI = radius*sin((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - 3*pi/20));
			C([1 2 3 4 5 6 12 18 24 30 36 35 34 33 32 31 25 19 13 7]) = interp2(X,Y,I,XI,YI, '*linear');
%         
%         mesh(X,Y,I)
%         hold on
%         plot3(XI,YI,C([1 2 3 4 5 6 12 18 24 30 36 35 34 33 32 31 25 19 13 7]),'ro')

        
			C(2:5,2:5) = FromSquareToCircular_(I(2:5,2:5));
        
		case 7
			C = zeros(7,7);
			[X,Y] = meshgrid(-3:3);
			nPoints = 24;
			radius = 3;
			XI = radius*cos((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - pi/6));
			YI = radius*sin((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - pi/6));
			C([1 2 3 4 5 6 7 14 21 28 35 42 49 48 47 46 45 44 43 36 29 22 15 8]) = interp2(X,Y,I,XI,YI, '*linear');
        
%			mesh(X,Y,I)
%			hold on
%			 plot3(XI,YI,C([1 2 3 4 5 6 7 14 21 28 35 42 49 48 47 46 45 44 43 36 29 22 15 8]),'ro')
        
			C(2:6,2:6) = FromSquareToCircular_(I(2:6,2:6));
        
		case 8,
			C = zeros(8,8);
			[X,Y] = meshgrid(-3.5:3.5);
			nPoints = 28;
			radius = 3.5;
			XI = radius*cos((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - 9*pi/45));
			YI = radius*sin((5/8)*(2*pi):-(2*pi)/nPoints:(-pi/2 - 9*pi/45));
			C([1 2 3 4 5 6 7 8 16 24 32 40 48 56 64 63 62 61 60 59 58 57 49 41 33 25 17 9]) = interp2(X,Y,I,XI,YI, '*linear');
        
%         mesh(X,Y,I)
%         hold on
%         plot3(XI,YI,C([1 2 3 4 5 6 7 8 16 24 32 40 48 56 64 63 62 61 60 59 58 57 49 41 33 25 17 9]),'ro')
        
			C(2:7,2:7) = FromSquareToCircular_(I(2:7,2:7));
            
		otherwise,
			error('Pattern resolution not supported')
        
	end
	
	C_OUT = C;
end


