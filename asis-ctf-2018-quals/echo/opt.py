# 
# Optimizing brainfuck compiler
# 
# This script translates brainfuck source code into C/Java/Python source code.
# Usage: python bfc.py BrainfuckFile OutputFile.c/java/py
# For Python 2 and 3.
# 
# Copyright (c) 2017 Project Nayuki
# All rights reserved. Contact Nayuki for licensing.
# https://www.nayuki.io/page/optimizing-brainfuck-compiler
# 

import os, re, sys


# ---- Main ----

def main(args):
	# Handle command-line arguments
	if len(args) != 2:
		return "Usage: python bfc.py BrainfuckFile OutputFile.c/java/py"
	
	inname = args[0]
	if not os.path.exists(inname):
		return inname + ": File does not exist"
	if not os.path.isfile(inname):
		return inname + ": Not a file"
	
	outname = args[1]
	if   outname.endswith(".c"   ): outfunc = commands_to_c
	elif outname.endswith(".java"): outfunc = commands_to_java
	elif outname.endswith(".py"  ): outfunc = commands_to_python
	else: return outname + ": Unknown output type"
	
	# Read input
	with open(inname, "r") as fin:
		incode = fin.read()
	
	# Parse and optimize Brainfuck code
	commands = parse(incode)
	commands = optimize(commands)
	commands = optimize(commands)
	commands = optimize(commands)
	
	# Write output
	if outname.startswith('$stdout'):
		outcode = outfunc(commands, 'stdout')
		print outcode
	else:
		tempname = os.path.splitext(os.path.basename(outname))[0]
		outcode = outfunc(commands, tempname)
		with open(outname, "w") as fout:
			fout.write(outcode)


# ---- Parser ----

# Parses the given raw code string, returning a list of Command objects.
def parse(codestr):
	codestr = re.sub(r"[^+\-<>.,\[\]]", "", codestr)  # Keep only the 8 Brainfuck characters
	return _parse(iter(codestr), True)


def _parse(chargen, maincall):
	result = []
	for c in chargen:
		if   c == "+": item = Add(0, +1)
		elif c == "-": item = Add(0, -1)
		elif c == "<": item = Right(-1)
		elif c == ">": item = Right(+1)
		elif c == ",": item = Input (0)
		elif c == ".": item = Output(0)
		elif c == "[": item = Loop(_parse(chargen, False))
		elif c == "]":
			if maincall:
				raise ValueError("Extra loop closing")
			else:
				return result
		else:
			raise AssertionError("Illegal code character")
		result.append(item)
	
	if maincall:
		return result
	else:
		raise ValueError("Unclosed loop")


# ---- Optimizers ----

# Optimizes the given list of Commands, returning a new list of Commands.
def optimize(commands):
	result = []
	offset = 0  # How much the memory pointer has moved without being updated
	for cmd in commands:
		if isinstance(cmd, Assign):
			# Try to fuse into previous command
			off = cmd.offset + offset
			prev = result[-1] if len(result) >= 1 else None
			if isinstance(prev, (Add,Assign)) and prev.offset == off \
					or isinstance(prev, (MultAdd,MultAssign)) and prev.destOff == off:
				del result[-1]
			result.append(Assign(off, cmd.value))
		elif isinstance(cmd, MultAssign):
			result.append(MultAssign(cmd.srcOff + offset, cmd.destOff + offset, cmd.value))
		elif isinstance(cmd, Add):
			# Try to fuse into previous command
			off = cmd.offset + offset
			prev = result[-1] if len(result) >= 1 else None
			if isinstance(prev, Add) and prev.offset == off:
				prev.value = (prev.value + cmd.value) & 0xFF
			elif isinstance(prev, Assign) and prev.offset == off:
				prev.value = (prev.value + cmd.value) & 0xFF
			else:
				result.append(Add(off, cmd.value))
		elif isinstance(cmd, MultAdd):
			# Try to fuse into previous command
			off = cmd.destOff + offset
			prev = result[-1] if len(result) >= 1 else None
			if isinstance(prev, Assign) and prev.offset == off and prev.value == 0:
				result[-1] = MultAssign(cmd.srcOff + offset, off, cmd.value)
			else:
				result.append(MultAdd(cmd.srcOff + offset, off, cmd.value))
		elif isinstance(cmd, Right):
			offset += cmd.offset
		elif isinstance(cmd, Input):
			result.append(Input(cmd.offset + offset))
		elif isinstance(cmd, Output):
			result.append(Output(cmd.offset + offset))
		else:
			# Commit the pointer movement before starting a loop/if
			if offset != 0:
				result.append(Right(offset))
				offset = 0
			
			if isinstance(cmd, Loop):
				temp = optimize_simple_loop(cmd.commands)
				if temp is not None:
					result.extend(temp)
				else:
					temp = optimize_complex_loop(cmd.commands)
					if temp is not None:
						result.append(temp)
					else:
						result.append(Loop(optimize(cmd.commands)))
			elif isinstance(cmd, If):
				result.append(If(optimize(cmd.commands)))
			else:
				raise AssertionError("Unknown command")
	
	# Commit the pointer movement before exiting this block
	if offset != 0:
		result.append(Right(offset))
	return result


