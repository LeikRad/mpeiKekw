function [Bloom] = BloomInsert(Bloom, elem, k, seedMatrix, FilmN)
    n = length(Bloom(1,:));
    for i=1:k
        elem = elem*10^(ceil(log10(abs(k)))) + i;
        index = mod(DJB31MA(elem,seedMatrix(k)),n)+1;
        Bloom(FilmN,index) = Bloom(FilmN,index)+1;
    end
end

