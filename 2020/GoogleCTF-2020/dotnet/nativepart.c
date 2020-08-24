
void __cdecl FYRKANTIGImpl(basic_string *input)
{
  char func[40]; // [esp+8h] [ebp-50h]
  char encrypted_str[24]; // [esp+30h] [ebp-28h]
  int v3; // [esp+54h] [ebp-4h]

  std_basicstring_ctor_ptr(encrypted_str, (int)xor_key);
  v3 = 0;
  do_xor(input, encrypted_str);
  do_shuffle(input);
  std_function::ctor(func, (int)&process_input_callback);// copy constructor
                                                // lambda prototype void(*)(basic_string*)
                                                // big_chungus_processing_callback
  LOBYTE(v3) = 1;
  std_function::call(func, (int)input);
  LOBYTE(v3) = 0;
  std::function::dtor(func);
  v3 = -1;
  std::string::dtor();
}

char __cdecl decode_flagchar(char a1)
{
  char result; // al

  if ( (unsigned __int8)(a1 - '0') <= 9u )
    return a1 - 0x30;
  if ( (unsigned __int8)(a1 - 'A') <= 0x19u )
    return a1 - 0x37;
  if ( (unsigned __int8)(a1 - 'a') <= 0x19u )
    return a1 - 0x3D;
  if ( a1 == '{' )
    return 62;
  result = -1;
  if ( a1 == '}' )
    result = 63;
  return result;
}

void __cdecl do_shuffle(void *input)
{
  void *v1; // eax
  int *randomItLast; // esi
  int *randomItFirst; // eax
  char v4[4]; // [esp+4h] [ebp-10h]
  char v5[4]; // [esp+8h] [ebp-Ch]
  char otherIter[7]; // [esp+Ch] [ebp-8h]
  char random_func; // [esp+13h] [ebp-1h]

  j_srand(572);                                 // srand
  if ( (unsigned int)std_basicstring_size(input) >= 2 )
  {
    random_func = 0;                            // templatized inlined, random_shuffle_lambda
    v1 = (void *)std_basicstring_end(input, v5);
    randomItLast = (int *)std_basicstring_itr_minus(v1, otherIter, 2);
    randomItFirst = (int *)std_basicstring_begin(input, v4);

    std_random_shuffle(*randomItFirst, *randomItLast, (int)&random_func);// shuffle!!
  }
}

unsigned int __stdcall random_shuffle_lambda(unsigned int a1)
{
  return j_rand() % a1;
}


// basically swap some shit
void __cdecl big_chungus_processing_callback(basic_string *a1)
{
  int i; // esi
  int v2; // eax
  int v3; // [esp-4h] [ebp-Ch]

  for ( i = 0; i < std_basicstring_size(a1) - 1; i += 3 )
  {
    if ( i != 28 && i != 27 )
    {
      v3 = std_basicstring_at(a1, i + 1);
      v2 = std_basicstring_at(a1, i);
      std::swap(v2, v3);
    }
  }
}

unsigned int __cdecl do_xor(void *a1, void *a2)
{
  unsigned int v2; // esi
  unsigned int result; // eax
  _BYTE *v4; // edi
  unsigned int v5; // eax
  _BYTE *v6; // eax

  v2 = 0;
  result = std_basicstring_size(a1);
  if ( result )
  {
    do
    {
      v4 = (_BYTE *)std_basicstring_at(a1, v2);
      v5 = std_basicstring_size(a2);
      v6 = (_BYTE *)std_basicstring_at2(a2, v2++ % v5);
      *v4 ^= *v6;
      result = std_basicstring_size(a1);
    }
    while ( v2 < result );
  }
  return result;
}


unsigned int __cdecl NativeGRUNDTAL_NORRVIKEN(basic_string *a1)
{
  unsigned int v1; // esi
  unsigned int len; // eax
  char *v3; // eax
  char v4; // bl
  char *v5; // eax

  v1 = 0;
  len = std_basicstring_size(a1);
  if ( len )
  {
    do
    {
      v3 = (char *)std_basicstring_at(a1, v1);
      v4 = decode_flagchar(*v3);
      v5 = (char *)std_basicstring_at(a1, v1++);
      *v5 = v4;
      len = std_basicstring_size(a1);
    }
    while ( v1 < len );
  }
  return len;
}


bool GODDAG()
{
  return j_IsDebuggerPresent() || byte_4D8AB0;
}
