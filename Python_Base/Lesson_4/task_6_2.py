from itertools import cycle


n = []
a = 1
while a != 'f':
    print(n.append(input("Enter the number for a cycle or 'f' to stop ")))
    print(n)
    a = n[-1]
else:
    for i in cycle(n):
        print(i)
