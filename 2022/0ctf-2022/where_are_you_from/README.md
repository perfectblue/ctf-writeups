# Where are you from?

1. The web server is vulnerable to CVE-2022-26377, which means we can use Request Smuggling to send AJP Requests.
2. Following the writeup in [http://noahblog.360.cn/apache-httpd-ajp-request-smuggling/](http://noahblog.360.cn/apache-httpd-ajp-request-smuggling/), we are able to craft a AJP request that allows us to leak the source code (index.jsp).

```jsp
<%
    String remote_addr = request.getRemoteAddr();
    if (remote_addr.equals("119.29.29.29")){
        String flag = System.getenv("flag");
        out.println(flag);
    }else {
        out.print(remote_addr);
    }
```

3. Then, we craft another request where we set the remote_addr to the fake address, and get the flag.


Exploit script: `gen.py` generates the payload which we can send to the server using the following command:

```
curl -vvv http://43.154.50.108:32512/ctf/ -u "username:password" -H 'Transfer-Encoding: chunked, chunked'  --data-binary @payload2
```
