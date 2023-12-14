function reorientedSnippet = TransformVectorSnippetFFT(vectorSnippet)

L = length(vectorSnippet);

% if mod(L,2) == 0
% 	%Even L
% 	vectorSnippet = vectorSnippet(1:(L/2 + 1));
% else
% 	%Odd L
% 	vectorSnippet = vectorSnippet(1:floor(L/2 + 1));
% end

reorientedSnippet = abs(fft(vectorSnippet));

%Remove the last L - (L/2 + 1) elements
R = round(L - (L/2 + 1));
reorientedSnippet((L-R+1):L) = [];

