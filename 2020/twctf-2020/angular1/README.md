# Angular v1

- Nginx blocked /debug
- Angular concats Host header in the path
- With some fuzzing, this gave us access to /debug/answer 
    - `curl http://universe.chal.ctf.westerns.tokyo/ -H "Host: %64ebug\answer"`
    - The `d` is URLEncoded %64 because it somehow breaks the path parsing and it's later decoded by Angular
