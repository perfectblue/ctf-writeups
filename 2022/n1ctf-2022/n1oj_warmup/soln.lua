a = gets()
b = gets()

a = string.reverse(a)
b = string.reverse(b)

while string.len(a) < string.len(b) do
    a = a .. "0"
end

while string.len(b) < string.len(a) do
    b = b .. "0"
end

ans = ""
carry = 0
i = 1
while i <= string.len(a) do
    x = string.byte(a, i) - 48
    y = string.byte(b, i) - 48 
    curr = x + y + carry
    ans = ans .. string.char((curr % 10) + 48)
    carry = curr // 10
    i = i + 1
end
if carry > 0 then
    ans = ans .. string.char(carry + 48)
end
ans = string.reverse(ans)
print(ans)

