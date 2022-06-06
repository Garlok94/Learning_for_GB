import requests
import json

url = 'https://api.github.com'
user ='fabpot'

r = requests.get(f'{url}/users/{user}/repos')

with open('HM_1_data.json', 'w') as f:
    json.dump(r.json(), f)

for i in r.json():
    print(i['name'])
