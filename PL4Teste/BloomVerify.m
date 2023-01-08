function [R] = BloomVerify(Bloom, elem, k, seedMatrix, FilmN)
%BLOOMVERIFY Summary of this function goes here
%   Detailed explanation goes here
    R = inf;
    n = length(Bloom(1,:));
    for i=1:k
        elem = elem*10^(ceil(log10(abs(k)))) + i;
        index = mod(DJB31MA(elem,seedMatrix(k)),n)+1;
        if R > Bloom(FilmN,index)
            R = Bloom(FilmN,index);
        end
    end
end

