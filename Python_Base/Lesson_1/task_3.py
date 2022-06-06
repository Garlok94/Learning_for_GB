number = int(input('Enter any number: '))
max = number % 10
while number >= 1:
    number = number // 10
    if number % 10 > max:
        max = number % 10
    elif number > 9:
        continue
    else:
        print("Max number is: ", max)
        break
