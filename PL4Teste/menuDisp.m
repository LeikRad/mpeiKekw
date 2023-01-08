function choice = menuDisp()
    choice = -1;
%MENUDISP() Summary of this function goes here
%   Detailed explanation goes here
    while (choice > 5 || choice < 1)
    fprintf('\t1 - Users that evaluated current movie\n')
    fprintf('\t2 - Suggestion of users to evaluate movie\n')
    fprintf('\t3 - Suggestion of users to based on common interests\n')
    fprintf('\t4 - Movies feedback based on popularity\n')
    fprintf('\t5 - Exit\n')
    choice = input("Select choice: ");
    end
end

