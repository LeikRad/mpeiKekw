clear all
%% General Data
udata = load("ml-100k\u.data");

FilmDic = readcell("film_info.txt", 'Delimiter', '\t');

UserDic = readcell("users.txt", 'Delimiter', ';');

%% Opçao 2

FilmList = unique(udata(:,2));
Nu = length(FilmList);
k = 200;
seedMatrix = randi([1 1000],1,k);
FilmMinHash = zeros(Nu, k);
N = 7919;

for FilmN=1:Nu
        ind = find(udata(:,2) == FilmList(FilmN));
        for hashFuncN=1:k
            hashArr=zeros(1,length(ind));
            for UserN = 1:length(ind)
                key = udata(ind(UserN),1) + hashFuncN;
                hashArr(UserN) = rem(DJB31MA(key, seedMatrix(hashFuncN)), N)+1;
            end
            FilmMinHash(FilmN,hashFuncN) = min(hashArr);
        end
end

%%

save("GeneralData", "FilmMinHash", "udata", "UserDic", "FilmDic")
