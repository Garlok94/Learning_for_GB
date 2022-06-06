def my_func(name, surname, year, city, email, phone):
    return ' '.join([name, surname, str(year), city, email, str(phone)])


name = input('enter name ')
surname = input('enter surname ')
year = int(input('enter year '))
city = input('enter city ')
email = input('enter email ')
phone = input('input phone ')
print(my_func(name, surname, year, city, email, phone))
