Introduction
============

We need to escape a PHP jail. PHP has all optional extensions disabled,
`open_basedir` is set to an empty read-only dir, and many functions
are disabled in `php.ini`. However there is a custom extension called "pwnlib".

The pwnlib extension
====================

Most interesting function in pwnlib is `pwnlib_hexdump(string, offset, length)`.
It's meant to act like `bin2hex(substr(string, offset, length))` but it doesn't check bounds,
which allows us to easily read memory in PHP's heap.

We can leak addresses of objects by creating an `array($random_marker, $object)` and then scanning
for `$random_marker` using `pwnlib_hexdump()`.

Exploiting a PHP n-day
======================
Since I didn't find a RCE in pwnlib (during the ctf). I exploited a known bug in PHP: https://bugs.php.net/bug.php?id=79214

Simple PoC:


	$x = array_fill(0, 16, 0xdeadbeef); // create a dense array
	$x[0] = &$x;
	set_error_handler(function($errno, $errstr){
		global $x;
		$x[100] = 0; // convert the array into a sparse one, causing a realloc
		do_a_bunch_allocations_to_reuse_x_old_memory(); // leads to a segfault after we return
	});
	var_export([&$x]);

The built-in function `var_export(x)` recursively walks a structure and prints it in php syntax.
It doesn't support cyclic structures and will print a warning whenever it encounters a cycle. By registering
a custom error handler we can use this mechanism to execute arbitrary PHP code from inside `var_export(x)`.

Now the bug itself: when iterating over arrays `var_export(x)` keeps raw pointers to the array's
buckets (field `arData` in `struct _zend_array`). Adding items to the array from inside `var_export(x)` can cause it reallocate
it's buckets and make `var_export(x)` UAF. When `var_export()` encounters a `zend_object` it conveniently
calls `obj->handlers->get_properties(obj)`, which gives us easy RIP control.

Note that the following won't work:

	$x = array();
	$x[0] = &$x;
	set_error_handler(function($errno, $errstr){
		... // make $x realloc
	});
	var_export($x);

Passing an array as an argument to function will mark it with `GC_IMMUTABLE` and our error callback
will automatically create a copy of `$x` to modify (i.e. the array will become copy-on-write). We bypass
this by passing `[&$x]` to `var_export`.

We use `pwnlib_hexdump` to leak heap addresses and craft a fake `struct _zend_object_handlers`, fake `struct _zend_object`, and a fake `struct _Bucket`.
With them we can call any address with pointer to pointer to our memory as the first argument.
Due to `offset >= 0` check in `pwnlib_hexdump` it's non-trivial to leak libc address, so instead of a one-gadget we jump into one of the callsites to `popen` in the main php executable (0x00208b9a). To make `rdi` point to a shell command we use a `mov rdi, qword ptr [rdi]; call qword ptr [rbx + 0x10]` gadget.

Full exploit is in `var_exploit.php`
