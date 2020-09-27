require "digest/sha2"

#fail unless ENV["FLAG"]


EXPECTED_MESSAGE = 'SUNSHINE RHYTHM'

hash = ""
4.times do |i|
  hash += Digest::SHA512.hexdigest(EXPECTED_MESSAGE + i.to_s)
end
hash = hash.to_i(16)
puts(hash)

key = JSON.parse(File.read("pubkey.txt"))
n = key["n"].to_i
k = key["k"].to_i

FunctionsFramework.http("index") do |request|
  if request.request_method != "POST"
    return "Bad Request"
  end

  data = JSON.parse(request.body.read)
  cmd = data["cmd"]
  if cmd == "pubkey"
    return { pubkey: { n: n.to_s, k: k.to_s } }
  elsif cmd == "verify"
    x = data["x"].to_i
    y = data["y"].to_i
    msg = data["msg"].to_s
    hash = ""
    4.times do |i|
      hash += Digest::SHA512.hexdigest(msg + i.to_s)
    end
    puts hash
    hash = hash.to_i(16) % n
    signature = (x ** 2 + k * y ** 2) % n

    if signature == hash
      if msg == EXPECTED_MESSAGE
        return { result: ENV["FLAG"] }
      end
      return { result: "verify success" }
    else
      return { result: "verify failed" }
    end
  else
    return "invalid command"
  end
end
