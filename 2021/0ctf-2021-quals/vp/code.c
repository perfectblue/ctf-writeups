#include <unistd.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/wait.h>

#define __int8  char
#define __int16 short
#define __int64 long long

unsigned char stru_204020[360] = {
    0x14,
    // Column down v
    0x00, 0x08, 0x02,
    0x00, 0x02, 0x03,
    0x00, 0x05, 0x04,
    0x00, 0x04, 0x02,
    0x00, 0x06, 0x01,

    // Column up ^
    0x01, 0x00, 0x02,
    0x01, 0x03, 0x02,
    0x01, 0x01, 0x04,
    0x01, 0x07, 0x03,
    0x01, 0x09, 0x02,

    // Row right >
    0x02, 0x03, 0x02,
    0x02, 0x04, 0x02,
    0x02, 0x09, 0x03,
    0x02, 0x07, 0x03,
    0x02, 0x02, 0x02,

    // Row left <
    0x03, 0x01, 0x02,
    0x03, 0x06, 0x03,
    0x03, 0x05, 0x02,
    0x03, 0x00, 0x02,
    0x03, 0x08, 0x01,

    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x93, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

typedef pid_t __pid_t;
typedef uint16_t _WORD;
typedef uint32_t _DWORD;

#define vfork() ({ctr++; 0; })
#define sys_fork vfork
#define waitpid(...)
#define getpid() ctr
#define _exit(a)

int foo()
{
  unsigned int ctr = 0;
  signed __int64 v0; // rax
  signed __int64 v1; // rax
  signed __int64 v2; // rax
  signed __int64 v3; // rax
  signed __int64 v4; // rax
  signed __int64 v5; // rax
  signed __int64 v6; // rax
  signed __int64 v7; // rax
  signed __int64 v8; // rax
  signed __int64 v9; // rax
  signed __int64 v10; // rax
  signed __int64 v11; // rax
  signed __int64 v12; // rax
  signed __int64 v13; // rax
  signed __int64 v14; // rax
  signed __int64 v15; // rax
  signed __int64 v16; // rax
  signed __int64 v17; // rax
  signed __int64 v18; // rax
  signed __int64 v19; // rax
  signed __int64 v20; // rax
  signed __int64 v21; // rax
  signed __int64 v22; // rax
  __pid_t pid; // [rsp+10h] [rbp-1E0h]
  __pid_t v25; // [rsp+18h] [rbp-1D8h]
  __pid_t v26; // [rsp+1Ch] [rbp-1D4h]
  __pid_t v27; // [rsp+24h] [rbp-1CCh]
  __pid_t v28; // [rsp+28h] [rbp-1C8h]
  __pid_t v29; // [rsp+2Ch] [rbp-1C4h]
  __pid_t v30; // [rsp+38h] [rbp-1B8h]
  __pid_t v31; // [rsp+40h] [rbp-1B0h]
  __pid_t v32; // [rsp+44h] [rbp-1ACh]
  int v33; // [rsp+4Ch] [rbp-1A4h]
  __pid_t v34; // [rsp+50h] [rbp-1A0h]
  __pid_t v35; // [rsp+5Ch] [rbp-194h]
  __pid_t v36; // [rsp+64h] [rbp-18Ch]
  __pid_t v37; // [rsp+6Ch] [rbp-184h]
  __pid_t v38; // [rsp+74h] [rbp-17Ch]
  int v39; // [rsp+78h] [rbp-178h]
  __pid_t v40; // [rsp+7Ch] [rbp-174h]
  int v41; // [rsp+84h] [rbp-16Ch]
  __pid_t v42; // [rsp+88h] [rbp-168h]
  __pid_t v43; // [rsp+8Ch] [rbp-164h]
  __pid_t v44; // [rsp+94h] [rbp-15Ch]
  __pid_t v45; // [rsp+98h] [rbp-158h]
  __pid_t v46; // [rsp+9Ch] [rbp-154h]
  __pid_t v47; // [rsp+A0h] [rbp-150h]
  __pid_t v48; // [rsp+A4h] [rbp-14Ch]
  __pid_t v49; // [rsp+A8h] [rbp-148h]
  __pid_t v50; // [rsp+ACh] [rbp-144h]
  __pid_t v51; // [rsp+B4h] [rbp-13Ch]
  __pid_t v52; // [rsp+B8h] [rbp-138h]
  __pid_t v53; // [rsp+BCh] [rbp-134h]
  __pid_t v54; // [rsp+C0h] [rbp-130h]
  __pid_t v55; // [rsp+C4h] [rbp-12Ch]
  __pid_t v56; // [rsp+C8h] [rbp-128h]
  __pid_t v57; // [rsp+CCh] [rbp-124h]
  __pid_t v58; // [rsp+D4h] [rbp-11Ch]
  int v59; // [rsp+DCh] [rbp-114h]
  __pid_t v60; // [rsp+E0h] [rbp-110h]
  __pid_t v61; // [rsp+E8h] [rbp-108h]
  __pid_t v62; // [rsp+ECh] [rbp-104h]
  __pid_t v63; // [rsp+F0h] [rbp-100h]
  __pid_t v64; // [rsp+F4h] [rbp-FCh]
  int v65; // [rsp+F8h] [rbp-F8h]
  __pid_t v66; // [rsp+FCh] [rbp-F4h]
  __pid_t v67; // [rsp+100h] [rbp-F0h]
  __pid_t v68; // [rsp+104h] [rbp-ECh]
  __pid_t v69; // [rsp+10Ch] [rbp-E4h]
  __pid_t v70; // [rsp+114h] [rbp-DCh]
  __pid_t v71; // [rsp+118h] [rbp-D8h]
  __pid_t v72; // [rsp+11Ch] [rbp-D4h]
  int v73; // [rsp+120h] [rbp-D0h]
  __pid_t v74; // [rsp+124h] [rbp-CCh]
  __pid_t v75; // [rsp+128h] [rbp-C8h]
  __pid_t v76; // [rsp+12Ch] [rbp-C4h]
  __pid_t v77; // [rsp+134h] [rbp-BCh]
  int v78; // [rsp+138h] [rbp-B8h]
  __pid_t v79; // [rsp+13Ch] [rbp-B4h]
  __pid_t v80; // [rsp+144h] [rbp-ACh]
  __pid_t v81; // [rsp+148h] [rbp-A8h]
  __pid_t v82; // [rsp+14Ch] [rbp-A4h]
  __pid_t v83; // [rsp+150h] [rbp-A0h]
  __pid_t v84; // [rsp+158h] [rbp-98h]
  __pid_t v85; // [rsp+15Ch] [rbp-94h]
  __pid_t v86; // [rsp+160h] [rbp-90h]
  __pid_t v87; // [rsp+164h] [rbp-8Ch]
  __pid_t v88; // [rsp+168h] [rbp-88h]
  __pid_t v89; // [rsp+170h] [rbp-80h]
  __pid_t v90; // [rsp+174h] [rbp-7Ch]
  __pid_t v91; // [rsp+178h] [rbp-78h]
  __pid_t v92; // [rsp+17Ch] [rbp-74h]
  int v93; // [rsp+180h] [rbp-70h]
  __pid_t v94; // [rsp+184h] [rbp-6Ch]
  __pid_t v95; // [rsp+18Ch] [rbp-64h]
  __pid_t v96; // [rsp+190h] [rbp-60h]
  __pid_t v97; // [rsp+194h] [rbp-5Ch]
  int v98; // [rsp+198h] [rbp-58h]
  __pid_t v99; // [rsp+19Ch] [rbp-54h]
  int v100; // [rsp+1A0h] [rbp-50h]
  __pid_t v101; // [rsp+1A4h] [rbp-4Ch]
  __pid_t v102; // [rsp+1A8h] [rbp-48h]
  __pid_t v103; // [rsp+1ACh] [rbp-44h]
  __pid_t v104; // [rsp+1B0h] [rbp-40h]
  __pid_t v105; // [rsp+1B4h] [rbp-3Ch]
  __pid_t v106; // [rsp+1B8h] [rbp-38h]
  int v107; // [rsp+1BCh] [rbp-34h]
  __pid_t v108; // [rsp+1C0h] [rbp-30h]
  __pid_t v109; // [rsp+1C4h] [rbp-2Ch]
  __pid_t v110; // [rsp+1CCh] [rbp-24h]
  __pid_t v111; // [rsp+1D4h] [rbp-1Ch]
  __pid_t v112; // [rsp+1D8h] [rbp-18h]
  int v113; // [rsp+1DCh] [rbp-14h]
  __pid_t v114; // [rsp+1E0h] [rbp-10h]
  int v115; // [rsp+1E4h] [rbp-Ch]
  __pid_t v116; // [rsp+1E8h] [rbp-8h]
  __pid_t v117; // [rsp+1ECh] [rbp-4h]

  uint32_t values[32];

  pid = vfork();
  if ( !pid )
  {
    values[0] = 1;
    _exit(2);
  }
  waitpid(pid, 0LL, 0);
  v0 = sys_fork();
  if ( (int)v0 < 0 )
    _exit(2);
  if ( (_DWORD)v0 )
  {
    waitpid(v0, 0LL, 0);
    _exit(2);
  }
  v25 = vfork();
  if ( !v25 )
  {
    values[29] = 0;
    _exit(2);
  }
  waitpid(v25, 0LL, 0);
  v26 = vfork();
  if ( !v26 )
  {
    values[30] = 256;
    _exit(2);
  }
  waitpid(v26, 0LL, 0);
  v1 = sys_fork();
  if ( (int)v1 < 0 )
    _exit(2);
  if ( (_DWORD)v1 )
  {
    waitpid(v1, 0LL, 0);
    _exit(2);
  }
  v27 = vfork();
  if ( !v27 )
  {
    values[28] = (unsigned __int8)stru_204020[values[29]];
    _exit(2);
  }
  waitpid(v27, 0LL, 0);
  v28 = vfork();
  if ( !v28 )
  {
    values[29] += values[0];
    _exit(2);
  }
  waitpid(v28, 0LL, 0);
  v29 = vfork();
  if ( !v29 )
  {
    values[5] = getpid();
    _exit(2);
  }
  waitpid(v29, 0LL, 0);
  v2 = sys_fork();
  if ( (int)v2 < 0 )
    _exit(2);
  if ( (_DWORD)v2 )
  {
    waitpid(v2, 0LL, 0);
    _exit(2);
  }
  v30 = vfork();
  if ( !v30 )
  {
    values[27] = 0;
    _exit(2);
  }
  waitpid(v30, 0LL, 0);
  v3 = sys_fork();
  if ( (int)v3 < 0 )
    _exit(2);
  if ( (_DWORD)v3 )
  {
    waitpid(v3, 0LL, 0);
    _exit(2);
  }
  v31 = vfork();
  if ( !v31 )
  {
    values[10] = 0;
    _exit(2);
  }
  waitpid(v31, 0LL, 0);
  while ( 1 )
  {
    v32 = vfork();
    if ( !v32 )
    {
      v33 = values[27] - values[28];
      values[31] = 0;
      if ( v33 )
      {
        if ( v33 < 0 )
          values[31] |= 2u;
      }
      else
      {
        values[31] |= 1u;
      }
      _exit(2);
    }
    waitpid(v32, 0LL, 0);
    if ( values[31] & 1 )
      break;
    v4 = sys_fork();
    if ( (int)v4 < 0 )
      _exit(2);
    if ( (_DWORD)v4 )
    {
      waitpid(v4, 0LL, 0);
      _exit(2);
    }
    v51 = vfork();
    if ( !v51 )
    {
      values[26] = (unsigned __int8)stru_204020[values[29]];
      _exit(2);
    }
    waitpid(v51, 0LL, 0);
    v52 = vfork();
    if ( !v52 )
    {
      values[29] += values[0];
      _exit(2);
    }
    waitpid(v52, 0LL, 0);
    v53 = vfork();
    if ( !v53 )
    {
      values[25] = (unsigned __int8)stru_204020[values[29]];
      _exit(2);
    }
    waitpid(v53, 0LL, 0);
    v54 = vfork();
    if ( !v54 )
    {
      values[29] += values[0];
      _exit(2);
    }
    waitpid(v54, 0LL, 0);
    v55 = vfork();
    if ( !v55 )
    {
      values[24] = (unsigned __int8)stru_204020[values[29]];
      _exit(2);
    }
    waitpid(v55, 0LL, 0);
    v56 = vfork();
    if ( !v56 )
    {
      values[29] += values[0];
      _exit(2);
    }
    waitpid(v56, 0LL, 0);
    v57 = vfork();
    if ( !v57 )
    {
      values[23] = 2;
      _exit(2);
    }
    waitpid(v57, 0LL, 0);
    v5 = sys_fork();
    if ( (int)v5 < 0 )
      _exit(2);
    if ( (_DWORD)v5 )
    {
      waitpid(v5, 0LL, 0);
      _exit(2);
    }
    v58 = vfork();
    if ( !v58 )
    {
      v59 = values[26] - values[23];
      values[31] = 0;
      if ( v59 )
      {
        if ( v59 < 0 )
          values[31] |= 2u;
      }
      else
      {
        values[31] |= 1u;
      }
      _exit(2);
    }
    waitpid(v58, 0LL, 0);
    if ( values[31] & 1 )
    {
      v6 = sys_fork();
      if ( (int)v6 < 0 )
        _exit(2);
      if ( (_DWORD)v6 )
      {
        waitpid(v6, 0LL, 0);
        _exit(2);
      }
      v60 = vfork();
      if ( !v60 )
      {
        values[22] = 1;
        _exit(2);
      }
      waitpid(v60, 0LL, 0);
      v7 = sys_fork();
      if ( (int)v7 < 0 )
        _exit(2);
      if ( (_DWORD)v7 )
      {
        waitpid(v7, 0LL, 0);
        _exit(2);
      }
      v61 = vfork();
      if ( !v61 )
      {
        values[21] = 10;
        _exit(2);
      }
      waitpid(v61, 0LL, 0);
      v62 = vfork();
      if ( !v62 )
      {
        values[21] *= values[25];
        _exit(2);
      }
      waitpid(v62, 0LL, 0);
    }
    else
    {
      v63 = vfork();
      if ( !v63 )
      {
        values[23] = 3;
        _exit(2);
      }
      waitpid(v63, 0LL, 0);
      v64 = vfork();
      if ( !v64 )
      {
        v65 = values[26] - values[23];
        values[31] = 0;
        if ( v65 )
        {
          if ( v65 < 0 )
            values[31] |= 2u;
        }
        else
        {
          values[31] |= 1u;
        }
        _exit(2);
      }
      waitpid(v64, 0LL, 0);
      if ( values[31] & 1 )
      {
        v66 = vfork();
        if ( !v66 )
        {
          values[22] = -1;
          _exit(2);
        }
        waitpid(v66, 0LL, 0);
        v67 = vfork();
        if ( !v67 )
        {
          values[21] = 10;
          _exit(2);
        }
        waitpid(v67, 0LL, 0);
        v68 = vfork();
        if ( !v68 )
        {
          values[25] += values[0];
          _exit(2);
        }
        waitpid(v68, 0LL, 0);
        v8 = sys_fork();
        if ( (int)v8 < 0 )
          _exit(2);
        if ( (_DWORD)v8 )
        {
          waitpid(v8, 0LL, 0);
          _exit(2);
        }
        v69 = vfork();
        if ( !v69 )
        {
          values[21] *= values[25];
          _exit(2);
        }
        waitpid(v69, 0LL, 0);
        v9 = sys_fork();
        if ( (int)v9 < 0 )
          _exit(2);
        if ( (_DWORD)v9 )
        {
          waitpid(v9, 0LL, 0);
          _exit(2);
        }
        v70 = vfork();
        if ( !v70 )
        {
          values[21] -= values[0];
          _exit(2);
        }
        waitpid(v70, 0LL, 0);
      }
      else
      {
        v71 = vfork();
        if ( !v71 )
        {
          values[23] = 0;
          _exit(2);
        }
        waitpid(v71, 0LL, 0);
        v72 = vfork();
        if ( !v72 )
        {
          v73 = values[26] - values[23];
          values[31] = 0;
          if ( v73 )
          {
            if ( v73 < 0 )
              values[31] |= 2u;
          }
          else
          {
            values[31] |= 1u;
          }
          _exit(2);
        }
        waitpid(v72, 0LL, 0);
        if ( values[31] & 1 )
        {
          v74 = vfork();
          if ( !v74 )
          {
            values[22] = 10;
            _exit(2);
          }
          waitpid(v74, 0LL, 0);
          v75 = vfork();
          if ( !v75 )
          {
            values[21] = values[25];
            _exit(2);
          }
          waitpid(v75, 0LL, 0);
        }
        else
        {
          v76 = vfork();
          if ( !v76 )
          {
            values[23] = 1;
            _exit(2);
          }
          waitpid(v76, 0LL, 0);
          v10 = sys_fork();
          if ( (int)v10 < 0 )
            _exit(2);
          if ( (_DWORD)v10 )
          {
            waitpid(v10, 0LL, 0);
            _exit(2);
          }
          v77 = vfork();
          if ( !v77 )
          {
            v78 = values[26] - values[23];
            values[31] = 0;
            if ( v78 )
            {
              if ( v78 < 0 )
                values[31] |= 2u;
            }
            else
            {
              values[31] |= 1u;
            }
            _exit(2);
          }
          waitpid(v77, 0LL, 0);
          if ( !(values[31] & 1) )
            goto LABEL_331;
          v79 = vfork();
          if ( !v79 )
          {
            values[21] = 10;
            _exit(2);
          }
          waitpid(v79, 0LL, 0);
          v11 = sys_fork();
          if ( (int)v11 < 0 )
            _exit(2);
          if ( (_DWORD)v11 )
          {
            waitpid(v11, 0LL, 0);
            _exit(2);
          }
          v80 = vfork();
          if ( !v80 )
          {
            values[22] = 0;
            _exit(2);
          }
          waitpid(v80, 0LL, 0);
          v81 = vfork();
          if ( !v81 )
          {
            values[22] -= values[21];
            _exit(2);
          }
          waitpid(v81, 0LL, 0);
          v82 = vfork();
          if ( !v82 )
          {
            values[20] = values[21];
            _exit(2);
          }
          waitpid(v82, 0LL, 0);
          v83 = vfork();
          if ( !v83 )
          {
            values[20] -= values[0];
            _exit(2);
          }
          waitpid(v83, 0LL, 0);
          v12 = sys_fork();
          if ( (int)v12 < 0 )
            _exit(2);
          if ( (_DWORD)v12 )
          {
            waitpid(v12, 0LL, 0);
            _exit(2);
          }
          v84 = vfork();
          if ( !v84 )
          {
            values[21] *= values[20];
            _exit(2);
          }
          waitpid(v84, 0LL, 0);
          v85 = vfork();
          if ( !v85 )
          {
            values[21] += values[25];
            _exit(2);
          }
          waitpid(v85, 0LL, 0);
        }
      }
    }
    v86 = vfork();
    if ( !v86 )
    {
      values[20] = 0;
      _exit(2);
    }
    waitpid(v86, 0LL, 0);
    v87 = vfork();
    if ( !v87 )
    {
      values[19] = 10;
      _exit(2);
    }
    waitpid(v87, 0LL, 0);
    v88 = vfork();
    if ( !v88 )
    {
      values[18] = 0;
      _exit(2);
    }
    waitpid(v88, 0LL, 0);
    v13 = sys_fork();
    if ( (int)v13 < 0 )
      _exit(2);
    if ( (_DWORD)v13 )
    {
      waitpid(v13, 0LL, 0);
      _exit(2);
    }
    v89 = vfork();
    if ( !v89 )
    {
      values[17] = -1;
      _exit(2);
    }
    waitpid(v89, 0LL, 0);
    v90 = vfork();
    if ( !v90 )
    {
      values[3] = 0;
      _exit(2);
    }
    waitpid(v90, 0LL, 0);
    v91 = vfork();
    if ( !v91 )
    {
      values[12] = 1023;
      _exit(2);
    }
    waitpid(v91, 0LL, 0);
    while ( 1 )
    {
      v92 = vfork();
      if ( !v92 )
      {
        v93 = values[20] - values[19];
        values[31] = 0;
        if ( v93 )
        {
          if ( v93 < 0 )
            values[31] |= 2u;
        }
        else
        {
          values[31] |= 1u;
        }
        _exit(2);
      }
      waitpid(v92, 0LL, 0);
      if ( values[31] & 1 )
        break;
      v94 = vfork();
      if ( !v94 )
      {
        values[16] = 256;
        _exit(2);
      }
      waitpid(v94, 0LL, 0);
      v14 = sys_fork();
      if ( (int)v14 < 0 )
        _exit(2);
      if ( (_DWORD)v14 )
      {
        waitpid(v14, 0LL, 0);
        _exit(2);
      }
      v95 = vfork();
      if ( !v95 )
      {
        values[16] += values[21];
        _exit(2);
      }
      waitpid(v95, 0LL, 0);
      v96 = vfork();
      if ( !v96 )
      {
        values[15] = (unsigned __int8)stru_204020[values[16]];
        _exit(2);
      }
      waitpid(v96, 0LL, 0);
      v97 = vfork();
      if ( !v97 )
      {
        v98 = values[15] - values[0];
        values[31] = 0;
        if ( v98 )
        {
          if ( v98 < 0 )
            values[31] |= 2u;
        }
        else
        {
          values[31] |= 1u;
        }
        _exit(2);
      }
      waitpid(v97, 0LL, 0);
      if ( (values[31] >> 1) & 1 )
        goto LABEL_331;
      v99 = vfork();
      if ( !v99 )
      {
        v100 = values[15] - values[19];
        values[31] = 0;
        if ( v100 )
        {
          if ( v100 < 0 )
            values[31] |= 2u;
        }
        else
        {
          values[31] |= 1u;
        }
        _exit(2);
      }
      waitpid(v99, 0LL, 0);
      if ( !((values[31] >> 1) & 1) && !(values[31] & 1) )
        goto LABEL_331;
      v101 = vfork();
      if ( !v101 )
      {
        values[14] = values[15];
        _exit(2);
      }
      waitpid(v101, 0LL, 0);
      v102 = vfork();
      if ( !v102 )
      {
        values[14] -= values[0];
        _exit(2);
      }
      waitpid(v102, 0LL, 0);
      v103 = vfork();
      if ( !v103 )
      {
        values[13] = values[0];
        _exit(2);
      }
      waitpid(v103, 0LL, 0);
      v104 = vfork();
      if ( !v104 )
      {
        values[13] <<= values[14];
        _exit(2);
      }
      waitpid(v104, 0LL, 0);
      v105 = vfork();
      if ( !v105 )
      {
        values[3] |= values[13];
        _exit(2);
      }
      waitpid(v105, 0LL, 0);
      v106 = vfork();
      if ( !v106 )
      {
        v107 = values[17] - values[15];
        values[31] = 0;
        if ( v107 )
        {
          if ( v107 < 0 )
            values[31] |= 2u;
        }
        else
        {
          values[31] |= 1u;
        }
        _exit(2);
      }
      waitpid(v106, 0LL, 0);
      if ( (values[31] >> 1) & 1 )
      {
        v108 = vfork();
        if ( !v108 )
        {
          values[17] = values[15];
          _exit(2);
        }
        waitpid(v108, 0LL, 0);
        v109 = vfork();
        if ( !v109 )
        {
          values[18] += values[0];
          _exit(2);
        }
        waitpid(v109, 0LL, 0);
        v15 = sys_fork();
        if ( (int)v15 < 0 )
          _exit(2);
        if ( (_DWORD)v15 )
        {
          waitpid(v15, 0LL, 0);
          _exit(2);
        }
      }
      v110 = vfork();
      if ( !v110 )
      {
        values[21] += values[22];
        _exit(2);
      }
      waitpid(v110, 0LL, 0);
      v16 = sys_fork();
      if ( (int)v16 < 0 )
        _exit(2);
      if ( (_DWORD)v16 )
      {
        waitpid(v16, 0LL, 0);
        _exit(2);
      }
      v111 = vfork();
      if ( !v111 )
      {
        values[20] += values[0];
        _exit(2);
      }
      waitpid(v111, 0LL, 0);
    }
    v112 = vfork();
    if ( !v112 )
    {
      v113 = values[12] - values[3];
      values[31] = 0;
      if ( v113 )
      {
        if ( v113 < 0 )
          values[31] |= 2u;
      }
      else
      {
        values[31] |= 1u;
      }
      _exit(2);
    }
    waitpid(v112, 0LL, 0);
    if ( values[31] & 1 )
    {
      v114 = vfork();
      if ( !v114 )
      {
        v115 = values[18] - values[24];
        values[31] = 0;
        if ( v115 )
        {
          if ( v115 < 0 )
            values[31] |= 2u;
        }
        else
        {
          values[31] |= 1u;
        }
        _exit(2);
      }
      waitpid(v114, 0LL, 0);
      if ( values[31] & 1 )
      {
        v116 = vfork();
        if ( !v116 )
        {
          values[10] += values[0];
          _exit(2);
        }
        waitpid(v116, 0LL, 0);
      }
    }
    v117 = vfork();
    if ( !v117 )
    {
      values[27] += values[0];
      _exit(2);
    }
    waitpid(v117, 0LL, 0);
  }
  v34 = vfork();
  if ( !v34 )
  {
    values[4] = getpid();
    _exit(2);
  }
  waitpid(v34, 0LL, 0);
  v17 = sys_fork();
  if ( (int)v17 < 0 )
    _exit(2);
  if ( (_DWORD)v17 )
  {
    waitpid(v17, 0LL, 0);
    _exit(2);
  }
  v35 = vfork();
  if ( !v35 )
  {
    values[4] -= values[5];
    _exit(2);
  }
  waitpid(v35, 0LL, 0);
  v18 = sys_fork();
  if ( (int)v18 < 0 )
    _exit(2);
  if ( (_DWORD)v18 )
  {
    waitpid(v18, 0LL, 0);
    _exit(2);
  }
  v36 = vfork();
  if ( !v36 )
  {
    values[7] = 192;
    _exit(2);
  }
  waitpid(v36, 0LL, 0);
  v19 = sys_fork();
  if ( (int)v19 < 0 )
    _exit(2);
  if ( (_DWORD)v19 )
  {
    waitpid(v19, 0LL, 0);
    _exit(2);
  }
  v37 = vfork();
  if ( !v37 )
  {
    values[6] = *(_DWORD *)&stru_204020[values[7]];
    _exit(2);
  }
  waitpid(v37, 0LL, 0);
  v38 = vfork();
  if ( !v38 )
  {
    v39 = values[4] - values[6];
    values[31] = 0;
    if ( v39 )
    {
      if ( v39 < 0 )
        values[31] |= 2u;
    }
    else
    {
      values[31] |= 1u;
    }
    _exit(2);
  }
  waitpid(v38, 0LL, 0);
  if ( !(values[31] & 1) )
    goto LABEL_331;
  v40 = vfork();
  if ( !v40 )
  {
    v41 = values[28] - values[10];
    values[31] = 0;
    if ( v41 )
    {
      if ( v41 < 0 )
        values[31] |= 2u;
    }
    else
    {
      values[31] |= 1u;
    }
    _exit(2);
  }
  waitpid(v40, 0LL, 0);
  if ( !(values[31] & 1) )
  {
LABEL_331:
    puts("Error :(");
    fflush(stdout);
    return 0;
  }
  puts("Correct");
  fflush(stdout);
  v20 = sys_fork();
  if ( (int)v20 < 0 )
    _exit(2);
  if ( (_DWORD)v20 )
  {
    waitpid(v20, 0LL, 0);
    _exit(2);
  }
  v42 = vfork();
  if ( !v42 )
  {
    values[9] = 256;
    _exit(2);
  }
  waitpid(v42, 0LL, 0);
  v43 = vfork();
  if ( !v43 )
  {
    values[8] = 10;
    _exit(2);
  }
  waitpid(v43, 0LL, 0);
  v21 = sys_fork();
  if ( (int)v21 < 0 )
    _exit(2);
  if ( (_DWORD)v21 )
  {
    waitpid(v21, 0LL, 0);
    _exit(2);
  }
  v44 = vfork();
  if ( !v44 )
  {
    values[8] *= values[8];
    _exit(2);
  }
  waitpid(v44, 0LL, 0);
  v45 = vfork();
  if ( !v45 )
  {
    values[9] += values[8];
    _exit(2);
  }
  waitpid(v45, 0LL, 0);
  v46 = vfork();
  if ( !v46 )
  {
    values[8] = *(unsigned __int16 *)&stru_204020[values[9]];
    _exit(2);
  }
  waitpid(v46, 0LL, 0);
  v47 = vfork();
  if ( !v47 )
  {
    values[9] += values[0];
    _exit(2);
  }
  waitpid(v47, 0LL, 0);
  v48 = vfork();
  if ( !v48 )
  {
    values[9] += values[0];
    _exit(2);
  }
  waitpid(v48, 0LL, 0);
  v49 = vfork();
  if ( !v49 )
  {
    values[7] = *(unsigned __int16 *)&stru_204020[values[9]];
    _exit(2);
  }
  waitpid(v49, 0LL, 0);
  v50 = vfork();
  if ( !v50 )
  {
    *(_WORD *)&stru_204020[values[7]] = values[8];
    _exit(2);
  }
  waitpid(v50, 0LL, 0);
  v22 = sys_fork();
  if ( (int)v22 < 0 )
    _exit(2);
  if ( (_DWORD)v22 )
  {
    waitpid(v22, 0LL, 0);
    _exit(2);
  }
  return v22;
}

int main() {
  fread(stru_204020 + 0x100, 0x104, 1, stdin);
  foo();
}
