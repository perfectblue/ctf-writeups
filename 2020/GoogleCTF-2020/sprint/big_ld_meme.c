#include <string.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdlib.h>

int sprintf(char *str, const char *format, ...)
{
	printf("%p %s\n", format, format);
	va_list args;
	va_start(args, format);
    int xxx = vsprintf(str, format, args);
	va_end(args);
	return xxx;
}
