error(s) {
	write(s + [10]);
	1 / 0;
}

indexof(v, x) {
	i = 0;
	while (i < len(v)) {
		if (v[i] == x) return i;
		else i = i + 1;
	}
	return -1;
}

is_head(v, w) {
	i = 0;
	res = 1;
	while (i < len(v)) {
		if (i >= len(w)) res = 0;
		else if (v[i] != w[i]) res = 0;
		i = i + 1;
	}
	return res;
}

assoc(v, x) {
	i = 0;
	while (i < len(v)) {
		if (v[i][0] == x) return v[i][1];
		i = i + 1;
	}
	debug("assoc not found", v, x);
	error("");
}

str2int(s) {
	res = 0;
	sign = 1;
	i = 0;
	if (s[0] == "-") {
		sign = -1;
		i = 1;
	}
	while (i < len(s)) {
		res = res * 10 + s[i] - 48;
		i = i + 1;
	}
	return res * sign;
}

int2str(n) {
	res = "";
	if (n < 0) {
		res = "-";
		n = -n;
	}
	if (n == 0) return "0";
	else {
		s = [];
		while (n > 0) {
			s = [48 + n % 10] + s;
			n = n / 10;
		}
		res = res + s;
		return res;
	}
}

is_ident_char(c) {
	return (48 <= c && c <= 57) || (65 <= c && c <= 90) || (97 <= c && c <= 122) || c == 95;
}

is_number(c) {
	return (48 <= c && c <= 57);
}

is_digit(s) {
	i = 0;
	while (i<len(s)) {
		if (!is_number(s[i])) return 0;
		i = i + 1;
	}
	return 1;
}

tokenize() {
	syms = ["+", "-", "*", "/", "%", "(", ",", ")", "{", "}", ";", "[", "]", "==", "!=", "=", "<=", ">=", ">", "<", "||", "!", "&&", "/*"];
	res = [];
	cont = 1;
	mc = -1;
	while(cont) {
		if (mc < 0) c = read();
		else {
			c = mc; mc = -1;
		}
		debug(c, is_ident_char(c), is_number(c));
		if (c == 255) cont = 0;
		else if (c == 9 || c == 10 || c == 32 || c == 13 || c == 11 || c == 12) { /* \t\s\n\r\x0b\x0c */
			/* pass */
		} else if (is_number(c)) {
			v = [c];
			cont2 = 1;
			while (cont2) {
				c = read();
				if (!is_number(c)) {
					mc = c;
					cont2 = 0;
				} else v = v + [c];
			}
			res = res + [v];
		} else if (is_ident_char(c)) {
			v = [c];
			cont2 = 1;
			while (cont2) {
				c = read();
				if (!is_ident_char(c)) {
					mc = c;
					cont2 = 0;
				} else v = v + [c];
			}
			res = res + [v];
		} else if (c == 34) { /* " */
			v = [c];
			cont2 = 1;
			while (cont2) {
				c = read();
				if (c == 34) cont2 = 0;
				v = v + [c];
			}
			res = res + [v];
		} else {
			v = [];
			ok = 1;
			while (ok) {
				ok = 0;
				tv = v + [c];
				i = 0;
				while (i < len(syms)) {
					if (is_head(tv, syms[i])) ok = 1;
					i = i + 1;
				}
				if (ok) {
					v = v + [c];
					c = read();
				}
			}
			ok = 0;
			i = 0;
			while (i < len(syms)) {
				ok = ok || (v == syms[i]);
				i = i + 1;
			}
			if (!ok) error("tokenize failed " + v);
			if (v == "/*") {
				bc = c;
				cont2 = 1;
				while (cont2) {
					c = read();
					if ([bc, c] == "*/") cont2 = 0;
					bc = c;
					mc = -1;
				}
			} else {
				res = res + [v];
				mc = c;
			}
		}
	}
	return res;
}

assert(b, s) {
	if (!b) error(s);
}

s; p;

expect(d, t) {
	assert(s[p + d] == t, "assert_token: expect " + t + " got: " + s[p + d]);
	p = p + d + 1;
}

get_priority(op) {
	prs = [
		["||", "&&", "!"],
		["==", "!=", ">", "<", "<=", ">="],
		["+", "-"],
		["*", "/", "%"]
	];
	i = 0;
	while (i < len(prs)) {
		if (indexof(prs[i], op) != -1) return i;
		i = i + 1;
	}
	error("unknown priority operator: " + op);
}

