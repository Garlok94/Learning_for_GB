def max_out_of_tree(a, b, c):
    if a < b <= c:
        return b + c
    elif b < a <= c:
        return a + c
    elif a < b <= c:
        return b + c


a, b, c = int(input()), int(input()), int(input())
print(max_out_of_tree(a, b, c))
