my_list = [300, 2, 12, 44, 1, 1, 4, 10, 7, 1, 78, 123, 55]
my_new_list = []
print(my_list)
i = 1
while i < len(my_list):
    if my_list[i] > my_list[i - 1]:
        my_new_list.append(my_list[i])
        i += 1
    else:
        i += 1
print(my_new_list)

###############################################################################################

my_list = [15, 2, 3, 1, 7, 5, 4, 10]
my_new_list = [el for num, el in enumerate(my_list) if my_list[num - 1] < my_list[num]]
print(f'Исходный список {my_list}')
print(f'Новый список {my_new_list}')