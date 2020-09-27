#p = random_prime(1<<1024, proof=False)
#q = random_prime(1<<1024, proof=False)
#n = p*q

n = 25299128324054183472341067223932160732879350179758036557232544635970111090474692853470743347443422497121006796606102551210094872253782062717537548880909979729182337501587763866901367212812697076494080678616385493076865655574412317879297160790121009524506015912113098690685202868184636344610142590510988192306870694667596904330867479578103616304053889409982447653859514868824002960431331342963562137691362725961627846051021103954795862501700267818317148154520620016172888281127685503677751830350686839873220480306266506898497203511851305686566444690384065880667273398255172752236076702247451872387522388546088290187449
k = 31019613858513746556266176233462864650379070310554671955689986199007361221356361736128815989480106678809272137963430923820800280374078610631771089089882153619351592434728588050285853284795554255483472955286848474793299446184220594124878818081534965835159741218233013815338595300394855159744354636541274026478456851924371621879725248093305782590590080796638483359868136648681381332610536250576568502512250581068814961097404403694071264894656697723213779631364079010490113719021172301802643377777927176399460547584115127172190000090756708138720022664973312744713394243720961199400948876916817452969615149776530401604593
m = 7647621505426523107416876116179503771882358225602233882688080500019700416074079641481433709829408187069837328548192260242213288375752541771980455357725520773932150990241200106710194070936521249397968646028251975570300856774501827288072745234025035794496061930945682174098054405440546453789891131472968763963211701605509016308957961233593474796671835082111731734173903413989101376338153157881536000538617570527656809006766854781353000424633201559848473157638877908589222891590426378306548494548233753531300670238544815960843418612332546932989237593742552831285809303013106494916607063536993429613432733764529882168669



R = Zmod(n)

class LuckException(Exception):
	pass

def combine(x, y, u, v, k):
	X = (x*u - k*y*v)
	Y = (x*v + u*y)
	assert X^2 + k*Y^2 == (x^2 + k*y^2) * (u^2 + k*v^2), 'combine'
	return (X, Y)

if False:
	x = R.random_element()
	y = R.random_element()
	k = R.random_element()
	u = R.random_element()
	v = R.random_element()

	a = (x^2 + k*y^2) * (u^2 + k*v^2)
	X, Y = combine(x, y, u, v, k)
	b = (X^2 + k*Y^2)
	assert a == b

def bitlen(x):
	w = int(x).bit_length()
	if w < 40:
		return str(x)
	else:
		return str(w) + 'bit'

def swap_solve(k, m):
	while True:
		try:
			X, Y = solve(-m, -k)
			break
		except LuckException:
			if abs(k) < 1000000:
				raise LuckException()
			continue

	try:
		y = R(1)/R(Y)
	except:
		assert False, 'what the fuck ' + str(Y)
	x = R(X) * y
	assert R(x^2 + k*y^2) == R(m), 'failed to swap_solve'
	print('swap_solve ok')
	return (ZZ(x), ZZ(y))

def solve(k, m):
	print('solve', bitlen(k), bitlen(m))
	print('m', m.parent())
	print('k', k.parent())

	if m == k:
		print('m == k')
		return (0, 1)

	ok, x = is_square(ZZ(m), root=True)
	if ok:
		print('m is perfect square')
		return (x, 0)

	if m%k == 0:
		ok, x = is_square(ZZ(m//k), root=True)
		if ok:
			print('m/k is perfect square')
			return (0, x)

	ok, x = is_square(ZZ(m-k), root=True)
	if ok:
		print('m-k is perfect square')
		return (x, 1)

	ok, x = is_square(ZZ(m-4*k), root=True)
	if ok:
		print('m-4k is perfect square')
		return (x, 2)

	ok, x = is_square(ZZ(m-9*k), root=True)
	if ok:
		print('m-9k is perfect square')
		return (x, 3)

	print('looking for (u, v) ', end='', flush=True)
	i = 0
	while True:
		if i%20 == 0:
			print('.', end='', flush=True)
		i += 1
		u = R.random_element()
		v = R.random_element()
		salt_uv = R(u), R(v)
		salt = u^2 + k*v^2
		m0 = ZZ(m/salt)
		if not is_pseudoprime(m0):
			continue
		Mod_m0 = GF(m0, impl='modn', proof=False)
		print('*', end='', flush=True)
		try:
			r = ZZ(GF(m0, impl='modn', proof=False)(-ZZ(k)).sqrt(extend=False))
		except ValueError:
			continue
		break
	print(' ok')

	print('m0 =', m0, m0.parent())
	print('r =', r, r.parent())
	print('k =', k, k.parent())
	assert Mod_m0(r)^2 + Mod_m0(k) == 0, 'wasdasdasd'

	print('reducing...')

	s, t = (R(1), R(0))
	lhs = R(1)
	m_i = m0
	lhs_square = R(1)
	while True:
		r = ZZ(r)
		prod = ZZ(r)^2 + ZZ(k)
		assert prod%ZZ(m_i) == 0, 'sqrt is fucked'
		m_next = prod // ZZ(m_i)
		if m_next == 0:
			raise LuckException()
		if m_next <= 0 or m_next > m_i:
			break

		assert s^2 + k*t^2 == lhs, 'product of equations is wrong'
		assert R(r)^2 + R(k) == R(prod), 'basic arithmetic is broken'
		#print('lhs_prev =', lhs)
		#print('prod =', R(prod))
		s, t = combine(s, t, R(r), R(1), k)
		lhs *= R(prod)
		#print('lhs =', lhs)
		#print('fuck =', s^2 + k*t^2)
		assert s^2 + k*t^2 == lhs, 'product of equations is wrong'
		if m_i != m0:
			lhs_square *= m_i

		m_i = m_next
		r = min(r%ZZ(m_next), ZZ(m_next) - r%ZZ(m_next))
		print(bitlen(m_i), bitlen(r))

	assert s^2 + k*t^2 == lhs, 'product of equations is wrong'
	assert lhs/m_i/m0 == lhs_square^2, 'lhs_square is wrong'
	lhs = R(m0) / R(m_i)
	s /= lhs_square*m_i
	t /= lhs_square*m_i
	assert s^2 + k*t^2 == lhs, 'asduiobasdiabwepqawuebqwe'

	U, V = swap_solve(k, m_i)
	lhs *= R(m_i)
	assert lhs == m0
	s, t = combine(s, t, U, V, k)
	assert s^2 + k*t^2 == m0
	print('good')

	u, v = salt_uv

	#print('lhs = ', lhs)
	#print('salt = ', salt)
	##print('m = ', m)
	#print('rhs = ', s^2 + k*t^2)
	#print('salt_uv = ', u^2 + k*v^2)

	lhs *= salt
	assert u^2 + k*v^2 == salt, 'salt'
	s, t = combine(s, t, u, v, k)
	assert lhs == m, 'm0*salt == m'
	#print('out = ', s^2 + k*t^2)
	assert s^2 + k*t^2 == m, 'salt uv'

	return s, t


k = ZZ(R(k))
m = ZZ(R(m))
x, y = solve(k, m)

print(x, y)

with open('output.txt', 'w') as f:
	print(x, y, file=f)