parse_expr(pri) {
	n = s[p];
	if(n == "(") {
		p = p + 1;
		v = parse_expr(-1);
		expect(0, ")");
	} else if(n == "[") {
		vs = get_arguments(0, "[", "]");
		v = ["[]", vs];
	} else if(n == "-") {
		p = p + 1;
		v = ["Minus", [parse_expr(get_priority("-"))]];
	} else if(n == "!") {
		p = p + 1;
		v = ["Not", [parse_expr(get_priority("!"))]];
	} else {
		if (is_digit(n)) {
			v = ["Int", n];
		} else if (n[0] == 34){ /* " */
			arr = [];
			i = 1;
			while (i + 1 < len(n)) {
				arr = arr + [["Int", int2str(n[i])]];
				i = i + 1;
			}
			v = ["[]", arr];
		} else {
			v = ["Var", n];
		}
		p = p + 1;
	}
	debug(s, len(s), p);
	while(1) {
		op = s[p];
		if (op == ")" || op == ";" || op == "," || op == "]") return v;
		else if (op == "(") {
			assert(v[0] == "Var", "function call for " + v[0] + " is not defined");
			vs = get_arguments(0, "(", ")");
			v = ["Call", [v[1], vs]];
		} else if (op == "[") {
			p = p + 1;
			v = ["Get", [v, parse_expr(-1)]];
			expect(0, "]");
		} else {
			pri2 = get_priority(op);
			if (pri >= pri2) return v;
			else {
				p = p + 1;
				v = [op, [v, parse_expr(pri2)]];
			}
		}
	}
}

get_arguments(is_decl, fr, to) {
	expect(0, fr);
	if (s[p] == to) {
		p = p + 1;
		return [];
	}
	else {
		if (is_decl) {
			v = s[p];
			p = p + 1;
		} else v = parse_expr(-1);
		res = [v];
		cont = 1;
		while (cont) {
			if (s[p] == to) {
				p = p + 1;
				cont = 0;
			}
			else {
				expect(0, ",");
				if (is_decl) {
					v = s[p];
					p = p + 1;
				} else v = parse_expr(-1);
				res = res + [v];
			}
		}
		return res;
	}
}

parse_statement() {
	n = s[p];
	if (n == "if") {
		expect(1, "(");
		e = parse_expr(-1);
		expect(0, ")");
		stt = parse_statements_or_statement();
		if(s[p] == "else"){
			p = p + 1;
			stf = parse_statements_or_statement();
		} else stf = [];
		return ["If", e, stt, stf];
	} else if (n == "while") {
		expect(1, "(");
		e = parse_expr(-1);
		expect(0, ")");
		st = parse_statements_or_statement();
		return ["While", e, st];
	} else if (n == "return") {
		p = p + 1;
		e = parse_expr(-1);
		expect(0, ";");
		return ["Return", e];
	} else if (s[p+1] == "=") {
		p = p + 2;
		e = parse_expr(-1);
		expect(0, ";");
		return ["Assign", n, e];
	} else {
		e = parse_expr(-1);
		expect(0, ";");
		return ["Expr", e];
	}
}

parse_statements(){
	expect(0, "{");
	res = [];
	while (1) {
		if (s[p] == "}") {
			p = p + 1;
			return res;
		}else{
			res = res + [parse_statement()];
		}
	}
}

parse_statements_or_statement() {
	if (s[p] == "{") return parse_statements();
	else return [parse_statement()];
}

parse(gs) {
	s = gs;
	p = 0;
	res = [];
	while (p < len(s)) {
		n = s[p];
		if (s[p+1] == "(") {
			p = p + 1;
			args = get_arguments(1,"(",")");
			res = res + [["Funcdecl", n, args,parse_statements()]];
		} else {
			expect(1, ";");
			res = res + [["Vardecl", n]];
		}
	}
	return res;
}

ip; executable; resolver; resolver_functions; func_arg_nums; funcip;

inst(ins) {
	executable = executable + [ins];
	ip = ip + 1;
}

dummyinst() {
	res = ip;
	inst("dummy");
	return res;
}

epilogue() {
	inst("mov sp bp");
	inst("pop bp");
	inst("ret");
}

env; dbp;

