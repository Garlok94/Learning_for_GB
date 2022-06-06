def int_func(n):
    while True:
        k = input("Start entering the words or type 'f' to stop ")
        while k != 'f':
            n.append(input("Enter the word "))
            print(n)
            k = input("Keep entering the words or type 'f' to stop ")
        else:
            n = str(n)
            return n.title()


n = []
print(int_func(n))

