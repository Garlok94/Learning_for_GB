f = open("file_task_5", "w", encoding="utf-8")
a = 0
b = 0
while True:
    b = float(input("Enter the number or '0' to stop: "))
    a += b
    print("*" * 50)
    print(f"Sum of number are:", a)
    print("*" * 50)
    if b == 0:
        print("*" * 50)
        print(f"Final sum of number was:", a)
        print("*" * 50)
        print("*" * 50)
        break
    print(b, file=f)
f.close()