# Tries to optimize the given list of looped commands into a list that would be executed without looping. Returns None if not possible.
def optimize_simple_loop(commands):
	deltas = {}  # delta[i] = v means that in each loop iteration, mem[p + i] is added by the amount v
	offset = 0
	for cmd in commands:
		# This implementation can only optimize loops that consist of only Add and Right
		if isinstance(cmd, Add):
			off = cmd.offset + offset
			deltas[off] = deltas.get(off, 0) + cmd.value
		elif isinstance(cmd, Right):
			offset += cmd.offset
		else:
			return None

	# zero loop
	if offset == 0 and len(deltas) == 1 and 0 in deltas and deltas[0] != 0:
		return [Assign(0, 0)]

	# Can't optimize if a loop iteration has a net pointer movement, or if the cell being tested isn't decremented by 1
	if offset != 0 or deltas.get(0, 0) != -1:
		return None
	
	# Convert the loop into a list of multiply-add commands that source from the cell being tested
	del deltas[0]
	result = []
	for off in sorted(deltas.keys()):
		result.append(MultAdd(0, off, deltas[off]))
	result.append(Assign(0, 0))
	return result


# Attempts to convert the body of a while-loop into an if-statement. This is possible if roughly all these conditions are met:
# - There are no commands other than Add/Assign/MultAdd/MultAssign (in particular, no net movement, I/O, or embedded loops)
# - The value at offset 0 is decremented by 1
# - All MultAdd and MultAssign commands read from {an offset other than 0 whose value is cleared before the end in the loop}
def optimize_complex_loop(commands):
	result = []
	origindelta = 0
	clears = {0}
	for cmd in commands:
		if isinstance(cmd, Add):
			if cmd.offset == 0:
				origindelta += cmd.value
			else:
				clears.discard(cmd.offset)
				result.append(MultAdd(0, cmd.offset, cmd.value))
		elif isinstance(cmd, (MultAdd,MultAssign)):
			if cmd.destOff == 0:
				return None
			clears.discard(cmd.destOff)
			result.append(cmd)
		elif isinstance(cmd, Assign):
			if cmd.offset == 0:
				return None
			else:
				if cmd.value == 0:
					clears.add(cmd.offset)
				else:
					clears.discard(cmd.offset)
				result.append(cmd)
		else:
			return None
	
	if origindelta != -1:
		return None
	for cmd in result:
		if isinstance(cmd, (MultAdd,MultAssign)) and cmd.srcOff not in clears:
			return None
	
	result.append(Assign(0, 0))
	return If(result)


# ---- Output formatters ----

