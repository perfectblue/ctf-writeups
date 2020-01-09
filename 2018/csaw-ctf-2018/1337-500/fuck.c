#define __int8 char
#define __int32 int
#define __int64 long int
#define _DWORD unsigned int
#define bool  int
#define _WORD  int
#define __int16 short
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
int     sub_5115C4(unsigned __int8 *a1, unsigned __int8 *a2, unsigned int a3)
{
  unsigned int v3; // esi
  unsigned __int8 *v4; // ecx
  int v5; // edi
  bool i; // cf
  int v7; // eax
  int v8; // edi
  int v9; // edx
  int v10; // ebx
  int v11; // ecx
  unsigned int v12; // eax
  unsigned int v13; // edi
  unsigned int v14; // ebx
  unsigned int v15; // edx
  unsigned int v16; // eax
  unsigned int v17; // edi
  unsigned int v18; // ebx
  unsigned int v19; // edx
  unsigned int v20; // ecx
  unsigned int v21; // edi
  unsigned int v22; // edx
  unsigned int v23; // eax
  unsigned int v24; // ebx
  unsigned int v25; // eax
  unsigned int v26; // edi
  unsigned int v27; // ebx
  unsigned int v28; // edx
  unsigned int v29; // ecx
  unsigned int v30; // edi
  unsigned int v31; // edx
  unsigned int v32; // eax
  unsigned int v33; // ebx
  unsigned int v34; // eax
  unsigned int v35; // edi
  unsigned int v36; // ebx
  unsigned int v37; // edx
  unsigned int v38; // eax
  unsigned int v39; // edi
  unsigned int v40; // ebx
  unsigned int v41; // edx
  int v42; // ecx
  int v43; // edi
  unsigned int v44; // eax
  unsigned int v45; // edx
  unsigned int v46; // esi
  unsigned int v47; // ebx
  unsigned int v48; // edi
  unsigned int v49; // eax
  unsigned int v50; // edx
  unsigned int v51; // esi
  unsigned int v52; // ebx
  unsigned int v53; // edi
  unsigned int v54; // ecx
  unsigned int v55; // eax
  unsigned int v56; // esi
  unsigned int v57; // edx
  unsigned int v58; // edi
  unsigned int v59; // ebx
  unsigned int v60; // eax
  unsigned int v61; // edx
  unsigned int v62; // esi
  unsigned int v63; // ebx
  unsigned int v64; // edi
  unsigned int v65; // eax
  unsigned int v66; // edx
  unsigned int v67; // esi
  unsigned int v68; // ebx
  unsigned int v69; // edi
  unsigned int v70; // eax
  unsigned int v71; // edx
  unsigned int v72; // esi
  unsigned int v73; // ebx
  unsigned int v74; // edi
  unsigned int v75; // eax
  unsigned int v76; // edx
  unsigned int v77; // esi
  unsigned int v78; // edi
  unsigned int v80; // ecx
  unsigned int v81; // eax
  unsigned int v82; // esi
  unsigned int v83; // edx
  unsigned int v84; // edi
  unsigned int v85; // ebx
  unsigned int v86; // eax
  unsigned int v87; // edx
  unsigned int v88; // esi
  unsigned int v89; // ebx
  unsigned int v90; // edi
  unsigned int v91; // ecx
  unsigned int v92; // eax
  unsigned int v93; // esi
  unsigned int v94; // edx
  unsigned int v95; // edi
  unsigned int v96; // ebx
  unsigned int v97; // eax
  unsigned int v98; // edx
  unsigned int v99; // esi
  unsigned int v100; // ebx
  unsigned int v101; // edi
  unsigned int v102; // ecx
  unsigned int v103; // eax
  unsigned int v104; // esi
  unsigned int v105; // edx
  unsigned int v106; // edi
  unsigned int v107; // ebx
  unsigned int v108; // eax
  unsigned int v109; // edx
  unsigned int v110; // esi
  unsigned int v111; // ebx
  unsigned int v112; // edi
  unsigned int v113; // ecx
  unsigned int v114; // eax
  unsigned int v115; // esi
  unsigned int v116; // edx
  unsigned int v117; // edi
  unsigned int v118; // ebx
  int v119; // ecx
  int v120; // eax
  unsigned int v121; // eax
  unsigned int v122; // edx
  unsigned int v123; // esi
  unsigned int v124; // ebx
  unsigned int v125; // edi
  unsigned int v126; // ecx
  unsigned int v127; // eax
  unsigned int v128; // esi
  unsigned int v129; // edx
  unsigned int v130; // edi
  unsigned int v131; // ebx
  unsigned int v132; // eax
  unsigned int v133; // edx
  unsigned int v134; // esi
  unsigned int v135; // ebx
  unsigned int v136; // edi
  unsigned int v137; // ecx
  unsigned int v138; // eax
  unsigned int v139; // esi
  unsigned int v140; // edx
  unsigned int v141; // edi
  unsigned int v142; // ebx
  unsigned int v143; // eax
  unsigned int v144; // edx
  unsigned int v145; // esi
  unsigned int v146; // ebx
  unsigned int v147; // edi
  unsigned int v148; // ecx
  unsigned int v149; // eax
  unsigned int v150; // esi
  unsigned int v151; // edx
  unsigned int v152; // edi
  unsigned int v153; // ebx
  unsigned int v154; // eax
  unsigned int v155; // edx
  unsigned int v156; // esi
  unsigned int v157; // ebx
  unsigned int v158; // edi
  unsigned __int16 v159; // cx
  __int16 v160; // dx
  int v161; // edi
  int v162; // edx
  unsigned int v163; // eax
  unsigned int v164; // edx
  unsigned int v165; // esi
  unsigned int v166; // ebx
  unsigned int v167; // edi
  unsigned int v168; // eax
  unsigned int v169; // edx
  unsigned int v170; // esi
  unsigned int v171; // ebx
  unsigned int v172; // edi
  unsigned int v173; // ecx
  unsigned int v174; // eax
  unsigned int v175; // esi
  unsigned int v176; // edx
  unsigned int v177; // edi
  unsigned int v178; // ebx
  unsigned int v179; // ecx
  unsigned int v180; // eax
  unsigned int v181; // esi
  unsigned int v182; // edx
  unsigned int v183; // edi
  unsigned int v184; // ebx
  unsigned int v185; // ecx
  unsigned int v186; // eax
  unsigned int v187; // esi
  unsigned int v188; // edx
  unsigned int v189; // edi
  unsigned int v190; // ebx
  unsigned int v191; // ecx
  unsigned int v192; // eax
  unsigned int v193; // esi
  unsigned int v194; // edx
  unsigned int v195; // edi
  unsigned int v196; // ebx
  unsigned int v197; // eax
  unsigned int v198; // edx
  unsigned int v199; // esi
  unsigned int v200; // ebx
  unsigned int v201; // edi
  int v202; // esi
  int v203; // ecx
  bool v204; // zf
  bool v205; // sf
  int v206; // ecx
  int v207; // ecx
  int v208; // eax
  int v209; // edx
  unsigned int v210; // [esp+4h] [ebp-18h]
  unsigned int v211; // [esp+4h] [ebp-18h]
  unsigned int v212; // [esp+4h] [ebp-18h]
  unsigned int v213; // [esp+4h] [ebp-18h]
  unsigned int v214; // [esp+4h] [ebp-18h]
  unsigned int v215; // [esp+4h] [ebp-18h]
  unsigned int v216; // [esp+4h] [ebp-18h]
  unsigned int v217; // [esp+4h] [ebp-18h]
  unsigned int v218; // [esp+4h] [ebp-18h]
  unsigned int v219; // [esp+4h] [ebp-18h]
  unsigned int v220; // [esp+4h] [ebp-18h]
  unsigned int v221; // [esp+4h] [ebp-18h]
  unsigned int v222; // [esp+4h] [ebp-18h]
  unsigned int v223; // [esp+4h] [ebp-18h]
  unsigned int v224; // [esp+4h] [ebp-18h]
  unsigned int v225; // [esp+4h] [ebp-18h]
  unsigned int v226; // [esp+4h] [ebp-18h]
  unsigned int v227; // [esp+4h] [ebp-18h]
  unsigned int v228; // [esp+4h] [ebp-18h]
  unsigned int v229; // [esp+4h] [ebp-18h]
  unsigned int v230; // [esp+4h] [ebp-18h]
  unsigned int v231; // [esp+4h] [ebp-18h]
  unsigned int v232; // [esp+4h] [ebp-18h]
  unsigned int v233; // [esp+4h] [ebp-18h]
  unsigned int v234; // [esp+4h] [ebp-18h]
  unsigned int v235; // [esp+4h] [ebp-18h]
  unsigned int v236; // [esp+4h] [ebp-18h]
  unsigned int v237; // [esp+4h] [ebp-18h]
  unsigned int v238; // [esp+4h] [ebp-18h]
  unsigned int v239; // [esp+4h] [ebp-18h]
  unsigned int v240; // [esp+4h] [ebp-18h]
  unsigned int v241; // [esp+4h] [ebp-18h]
  unsigned int v242; // [esp+4h] [ebp-18h]
  unsigned int v243; // [esp+4h] [ebp-18h]
  unsigned int v244; // [esp+4h] [ebp-18h]
  int v245; // [esp+8h] [ebp-14h]
  unsigned int v246; // [esp+8h] [ebp-14h]
  unsigned int v247; // [esp+8h] [ebp-14h]
  int v248; // [esp+8h] [ebp-14h]
  unsigned int v249; // [esp+8h] [ebp-14h]
  int v250; // [esp+8h] [ebp-14h]
  int v251; // [esp+8h] [ebp-14h]
  unsigned int v252; // [esp+8h] [ebp-14h]
  unsigned int v253; // [esp+8h] [ebp-14h]
  unsigned int v254; // [esp+8h] [ebp-14h]
  unsigned int v255; // [esp+8h] [ebp-14h]
  unsigned int v256; // [esp+8h] [ebp-14h]
  unsigned int v257; // [esp+8h] [ebp-14h]
  unsigned int v258; // [esp+8h] [ebp-14h]
  unsigned int v259; // [esp+8h] [ebp-14h]
  unsigned int v260; // [esp+8h] [ebp-14h]
  unsigned int v261; // [esp+8h] [ebp-14h]
  unsigned int v262; // [esp+8h] [ebp-14h]
  unsigned int v263; // [esp+8h] [ebp-14h]
  unsigned int v264; // [esp+8h] [ebp-14h]
  unsigned int v265; // [esp+8h] [ebp-14h]
  unsigned int v266; // [esp+8h] [ebp-14h]
  unsigned int v267; // [esp+8h] [ebp-14h]
  unsigned int v268; // [esp+8h] [ebp-14h]
  unsigned int v269; // [esp+8h] [ebp-14h]
  unsigned int v270; // [esp+8h] [ebp-14h]
  unsigned int v271; // [esp+8h] [ebp-14h]
  unsigned int v272; // [esp+8h] [ebp-14h]
  unsigned int v273; // [esp+8h] [ebp-14h]
  unsigned int v274; // [esp+8h] [ebp-14h]
  unsigned int v275; // [esp+8h] [ebp-14h]
  unsigned int v276; // [esp+8h] [ebp-14h]
  unsigned int v277; // [esp+8h] [ebp-14h]
  unsigned int v278; // [esp+8h] [ebp-14h]
  unsigned int v279; // [esp+8h] [ebp-14h]
  unsigned int v280; // [esp+Ch] [ebp-10h]
  int v281; // [esp+Ch] [ebp-10h]
  int v282; // [esp+Ch] [ebp-10h]
  unsigned int v283; // [esp+Ch] [ebp-10h]
  int v284; // [esp+Ch] [ebp-10h]
  unsigned int v285; // [esp+Ch] [ebp-10h]
  unsigned int v286; // [esp+Ch] [ebp-10h]
  int v287; // [esp+Ch] [ebp-10h]
  int v288; // [esp+Ch] [ebp-10h]
  int v289; // [esp+Ch] [ebp-10h]
  int v290; // [esp+Ch] [ebp-10h]
  int v291; // [esp+Ch] [ebp-10h]
  int v292; // [esp+Ch] [ebp-10h]
  int v293; // [esp+Ch] [ebp-10h]
  int v294; // [esp+Ch] [ebp-10h]
  int v295; // [esp+Ch] [ebp-10h]
  int v296; // [esp+Ch] [ebp-10h]
  int v297; // [esp+Ch] [ebp-10h]
  int v298; // [esp+Ch] [ebp-10h]
  int v299; // [esp+Ch] [ebp-10h]
  int v300; // [esp+Ch] [ebp-10h]
  int v301; // [esp+Ch] [ebp-10h]
  int v302; // [esp+Ch] [ebp-10h]
  int v303; // [esp+Ch] [ebp-10h]
  unsigned int v304; // [esp+10h] [ebp-Ch]
  unsigned int v305; // [esp+10h] [ebp-Ch]
  unsigned int v306; // [esp+10h] [ebp-Ch]
  unsigned int v307; // [esp+10h] [ebp-Ch]
  unsigned int v308; // [esp+10h] [ebp-Ch]
  unsigned int v309; // [esp+10h] [ebp-Ch]
  unsigned __int8 *v310; // [esp+14h] [ebp-8h]
  int v311; // [esp+14h] [ebp-8h]
  int *v312; // [esp+18h] [ebp-4h]
  int v313; // [esp+18h] [ebp-4h]

  v3 = a3;
  if ( !a3 )
    return 0;
  if ( a3 == 1 )
  {
    v207 = *a1;
    v208 = *a2;
    goto LABEL_522;
  }
  v4 = a1;
  switch ( a3 )
  {
    case 2u:
      v209 = *a1 - *a2;
      if ( *a1 == *a2 )
      {
        v207 = a1[1];
        v208 = a2[1];
        goto LABEL_522;
      }
LABEL_527:
      v203 = 0;
      v204 = v209 == 0;
      v205 = v209 < 0;
      goto LABEL_520;
    case 3u:
      v209 = *a1 - *a2;
      if ( *a1 == *a2 )
      {
        v209 = a1[1] - a2[1];
        if ( a1[1] == a2[1] )
        {
          v207 = a1[2];
          v208 = a2[2];
          goto LABEL_522;
        }
      }
      goto LABEL_527;
    case 4u:
      v202 = *a1 - *a2;
      if ( *a1 != *a2 || (v202 = a1[1] - a2[1], a1[1] != a2[1]) || (v202 = a1[2] - a2[2], a1[2] != a2[2]) )
      {
        v203 = 0;
        v204 = v202 == 0;
        v205 = v202 < 0;
LABEL_520:
        v203 &= ~0xff;
        v203 |= (!v205 && !v204)&0xff;
        return 2 * v203 - 1;
      }
      v207 = a1[3];
      v208 = a2[3];
LABEL_522:
      v206 = v207 - v208;
      if ( v206 )
        v206 = 2 * (v206 > 0) - 1;
      return v206;
  }
  v5 = (int)a2;
  for ( i = a3 < 0x20; ; i = v3 < 0x20 )
  {
    v310 = v4;
    v312 = (int *)v5;
    if ( i )
      break;
    v7 = *(_DWORD *)v4;
    v245 = *(_DWORD *)v4 >> 16;
    v8 = *(_DWORD *)v4 >> 24;
    v9 = *v312;
    v210 = (unsigned int)*v312 >> 24;
    v280 = (unsigned int)*v312 >> 16;
    v10 = *(_DWORD *)v4 >> 8;
    v304 = (unsigned int)*v312 >> 8;
    if ( *(_DWORD *)v4 == *v312 )
    {
      v11 = 0;
    }
    else
    {
      v11 = (unsigned __int8)v7 - (unsigned __int8)v9;
      if ( (unsigned __int8)v7 != (unsigned __int8)v9 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      v11 = (unsigned __int8)v10 - (unsigned __int8)v304;
      if ( (unsigned __int8)v10 != (unsigned __int8)v304 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      if ( (unsigned __int8)v245 == (unsigned __int8)v280 )
      {
        v11 = v8 - v210;
        if ( v8 != v210 )
          v11 = 2 * (v11 > 0) - 1;
      }
      else
      {
        v11 = 2 * ((unsigned __int8)v245 - (unsigned __int8)v280 > 0) - 1;
      }
    }
    if ( v11 )
      return v11;
    v12 = *((_DWORD *)v310 + 1);
    v281 = *((_DWORD *)v310 + 1) >> 16;
    v13 = v12 >> 24;
    v14 = v12 >> 8;
    v15 = v312[1];
    v305 = (unsigned int)v312[1] >> 24;
    v246 = v15 >> 16;
    v211 = v15 >> 8;
    if ( v12 == v15 )
    {
      v11 = 0;
    }
    else
    {
      v11 = (unsigned __int8)v12 - (unsigned __int8)v15;
      if ( (unsigned __int8)v12 != (unsigned __int8)v15 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      v11 = (unsigned __int8)v14 - (unsigned __int8)v211;
      if ( (unsigned __int8)v14 != (unsigned __int8)v211 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      if ( (unsigned __int8)v281 == (unsigned __int8)v246 )
      {
        v11 = v13 - v305;
        if ( v13 != v305 )
          v11 = 2 * (v11 > 0) - 1;
      }
      else
      {
        v11 = 2 * ((unsigned __int8)v281 - (unsigned __int8)v246 > 0) - 1;
      }
    }
    if ( v11 )
      return v11;
    v16 = *((_DWORD *)v310 + 2);
    v282 = *((_DWORD *)v310 + 2) >> 16;
    v17 = v16 >> 24;
    v18 = v16 >> 8;
    v19 = v312[2];
    v306 = (unsigned int)v312[2] >> 24;
    v247 = v19 >> 16;
    v212 = v19 >> 8;
    if ( v16 == v19 )
    {
      v11 = 0;
    }
    else
    {
      v11 = (unsigned __int8)v16 - (unsigned __int8)v19;
      if ( (unsigned __int8)v16 != (unsigned __int8)v19 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      v11 = (unsigned __int8)v18 - (unsigned __int8)v212;
      if ( (unsigned __int8)v18 != (unsigned __int8)v212 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      if ( (unsigned __int8)v282 == (unsigned __int8)v247 )
      {
        v11 = v17 - v306;
        if ( v17 != v306 )
          v11 = 2 * (v11 > 0) - 1;
      }
      else
      {
        v11 = 2 * ((unsigned __int8)v282 - (unsigned __int8)v247 > 0) - 1;
      }
    }
    if ( v11 )
      return v11;
    v20 = *((_DWORD *)v310 + 3);
    v248 = *((_DWORD *)v310 + 3) >> 16;
    v21 = v20 >> 24;
    v22 = v20 >> 8;
    v23 = v312[3];
    v283 = (unsigned int)v312[3] >> 24;
    v213 = v23 >> 16;
    v24 = v23 >> 8;
    if ( v20 == v23 )
    {
      v11 = 0;
    }
    else
    {
      v11 = (unsigned __int8)v20 - (unsigned __int8)v23;
      if ( v11 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      v11 = (unsigned __int8)v22 - (unsigned __int8)v24;
      if ( (unsigned __int8)v22 != (unsigned __int8)v24 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      if ( (unsigned __int8)v248 == (unsigned __int8)v213 )
      {
        v11 = v21 - v283;
        if ( v21 != v283 )
          v11 = 2 * (v11 > 0) - 1;
      }
      else
      {
        v11 = 2 * ((unsigned __int8)v248 - (unsigned __int8)v213 > 0) - 1;
      }
    }
    if ( v11 )
      return v11;
    v25 = *((_DWORD *)v310 + 4);
    v284 = *((_DWORD *)v310 + 4) >> 16;
    v26 = v25 >> 24;
    v27 = v25 >> 8;
    v28 = v312[4];
    v307 = (unsigned int)v312[4] >> 24;
    v249 = v28 >> 16;
    v214 = v28 >> 8;
    if ( v25 == v28 )
    {
      v11 = 0;
    }
    else
    {
      v11 = (unsigned __int8)v25 - (unsigned __int8)v28;
      if ( (unsigned __int8)v25 != (unsigned __int8)v28 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      v11 = (unsigned __int8)v27 - (unsigned __int8)v214;
      if ( (unsigned __int8)v27 != (unsigned __int8)v214 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      if ( (unsigned __int8)v284 == (unsigned __int8)v249 )
      {
        v11 = v26 - v307;
        if ( v26 != v307 )
          v11 = 2 * (v11 > 0) - 1;
      }
      else
      {
        v11 = 2 * ((unsigned __int8)v284 - (unsigned __int8)v249 > 0) - 1;
      }
    }
    if ( v11 )
      return v11;
    v29 = *((_DWORD *)v310 + 5);
    v250 = *((_DWORD *)v310 + 5) >> 16;
    v30 = v29 >> 24;
    v31 = v29 >> 8;
    v32 = v312[5];
    v285 = (unsigned int)v312[5] >> 24;
    v215 = v32 >> 16;
    v33 = v32 >> 8;
    if ( v29 == v32 )
    {
      v11 = 0;
    }
    else
    {
      v11 = (unsigned __int8)v29 - (unsigned __int8)v32;
      if ( v11 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      v11 = (unsigned __int8)v31 - (unsigned __int8)v33;
      if ( (unsigned __int8)v31 != (unsigned __int8)v33 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      if ( (unsigned __int8)v250 == (unsigned __int8)v215 )
      {
        v11 = v30 - v285;
        if ( v30 != v285 )
          v11 = 2 * (v11 > 0) - 1;
      }
      else
      {
        v11 = 2 * ((unsigned __int8)v250 - (unsigned __int8)v215 > 0) - 1;
      }
    }
    if ( v11 )
      return v11;
    v34 = *((_DWORD *)v310 + 6);
    v251 = *((_DWORD *)v310 + 6) >> 16;
    v35 = v34 >> 24;
    v36 = v34 >> 8;
    v37 = v312[6];
    v308 = (unsigned int)v312[6] >> 24;
    v286 = v37 >> 16;
    v216 = v37 >> 8;
    if ( v34 == v37 )
    {
      v11 = 0;
    }
    else
    {
      v11 = (unsigned __int8)v34 - (unsigned __int8)v37;
      if ( (unsigned __int8)v34 != (unsigned __int8)v37 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      v11 = (unsigned __int8)v36 - (unsigned __int8)v216;
      if ( (unsigned __int8)v36 != (unsigned __int8)v216 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      if ( (unsigned __int8)v251 == (unsigned __int8)v286 )
      {
        v11 = v35 - v308;
        if ( v35 != v308 )
          v11 = 2 * (v11 > 0) - 1;
      }
      else
      {
        v11&=~0xff;
        v11 |= (unsigned __int8)v251 - (unsigned __int8)v286 > 0;
        v11 = 2 * v11 - 1;
      }
    }
    if ( v11 )
      return v11;
    v38 = *((_DWORD *)v310 + 7);
    v287 = *((_DWORD *)v310 + 7) >> 16;
    v39 = v38 >> 24;
    v40 = v38 >> 8;
    v41 = v312[7];
    v309 = (unsigned int)v312[7] >> 24;
    v252 = v41 >> 16;
    v217 = v41 >> 8;
    if ( v38 == v41 )
    {
      v11 = 0;
    }
    else
    {
      v11 = (unsigned __int8)v38 - (unsigned __int8)v41;
      if ( (unsigned __int8)v38 != (unsigned __int8)v41 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      v11 = (unsigned __int8)v40 - (unsigned __int8)v217;
      if ( (unsigned __int8)v40 != (unsigned __int8)v217 )
        v11 = 2 * (v11 > 0) - 1;
      if ( v11 )
        return v11;
      if ( (unsigned __int8)v287 == (unsigned __int8)v252 )
      {
        v11 = v39 - v309;
        if ( v39 != v309 )
          v11 = 2 * (v11 > 0) - 1;
      }
      else
      {
        v11 = 2 * ((unsigned __int8)v287 - (unsigned __int8)v252 > 0) - 1;
      }
    }
    if ( v11 )
      return v11;
    v3 -= 32;
    v4 = v310 + 32;
    v5 = (int)(v312 + 8);
  }
  v42 = (int)&v4[v3];
  v43 = v3 + v5;
  v311 = v42;
  v313 = v43;
  switch ( v3 )
  {
    case 1u:
      goto LABEL_311;
    case 2u:
      goto LABEL_412;
    case 3u:
      goto LABEL_513;
    case 4u:
      goto LABEL_198;
    case 5u:
      goto LABEL_297;
    case 6u:
      goto LABEL_398;
    case 7u:
      goto LABEL_499;
    case 8u:
      goto LABEL_184;
    case 9u:
      goto LABEL_283;
    case 0xAu:
      goto LABEL_384;
    case 0xBu:
      goto LABEL_485;
    case 0xCu:
      goto LABEL_170;
    case 0xDu:
      goto LABEL_269;
    case 0xEu:
      goto LABEL_370;
    case 0xFu:
      goto LABEL_471;
    case 0x10u:
      goto LABEL_156;
    case 0x11u:
      goto LABEL_255;
    case 0x12u:
      goto LABEL_356;
    case 0x13u:
      goto LABEL_457;
    case 0x14u:
      goto LABEL_142;
    case 0x15u:
      goto LABEL_241;
    case 0x16u:
      goto LABEL_342;
    case 0x17u:
      goto LABEL_443;
    case 0x18u:
      goto LABEL_128;
    case 0x19u:
      goto LABEL_227;
    case 0x1Au:
      goto LABEL_328;
    case 0x1Bu:
      goto LABEL_429;
    case 0x1Cu:
      v44 = *(_DWORD *)(v42 - 28);
      v45 = *(_DWORD *)(v43 - 28);
      v288 = *(_DWORD *)(v42 - 28) >> 16;
      v46 = v44 >> 24;
      v253 = v45 >> 16;
      v47 = v44 >> 8;
      v48 = v45 >> 24;
      v218 = v45 >> 8;
      if ( v44 == v45 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v44 - (unsigned __int8)v45;
        if ( (unsigned __int8)v44 != (unsigned __int8)v45 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v47 - (unsigned __int8)v218;
        if ( (unsigned __int8)v47 != (unsigned __int8)v218 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v288 == (unsigned __int8)v253 )
        {
          v11 = v46 - v48;
          if ( v46 != v48 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v288 - (unsigned __int8)v253 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_128:
      v49 = *(_DWORD *)(v42 - 24);
      v50 = *(_DWORD *)(v43 - 24);
      v289 = *(_DWORD *)(v42 - 24) >> 16;
      v51 = v49 >> 24;
      v254 = v50 >> 16;
      v52 = v49 >> 8;
      v53 = v50 >> 24;
      v219 = v50 >> 8;
      if ( v49 == v50 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v49 - (unsigned __int8)v50;
        if ( (unsigned __int8)v49 != (unsigned __int8)v50 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v52 - (unsigned __int8)v219;
        if ( (unsigned __int8)v52 != (unsigned __int8)v219 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v289 == (unsigned __int8)v254 )
        {
          v11 = v51 - v53;
          if ( v51 != v53 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v289 - (unsigned __int8)v254 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_142:
      v54 = *(_DWORD *)(v42 - 20);
      v255 = v54 >> 16;
      v55 = *(_DWORD *)(v43 - 20);
      v56 = v54 >> 24;
      v220 = v55 >> 16;
      v57 = v54 >> 8;
      v58 = v55 >> 24;
      v59 = v55 >> 8;
      if ( v54 == v55 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v54 - (unsigned __int8)v55;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v57 - (unsigned __int8)v59;
        if ( (unsigned __int8)v57 != (unsigned __int8)v59 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v255 == (unsigned __int8)v220 )
        {
          v11 = v56 - v58;
          if ( v56 != v58 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v255 - (unsigned __int8)v220 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_156:
      v60 = *(_DWORD *)(v42 - 16);
      v61 = *(_DWORD *)(v43 - 16);
      v290 = *(_DWORD *)(v42 - 16) >> 16;
      v62 = v60 >> 24;
      v256 = v61 >> 16;
      v63 = v60 >> 8;
      v64 = v61 >> 24;
      v221 = v61 >> 8;
      if ( v60 == v61 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v60 - (unsigned __int8)v61;
        if ( (unsigned __int8)v60 != (unsigned __int8)v61 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v63 - (unsigned __int8)v221;
        if ( (unsigned __int8)v63 != (unsigned __int8)v221 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v290 == (unsigned __int8)v256 )
        {
          v11 = v62 - v64;
          if ( v62 != v64 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v290 - (unsigned __int8)v256 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_170:
      v65 = *(_DWORD *)(v42 - 12);
      v66 = *(_DWORD *)(v43 - 12);
      v291 = *(_DWORD *)(v42 - 12) >> 16;
      v67 = v65 >> 24;
      v257 = v66 >> 16;
      v68 = v65 >> 8;
      v69 = v66 >> 24;
      v222 = v66 >> 8;
      if ( v65 == v66 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v65 - (unsigned __int8)v66;
        if ( (unsigned __int8)v65 != (unsigned __int8)v66 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v68 - (unsigned __int8)v222;
        if ( (unsigned __int8)v68 != (unsigned __int8)v222 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v291 == (unsigned __int8)v257 )
        {
          v11 = v67 - v69;
          if ( v67 != v69 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v291 - (unsigned __int8)v257 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_184:
      v70 = *(_DWORD *)(v42 - 8);
      v71 = *(_DWORD *)(v43 - 8);
      v292 = *(_DWORD *)(v42 - 8) >> 16;
      v72 = v70 >> 24;
      v258 = v71 >> 16;
      v73 = v70 >> 8;
      v74 = v71 >> 24;
      v223 = v71 >> 8;
      if ( v70 == v71 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v70 - (unsigned __int8)v71;
        if ( (unsigned __int8)v70 != (unsigned __int8)v71 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v73 - (unsigned __int8)v223;
        if ( (unsigned __int8)v73 != (unsigned __int8)v223 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v292 == (unsigned __int8)v258 )
        {
          v11 = v72 - v74;
          if ( v72 != v74 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v292 - (unsigned __int8)v258 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_198:
      v75 = *(_DWORD *)(v42 - 4);
      v76 = *(_DWORD *)(v43 - 4);
      v293 = *(_DWORD *)(v42 - 4) >> 16;
      v77 = v75 >> 24;
      v78 = v76 >> 24;
      if ( v75 == v76 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v75 - (unsigned __int8)v76;
        if ( (unsigned __int8)v75 != (unsigned __int8)v76 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (v75&0xff) - (v76&0xff);
        if ( (v75&0xff) != (v76&0xff) )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v293 == ((v76&0xff00)>>8) )
        {
          v11 = v77 - v78;
          if ( v77 != v78 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v293 -((v76&0xff00)>>8) > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      return 0;
    case 0x1Du:
      v80 = *(_DWORD *)(v42 - 29);
      v259 = v80 >> 16;
      v81 = *(_DWORD *)(v43 - 29);
      v82 = v80 >> 24;
      v224 = v81 >> 16;
      v83 = v80 >> 8;
      v84 = v81 >> 24;
      v85 = v81 >> 8;
      if ( v80 == v81 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v80 - (unsigned __int8)v81;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v83 - (unsigned __int8)v85;
        if ( (unsigned __int8)v83 != (unsigned __int8)v85 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v259 == (unsigned __int8)v224 )
        {
          v11 = v82 - v84;
          if ( v82 != v84 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v259 - (unsigned __int8)v224 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_227:
      v86 = *(_DWORD *)(v42 - 25);
      v87 = *(_DWORD *)(v43 - 25);
      v294 = *(_DWORD *)(v42 - 25) >> 16;
      v88 = v86 >> 24;
      v260 = v87 >> 16;
      v89 = v86 >> 8;
      v90 = v87 >> 24;
      v225 = v87 >> 8;
      if ( v86 == v87 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v86 - (unsigned __int8)v87;
        if ( (unsigned __int8)v86 != (unsigned __int8)v87 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v89 - (unsigned __int8)v225;
        if ( (unsigned __int8)v89 != (unsigned __int8)v225 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v294 == (unsigned __int8)v260 )
        {
          v11 = v88 - v90;
          if ( v88 != v90 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v294 - (unsigned __int8)v260 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_241:
      v91 = *(_DWORD *)(v42 - 21);
      v261 = v91 >> 16;
      v92 = *(_DWORD *)(v43 - 21);
      v93 = v91 >> 24;
      v226 = v92 >> 16;
      v94 = v91 >> 8;
      v95 = v92 >> 24;
      v96 = v92 >> 8;
      if ( v91 == v92 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v91 - (unsigned __int8)v92;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v94 - (unsigned __int8)v96;
        if ( (unsigned __int8)v94 != (unsigned __int8)v96 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v261 == (unsigned __int8)v226 )
        {
          v11 = v93 - v95;
          if ( v93 != v95 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v261 - (unsigned __int8)v226 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_255:
      v97 = *(_DWORD *)(v42 - 17);
      v98 = *(_DWORD *)(v43 - 17);
      v295 = *(_DWORD *)(v42 - 17) >> 16;
      v99 = v97 >> 24;
      v262 = v98 >> 16;
      v100 = v97 >> 8;
      v101 = v98 >> 24;
      v227 = v98 >> 8;
      if ( v97 == v98 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v97 - (unsigned __int8)v98;
        if ( (unsigned __int8)v97 != (unsigned __int8)v98 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v100 - (unsigned __int8)v227;
        if ( (unsigned __int8)v100 != (unsigned __int8)v227 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v295 == (unsigned __int8)v262 )
        {
          v11 = v99 - v101;
          if ( v99 != v101 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v295 - (unsigned __int8)v262 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_269:
      v102 = *(_DWORD *)(v42 - 13);
      v263 = v102 >> 16;
      v103 = *(_DWORD *)(v43 - 13);
      v104 = v102 >> 24;
      v228 = v103 >> 16;
      v105 = v102 >> 8;
      v106 = v103 >> 24;
      v107 = v103 >> 8;
      if ( v102 == v103 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v102 - (unsigned __int8)v103;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v105 - (unsigned __int8)v107;
        if ( (unsigned __int8)v105 != (unsigned __int8)v107 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v263 == (unsigned __int8)v228 )
        {
          v11 = v104 - v106;
          if ( v104 != v106 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v263 - (unsigned __int8)v228 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_283:
      v108 = *(_DWORD *)(v42 - 9);
      v109 = *(_DWORD *)(v43 - 9);
      v296 = *(_DWORD *)(v42 - 9) >> 16;
      v110 = v108 >> 24;
      v264 = v109 >> 16;
      v111 = v108 >> 8;
      v112 = v109 >> 24;
      v229 = v109 >> 8;
      if ( v108 == v109 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v108 - (unsigned __int8)v109;
        if ( (unsigned __int8)v108 != (unsigned __int8)v109 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v111 - (unsigned __int8)v229;
        if ( (unsigned __int8)v111 != (unsigned __int8)v229 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v296 == (unsigned __int8)v264 )
        {
          v11 = v110 - v112;
          if ( v110 != v112 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v296 - (unsigned __int8)v264 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_297:
      v113 = *(_DWORD *)(v42 - 5);
      v265 = v113 >> 16;
      v114 = *(_DWORD *)(v43 - 5);
      v115 = v113 >> 24;
      v230 = v114 >> 16;
      v116 = v113 >> 8;
      v117 = v114 >> 24;
      v118 = v114 >> 8;
      if ( v113 == v114 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v113 - (unsigned __int8)v114;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v116 - (unsigned __int8)v118;
        if ( (unsigned __int8)v116 != (unsigned __int8)v118 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v265 == (unsigned __int8)v230 )
        {
          v11 = v115 - v117;
          if ( v115 != v117 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v265 - (unsigned __int8)v230 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
      goto LABEL_311;
    case 0x1Eu:
      v121 = *(_DWORD *)(v42 - 30);
      v122 = *(_DWORD *)(v43 - 30);
      v297 = *(_DWORD *)(v42 - 30) >> 16;
      v123 = v121 >> 24;
      v266 = v122 >> 16;
      v124 = v121 >> 8;
      v125 = v122 >> 24;
      v231 = v122 >> 8;
      if ( v121 == v122 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v121 - (unsigned __int8)v122;
        if ( (unsigned __int8)v121 != (unsigned __int8)v122 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v124 - (unsigned __int8)v231;
        if ( (unsigned __int8)v124 != (unsigned __int8)v231 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v297 == (unsigned __int8)v266 )
        {
          v11 = v123 - v125;
          if ( v123 != v125 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v297 - (unsigned __int8)v266 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_328:
      v126 = *(_DWORD *)(v42 - 26);
      v267 = v126 >> 16;
      v127 = *(_DWORD *)(v43 - 26);
      v128 = v126 >> 24;
      v232 = v127 >> 16;
      v129 = v126 >> 8;
      v130 = v127 >> 24;
      v131 = v127 >> 8;
      if ( v126 == v127 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v126 - (unsigned __int8)v127;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v129 - (unsigned __int8)v131;
        if ( (unsigned __int8)v129 != (unsigned __int8)v131 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v267 == (unsigned __int8)v232 )
        {
          v11 = v128 - v130;
          if ( v128 != v130 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v267 - (unsigned __int8)v232 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_342:
      v132 = *(_DWORD *)(v42 - 22);
      v133 = *(_DWORD *)(v43 - 22);
      v298 = *(_DWORD *)(v42 - 22) >> 16;
      v134 = v132 >> 24;
      v268 = v133 >> 16;
      v135 = v132 >> 8;
      v136 = v133 >> 24;
      v233 = v133 >> 8;
      if ( v132 == v133 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v132 - (unsigned __int8)v133;
        if ( (unsigned __int8)v132 != (unsigned __int8)v133 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v135 - (unsigned __int8)v233;
        if ( (unsigned __int8)v135 != (unsigned __int8)v233 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v298 == (unsigned __int8)v268 )
        {
          v11 = v134 - v136;
          if ( v134 != v136 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v298 - (unsigned __int8)v268 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_356:
      v137 = *(_DWORD *)(v42 - 18);
      v269 = v137 >> 16;
      v138 = *(_DWORD *)(v43 - 18);
      v139 = v137 >> 24;
      v234 = v138 >> 16;
      v140 = v137 >> 8;
      v141 = v138 >> 24;
      v142 = v138 >> 8;
      if ( v137 == v138 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v137 - (unsigned __int8)v138;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v140 - (unsigned __int8)v142;
        if ( (unsigned __int8)v140 != (unsigned __int8)v142 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v269 == (unsigned __int8)v234 )
        {
          v11 = v139 - v141;
          if ( v139 != v141 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v269 - (unsigned __int8)v234 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_370:
      v143 = *(_DWORD *)(v42 - 14);
      v144 = *(_DWORD *)(v43 - 14);
      v299 = *(_DWORD *)(v42 - 14) >> 16;
      v145 = v143 >> 24;
      v270 = v144 >> 16;
      v146 = v143 >> 8;
      v147 = v144 >> 24;
      v235 = v144 >> 8;
      if ( v143 == v144 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v143 - (unsigned __int8)v144;
        if ( (unsigned __int8)v143 != (unsigned __int8)v144 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v146 - (unsigned __int8)v235;
        if ( (unsigned __int8)v146 != (unsigned __int8)v235 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v299 == (unsigned __int8)v270 )
        {
          v11 = v145 - v147;
          if ( v145 != v147 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v299 - (unsigned __int8)v270 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_384:
      v148 = *(_DWORD *)(v42 - 10);
      v271 = v148 >> 16;
      v149 = *(_DWORD *)(v43 - 10);
      v150 = v148 >> 24;
      v236 = v149 >> 16;
      v151 = v148 >> 8;
      v152 = v149 >> 24;
      v153 = v149 >> 8;
      if ( v148 == v149 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v148 - (unsigned __int8)v149;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v151 - (unsigned __int8)v153;
        if ( (unsigned __int8)v151 != (unsigned __int8)v153 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v271 == (unsigned __int8)v236 )
        {
          v11 = v150 - v152;
          if ( v150 != v152 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v271 - (unsigned __int8)v236 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_398:
      v154 = *(_DWORD *)(v42 - 6);
      v155 = *(_DWORD *)(v43 - 6);
      v300 = *(_DWORD *)(v42 - 6) >> 16;
      v156 = v154 >> 24;
      v272 = v155 >> 16;
      v157 = v154 >> 8;
      v158 = v155 >> 24;
      v237 = v155 >> 8;
      if ( v154 == v155 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v154 - (unsigned __int8)v155;
        if ( (unsigned __int8)v154 != (unsigned __int8)v155 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v157 - (unsigned __int8)v237;
        if ( (unsigned __int8)v157 != (unsigned __int8)v237 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v300 == (unsigned __int8)v272 )
        {
          v11 = v156 - v158;
          if ( v156 != v158 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v300 - (unsigned __int8)v272 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_412:
      v159 = *(_WORD *)(v42 - 2);
      v160 = *(_WORD *)(v43 - 2);
      v161 = (unsigned __int16)(*(_WORD *)(v43 - 2) >> 8);
      if ( v159 == v160 )
        return 0;
      v162 = (unsigned __int8)v159 - (unsigned __int8)v160;
      if ( !v162 )
      {
        v120 = v161;
        v119 = v159 >> 8;
        goto LABEL_312;
      }
      goto LABEL_515;
    case 0x1Fu:
      v163 = *(_DWORD *)(v42 - 31);
      v164 = *(_DWORD *)(v43 - 31);
      v301 = *(_DWORD *)(v42 - 31) >> 16;
      v165 = v163 >> 24;
      v273 = v164 >> 16;
      v166 = v163 >> 8;
      v167 = v164 >> 24;
      v238 = v164 >> 8;
      if ( v163 == v164 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v163 - (unsigned __int8)v164;
        if ( (unsigned __int8)v163 != (unsigned __int8)v164 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v166 - (unsigned __int8)v238;
        if ( (unsigned __int8)v166 != (unsigned __int8)v238 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v301 == (unsigned __int8)v273 )
        {
          v11 = v165 - v167;
          if ( v165 != v167 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v301 - (unsigned __int8)v273 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_429:
      v168 = *(_DWORD *)(v42 - 27);
      v169 = *(_DWORD *)(v43 - 27);
      v302 = *(_DWORD *)(v42 - 27) >> 16;
      v170 = v168 >> 24;
      v274 = v169 >> 16;
      v171 = v168 >> 8;
      v172 = v169 >> 24;
      v239 = v169 >> 8;
      if ( v168 == v169 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v168 - (unsigned __int8)v169;
        if ( (unsigned __int8)v168 != (unsigned __int8)v169 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v171 - (unsigned __int8)v239;
        if ( (unsigned __int8)v171 != (unsigned __int8)v239 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v302 == (unsigned __int8)v274 )
        {
          v11 = v170 - v172;
          if ( v170 != v172 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v302 - (unsigned __int8)v274 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_443:
      v173 = *(_DWORD *)(v42 - 23);
      v275 = v173 >> 16;
      v174 = *(_DWORD *)(v43 - 23);
      v175 = v173 >> 24;
      v240 = v174 >> 16;
      v176 = v173 >> 8;
      v177 = v174 >> 24;
      v178 = v174 >> 8;
      if ( v173 == v174 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v173 - (unsigned __int8)v174;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v176 - (unsigned __int8)v178;
        if ( (unsigned __int8)v176 != (unsigned __int8)v178 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v275 == (unsigned __int8)v240 )
        {
          v11 = v175 - v177;
          if ( v175 != v177 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v275 - (unsigned __int8)v240 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_457:
      v179 = *(_DWORD *)(v42 - 19);
      v276 = v179 >> 16;
      v180 = *(_DWORD *)(v43 - 19);
      v181 = v179 >> 24;
      v241 = v180 >> 16;
      v182 = v179 >> 8;
      v183 = v180 >> 24;
      v184 = v180 >> 8;
      if ( v179 == v180 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v179 - (unsigned __int8)v180;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v182 - (unsigned __int8)v184;
        if ( (unsigned __int8)v182 != (unsigned __int8)v184 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v276 == (unsigned __int8)v241 )
        {
          v11 = v181 - v183;
          if ( v181 != v183 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v276 - (unsigned __int8)v241 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_471:
      v185 = *(_DWORD *)(v42 - 15);
      v277 = v185 >> 16;
      v186 = *(_DWORD *)(v43 - 15);
      v187 = v185 >> 24;
      v242 = v186 >> 16;
      v188 = v185 >> 8;
      v189 = v186 >> 24;
      v190 = v186 >> 8;
      if ( v185 == v186 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v185 - (unsigned __int8)v186;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v188 - (unsigned __int8)v190;
        if ( (unsigned __int8)v188 != (unsigned __int8)v190 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v277 == (unsigned __int8)v242 )
        {
          v11 = v187 - v189;
          if ( v187 != v189 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v277 - (unsigned __int8)v242 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_485:
      v191 = *(_DWORD *)(v42 - 11);
      v278 = v191 >> 16;
      v192 = *(_DWORD *)(v43 - 11);
      v193 = v191 >> 24;
      v243 = v192 >> 16;
      v194 = v191 >> 8;
      v195 = v192 >> 24;
      v196 = v192 >> 8;
      if ( v191 == v192 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v191 - (unsigned __int8)v192;
        if ( v11 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v194 - (unsigned __int8)v196;
        if ( (unsigned __int8)v194 != (unsigned __int8)v196 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v278 == (unsigned __int8)v243 )
        {
          v11 = v193 - v195;
          if ( v193 != v195 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v278 - (unsigned __int8)v243 > 0) - 1;
        }
      }
      if ( v11 )
        return v11;
      v43 = v313;
      v42 = v311;
LABEL_499:
      v197 = *(_DWORD *)(v42 - 7);
      v198 = *(_DWORD *)(v43 - 7);
      v303 = *(_DWORD *)(v42 - 7) >> 16;
      v199 = v197 >> 24;
      v279 = v198 >> 16;
      v200 = v197 >> 8;
      v201 = v198 >> 24;
      v244 = v198 >> 8;
      if ( v197 == v198 )
      {
        v11 = 0;
      }
      else
      {
        v11 = (unsigned __int8)v197 - (unsigned __int8)v198;
        if ( (unsigned __int8)v197 != (unsigned __int8)v198 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        v11 = (unsigned __int8)v200 - (unsigned __int8)v244;
        if ( (unsigned __int8)v200 != (unsigned __int8)v244 )
          v11 = 2 * (v11 > 0) - 1;
        if ( v11 )
          return v11;
        if ( (unsigned __int8)v303 == (unsigned __int8)v279 )
        {
          v11 = v199 - v201;
          if ( v199 != v201 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
          v11 = 2 * ((unsigned __int8)v303 - (unsigned __int8)v279 > 0) - 1;
        }
      }
      if ( !v11 )
      {
        v43 = v313;
        v42 = v311;
LABEL_513:
        v162 = *(unsigned __int8 *)(v42 - 3) - *(unsigned __int8 *)(v43 - 3);
        if ( *(unsigned __int8 *)(v42 - 3) == *(unsigned __int8 *)(v43 - 3)
          && (v162 = *(unsigned __int8 *)(v42 - 2) - *(unsigned __int8 *)(v43 - 2),
              *(unsigned __int8 *)(v42 - 2) == *(unsigned __int8 *)(v43 - 2)) )
        {
LABEL_311:
          v119 = *(unsigned __int8 *)(v42 - 1);
          v120 = *(unsigned __int8 *)(v43 - 1);
LABEL_312:
          v11 = v119 - v120;
          if ( v11 )
            v11 = 2 * (v11 > 0) - 1;
        }
        else
        {
LABEL_515:
          v11 = 2 * (v162 > 0) - 1;
        }
      }
      break;
    default:
      return 0;
  }
  return v11;
}
int main() {
  printf("%x\n",sub_5115C4("12345", "12346", 5));
  printf("fuck");
}