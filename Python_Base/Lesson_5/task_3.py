f = open("file_task_3", "r", encoding="utf-8")
i, a = [], []
b, c = 0, 0
print("*" * 50)
for line in f:
    c += 1
    print(line, end="")
    a.append(line.split(" ")[1][:-1])
    if int(line.split(" ")[1]) < 20000:
        i.append((line.split(" ")[0]))
print("*" * 50)
print("Names of workers with salary < '20000'")
if len(i) > 0:
    for i in i:
        print(i)
else:
    print("No such!")
for i in a:
    b = b + int(i)
print("*" * 50)
print(f"Total profit for all are:", b)
print("*" * 50)
print(f"Average profit for all are:", b // c)
print("*" * 50)
f.close()
print("Reading done!")
