function RC = ComputeRankletCoefficient(RT, direction);

    %Computes the ranklet coefficient from the ranklet transform

    %Input:     RT (ranklet transform)
    %           direction (direction used to define the two subsets into which the window is split)
    %Output:    RC (ranklet coefficient)
    %
    %Author:    Francesco Bianconi
    %Version:   1.0
    %Date:      Nov 16, 2011 
    
    [N cols] = size(RT);

    switch char(direction)
        case '0',
            switch N
                case 4,
                    T = RT([14 13 9 5 1 2 10 6]);
                case 6,
                    T = RT([33 32 31 25 19 13 7 1 2 3 27 26 20 14 8 9 21 15]);
                case 8, 
                    T = RT([60 59 58 57 49 41 33 25 17 9 1 2 3 4 52 51 50 42 34 26 18 10 11 12 44 43 35 27 19 20 36 28]);
                otherwise,
                    error('Pattern dimension not supported');
            end
        case '30',
            switch N
                case 4,
                    T = RT([13 9 5 1 2 3 10 6]);
                case 6,
                    T = RT([31 25 19 13 7 1 2 3 4 5 26 20 14 8 9 10 21 15]);
                case 8,
                    T = RT([58 57 49 41 33 25 17 9 1 2 3 4 5 6 50 42 34 26 18 10 11 12 13 14 43 35 27 19 20 21 36 28]);
                otherwise,
                    error('Pattern dimension not supported');
            end
        case '60',
            switch N
                case 4,
                    T = RT([9 5 1 2 3 4 6 7]);
                case 6,
                    T = RT([25 19 13 7 1 2 3 4 5 6 20 14 8 9 10 11 15 16]);
                case 8,
                    T = RT([41 33 25 17 9 1 2 3 4 5 6 7 8 16 42 34 26 18 10 11 12 13 14 15 35 27 19 20 21 22 28 29]);
                otherwise,
                    error('Pattern dimension not supported');
            end
        case '90',
            switch N
                case 4,
                    T = RT([5 1 2 3 4 8 7 6]);
                case 6,
                    T = RT([13 7 1 2 3 4 5 6 12 18 14 8 9 10 11 17 15 16]);
                case 8,
                    T = RT([25 17 9 1 2 3 4 5 6 7 8 16 24 32 26 18 10 11 12 13 14 15 23 31 27 19 20 21 22 30 28 39]);
                otherwise,
                    error('Pattern dimension not supported');
            end
        case '120',
            switch N
                case 4,
                    T = RT([1 2 3 4 8 12 6 7]);
                case 6,
                    T = RT([1 2 3 4 5 6 12 18 24 30 8 9 10 11 17 23 15 16]);
                case 8,
                    T = RT([9 1 2 3 4 5 6 7 8 16 24 32 40 48 10 11 12 13 14 15 23 31 39 47 19 20 21 22 30 38 28 29]);

                otherwise,
                    error('Pattern dimension not supported');
            end
        case '150',
            switch N
                case 4,
                    T = RT([2 3 4 8 12 16 7 11]);
                case 6,
                    T = RT([2 3 4 5 6 12 18 24 30 36 9 10 11 17 23 29 16 22]);
                case 8,
                    T = RT([3 4 5 6 7 8 16 24 32 40 48 56 64 63 11 12 13 14 15 23 31 39 47 55 20 21 22 30 38 46 29 37]);

                otherwise,
                    error('Pattern dimension not supported');
            end
        case '0D',
            switch N
                case 4,
                    T = RT([5 1 2 6 12 16 15 11]);
                case 6,
                    T = RT([13 7 1 2 3 14 8 9 15 24 30 36 35 34 23 29 28 22]);
                case 8,
                    T = RT([25 17 9 1 2 3 4 26 18 10 11 12 27 19 20 28 40 48 56 64 63 62 61 39 47 55 54 53 38 46 45 37]);

                otherwise,
                    error('Pattern dimension not supported');
            end
        case '30D',
            switch N
                case 4,
                    T = RT([1 2 3 6 16 15 14 11]);
                case 6,
                    T = RT([1 2 3 4 5 8 9 10 15 36 35 34 33 32 29 28 27 22]);
                case 8,
                    T = RT([9 1 2 3 4 5 6 10 11 12 13 14 19 20 21 28 56 64 63 62 61 60 59 55 54 53 52 51 46 45 44 37]);
                otherwise,
                    error('Pattern dimension not supported');
            end
        case '60D',
            switch N
                case 4,
                    T = RT([2 3 4 7 15 14 13 10]);
                case 6,
                    T = RT([2 3 4 5 6 9 10 11 16 35 34 33 32 31 28 27 26 21]);
                case 8,
                    T = RT([3 4 5 6 7 8 16 11 12 13 14 15 20 21 22 29 62 61 60 59 58 57 49 54 53 52 51 50 45 44 43 36]);
                otherwise,
                    error('Pattern dimension not supported');
            end
        case '90D',
            switch N
                case 4,
                    T = RT([3 4 8 7 14 13 9 10]);
                case 6,
                    T = RT([4 5 6 12 18 10 11 17 16 33 32 31 25 19 27 26 20 21]);
                case 8,
                    T = RT([5 6 7 8 16 24 32 13 14 15 23 31 21 22 30 29 60 59 58 57 49 41 33 52 51 50 42 34 44 43 35 36]);
                otherwise,
                    error('Pattern dimension not supported');
            end
        case '120D',
            switch N
                case 4,
                    T = RT([4 8 12 7 13 9 5 10]);
                case 6,
                    T = RT([6 12 18 24 30 11 17 23 16 31 25 19 13 7 26 20 14 21]);
                case 8,
                    T = RT([7 8 16 24 32 40 48 15 23 31 39 47 22 30 38 29 58 57 49 41 33 25 17 50 42 34 26 18 43 35 27 36]);
                otherwise,
                    error('Pattern dimension not supported');
            end
        case '150D',
            switch N
                case 4,
                    T = RT([9 5 1 6 8 12 16 11]);
                case 6,
                    T = RT([12 18 24 30 36 17 23 29 22 25 19 13 7 1 20 14 8 15]);
                case 8,
                    T = RT([41 33 25 17 9 1 2 42 34 26 18 10 35 27 19 28 24 32 40 48 56 64 63 23 31 39 47 55 30 38 46 37]);
                otherwise,
                    error('Pattern dimension not supported');
            end

        otherwise,
            error('Direction not supported');
    end

    ranks_sum_min = ((N^2)/4)*((N^2)/2 + 1);
    ranks_sum_max = (1/8)*(3*(N^4) + 2*(N^2));
    
    RC = sum(sum(T));
    RC = abs(2*(RC - ranks_sum_min)/(ranks_sum_max - ranks_sum_min) - 1);

end






