f = open("file_task_7.txt", "r", encoding="utf-8")
a = []
for line in f:
    lines = f.readlines()
    for i in lines:
        print(i.split())
        a.append(line.split(" "))
        print(a)
f.close()
print("Reading done!")
