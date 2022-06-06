time = int(input('input the time: '))
hour = time // 3600
minute = (time - hour*3600)//60
second = time - (hour*3600 + minute*60)
print('Total time of ' + str(time) + ' equals: ' +
      str(hour) + ' hours ' +
      str(minute) + ' minutes ' +
      str(second) + ' seconds.')
