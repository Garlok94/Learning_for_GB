def num_num():
    g, h, j = [], [], []
    a = list((i.replace("(", " ")).split(" ")[1])
    b = list((i.replace("(", " ")).split(" ")[3])
    c = list((i.replace("(", " ")).split(" ")[5])
    g = " ".join(a)
    g = g.replace(" ", "")
    h = " ".join(b)
    h = h.replace(" ", "")
    j = " ".join(c)
    j = j.replace(" ", "")
    print(a, b, c)
    print(g, h, j)


f = open("file_task_6", "r", encoding="utf-8")
for i in f.read().splitlines():
    print(i.replace("(", " "))
    print(num_num())
f.close()