def commands_to_c(commands, name, maincall=True, indentlevel=1):
	def indent(line, level=indentlevel):
		return "\t" * level + line + "\n"
	
	result = ""
	if maincall:
		result += indent("#include <stdint.h>", 0)
		result += indent("#include <stdio.h>", 0)
		result += indent("#include <stdlib.h>", 0)
		result += indent("", 0)
		result += indent("static uint8_t read() {", 0)
		result += indent("int temp = getchar();", 1)
		result += indent("return (uint8_t)(temp != EOF ? temp : 0);", 1)
		result += indent("}", 0)
		result += indent("", 0)
		result += indent("int main(void) {", 0)
		result += indent("uint8_t mem[1000000] = {0};")
		result += indent("uint8_t *p = &mem[1000];")
		result += indent("")
	
	for cmd in commands:
		if isinstance(cmd, Assign):
			result += indent("p[{}] = {};".format(cmd.offset, cmd.value))
		elif isinstance(cmd, Add):
			s = "p[{}]".format(cmd.offset)
			if cmd.value == 1:
				s += "++;"
			elif cmd.value == -1:
				s += "--;"
			else:
				s += " {}= {};".format(plusminus(cmd.value), abs(cmd.value))
			result += indent(s)
		elif isinstance(cmd, MultAssign):
			if cmd.value == 1:
				result += indent("p[{}] = p[{}];".format(cmd.destOff, cmd.srcOff))
			else:
				result += indent("p[{}] = p[{}] * {};".format(cmd.destOff, cmd.srcOff, cmd.value))
		elif isinstance(cmd, MultAdd):
			if abs(cmd.value) == 1:
				result += indent("p[{}] {}= p[{}];".format(cmd.destOff, plusminus(cmd.value), cmd.srcOff))
			else:
				result += indent("p[{}] {}= p[{}] * {};".format(cmd.destOff, plusminus(cmd.value), cmd.srcOff, abs(cmd.value)))
		elif isinstance(cmd, Right):
			if cmd.offset == 1:
				result += indent("p++;")
			elif cmd.offset == -1:
				result += indent("p--;")
			else:
				result += indent("p {}= {};".format(plusminus(cmd.offset), abs(cmd.offset)))
		elif isinstance(cmd, Input):
			result += indent("p[{}] = read();".format(cmd.offset))
		elif isinstance(cmd, Output):
			result += indent("putchar(p[{}]);".format(cmd.offset))
		elif isinstance(cmd, If):
			result += indent("if (*p != 0) {")
			result += commands_to_c(cmd.commands, name, False, indentlevel + 1)
			result += indent("}")
		elif isinstance(cmd, Loop):
			result += indent("while (*p != 0) {")
			result += commands_to_c(cmd.commands, name, False, indentlevel + 1)
			result += indent("}")
		else:
			raise AssertionError("Unknown command")
	
	if maincall:
		result += indent("")
		result += indent("return EXIT_SUCCESS;")
		result += indent("}", 0)
	return result


def commands_to_java(commands, name, maincall=True, indentlevel=2):
	def indent(line, level=indentlevel):
		return "\t" * level + line + "\n"
	
	result = ""
	if maincall:
		result += indent("import java.io.IOException;", 0)
		result += indent("", 0)
		result += indent("public class " + name + " {", 0)
		result += indent("public static void main(String[] args) throws IOException {", 1)
		result += indent("byte[] mem = new byte[1000000];")
		result += indent("int i = 1000;")
		result += indent("")
	
	def format_memory(off):
		if off == 0:
			return "mem[i]"
		else:
			return "mem[i {} {}]".format(plusminus(off), abs(off))
	
	for cmd in commands:
		if isinstance(cmd, Assign):
			result += indent("{} = {};".format(format_memory(cmd.offset), (cmd.value & 0xFF) - ((cmd.value & 0x80) << 1)))
		elif isinstance(cmd, Add):
			if cmd.value == 1:
				result += indent("{}++;".format(format_memory(cmd.offset)))
			elif cmd.value == -1:
				result += indent("{}--;".format(format_memory(cmd.offset)))
			else:
				result += indent("{} {}= {};".format(format_memory(cmd.offset), plusminus(cmd.value), abs(cmd.value)))
		elif isinstance(cmd, MultAssign):
			if cmd.value == 1:
				result += indent("{} = {};".format(format_memory(cmd.destOff), format_memory(cmd.srcOff)))
			else:
				result += indent("{} = (byte)({} * {});".format(format_memory(cmd.destOff), format_memory(cmd.srcOff), cmd.value))
		elif isinstance(cmd, MultAdd):
			if abs(cmd.value) == 1:
				result += indent("{} {}= {};".format(format_memory(cmd.destOff), plusminus(cmd.value), format_memory(cmd.srcOff)))
			else:
				result += indent("{} {}= {} * {};".format(format_memory(cmd.destOff), plusminus(cmd.value), format_memory(cmd.srcOff), abs(cmd.value)))
		elif isinstance(cmd, Right):
			if cmd.offset == 1:
				result += indent("i++;")
			elif cmd.offset == -1:
				result += indent("i--;")
			else:
				result += indent("i {}= {};".format(plusminus(cmd.offset), abs(cmd.offset)))
		elif isinstance(cmd, Input):
			result += indent("{} = (byte)Math.max(System.in.read(), 0);".format(format_memory(cmd.offset)))
		elif isinstance(cmd, Output):
			result += indent("System.out.write({});".format(format_memory(cmd.offset))) + indent("System.out.flush();")
		elif isinstance(cmd, If):
			result += indent("if (mem[i] != 0) {")
			result += commands_to_java(cmd.commands, name, False, indentlevel + 1)
			result += indent("}")
		elif isinstance(cmd, Loop):
			result += indent("while (mem[i] != 0) {")
			result += commands_to_java(cmd.commands, name, False, indentlevel + 1)
			result += indent("}")
		else:
			raise AssertionError("Unknown command")
	
	if maincall:
		result += indent("}", 1)
		result += indent("}", 0)
	return result


