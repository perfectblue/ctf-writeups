// stupid instrumentation shit
internal static void VARDAGEN()
{
	Harmony harmony = new Harmony("fun");
	MethodInfo method = typeof(KVOT).GetMethod("FYRKANTIG", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	MethodInfo method2 = typeof(GATKAMOMILL).GetMethod("NUFFRA", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	harmony.Patch(method, new HarmonyMethod(method2), null, null, null);
	MethodInfo method3 = typeof(KVOT).GetMethod("RIKTIG_OGLA", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	MethodInfo method4 = typeof(GATKAMOMILL).GetMethod("GRONKULLA", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	harmony.Patch(method3, new HarmonyMethod(method4), null, null, null);
	MethodInfo method5 = typeof(SOCKERBIT).GetMethod("GRUNDTAL_NORRVIKEN", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	MethodInfo method6 = typeof(GATKAMOMILL).GetMethod("SPARSAM", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	harmony.Patch(method5, new HarmonyMethod(method6), null, null, null);
	MethodInfo method7 = typeof(FARGRIK).GetMethod("DAGSTORP", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	MethodInfo method8 = typeof(GATKAMOMILL).GetMethod("FLARDFULL", BindingFlags.Instance | BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic);
	harmony.Patch(method7, new HarmonyMethod(method8), null, null, null);
}

// flag checker
private static string FYRKANTIG(string BISSING)
{
	List<uint> list = null;
	if (BISSING.Length != 30)
	{
		return "Flag must be exactly 30 characters long. Please check the number and try again.";
	}
	list = SOCKERBIT.GRUNDTAL_NORRVIKEN(BISSING);
	int num = 0;
	if (0 < list.Count)
	{
		while (list[num] <= 63U)
		{
			num++;
			if (num >= list.Count)
			{
				goto IL_5F;
			}
		}
		return "Unexpected character " + BISSING[num] + "; Characters must be in the set {A-Za-z0-9}. Please check the number and try again.";
	}
	IL_5F:
	FARGRIK.DAGSTORP(ref list, new List<uint>(30)
	{
		18U, 43U, 47U, 5U, 35U, 44U, 59U, 17U, 3U, 21U, 6U, 43U, 44U, 37U, 26U, 42U, 24U, 34U, 57U, 14U, 30U, 5U, 16U, 23U, 37U, 49U, 48U, 16U, 28U, 49U
	});
	if (!<Module>.SMORBOLL(list))
	{
		return "Flag checksum invalid. Please check the number and try again.";
	}
	return <Module>.HEROISK(list);
}

// checksum
internal static bool SMORBOLL(List<uint> flag)
{
	if (flag.Count == 0)
	{
		return true;
	}
	uint num = 16U;
	for (int num2 = 0; num2 < flag.Count; num2++)
	{
		if (num2 != flag.Count - 2)
		{
			num += flag[num2];
			if (num2 % 2 == 0)
			{
				num += flag[num2];
			}
			if (num2 % 3 == 0)
			{
				num += -2 * flag[num2];
			}
			if (num2 % 5 == 0)
			{
				num += -3 * flag[num2];
			}
			if (num2 % 7 == 0)
			{
				num += 4 * flag[num2];
			}
		}
	}
	return (((uint)((sbyte)flag[flag.Count - 2]) == (num & 63U)) ? 1 : 0) != 0;
}

// check unique
internal static bool VAXMYRA(List<uint> flag)
{
	int num = 0;
	if (0 < flag.Count)
	{
		do
		{
			int num2 = 0;
			if (0 < num)
			{
				while (flag[num] != flag[num2])
				{
					num2++;
					if (num2 >= num)
					{
						goto IL_29;
					}
				}
				return false;
			}
			IL_29:
			num++;
		}
		while (num < flag.Count);
		return true;
	}
	return true;
}

// flag checker (basically z3 food)
internal static string HEROISK(List<uint> flag)
{
	string result = "Invalid flag. Please check the number and try again.";
	if (!<Module>.VAXMYRA(flag)) // check unique
	{
		return result;
	}
	if (flag[1] != 25U)
	{
		return result;
	}
	if (flag[2] != 23U)
	{
		return result;
	}
	if (flag[9] != 9U)
	{
		return result;
	}
	if (flag[20] != 45U)
	{
		return result;
	}
	if (flag[26] != 7U)
	{
		return result;
	}
	if (flag[8] < 15U)
	{
		return result;
	}
	if (flag[12] > 4U)
	{
		return result;
	}
	if (flag[14] < 48U)
	{
		return result;
	}
	if (flag[29] < 1U)
	{
		return result;
	}
	int num = (int)flag[4];
	int num2 = (int)flag[3];
	int num3 = (int)flag[2];
	int num4 = (int)flag[1];
	if (((flag[0] + (uint)num4 + (uint)num + (uint)num3 + (uint)num2 - 130U <= 10U) ? 1 : 0) == 0)
	{
		return result;
	}
	num4 = (int)flag[9];
	int num5 = (int)flag[8];
	int num6 = (int)flag[7];
	int num7 = (int)flag[6];
	if (((flag[5] + (uint)num7 + (uint)num6 + (uint)num5 + (uint)num4 - 140U <= 10U) ? 1 : 0) == 0)
	{
		return result;
	}
	int num8 = (int)flag[14];
	int num9 = (int)flag[13];
	int num10 = (int)flag[12];
	int num11 = (int)flag[11];
	if (((flag[10] + (uint)num11 + (uint)num10 + (uint)num9 + (uint)num8 - 150U <= 10U) ? 1 : 0) == 0)
	{
		return result;
	}
	int num12 = (int)flag[19];
	int num13 = (int)flag[18];
	int num14 = (int)flag[17];
	int num15 = (int)flag[16];
	if (((flag[15] + (uint)num15 + (uint)num14 + (uint)num13 + (uint)num12 - 160U <= 10U) ? 1 : 0) == 0)
	{
		return result;
	}
	int num16 = (int)flag[24];
	int num17 = (int)flag[23];
	int num18 = (int)flag[22];
	int num19 = (int)flag[21];
	if (((flag[20] + (uint)num19 + (uint)num18 + (uint)num17 + (uint)num16 - 170U <= 10U) ? 1 : 0) == 0)
	{
		return result;
	}
	int num20 = (int)flag[25];
	int num21 = (int)flag[20];
	int num22 = (int)flag[15];
	int num23 = (int)flag[10];
	int num24 = (int)flag[5];
	if (((flag[0] + (uint)num24 + (uint)num23 + (uint)num22 + (uint)num21 + (uint)num20 - 172U <= 6U) ? 1 : 0) == 0)
	{
		return result;
	}
	int num25 = (int)flag[26];
	int num26 = (int)flag[21];
	int num27 = (int)flag[16];
	int num28 = (int)flag[11];
	int num29 = (int)flag[6];
	if (((flag[1] + (uint)num29 + (uint)num28 + (uint)num27 + (uint)num26 + (uint)num25 - 162U <= 6U) ? 1 : 0) == 0)
	{
		return result;
	}
	int num30 = (int)flag[27];
	int num31 = (int)flag[22];
	int num32 = (int)flag[17];
	int num33 = (int)flag[12];
	int num34 = (int)flag[7];
	if (((flag[2] + (uint)num34 + (uint)num33 + (uint)num32 + (uint)num31 + (uint)num30 - 152U <= 6U) ? 1 : 0) == 0)
	{
		return result;
	}
	int num35 = (int)flag[23];
	int num36 = (int)flag[18];
	int num37 = (int)flag[13];
	int num38 = (int)flag[8];
	if (((flag[3] + (uint)num38 + (uint)num37 + (uint)num36 + (uint)num35 - 142U <= 6U) ? 1 : 0) == 0)
	{
		return result;
	}
	int num39 = (int)flag[29];
	int num40 = (int)flag[24];
	int num41 = (int)flag[19];
	int num42 = (int)flag[14];
	int num43 = (int)flag[9];
	if (((flag[4] + (uint)num43 + (uint)num42 + (uint)num41 + (uint)num40 + (uint)num39 - 132U <= 6U) ? 1 : 0) == 0)
	{
		return result;
	}


	uint num44 = flag[27] * 3U;
	uint num45 = (flag[7] + num44) * 3U - flag[5] * 13U;
	if (num45 - 57U > 28U)
	{
		return result;
	}
	num44 = flag[20] * 5U;
	num44 = (flag[14] << 2) - num44;
	num45 = flag[22] * 3U + num44;
	if (num45 - 12U > 70U)
	{
		return result;
	}
	num44 = flag[18] * 2U;
	num44 = (flag[15] - num44) * 3U;
	uint num46 = flag[16] * 2U;
	num46 = (flag[14] + num46) * 2U + num44 - flag[17] * 5U;
	if (flag[13] + num46 != 0U)
	{
		return result;
	}
	num46 = flag[6] * 2U;
	if (flag[5] != num46)
	{
		return result;
	}
	if (flag[29] + flag[7] != 59U)
	{
		return result;
	}
	uint num47 = flag[17] * 6U;
	if (flag[0] != num47)
	{
		return result;
	}
	num47 = flag[9] * 4U;
	if (flag[8] != num47)
	{
		return result;
	}
	num47 = flag[13] * 3U;
	if (flag[11] << 1 != num47)
	{
		return result;
	}
	if (flag[13] + flag[29] + flag[11] + flag[4] != flag[19])
	{
		return result;
	}
	uint num48 = flag[12] * 13U;
	if (flag[10] != num48)
	{
		return result;
	}
	return null;
}

// shitty fisher yates shuffle
internal unsafe static void _Random_shuffle1<class\u0020std::_String_iterator<class\u0020std::_String_val<struct\u0020std::_Simple_types<char>\u0020>\u0020>,class\u0020<lambda_7b24d0a324c66665c2319d5904cf2705>\u0020>(_String_iterator<std::_String_val<std::_Simple_types<char>\u0020>\u0020> _First, _String_iterator<std::_String_val<std::_Simple_types<char>\u0020>\u0020> _Last, <lambda_7b24d0a324c66665c2319d5904cf2705>* _RngFunc)
{
	if (_First != _Last)
	{
		sbyte* ptr = _First + 1;
		if (ptr != _Last)
		{
			sbyte* ptr2 = ptr - _First / sizeof(sbyte);
			do
			{
				int num = <Module>.Shuffle.<lambda_7b24d0a324c66665c2319d5904cf2705>.()(_RngFunc, ptr2 + 1 / sizeof(sbyte));
				if (num != ptr2)
				{
					sbyte* ptr3 = _First + num;
					sbyte b = *(sbyte*)ptr;
					*(byte*)ptr = (byte)(*(sbyte*)ptr3);
					*(byte*)ptr3 = b;
				}
				ptr += 1 / sizeof(sbyte);
				ptr2 += 1 / sizeof(sbyte);
			}
			while (ptr != _Last);
		}
	}
}

