a = int(input("Enter the number of words: "))
i = 0
my_list = []
while a > i:
    my_list.append(input("Enter the words: "))
    i += 1
else:
    i = 0
    while a > i:
        if len(str(my_list[i])) > 10:
            print(my_list[i][0:11])
            i += 1
        else:
            print(my_list[i])
            i += 1
