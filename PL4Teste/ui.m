clear all
% load all data (user, films, minhashes, blooms)

load("GeneralData.mat")

% get the movie ID 
fprintf("\tInsert Film ID 1 to %d: ", length(FilmDic))
IDSelect = input("");
while(IDSelect > length(FilmDic) || IDSelect < 1)
    fprintf("\tInsert Film ID 1 to %d: ", length(FilmDic))
    IDSelect = input("");
end

% Menu Operations
while true
    choice = menuDisp();
    switch choice
        case 1
            ind = find(udata(:,2) == IDSelect);
            users = udata(ind);
            for i=1:length(users)
                name = UserDic{users(i),2};
                fprintf("%d - %s\n",users(i), name)
            end
        case 2
            load("Opcao2Data.mat")
            filmIdMinHash = FilmMinHash(IDSelect,:);
            Distance = zeros(1,length(FilmMinHash(:,1)));
            for i=1:length(Distance)
                isMatch = filmIdMinHash(1,:)==FilmMinHash(i,:);
                Distance(i) = 1-sum(isMatch)/length(isMatch);
            end
            [sortDist,indx] = sort(Distance);
            usersFilm1 = udata(udata(:,2) == indx(2));
            usersFilm2 = udata(udata(:,2) == indx(3));
            usersFilmSel = udata(udata(:,2) == IDSelect);
            userFilms1_2 = unique(union(usersFilm1,usersFilm2));
            users = setdiff(userFilms1_2,usersFilmSel);
            for i=1:length(users)
                name = UserDic{users(i),2};
                fprintf("%d - %s\n",users(i), name)
            end
        case 3
            load("Opcao3Data.mat")
            ind = find(udata(:,2) == IDSelect);
            users = udata(ind);
            usersNoFilm = dictionary([],[]);
            for i=1:length(users)
                userSimilarity = UserInterestDistance(users(i),:);
                indexOfSim = userSimilarity < 0.9;
                indexOfSim(users(i)) = 0; % remove himself from index;
                simUsers = find(indexOfSim);
                for j=1:length(simUsers)
                    watchedFilm = find(udata(udata(:,1) == simUsers(j), 2) == IDSelect);
                    if isempty(watchedFilm)
                        if isKey( usersNoFilm , simUsers(j)) 
                            usersNoFilm(simUsers(j)) = usersNoFilm(simUsers(j))+1;
                        else
                            usersNoFilm(simUsers(j)) = 1;
                        end
                    end
                end
            end
            [sorted, indx] = sort(values(usersNoFilm), "descend");
            usersId = keys(usersNoFilm);
            for i=1:2
                name = UserDic{usersId(indx(i)),2};
                fprintf("%d - %s\n", usersId(indx(i)), name)
            end
        case 4
            load("Opcao4Data.mat")
            filmname = lower(char(input("Write film name: ", "s")));
            while (length(filmname) < shingleSize)
                fprintf('Write a minimum of %d characters\n', shingleSize);
                filmname = lower(input("Write a string: ", "s"));
            end
            hashArr = getFilmHash(filmname);
            Distance = zeros(1,length(FilmNameMinHash(:,1)));
            for i=1:length(FilmNameMinHash(:,1))
                isMatch = hashArr(1,:)==FilmNameMinHash(i,:);
                Distance(i) = 1-sum(isMatch)/length(isMatch);
            end
            [distanceClose, closestfilm] = sort(Distance, "ascend");
            filmIds= [closestfilm(1),closestfilm(2),closestfilm(3)];
            load("BloomData.mat")
            for i=1:length(filmIds)
                Rating = 0;
                Rating = Rating + BloomVerify(BloomData.Bloom,3,BloomData.k,BloomData.BloomSeedMatrix, filmIds(i));
                Rating = Rating + BloomVerify(BloomData.Bloom,4,BloomData.k,BloomData.BloomSeedMatrix, filmIds(i));
                Rating = Rating + BloomVerify(BloomData.Bloom,5,BloomData.k,BloomData.BloomSeedMatrix, filmIds(i));        
                fprintf("%s : %d Ratings of 3 or more\n", FilmDic{filmIds(i),1}, Rating)
            end
        case 5
            break
        otherwise
            fprintf('Choice is not valid\n')
    end
end