def commands_to_python(commands, name, maincall=True, indentlevel=0):
	def indent(line, level=indentlevel):
		return "\t" * level + line + "\n"
	
	result = ""
	if maincall:
		result += indent("import sys")
		result += indent("")
		result += indent("mem = [0] * 1000000")
		result += indent("i = 1000")
		result += indent("")
	
	def format_memory(off):
		if off == 0:
			return "mem[i]"
		else:
			return "mem[i {} {}]".format(plusminus(off), abs(off))
	
	for cmd in commands:
		if isinstance(cmd, Assign):
			result += indent("{} = {}".format(format_memory(cmd.offset), cmd.value))
		elif isinstance(cmd, Add):
			result += indent("{} = ({} {} {}) & 0xFF".format(format_memory(cmd.offset),
				format_memory(cmd.offset), plusminus(cmd.value), abs(cmd.value)))
		elif isinstance(cmd, MultAssign):
			if cmd.value == 1:
				result += indent("{} = {}".format(format_memory(cmd.destOff), format_memory(cmd.srcOff)))
			else:
				result += indent("{} = ({} * {}) & 0xFF".format(format_memory(cmd.destOff), format_memory(cmd.srcOff), cmd.value))
		elif isinstance(cmd, MultAdd):
			result += indent("{} = ({} + {} * {}) & 0xFF".format(format_memory(cmd.destOff), format_memory(cmd.destOff), format_memory(cmd.srcOff), cmd.value))
		elif isinstance(cmd, Right):
			result += indent("i {}= {}".format(plusminus(cmd.offset), abs(cmd.offset)))
		elif isinstance(cmd, Input):
			result += indent("{} = ord((sys.stdin.read(1) + chr(0))[0])".format(format_memory(cmd.offset)))
		elif isinstance(cmd, Output):
			result += indent("sys.stdout.write(chr({}))".format(format_memory(cmd.offset)))
		elif isinstance(cmd, If):
			result += indent("if mem[i] != 0:")
			result += commands_to_python(cmd.commands, name, False, indentlevel + 1)
		elif isinstance(cmd, Loop):
			result += indent("while mem[i] != 0:")
			result += commands_to_python(cmd.commands, name, False, indentlevel + 1)
		else:
			raise AssertionError("Unknown command")
	return result


def plusminus(val):
	if val >= 0:
		return "+"
	else:
		return "-"


# ---- Intermediate representation (IR) ----

class Command(object):  # Common superclass
	pass

class Assign(Command):
	def __init__(self, offset, value):
		self.offset = offset
		self.value = value

class Add(Command):
	def __init__(self, offset, value):
		self.offset = offset
		self.value = value

class MultAssign(Command):
	def __init__(self, srcOff, destOff, value):
		self.srcOff = srcOff
		self.destOff = destOff
		self.value = value

class MultAdd(Command):
	def __init__(self, srcOff, destOff, value):
		self.srcOff = srcOff
		self.destOff = destOff
		self.value = value

class Right(Command):
	def __init__(self, offset):
		self.offset = offset

class Input(Command):
	def __init__(self, offset):
		self.offset = offset

class Output(Command):
	def __init__(self, offset):
		self.offset = offset

class If(Command):
	def __init__(self, commands):
		self.commands = commands

class Loop(Command):
	def __init__(self, commands):
		self.commands = commands


# print main(['test.bf','$stdout.c'])
main(['brainfuck.txt', 'bfopt.c'])