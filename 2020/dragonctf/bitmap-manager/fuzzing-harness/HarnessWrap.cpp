// cl.exe /D_USERDLL /D_WINDLL HarnessWrap.cpp /MT /link /DLL /OUT:HarnessWrap.dll

#include <stdio.h>
#include <windows.h>
#include <io.h>
#include <stdlib.h>
#include <conio.h>
#include "harness-api.h"

void CALLBACK setup_func()
{
	// reopen stdin
	// FILE* lol = fopen("fakestdin.txt", "rb");
	// _dup2(_fileno(lol), _fileno(stdin));

	freopen("fakestdin.txt", "rb", stdin);
	freopen("stdout.txt", "wb", stdout);
	printf("Reopened stdio\n");
}

HMODULE hMainModule;
uintptr_t main_addr;

void CALLBACK fuzz_iter_func()
{
	freopen("stdout.txt", "wb", stdout);
	FILE* fuck = fopen("test.txt", "wb");
	_dup2(_fileno(fuck), _fileno(stdout));
	FILE* fuck2 = fopen("fakestdin.txt", "rb");
	_dup2(_fileno(fuck2), _fileno(stdin));

	printf("calling main now\n");
	fflush(stdout);
	// call main
	((int(__cdecl *)(int, char**, char**))main_addr)(0,0,0);
	printf("main returns\n");
	fflush(stdout);
}

EXPOSE_HARNESS(
	NULL, // target method. fill in later
	fuzz_iter_func, // fuzz iter func
	NULL, // no preload
	L"bitmaps\\1.bmp",
	setup_func, // setup
	FALSE // not network
);

BOOL APIENTRY DllMain(HMODULE hModule,
	DWORD  ul_reason_for_call,
	LPVOID lpReserved
)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		hMainModule = GetModuleHandle(NULL);
		main_addr = (uintptr_t)hMainModule + 0x7520;
		HarnessInfo.target_method = (LPVOID) main_addr;
		break;
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

