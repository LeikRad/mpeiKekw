function num = stringToNum(String)
%STRINGTONUM Summary of this function goes here
%   Detailed explanation goes here
    arr = double(upper(String));
    num = sum(arr);
end