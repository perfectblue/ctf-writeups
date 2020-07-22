all: compiler.y evil_compiler.y poisoned3_compiler.y getflag.y poisoned_getflag.y

compiler.y: interpreter.py compiler.x
	pypy3 interpreter.py compiler.x < compiler.x > $@

%.y: %.x interpreter.py compiler.x
	pypy3 simulator.py compiler.y < $^ > $@

evil_compiler.x: diff.py compiler_backdoor.template compiler.x
	python3 diff.py compiler.x compiler_backdoor.template > $@

poisoned1_compiler.y: evil_compiler.y compiler.x
	pypy3 simulator.py evil_compiler.y < compiler.x > $@

poisoned2_compiler.y: poisoned1_compiler.y compiler.x
	pypy3 simulator.py poisoned1_compiler.y < compiler.x > $@

poisoned3_compiler.y: poisoned2_compiler.y compiler.x
	pypy3 simulator.py poisoned2_compiler.y < compiler.x > $@

poisoned_getflag.y: poisoned2_compiler.y getflag.x
	pypy3 simulator.py poisoned2_compiler.y < getflag.x > $@

.PHONY: clean
clean:
	rm -f evil_compiler.x
	rm -f *.y
	rm -f poisoned{1,2,3}_compiler.{x,y}
