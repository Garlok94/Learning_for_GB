f = open("file_task_1", "w", encoding="utf-8")
while True:
    string = input("Enter your data ")
    if string == "":
        break
    f.write(string + '\n')
f.close()
