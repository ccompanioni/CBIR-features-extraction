function [Xcod] = codeLBP3x3(X)

    % Computes LBP3x3 codes of a single channel texture image
    %
    % [Xcod] = codeLBP3x3(X) 
    %
    % Input:
    %   X     -  Single channel texture image (at least 3x3 pixels)
    %
    % Output:
    %   Xcod  -  Matrix with LBP3x3 codes
    %
    %
    %Authors:   Antonio Fernández
    %           Francesco Bianconi
    %Version:   1.0
    %Date:      Oct 26, 2011 


    % Conversion to avoid errors when using sort, unique...
    X = double(X);

    % Image size
    [L M] = size(X);

    % Displacement directions
    north = 1:L;   % N: North
    south = 3:L+2; % S: South
    equad = 2:L+1; % equator
    east  = 3:M+2; % E: East
    west  = 1:M;   % W: West
    meri  = 2:M+1; % meridian
    % 0: No displacement

    [X0, XN, XNE, XE, XSE, XS, XSW, XW, XNW] = deal(zeros(L+2,M+2));

    X0(equad,meri)  = X;

    XN(north,meri)  = X;
    XS(south,meri)  = X;
    XE(equad,east)  = X;
    XW(equad,west)  = X;

    XNE(north,east) = X;
    XNW(north,west) = X;
    XSE(south,east) = X;
    XSW(south,west) = X;

    X0 = 128*(XSE>=X0)+64*(XS>=X0)+32*(XSW>=X0)+16*(XW>=X0)+8*(XNW>=X0)+4*(XN>=X0)+2*(XNE>=X0)+(XE>=X0);

    %Original code
    Xcod = X0(3:L,3:M);

end
