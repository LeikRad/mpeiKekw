clear all
% load all data (user, films, minhashes, blooms)

load("GeneralData.mat")

% get the movie ID 
fprintf("\tInsert Film ID 1 to %d: ", length(FilmDic))
IDSelect = input("");

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
            userFilms12 = unique(union(usersFilm1,usersFilm2));
            users = setdiff(userFilms12,usersFilmSel);
            for i=1:length(users)
                name = UserDic{users(i),2};
                fprintf("%d - %s\n",users(i), name)
            end
        case 3
            fprintf("1\n")
        case 4
            fprintf("1\n")
        case 5
            break
        otherwise
            fprintf('Choice is not valid\n')
    end
end