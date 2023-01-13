clear all
%% General Data
udata = load("ml-100k\u.data");
FilmDic = readcell("film_info.txt", 'Delimiter', '\t');
N = 7919;

UserDic = readcell("users.txt", 'Delimiter', ';');
save("GeneralData", "udata","UserDic","FilmDic","N")
%% Opçao 2

FilmList = unique(udata(:,2));
Nu = length(FilmList);
k = 200;
seedMatrix = randi([1 1000],1,k);
FilmMinHash = zeros(Nu, k);

for FilmN=1:Nu
        ind = find(udata(:,2) == FilmList(FilmN));
        for hashFuncN=1:k
            hashArr=zeros(1,length(ind));
            for UserN = 1:length(ind)
                key = udata(ind(UserN),1)*10^(ceil(log10(abs(hashFuncN)))) + hashFuncN;
                hashArr(UserN) = rem(DJB31MA(key, seedMatrix(hashFuncN)), N)+1;
            end
            FilmMinHash(FilmN,hashFuncN) = min(hashArr);
        end
end
save("Opcao2Data", "FilmMinHash")
%% Opcao 3

Users = unique(udata(:,1));
Nu = length(Users);
k = 200;
seedMatrix = randi([1 1000],1,k);
InteressesMinHash = zeros(Nu,k);
for UserN=1:Nu
    UserData = UserDic(UserN,4:end);
    x = cellfun(@numel,UserData);
    UserData(x==1) = [];
    for hashFuncN=1:k
        hashArr=zeros(1,length(UserData));
        for InteressesN=1:length(UserData)
            key=stringToNum(UserData{InteressesN})*10^(ceil(log10(abs(hashFuncN)+1))) + hashFuncN;
            hashArr(UserN) = rem(DJB31MA(key, seedMatrix(hashFuncN)), N)+1;
        end
    end
end

UserInterestDistance=zeros(Nu,Nu); % array para guardar distancias
for n1= 1:Nu
    for n2= 1:Nu
        isMatch = InteressesMinHash(n1,:)==InteressesMinHash(n2,:);
        UserInterestDistance(n1,n2) = 1-sum(isMatch)/length(isMatch);
    end
end
save("Opcao3Data", "UserInterestDistance")
%% Opcao 4

Nu = length(FilmDic);
k = 200;
seedMatrix = randi([1 1000],1,k);
FilmNameMinHash = zeros(Nu,k);
shingleSize = 3;
for FilmNameN=1:Nu
    FilmName = FilmDic{FilmNameN,1};
    for hashFuncN=1:k
        hashArr=zeros(1,strlength(FilmName)-shingleSize+1);
        for ShingleN=1:strlength(FilmName)-shingleSize+1

            key= [lower(char(FilmName(ShingleN:(ShingleN+shingleSize-1)))) num2str(hashFuncN)];
            hashArr(ShingleN) = rem(DJB31MA(key, seedMatrix(hashFuncN)), N)+1;
        end
        FilmNameMinHash(FilmNameN,hashFuncN) = min(hashArr);
    end
end
save("Opcao4Data.mat","FilmNameMinHash","seedMatrix","shingleSize", "k")
%% bloom
k = 9;
Nu = length(FilmDic);
NSpace= 63;
BloomSeedMatrix = randi([1, 1000], 1, k);
Bloom = BloomInit(length(FilmDic),NSpace,k);

for FilmIdN=1:Nu
    Ratings = find(udata(:,2) == FilmIdN);
    for RatingN=1:length(Ratings)
        Bloom = BloomInsert(Bloom,udata(Ratings(RatingN),3), k, BloomSeedMatrix, FilmIdN);
    end
end

BloomData.Bloom = Bloom;
BloomData.k = k;
BloomData.BloomSeedMatrix = BloomSeedMatrix;
save("BloomData", "BloomData")
