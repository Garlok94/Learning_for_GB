from typing import Type

a = (11, "hello world", [1, 2, 3], 1.5, False)
print(type(a))
b = {11, "hello world", 1.5, False}
print(type(b))
c = [11, "hello world", [1, 2, 3], 1.5, False]
print(type(c))
print(len(c))
i = 0
while i < len(c):
    print(c[i])
    print(type(c[i]))
    i += 1
else:
    print("Done ")
