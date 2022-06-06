f = open("file_task_4_1", "r", encoding="utf-8")
a = []
print("*" * 50)
for line in f:
    print(line, end="")
    a.append(line.split(" ")[0])
print("*" * 50)
print(a)
print("*" * 50)
f.close()
f_1 = open("file_task_4_2", "w", encoding="utf-8")
print("*" * 50)
f_1.close()
