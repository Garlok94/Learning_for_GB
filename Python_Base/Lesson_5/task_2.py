f = open("file_task_2", "r", encoding="utf-8")
for line in f:
    print(line, end="")
    print(f"Total number of symbols are:", (len(line) - 1))
    print(f"Total number of words are:", len(line.split(" ")))
    print("*" * 50)
f.close()
print("Reading done!")