genvar() {
	res = "bp[" + int2str(dbp) + "]";
	dbp = dbp + 1;
	return res;
}

compile_expr(e) {
	op = e[0];
	if(op == "Call"){
		fn = e[1][0];
		vs = e[1][1];
		if (fn == "debug") return "debugdummy";
		retv = genvar();
		efn = assoc(func_arg_nums, fn);
		assert(efn == len(vs), "compile_expr: expect " + int2str(efn) + " arguments, got " + int2str(len(vs)));
		i = 0;
		while (i < len(vs)) {
			v = compile_expr(vs[i]);
			inst("push " + v);
			i = i + 1;
		}
		inst("push 0");
		if (fn == "read" || fn == "write" || fn == "len") inst(fn);
		else {
			mp = dummyinst();
			resolver_functions = resolver_functions + [[mp, fn,"call "]];
		}
		inst("pop " + retv);
		inst("sub sp sp " + int2str(len(vs)));
		return retv;
	}
	else if (op == "Int") {
		return e[1];
	}
	else if (op == "Var") {
		return assoc(env, e[1]);
	}
	else {
		vs = [];
		i = 0;
		while (i < len(e[1])) {
			vs = vs + [compile_expr(e[1][i])];
			i = i + 1;
		}
		v = genvar();
		if(op == "[]"){
			if (len(vs) == 0) s = "[]";
			else {
				s = "[" + vs[0];
				i = 1;
				while (i < len(vs)) {
					s = s + "," + vs[i];
					i = i + 1;
				}
				s = s + "]";
			}
			inst("makelist " + v + " " + s);
		}
		else if (op == "Minus") {
			inst("sub " + v + " 0 " + vs[0]);
		}
		else if (op == "Not") {
			inst("eq " + v + " " + vs[0] + " 0");
		}
		else if (op == "+") {
			inst("add " + v + " " + vs[0] + " " + vs[1]);
		}
		else if (op == "-") {
			inst("sub " + v + " " + vs[0] + " " + vs[1]);
		}
		else if (op == "*") {
			inst("mul " + v + " " + vs[0] + " " + vs[1]);
		}
		else if (op == "/") {
			inst("div " + v + " " + vs[0] + " " + vs[1]);
		}
		else if (op == "%") {
			inst("div " + v + " " + vs[0] + " " + vs[1]);
			inst("mul " + v + " " + v + " " + vs[1]);
			inst("sub " + v + " " + vs[0] + " " + v);
		}
		else if (op == "<") {
			inst("lt " + v + " " + vs[0] + " " + vs[1]);
		}
		else if (op == ">") {
			inst("lt " + v + " " + vs[1] + " " + vs[0]);
		}
		else if (op == "<=") {
			inst("lt " + v + " " + vs[1] + " " + vs[0]);
			inst("eq " + v + " 0 " + v);
		}
		else if (op == ">=") {
			inst("lt " + v + " " + vs[0] + " " + vs[1]);
			inst("eq " + v + " 0 " + v);
		}
		else if (op == "==") {
			inst("eq " + v + " " + vs[0] + " " + vs[1]);
		}
		else if (op == "!=") {
			inst("eq " + v + " " + vs[0] + " " + vs[1]);
			inst("eq " + v + " " + v + " 0");
		}
		else if (op == "&&") {
			inst("mul " + v + " " + vs[0] + " " + vs[1]);
			inst("eq " + v + " " + v + " 0");
			inst("eq " + v + " " + v + " 0");
		}
		else if (op == "||") {
			w = genvar();
			inst("eq " + v + " " + vs[0] + " 0");
			inst("eq " + w + " " + vs[1] + " 0");
			inst("mul " + v + " " + v + " " + w);
			inst("eq " + v + " " + v + " 0");
		}
		else if (op == "Get") {
			inst("get " + v + " " + vs[0] + " " + vs[1]);
		}
		else error("unknown operator " + op);
		return v;
	}
}

