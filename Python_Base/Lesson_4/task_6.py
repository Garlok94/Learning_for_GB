from itertools import count


a = int(input("Enter the end range of numbers "))
for i in count(int(input("Enter start number for generator "))):
    print(i)
    if i > a - 1:
        break
