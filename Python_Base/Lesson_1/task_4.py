earnings = int(input("Enter the earnings "))
loss = int(input("Enter the loss "))
if earnings > loss:
    print("Profit! The total is: ", (earnings - loss) / earnings)
    workers = int(input("Enter the number of workers: "))
    print("Profit per worker: ", (earnings - loss)/workers)
elif earnings == loss:
    print("No profit / no loss")
else:
    print("Total is loss")