compile_statements(stmts) {
	i = 0;
	while (i < len(stmts)) {
		st = stmts[i];
		if (st[0] == "While") {
			mp = ip;
			e = compile_expr(st[1]);
			mp2 = dummyinst();
			compile_statements(st[2]);
			inst("jz 0 " + int2str(mp));
			resolver = resolver + [[mp2,"jz " + e + " " + int2str(ip)]];
		}
		else if (st[0] == "If") {
			e = compile_expr(st[1]);
			mp = dummyinst();
			compile_statements(st[2]);
			mp2 = dummyinst();
			resolver = resolver + [[mp,"jz " + e + " " + int2str(ip)]];
			compile_statements(st[3]);
			resolver = resolver + [[mp2,"jz 0 " + int2str(ip)]];
		}
		else if (st[0] == "Return") {
			e = compile_expr(st[1]);
			inst("mov bp[-2] " + e);
			epilogue();
		}
		else if (st[0] == "Assign") {
			e = compile_expr(st[2]);
			inst("mov " + assoc(env,st[1]) + " " + e);
		}
		else if (st[0] == "Expr") {
			compile_expr(st[1]);
		} else error("unknown statement type" + st[0]);
		i = i + 1;
	}
}

globals;

collect_locals(stmts, args, locals) {
	i = 0;
	while (i < len(stmts)) {
		st = stmts[i];
		if (st[0] == "While") {
			locals = collect_locals(st[2], args, locals);
		}
		else if (st[0] == "If") {
			locals = collect_locals(st[2], args, locals);
			locals = collect_locals(st[3], args, locals);
		}
		else if (st[0] == "Assign") {
			n = st[1];
			if(indexof(args + globals + locals, n) == -1){
				locals = locals + [n];
			}
		}
		i = i + 1;
	}
	return locals;
}

compile_function(fn, args, body) {
	locals = collect_locals(body, args, []);
	funcip = funcip + [[fn, ip]];
	inst("push bp");
	inst("mov bp sp");
	mplo = dummyinst(); /* inst("add sp sp " + int2str(len(locals))); */
	/* -len(args)-2      -3  |  -2  |  -1   |   0   |    1         len(locals) |            */
	/*  args[-1] ... args[0] | retv | oldip | oldbp | locals[0] ... locals[-1] | dbp[0] ... */
	env = [];
	i = 0;
	while (i < len(args)) {
		env = env + [[args[len(args) - i - 1], "bp[" + int2str(-i - 3) + "]"]];
		i = i + 1;
	}
	i = 0;
	while (i < len(globals)) {
		if (indexof(args, globals[i]) == -1) env = env + [[globals[i], "#" + int2str(i)]];
		i = i + 1;
	}
	i = 0;
	while (i < len(locals)) {
		env = env + [[locals[i], "bp[" + int2str(i + 1) + "]"]];
		i = i + 1;
	}
	debug("env", fn, env);
	dbp = len(locals) + 1;
	compile_statements(body);
	resolver = resolver + [[mplo, "add sp sp " + int2str(dbp - 1)]];
	inst("mov bp[-2] 0");
	epilogue();
}

main() {
	s = tokenize();
	debug(s);
	prog = parse(s);
	debug(prog);
	i = 0;
	func_arg_nums = [["read", 0], ["write", 1], ["len", 1]];
	while (i < len(prog)) {
		if (prog[i][0] == "Funcdecl") {
			func_arg_nums = func_arg_nums + [[prog[i][1], len(prog[i][2])]];
		}
		i = i + 1;
	}
	debug("func_arg_nums", func_arg_nums);

	ip = 0;
	i = 0;
	globals = [];
	executable = [];
	resolver = [];
	funcip = [];

	ipz = dummyinst();
	resolver_functions = [[dummyinst(), "main", "call "]];
	inst("hlt");

	while (i < len(prog)) {
		d = prog[i];
		if (d[0] == "Funcdecl") {
			compile_function(d[1], d[2], d[3]);
		} else if (d[0] == "Vardecl") {
			globals = globals + [d[1]];
		} else error("unknown global type" + prog[i][0]);
		i = i + 1;
	}
	debug(executable);

	resolver = resolver + [[ipz, "add sp sp " + int2str(len(globals))]];

	i = 0;
	while (i < len(resolver_functions)) {
		d = resolver_functions[i];
		resolver = resolver + [[d[0], d[2] + int2str(assoc(funcip, d[1]))]];
		i = i + 1;
	}

	output = "";
	i = 0;
	while (i < len(executable)) {
		s = executable[i];
		if (s == "dummy") {
			s = assoc(resolver, i);
		}
		output = output + s + [10];
		i = i + 1;
	}
	write(output);
}

