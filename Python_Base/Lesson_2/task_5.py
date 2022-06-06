my_list = [7, 5, 3, 3, 2]
print(my_list)
n = int(input("Enter the number:" + " '13' for exit "))
i = 0
if n != 13:
    for el in range(len(my_list)):
        if n >= my_list[i]:
            my_list.insert(i, n)
            i += 1
            n = int(input("Enter the number:" + " '13' for exit "))
            if n == 13:
                break
        else:
            i += 1
print(my_list)
print("-*-" * 10)
print("END")
