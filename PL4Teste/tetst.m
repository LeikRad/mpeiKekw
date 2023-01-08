clear all
test = "astasdas"
shingleSize = 3
strlength(test)
        for ShingleN=1:strlength(test)-shingleSize+1
            key=extractBetween(test, ShingleN, ShingleN+shingleSize-1);

        end