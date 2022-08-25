from urllib.parse import unquote, quote
import base64

cookie = 'BYrTNbiCLALbFj91qtxv5Hw%2BFbAt%2F23ThGPnRm8J6UjrD4t7hur6XNYhbb8QA1qjVCGT0CjXwETmMiA%2FESJhunvhbCL7VjZZ02z8orEn6tFmgXAlFfPKmQ%3D%3D'
res = base64.b64decode(unquote(cookie).encode())
res = bytearray(res)

res[17] ^= ord('a') ^ ord('g')
res[18] ^= ord('d') ^ ord('u')
res[19] ^= ord('m') ^ ord('e')
res[20] ^= ord('i') ^ ord('s')
res[21] ^= ord('n') ^ ord('t')

print(quote(base64.b64encode(res).decode()))
