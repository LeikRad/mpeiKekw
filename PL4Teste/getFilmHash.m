function [minhashArr] = getFilmHash(film_name)
%GETFILMHASH Summary of this function goes here
%   Detailed explanation goes here
    load("Opcao4Data.mat");
    load("GeneralData.mat");
    minhashArr = zeros(1,k);
    for hashFuncN=1:k
        hashArr=zeros(1,strlength(film_name)-shingleSize+1);
        for ShingleN=1:strlength(film_name)-shingleSize+1
            key= [lower(char(film_name(ShingleN:(ShingleN+shingleSize-1)))) num2str(hashFuncN)];
            hashArr(ShingleN) = rem(DJB31MA(key, seedMatrix(hashFuncN)), N)+1;
        end
        minhashArr(1,hashFuncN) = min(hashArr);
    end

end

