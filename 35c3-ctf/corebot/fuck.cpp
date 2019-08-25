// fuck.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <Wincrypt.h>
#include "aes.h"

__declspec(naked) void __stdcall fuckit(void* out, DWORD serial) {
	__asm {
		push esi;
		push ebp;
		mov ebp, esp;
		mov esp, [ebp + 0xc];
		mov eax, [ebp + 0x10];
		mov ecx, 0x10;
		add esp, 0x20;
	loc_40119F:
		push    ax;
		movzx   esi, ax;
		mov     edx, esi;
		shl     edx, 7;
		xor eax, edx;
		mov     edx, esi;
		shl     edx, 0x0B;
		xor eax, edx;
		mov     edx, esi;
		shr     edx, 4;
		xor eax, edx;
		loop    loc_40119F;
		mov ecx, 0x20;
		leave;
		pop esi;
		ret 8;
	}
}


typedef struct _PLAINTEXTKEYBLOB {
	BLOBHEADER hdr;
	DWORD      dwKeySize;
	BYTE       rgbKeyData[0x20];
} _PLAINTEXTKEYBLOB, *PPLAINTEXTKEYBLOB;


/* Untitled1 (12/28/2018 02:30:24)
StartOffset(h): 00000000, EndOffset(h): 0000001F, Length(h): 00000020 */

int main()
{
	_PLAINTEXTKEYBLOB dank;
	dank.hdr.bType = PLAINTEXTKEYBLOB;
	dank.hdr.bVersion = 2;
	dank.hdr.aiKeyAlg = CALG_AES_256;
	dank.dwKeySize = 0x20;
	HCRYPTPROV hProv;
	__declspec(align(32)) unsigned char resourceData[32] = {
		0x10, 0x29, 0xB8, 0x45, 0x9D, 0x2A, 0xAB, 0x93, 0xFE, 0x89, 0xFB, 0x82,
		0x93, 0x42, 0xA1, 0x8C, 0x2E, 0x90, 0x63, 0x00, 0x06, 0x11, 0x80, 0x64,
		0xB8, 0x21, 0xC2, 0x9F, 0x35, 0xE7, 0x7E, 0xF2
	};

	__declspec(align(32)) AES_KEY k;

	/*
	4096
	ff 16 f0 e0 ee 61 e0 10 55 13 50 b0 44 31 40 10 99 15 90 d0 88 51 80 10 11 11 10 90 00 11 00 10
	74 ef 87 35 f5 18 08 5f 77 8d 34 4f b8 73 6a 82
	*/
	DWORD dwKey = 0;
	__declspec(align(32)) BYTE inputBuf[32];
	//CryptAcquireContextA(&hProv, 0, 0, 0x18u, 0);
	do {
		//memset(dank.rgbKeyData, 0, 0x20);
		//memcpy(inputBuf, resourceData, 32);
		//memset(inputBuf, 0, 32);
		fuckit(dank.rgbKeyData, dwKey);


		/*HCRYPTKEY hKey;
		CryptImportKey(hProv, (BYTE*)&dank, 0x2Cu, 0, 0, &hKey);
		int tmp_1 = CRYPT_MODE_ECB;
		CryptSetKeyParam(hKey, KP_MODE, (const BYTE *)&tmp_1, 0);
		tmp_1 = sizeof(inputBuf);
		CryptDecrypt(hKey, 0, 1, 0, inputBuf, (DWORD *)&tmp_1);*/
		AES_set_decrypt_key(dank.rgbKeyData, 256, &k);
		AES_decrypt(resourceData, inputBuf, &k);

		if (*(DWORD*)inputBuf == '3C53') {
			printf("%08x\n", dwKey);
			for (int i = 0; i < 0x20; i++) {
				printf("%02x ", dank.rgbKeyData[i]);
			}
			printf("\n");
			AES_decrypt(resourceData + 16, inputBuf + 16, &k);
			for (int i = 0; i < sizeof(inputBuf); i++) {
				printf("%02x ", inputBuf[i]);
			}
			printf("\n");
			printf("%s\n", inputBuf);
			break;
		}
		//CryptDestroyKey(hKey);
	} while (++dwKey < 0x10000);
	getchar();
    return 0;
}

