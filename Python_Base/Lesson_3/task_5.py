def my_func(num):
    a = num.count(" ")
    return "First summa of spaces = ", a


num = input("Enter numbers with space or print 'f' to stop ")
num = list(num)
if num != "f":
    print(my_func(num))
else:
    print("none")
