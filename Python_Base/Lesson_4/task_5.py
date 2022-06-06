from functools import reduce


def my_func(i_p, i):
    return i_p * i


print(reduce(my_func, [i for i in range(100, 1001) if i % 2 == 0]))
