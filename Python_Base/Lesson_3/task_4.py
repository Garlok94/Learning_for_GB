def my_func(a, b):
    return a ** b


def my_func_2(a, b):
    c = a
    while b > 1:
        a = a * c
        b -= 1
    return a


def my_func_3(a1, b1):
    c1 = a1
    while b1 < -1:
        a1 = a1 * c1
        b1 += 1
    return a1


a, b = int(input("a ")), int(input("b "))
a1, b1 = int(input("a1 ")), int(input("b1 "))
print(my_func(a, b))
print(my_func_2(a, b))
print(my_func_3(a1, b1))
