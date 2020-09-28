# Tamarin

- Xamarin Android app: Xamarin is basically a cross-platform app framework for .NET
- Xamarin can JIT or AOT the .NET code to the target platform
- However in this case you can actually find the original .NET classes still in libmonodroid_bundle_app.so
- Extracted with binwalk (LOL)
- Found Tamarin.dll in binwalk extracted '24E0'

DnSpy:

```c#
button.Click += delegate(object sender, EventArgs e)
{
	if (Check.Func4(flagText.Text))
	{
		flagText.Text = "The flag is TWCTF{" + flagText.Text + "}";
		return;
	}
	flagText.Text = "Invalid";
};

// Token: 0x02000004 RID: 4
public static class Check
{
    // Token: 0x06000007 RID: 7 RVA: 0x00002764 File Offset: 0x00000964
    private static uint Pow(uint x, int n)
    {
        uint num = 1U;
        for (int i = 0; i < n; i++)
        {
            num *= x;
        }
        return num;
    }

    // Token: 0x06000008 RID: 8 RVA: 0x00002784 File Offset: 0x00000984
    private static uint Polynomial(List<uint> coefficients, uint x, int pos)
    {
        if (pos == -1)
        {
            return 0U;
        }
        uint num = coefficients[pos] * Check.Pow(x, pos);
        return num + Check.Polynomial(coefficients, x, pos - 1);
    }

    // Token: 0x06000009 RID: 9 RVA: 0x000027B8 File Offset: 0x000009B8
    private static uint RandomUint32()
    {
        byte[] array = new byte[4];
        using (RNGCryptoServiceProvider rngcryptoServiceProvider = new RNGCryptoServiceProvider())
        {
            rngcryptoServiceProvider.GetBytes(array);
        }
        return BitConverter.ToUInt32(array, 0);
    }

    // Token: 0x0600000A RID: 10 RVA: 0x000027FC File Offset: 0x000009FC
    public static bool CheckFlag(string flag)
    {
        ParallelOptions parallelOptions = new ParallelOptions
        {
            MaxDegreeOfParallelism = 4
        };
        byte[] flagBytes = Encoding.ASCII.GetBytes(flag);

        // Pad to multiple of 4
        int length = flag.Length;
        if ((length & 3) != 0)
        {
            Array.Resize<byte>(ref flagBytes, length + (4 - (length & 3)));
        }
        for (int i = length; i < flagBytes.Length; i++)
        {
            flagBytes[i] = 0;
        }

        // flag length: 88
        if (flagBytes.Length != Check.equations_arr.GetLength(0) * 4)
        {
            return false;
        }

        object lockObj = new object();
        ConcurrentBag<bool> checkResults = new ConcurrentBag<bool>();
        List<List<uint>> list = new List<List<uint>>();
        for (int j = 0; j < Check.equations_arr.GetLength(0); j++)
        {
            List<uint> list2 = new List<uint>();
            list2.Add(BitConverter.ToUInt32(flagBytes, j * 4));
            for (int k = 0; k < Check.equations_arr.GetLength(1); k++)
            {
                list2.Add(Check.equations_arr[j, k]);
            }
            list.Add(list2);
            // list2 contents: 4 bytes of flag as uint32, equations_arr[j]
        }

        // flagBytes + equations_arr[0]*x^1 + equations_arr[1]*x^2 + ... + equations_arr[len-2]*x^n-1 = equations_arr[len-1]

        Parallel.ForEach<List<uint>>(list, parallelOptions, delegate (List<uint> equation)
        {
            // flag chars = constant factor in polynomial


            object lockObj_ = lockObj;
            lock (lockObj_)
            {
                uint point = Check.RandomUint32();
                for (int l = 0; l < 10000; l++)
                {
                    point = Check.Polynomial(equation, point, equation.Count - 2);
                }
                checkResults.Add(point == equation[equation.Count - 1]);
            }
        });
        return checkResults.ToArray().All((bool x) => x);
    }

    // coefficients for equations from x^1 to x^n (flag is x^0 coeff)
    public static readonly uint[,] equations_arr = new uint[,]
    {
        {
            2921822136U, 1060277104U, 2035740900U, 823622198U, 210968592U, 3474619224U, 3252966626U, 1671622480U, 1174723606U, 3830387194U, 2514889364U, 3125636774U, 896423784U, 4164953836U, 2838119626U, 2523117444U, 1385864710U, 3157438448U, 132542958U, 4108218268U, 314662132U, 432653936U, 1147047258U, 1802950730U, 67411056U, 1207641174U, 1920298940U, 2947533900U, 3468512014U, 3485949926U, 3695085832U, 3903653528U
        },
        // ...
}
```

Basically the code:
 - splits input into 4 byte (32bits) pieces
 - there are a bunch of polynomials, and your flag pieces are the constant term in each polynomial
 - iterate the polynomial and check for fixed point. The fixed point is checked against to validate the flag, for each polynomial

It's easy to find the constant term that gives the fixed point using algebra, then we combine all the pieces to get the flag

` TWCTF{Xm4r1n_15_4bl3_70_6en3r4t3_N471v3_C0d3_w17h_VS_3n73rpr153_bu7_17_c0n741n5_D07_N3t_B1n4ry}`

