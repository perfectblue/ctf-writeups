.class public Looo/defcon2019/quals/veryandroidoso/Solver;
.super Ljava/lang/Object;
.source "Solver.java"


# static fields
.field public static cc:Landroid/content/Context;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const-string v0, "native-lib"

    .line 23
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 18
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getSecretNumber(I)I
    .locals 9

    .line 2159
    sget-object v0, Looo/defcon2019/quals/veryandroidoso/Solver;->cc:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    .line 2160
    sget-object v1, Looo/defcon2019/quals/veryandroidoso/Solver;->cc:Landroid/content/Context;

    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    const/16 v3, 0x40

    .line 2164
    :try_start_0
    invoke-virtual {v0, v1, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v0
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 2166
    invoke-virtual {v0}, Landroid/content/pm/PackageManager$NameNotFoundException;->printStackTrace()V

    move-object v0, v2

    .line 2168
    :goto_0
    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    const/4 v1, 0x0

    .line 2169
    aget-object v0, v0, v1

    invoke-virtual {v0}, Landroid/content/pm/Signature;->toByteArray()[B

    move-result-object v0

    .line 2170
    new-instance v3, Ljava/io/ByteArrayInputStream;

    invoke-direct {v3, v0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    :try_start_1
    const-string v0, "X509"

    .line 2173
    invoke-static {v0}, Ljava/security/cert/CertificateFactory;->getInstance(Ljava/lang/String;)Ljava/security/cert/CertificateFactory;

    move-result-object v0
    :try_end_1
    .catch Ljava/security/cert/CertificateException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_1
    move-exception v0

    .line 2175
    invoke-virtual {v0}, Ljava/security/cert/CertificateException;->printStackTrace()V

    move-object v0, v2

    .line 2179
    :goto_1
    :try_start_2
    invoke-virtual {v0, v3}, Ljava/security/cert/CertificateFactory;->generateCertificate(Ljava/io/InputStream;)Ljava/security/cert/Certificate;

    move-result-object v0

    check-cast v0, Ljava/security/cert/X509Certificate;
    :try_end_2
    .catch Ljava/security/cert/CertificateException; {:try_start_2 .. :try_end_2} :catch_2

    goto :goto_2

    :catch_2
    move-exception v0

    .line 2181
    invoke-virtual {v0}, Ljava/security/cert/CertificateException;->printStackTrace()V

    move-object v0, v2

    :goto_2
    :try_start_3
    const-string v2, "SHA256"

    .line 2185
    invoke-static {v2}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v2

    const/16 v3, 0x100

    .line 2187
    new-array v3, v3, [I

    const/4 v4, 0x0

    :goto_3
    const/16 v5, 0x8

    if-ge v4, v5, :cond_3

    .line 2189
    invoke-virtual {v0}, Ljava/security/cert/X509Certificate;->getEncoded()[B

    move-result-object v5

    const/16 v6, 0x21

    .line 2190
    aput-byte v6, v5, v4

    .line 2191
    invoke-virtual {v2, v5}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object v5

    const/4 v6, 0x0

    .line 2192
    :goto_4
    array-length v7, v5

    if-ge v6, v7, :cond_2

    .line 2193
    aget-byte v7, v5, v6

    if-gez v7, :cond_0

    add-int/lit16 v7, v7, 0x100

    :cond_0
    if-nez v7, :cond_1

    const/4 v7, 0x1

    :cond_1
    mul-int/lit8 v8, v4, 0x20

    add-int/2addr v8, v6

    .line 2200
    aput v7, v3, v8

    add-int/lit8 v6, v6, 0x1

    goto :goto_4

    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_3

    .line 2211
    :cond_3
    aget p0, v3, p0
    :try_end_3
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_3 .. :try_end_3} :catch_4
    .catch Ljava/security/cert/CertificateEncodingException; {:try_start_3 .. :try_end_3} :catch_3

    return p0

    :catch_3
    move-exception p0

    .line 2215
    invoke-virtual {p0}, Ljava/security/cert/CertificateEncodingException;->printStackTrace()V

    goto :goto_5

    :catch_4
    move-exception p0

    .line 2213
    invoke-virtual {p0}, Ljava/security/NoSuchAlgorithmException;->printStackTrace()V

    :goto_5
    const/4 p0, 0x2

    .line 2217
    div-int/2addr p0, v1

    return v1
.end method

.method public static native m0(II)I
.end method

.method public static native m1(II)I
.end method

.method public static native m2(II)I
.end method

.method public static native m3(II)I
.end method

.method public static native m4(II)I
.end method

.method public static native m5(II)I
.end method

.method public static native m6(II)I
.end method

.method public static native m7(II)I
.end method

.method public static native m8(II)I
.end method

.method public static native m9(I)V
.end method

.method public static scramble(I)I
    .locals 5

    const/16 v0, 0x1f4

    .line 2222
    invoke-static {v0}, Looo/defcon2019/quals/veryandroidoso/Solver;->sleep(I)J

    move-result-wide v0

    long-to-int v0, v0

    add-int/lit16 v0, v0, -0x1f3

    mul-int/lit8 v1, v0, 0x4

    mul-int v1, v1, v0

    int-to-double v1, v1

    .line 2223
    invoke-static {v1, v2}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v1

    int-to-double v3, v0

    div-double/2addr v1, v3

    invoke-static {v1, v2}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    long-to-int v0, v0

    add-int/2addr p0, v0

    add-int/lit16 p0, p0, 0x141

    .line 2224
    rem-int/lit16 p0, p0, 0x100

    return p0
.end method

.method static sleep(I)J
    .locals 4

    .line 2134
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v0

    int-to-long v2, p0

    .line 2136
    :try_start_0
    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    const/4 p0, 0x2

    .line 2138
    div-int/lit8 p0, p0, 0x0

    .line 2140
    :goto_0
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v2

    sub-long/2addr v2, v0

    long-to-float p0, v2

    const v0, 0x49742400    # 1000000.0f

    div-float/2addr p0, v0

    float-to-int p0, p0

    add-int/lit8 p0, p0, 0x1

    int-to-long v0, p0

    return-wide v0
.end method

.method static solve(IIIIIIIII)Z
    .locals 16

    move/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    move/from16 v3, p3

    move/from16 v4, p4

    move/from16 v5, p6

    move/from16 v6, p7

    move/from16 v7, p8

    add-int v8, v0, v1

    add-int/2addr v8, v2

    add-int/2addr v8, v3

    add-int/2addr v8, v4

    add-int v8, v8, p5

    mul-int v9, v5, v6

    add-int/2addr v8, v9

    const/16 v9, 0xd

    .line 35
    invoke-static {v9}, Looo/defcon2019/quals/veryandroidoso/Solver;->scramble(I)I

    move-result v10

    const/4 v14, 0x6

    const/16 v12, 0x61

    const/4 v13, 0x1

    if-nez v0, :cond_0

    const/16 v11, 0x64

    .line 36
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_0
    if-ne v0, v13, :cond_1

    const/16 v11, 0xbe

    .line 37
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_1
    const/4 v11, 0x2

    if-ne v0, v11, :cond_2

    const/16 v11, 0x58

    .line 38
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_2
    const/4 v11, 0x3

    if-ne v0, v11, :cond_3

    const/16 v11, 0xf0

    .line 39
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_3
    const/4 v11, 0x4

    if-ne v0, v11, :cond_4

    .line 40
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_4
    const/4 v11, 0x5

    if-ne v0, v11, :cond_5

    const/16 v11, 0xd8

    .line 41
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_5
    if-ne v0, v14, :cond_6

    const/16 v11, 0x2f

    .line 42
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_6
    const/4 v11, 0x7

    if-ne v0, v11, :cond_7

    const/16 v11, 0xf3

    .line 43
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_7
    const/16 v11, 0x8

    if-ne v0, v11, :cond_8

    const/16 v11, 0x27

    .line 44
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_8
    const/16 v11, 0x9

    if-ne v0, v11, :cond_9

    const/16 v11, 0x12

    .line 45
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_9
    const/16 v11, 0xa

    if-ne v0, v11, :cond_a

    const/16 v11, 0xad

    .line 46
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a
    const/16 v11, 0xb

    if-ne v0, v11, :cond_b

    const/16 v11, 0x90

    .line 47
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b
    const/16 v11, 0xc

    if-ne v0, v11, :cond_c

    const/16 v11, 0x9d

    .line 48
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c
    if-ne v0, v9, :cond_d

    const/16 v11, 0x72

    .line 49
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d
    const/16 v11, 0xe

    if-ne v0, v11, :cond_e

    const/16 v11, 0x74

    .line 50
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e
    const/16 v11, 0xf

    if-ne v0, v11, :cond_f

    const/16 v11, 0xfa

    .line 51
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f
    const/16 v11, 0x10

    if-ne v0, v11, :cond_10

    const/16 v11, 0x98

    .line 52
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_10
    const/16 v11, 0x11

    if-ne v0, v11, :cond_11

    const/16 v11, 0x96

    .line 53
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_11
    const/16 v11, 0x12

    if-ne v0, v11, :cond_12

    const/16 v11, 0xc4

    .line 54
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_12
    const/16 v11, 0x13

    if-ne v0, v11, :cond_13

    const/16 v11, 0xaf

    .line 55
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_13
    const/16 v11, 0x14

    if-ne v0, v11, :cond_14

    const/16 v11, 0x1c

    .line 56
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_14
    const/16 v11, 0x15

    if-ne v0, v11, :cond_15

    const/16 v11, 0xb3

    .line 57
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_15
    const/16 v11, 0x16

    if-ne v0, v11, :cond_16

    const/16 v11, 0x17

    .line 58
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_16
    const/16 v11, 0x17

    if-ne v0, v11, :cond_17

    const/16 v11, 0xd5

    .line 59
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_17
    const/16 v11, 0x18

    if-ne v0, v11, :cond_18

    const/16 v11, 0x49

    .line 60
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_18
    const/16 v11, 0x19

    if-ne v0, v11, :cond_19

    const/16 v11, 0x42

    .line 61
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_19
    const/16 v11, 0x1a

    if-ne v0, v11, :cond_1a

    const/16 v11, 0x14

    .line 62
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_1a
    const/16 v11, 0x1b

    if-ne v0, v11, :cond_1b

    const/16 v11, 0xe4

    .line 63
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_1b
    const/16 v11, 0x1c

    if-ne v0, v11, :cond_1c

    const/16 v11, 0x43

    .line 64
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_1c
    const/16 v11, 0x1d

    if-ne v0, v11, :cond_1d

    const/16 v11, 0xc8

    .line 65
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_1d
    const/16 v11, 0x1e

    if-ne v0, v11, :cond_1e

    const/16 v11, 0x9c

    .line 66
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_1e
    const/16 v11, 0x1f

    if-ne v0, v11, :cond_1f

    const/4 v11, 0x7

    .line 67
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_1f
    const/16 v11, 0x20

    if-ne v0, v11, :cond_20

    const/16 v11, 0xdd

    .line 68
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_20
    const/16 v11, 0x21

    if-ne v0, v11, :cond_21

    const/16 v11, 0xd2

    .line 69
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_21
    const/16 v11, 0x22

    if-ne v0, v11, :cond_22

    const/16 v11, 0x32

    .line 70
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_22
    const/16 v11, 0x23

    if-ne v0, v11, :cond_23

    const/16 v11, 0xe9

    .line 71
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_23
    const/16 v11, 0x24

    if-ne v0, v11, :cond_24

    const/16 v11, 0x6e

    .line 72
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_24
    const/16 v11, 0x25

    if-ne v0, v11, :cond_25

    const/16 v11, 0x20

    .line 73
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_25
    const/16 v11, 0x26

    if-ne v0, v11, :cond_26

    const/16 v11, 0x47

    .line 74
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_26
    const/16 v11, 0x27

    if-ne v0, v11, :cond_27

    const/16 v11, 0xc2

    .line 75
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_27
    const/16 v11, 0x28

    if-ne v0, v11, :cond_28

    const/16 v11, 0x75

    .line 76
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_28
    const/16 v11, 0x29

    if-ne v0, v11, :cond_29

    const/16 v11, 0xdc

    .line 77
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_29
    const/16 v11, 0x2a

    if-ne v0, v11, :cond_2a

    const/16 v11, 0x2b

    .line 78
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_2a
    const/16 v11, 0x2b

    if-ne v0, v11, :cond_2b

    const/16 v11, 0x71

    .line 79
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_2b
    const/16 v11, 0x2c

    if-ne v0, v11, :cond_2c

    const/16 v11, 0x94

    .line 80
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_2c
    const/16 v11, 0x2d

    if-ne v0, v11, :cond_2d

    .line 81
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0xf7

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_2d
    const/16 v11, 0x2e

    if-ne v0, v11, :cond_2e

    const/16 v11, 0xd9

    .line 82
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_2e
    const/16 v11, 0x2f

    if-ne v0, v11, :cond_2f

    const/16 v11, 0xb9

    .line 83
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_2f
    const/16 v11, 0x30

    if-ne v0, v11, :cond_30

    const/16 v11, 0x29

    .line 84
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_30
    const/16 v11, 0x31

    if-ne v0, v11, :cond_31

    const/16 v11, 0xb1

    .line 85
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_31
    const/16 v11, 0x32

    if-ne v0, v11, :cond_32

    const/16 v11, 0xef

    .line 86
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_32
    const/16 v11, 0x33

    if-ne v0, v11, :cond_33

    const/16 v11, 0xc

    .line 87
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_33
    const/16 v11, 0x34

    if-ne v0, v11, :cond_34

    const/16 v11, 0xe8

    .line 88
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_34
    const/16 v11, 0x35

    if-ne v0, v11, :cond_35

    const/16 v11, 0x65

    .line 89
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_35
    const/16 v11, 0x36

    if-ne v0, v11, :cond_36

    const/16 v11, 0x52

    .line 90
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_36
    const/16 v11, 0x37

    if-ne v0, v11, :cond_37

    const/16 v11, 0xb2

    .line 91
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_37
    const/16 v11, 0x38

    if-ne v0, v11, :cond_38

    const/16 v11, 0x80

    .line 92
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_38
    const/16 v11, 0x39

    if-ne v0, v11, :cond_39

    const/16 v11, 0xbf

    .line 93
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_39
    const/16 v11, 0x3a

    if-ne v0, v11, :cond_3a

    const/16 v11, 0x2a

    .line 94
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_3a
    const/16 v11, 0x3b

    if-ne v0, v11, :cond_3b

    .line 95
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0xac

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_3b
    const/16 v11, 0x3c

    if-ne v0, v11, :cond_3c

    const/16 v11, 0x88

    .line 96
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_3c
    const/16 v11, 0x3d

    if-ne v0, v11, :cond_3d

    const/16 v11, 0x51

    .line 97
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_3d
    const/16 v11, 0x3e

    if-ne v0, v11, :cond_3e

    const/16 v11, 0x73

    .line 98
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_3e
    const/16 v11, 0x3f

    if-ne v0, v11, :cond_3f

    .line 99
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0xfb

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_3f
    const/16 v11, 0x40

    if-ne v0, v11, :cond_40

    const/16 v11, 0x45

    .line 100
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_40
    const/16 v11, 0x41

    if-ne v0, v11, :cond_41

    const/16 v11, 0x59

    .line 101
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_41
    const/16 v11, 0x42

    if-ne v0, v11, :cond_42

    const/16 v11, 0x8b

    .line 102
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_42
    const/16 v11, 0x43

    if-ne v0, v11, :cond_43

    const/16 v11, 0x30

    .line 103
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_43
    const/16 v11, 0x44

    if-ne v0, v11, :cond_44

    const/16 v11, 0x81

    .line 104
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_44
    const/16 v11, 0x45

    if-ne v0, v11, :cond_45

    const/16 v11, 0x3f

    .line 105
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_45
    const/16 v11, 0x46

    if-ne v0, v11, :cond_46

    const/16 v11, 0x9a

    .line 106
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_46
    const/16 v11, 0x47

    if-ne v0, v11, :cond_47

    const/16 v11, 0x7d

    .line 107
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_47
    const/16 v11, 0x48

    if-ne v0, v11, :cond_48

    const/16 v11, 0xf2

    .line 108
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_48
    const/16 v11, 0x49

    if-ne v0, v11, :cond_49

    const/16 v11, 0x5f

    .line 109
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_49
    const/16 v11, 0x4a

    if-ne v0, v11, :cond_4a

    const/16 v11, 0x84

    .line 110
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_4a
    const/16 v11, 0x4b

    if-ne v0, v11, :cond_4b

    const/16 v11, 0x8f

    .line 111
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_4b
    const/16 v11, 0x4c

    if-ne v0, v11, :cond_4c

    const/16 v11, 0x66

    .line 112
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_4c
    const/16 v11, 0x4d

    if-ne v0, v11, :cond_4d

    const/16 v11, 0x1d

    .line 113
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_4d
    const/16 v11, 0x4e

    if-ne v0, v11, :cond_4e

    const/16 v11, 0xc7

    .line 114
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_4e
    const/16 v11, 0x4f

    if-ne v0, v11, :cond_4f

    const/16 v11, 0xa

    .line 115
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_4f
    const/16 v11, 0x50

    if-ne v0, v11, :cond_50

    .line 116
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0x92

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_50
    const/16 v11, 0x51

    if-ne v0, v11, :cond_51

    const/16 v11, 0x4f

    .line 117
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_51
    const/16 v11, 0x52

    if-ne v0, v11, :cond_52

    const/16 v11, 0xe1

    .line 118
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_52
    const/16 v11, 0x53

    if-ne v0, v11, :cond_53

    const/16 v11, 0x95

    .line 119
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_53
    const/16 v11, 0x54

    if-ne v0, v11, :cond_54

    .line 120
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0xec

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_54
    const/16 v11, 0x55

    if-ne v0, v11, :cond_55

    const/16 v11, 0xf5

    .line 121
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_55
    const/16 v11, 0x56

    if-ne v0, v11, :cond_56

    const/16 v11, 0x38

    .line 122
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_56
    const/16 v11, 0x57

    if-ne v0, v11, :cond_57

    const/16 v11, 0x69

    .line 123
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_57
    const/16 v11, 0x58

    if-ne v0, v11, :cond_58

    const/16 v11, 0x1b

    .line 124
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_58
    const/16 v11, 0x59

    if-ne v0, v11, :cond_59

    const/16 v11, 0xeb

    .line 125
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_59
    const/16 v11, 0x5a

    if-ne v0, v11, :cond_5a

    const/16 v11, 0xa2

    .line 126
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_5a
    const/16 v11, 0x5b

    if-ne v0, v11, :cond_5b

    const/16 v11, 0xc9

    .line 127
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_5b
    const/16 v11, 0x5c

    if-ne v0, v11, :cond_5c

    const/16 v11, 0xc1

    .line 128
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_5c
    const/16 v11, 0x5d

    if-ne v0, v11, :cond_5d

    const/16 v11, 0xd0

    .line 129
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_5d
    const/16 v11, 0x5e

    if-ne v0, v11, :cond_5e

    const/16 v11, 0x68

    .line 130
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_5e
    const/16 v11, 0x5f

    if-ne v0, v11, :cond_5f

    const/16 v11, 0x60

    .line 131
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_5f
    const/16 v11, 0x60

    if-ne v0, v11, :cond_60

    const/16 v11, 0xd1

    .line 132
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_60
    if-ne v0, v12, :cond_61

    const/16 v11, 0x9b

    .line 133
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_61
    const/16 v11, 0x62

    if-ne v0, v11, :cond_62

    const/16 v11, 0x22

    .line 134
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_62
    const/16 v11, 0x63

    if-ne v0, v11, :cond_63

    const/16 v11, 0x44

    .line 135
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_63
    const/16 v11, 0x64

    if-ne v0, v11, :cond_64

    .line 136
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0xca

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_64
    const/16 v11, 0x65

    if-ne v0, v11, :cond_65

    const/16 v11, 0xa9

    .line 137
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_65
    const/16 v11, 0x66

    if-ne v0, v11, :cond_66

    const/16 v11, 0x31

    .line 138
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_66
    const/16 v11, 0x67

    if-ne v0, v11, :cond_67

    .line 139
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v9, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_67
    const/16 v11, 0x68

    if-ne v0, v11, :cond_68

    const/16 v11, 0x86

    .line 140
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_68
    const/16 v11, 0x69

    if-ne v0, v11, :cond_69

    const/16 v11, 0x2d

    .line 141
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_69
    const/16 v11, 0x6a

    if-ne v0, v11, :cond_6a

    const/16 v11, 0xe2

    .line 142
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_6a
    const/16 v11, 0x6b

    if-ne v0, v11, :cond_6b

    .line 143
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0xff

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_6b
    const/16 v11, 0x6c

    if-ne v0, v11, :cond_6c

    const/16 v11, 0xe

    .line 144
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_6c
    const/16 v11, 0x6d

    if-ne v0, v11, :cond_6d

    const/16 v11, 0x34

    .line 145
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_6d
    const/16 v11, 0x6e

    if-ne v0, v11, :cond_6e

    const/16 v11, 0x21

    .line 146
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_6e
    const/16 v11, 0x6f

    if-ne v0, v11, :cond_6f

    const/16 v11, 0x3e

    .line 147
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_6f
    const/16 v11, 0x70

    if-ne v0, v11, :cond_70

    const/16 v11, 0x2c

    .line 148
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_70
    const/16 v11, 0x71

    if-ne v0, v11, :cond_71

    const/16 v11, 0xba

    .line 149
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_71
    const/16 v11, 0x72

    if-ne v0, v11, :cond_72

    .line 150
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v14, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_72
    const/16 v11, 0x73

    if-ne v0, v11, :cond_73

    const/16 v11, 0x79

    .line 151
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_73
    const/16 v11, 0x74

    if-ne v0, v11, :cond_74

    const/16 v11, 0x15

    .line 152
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_74
    const/16 v11, 0x75

    if-ne v0, v11, :cond_75

    const/16 v11, 0xf4

    .line 153
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_75
    const/16 v11, 0x76

    if-ne v0, v11, :cond_76

    const/16 v11, 0x83

    .line 154
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_76
    const/16 v11, 0x77

    if-ne v0, v11, :cond_77

    const/16 v11, 0x40

    .line 155
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_77
    const/16 v11, 0x78

    if-ne v0, v11, :cond_78

    const/16 v11, 0x6f

    .line 156
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_78
    const/16 v11, 0x79

    if-ne v0, v11, :cond_79

    const/16 v11, 0x7b

    .line 157
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_79
    const/16 v11, 0x7a

    if-ne v0, v11, :cond_7a

    const/16 v11, 0xf8

    .line 158
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_7a
    const/16 v11, 0x7b

    if-ne v0, v11, :cond_7b

    const/16 v11, 0x7c

    .line 159
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_7b
    const/16 v11, 0x7c

    if-ne v0, v11, :cond_7c

    const/16 v11, 0x24

    .line 160
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_7c
    const/16 v11, 0x7d

    if-ne v0, v11, :cond_7d

    const/16 v11, 0x9

    .line 161
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_7d
    const/16 v11, 0x7e

    if-ne v0, v11, :cond_7e

    const/16 v11, 0x3a

    .line 162
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_7e
    const/16 v11, 0x7f

    if-ne v0, v11, :cond_7f

    const/16 v11, 0x70

    .line 163
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_7f
    const/16 v11, 0x80

    if-ne v0, v11, :cond_80

    const/16 v11, 0xde

    .line 164
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_80
    const/16 v11, 0x81

    if-ne v0, v11, :cond_81

    .line 165
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0x82

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_81
    const/16 v15, 0x82

    if-ne v0, v15, :cond_82

    const/16 v11, 0xfe

    .line 166
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_82
    const/16 v11, 0x83

    if-ne v0, v11, :cond_83

    const/16 v11, 0x78

    .line 167
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_83
    const/16 v11, 0x84

    if-ne v0, v11, :cond_84

    const/16 v11, 0x4b

    .line 168
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_84
    const/16 v11, 0x85

    if-ne v0, v11, :cond_85

    const/16 v11, 0xe0

    .line 169
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_85
    const/16 v11, 0x86

    if-ne v0, v11, :cond_86

    const/16 v11, 0x4c

    .line 170
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_86
    const/16 v11, 0x87

    if-ne v0, v11, :cond_87

    const/16 v11, 0x91

    .line 171
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_87
    const/16 v11, 0x88

    if-ne v0, v11, :cond_88

    const/16 v11, 0x50

    .line 172
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_88
    const/16 v11, 0x89

    if-ne v0, v11, :cond_89

    const/16 v11, 0xe7

    .line 173
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_89
    const/16 v11, 0x8a

    if-ne v0, v11, :cond_8a

    const/16 v11, 0xc6

    .line 174
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_8a
    const/16 v11, 0x8b

    if-ne v0, v11, :cond_8b

    const/16 v11, 0xdb

    .line 175
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_8b
    const/16 v11, 0x8c

    if-ne v0, v11, :cond_8c

    const/16 v11, 0xb6

    .line 176
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_8c
    const/16 v11, 0x8d

    if-ne v0, v11, :cond_8d

    const/16 v11, 0x18

    .line 177
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_8d
    const/16 v11, 0x8e

    if-ne v0, v11, :cond_8e

    const/16 v11, 0x7e

    .line 178
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_8e
    const/16 v11, 0x8f

    if-ne v0, v11, :cond_8f

    const/16 v11, 0x28

    .line 179
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_8f
    const/16 v11, 0x90

    if-ne v0, v11, :cond_90

    const/16 v11, 0xf6

    .line 180
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_90
    const/16 v11, 0x91

    if-ne v0, v11, :cond_91

    const/16 v11, 0xc0

    .line 181
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_91
    const/16 v11, 0x92

    if-ne v0, v11, :cond_92

    const/16 v11, 0x4e

    .line 182
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_92
    const/16 v11, 0x93

    if-ne v0, v11, :cond_93

    const/16 v11, 0xa6

    .line 183
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_93
    const/16 v11, 0x94

    if-ne v0, v11, :cond_94

    const/16 v11, 0x8c

    .line 184
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_94
    const/16 v11, 0x95

    if-ne v0, v11, :cond_95

    const/16 v11, 0x9e

    .line 185
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_95
    const/16 v11, 0x96

    if-ne v0, v11, :cond_96

    const/16 v11, 0xdf

    .line 186
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_96
    const/16 v11, 0x97

    if-ne v0, v11, :cond_97

    const/16 v11, 0x39

    .line 187
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_97
    const/16 v11, 0x98

    if-ne v0, v11, :cond_98

    const/16 v11, 0xcf

    .line 188
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_98
    const/16 v11, 0x99

    if-ne v0, v11, :cond_99

    const/16 v11, 0x5a

    .line 189
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_99
    const/16 v11, 0x9a

    if-ne v0, v11, :cond_9a

    const/16 v11, 0xa1

    .line 190
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_9a
    const/16 v11, 0x9b

    if-ne v0, v11, :cond_9b

    const/16 v11, 0x36

    .line 191
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_9b
    const/16 v11, 0x9c

    if-ne v0, v11, :cond_9c

    const/16 v11, 0x26

    .line 192
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_9c
    const/16 v11, 0x9d

    if-ne v0, v11, :cond_9d

    const/16 v11, 0xfc

    .line 193
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_9d
    const/16 v11, 0x9e

    if-ne v0, v11, :cond_9e

    const/16 v11, 0x48

    .line 194
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_9e
    const/16 v11, 0x9f

    if-ne v0, v11, :cond_9f

    const/16 v11, 0xcb

    .line 195
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_9f
    const/16 v11, 0xa0

    if-ne v0, v11, :cond_a0

    const/16 v11, 0x46

    .line 196
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a0
    const/16 v11, 0xa1

    if-ne v0, v11, :cond_a1

    const/16 v11, 0x55

    .line 197
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a1
    const/16 v11, 0xa2

    if-ne v0, v11, :cond_a2

    const/16 v11, 0xab

    .line 198
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a2
    const/16 v11, 0xa3

    if-ne v0, v11, :cond_a3

    const/16 v11, 0x6b

    .line 199
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a3
    const/16 v11, 0xa4

    if-ne v0, v11, :cond_a4

    const/16 v11, 0x62

    .line 200
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a4
    const/16 v11, 0xa5

    if-ne v0, v11, :cond_a5

    const/4 v11, 0x4

    .line 201
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a5
    const/16 v11, 0xa6

    if-ne v0, v11, :cond_a6

    const/16 v11, 0x33

    .line 202
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a6
    const/16 v11, 0xa7

    if-ne v0, v11, :cond_a7

    const/16 v11, 0xbc

    .line 203
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a7
    const/16 v11, 0xa8

    if-ne v0, v11, :cond_a8

    const/16 v11, 0xee

    .line 204
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a8
    const/16 v11, 0xa9

    if-ne v0, v11, :cond_a9

    const/16 v11, 0xf

    .line 205
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_a9
    const/16 v11, 0xaa

    if-ne v0, v11, :cond_aa

    const/16 v11, 0x93

    .line 206
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_aa
    const/16 v11, 0xab

    if-ne v0, v11, :cond_ab

    const/16 v11, 0xed

    .line 207
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ab
    const/16 v11, 0xac

    if-ne v0, v11, :cond_ac

    .line 208
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0x41

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ac
    const/16 v11, 0xad

    if-ne v0, v11, :cond_ad

    const/16 v11, 0xd6

    .line 209
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ad
    const/16 v11, 0xae

    if-ne v0, v11, :cond_ae

    const/16 v11, 0x63

    .line 210
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ae
    const/16 v11, 0xaf

    if-ne v0, v11, :cond_af

    const/16 v11, 0xb7

    .line 211
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_af
    const/16 v11, 0xb0

    if-ne v0, v11, :cond_b0

    const/16 v11, 0x16

    .line 212
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b0
    const/16 v11, 0xb1

    if-ne v0, v11, :cond_b1

    const/4 v11, 0x5

    .line 213
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b1
    const/16 v11, 0xb2

    if-ne v0, v11, :cond_b2

    const/16 v11, 0x5c

    .line 214
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b2
    const/16 v11, 0xb3

    if-ne v0, v11, :cond_b3

    const/16 v11, 0x8d

    .line 215
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b3
    const/16 v11, 0xb4

    if-ne v0, v11, :cond_b4

    const/16 v11, 0xb8

    .line 216
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b4
    const/16 v11, 0xb5

    if-ne v0, v11, :cond_b5

    const/16 v11, 0x1e

    .line 217
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b5
    const/16 v11, 0xb6

    if-ne v0, v11, :cond_b6

    const/16 v11, 0x6c

    .line 218
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b6
    const/16 v11, 0xb7

    if-ne v0, v11, :cond_b7

    const/16 v11, 0x3c

    .line 219
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b7
    const/16 v11, 0xb8

    if-ne v0, v11, :cond_b8

    const/16 v11, 0x87

    .line 220
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b8
    const/16 v11, 0xb9

    if-ne v0, v11, :cond_b9

    const/16 v11, 0x76

    .line 221
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_b9
    const/16 v11, 0xba

    if-ne v0, v11, :cond_ba

    const/16 v11, 0x7f

    .line 222
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ba
    const/16 v11, 0xbb

    if-ne v0, v11, :cond_bb

    const/16 v11, 0xcd

    .line 223
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_bb
    const/16 v11, 0xbc

    if-ne v0, v11, :cond_bc

    const/16 v11, 0x85

    .line 224
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_bc
    const/16 v11, 0xbd

    if-ne v0, v11, :cond_bd

    const/16 v11, 0x9f

    .line 225
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_bd
    const/16 v11, 0xbe

    if-ne v0, v11, :cond_be

    const/16 v11, 0x13

    .line 226
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_be
    const/16 v11, 0xbf

    if-ne v0, v11, :cond_bf

    const/16 v11, 0xc5

    .line 227
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_bf
    const/16 v11, 0xc0

    if-ne v0, v11, :cond_c0

    const/16 v11, 0x4a

    .line 228
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c0
    const/16 v11, 0xc1

    if-ne v0, v11, :cond_c1

    const/16 v11, 0x11

    .line 229
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c1
    const/16 v11, 0xc2

    if-ne v0, v11, :cond_c2

    const/16 v11, 0x3b

    .line 230
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c2
    const/16 v11, 0xc3

    if-ne v0, v11, :cond_c3

    const/16 v11, 0x8a

    .line 231
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c3
    const/16 v11, 0xc4

    if-ne v0, v11, :cond_c4

    const/16 v11, 0xc3

    .line 232
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c4
    const/16 v11, 0xc5

    if-ne v0, v11, :cond_c5

    const/16 v11, 0x77

    .line 233
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c5
    const/16 v11, 0xc6

    if-ne v0, v11, :cond_c6

    const/16 v11, 0x8

    .line 234
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c6
    const/16 v11, 0xc7

    if-ne v0, v11, :cond_c7

    const/16 v11, 0x19

    .line 235
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c7
    const/16 v11, 0xc8

    if-ne v0, v11, :cond_c8

    const/16 v11, 0xce

    .line 236
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c8
    const/16 v11, 0xc9

    if-ne v0, v11, :cond_c9

    const/16 v11, 0x37

    .line 237
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_c9
    const/16 v11, 0xca

    if-ne v0, v11, :cond_ca

    const/16 v11, 0x6a

    .line 238
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ca
    const/16 v11, 0xcb

    if-ne v0, v11, :cond_cb

    const/16 v11, 0x5b

    .line 239
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_cb
    const/16 v11, 0xcc

    if-ne v0, v11, :cond_cc

    const/16 v11, 0xa0

    .line 240
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_cc
    const/16 v11, 0xcd

    if-ne v0, v11, :cond_cd

    const/16 v11, 0x7a

    .line 241
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_cd
    const/16 v11, 0xce

    if-ne v0, v11, :cond_ce

    const/16 v11, 0xda

    .line 242
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ce
    const/16 v11, 0xcf

    if-ne v0, v11, :cond_cf

    const/16 v11, 0x25

    .line 243
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_cf
    const/16 v11, 0xd0

    if-ne v0, v11, :cond_d0

    const/16 v11, 0xb5

    .line 244
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d0
    const/16 v11, 0xd1

    if-ne v0, v11, :cond_d1

    const/16 v11, 0xd3

    .line 245
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d1
    const/16 v11, 0xd2

    if-ne v0, v11, :cond_d2

    const/16 v11, 0xd4

    .line 246
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d2
    const/16 v11, 0xd3

    if-ne v0, v11, :cond_d3

    const/16 v11, 0xea

    .line 247
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d3
    const/16 v11, 0xd4

    if-ne v0, v11, :cond_d4

    const/16 v11, 0xf1

    .line 248
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d4
    const/16 v11, 0xd5

    if-ne v0, v11, :cond_d5

    const/16 v11, 0x2e

    .line 249
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d5
    const/16 v11, 0xd6

    if-ne v0, v11, :cond_d6

    const/16 v11, 0x4d

    .line 250
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d6
    const/16 v11, 0xd7

    if-ne v0, v11, :cond_d7

    const/16 v11, 0xaa

    .line 251
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d7
    const/16 v11, 0xd8

    if-ne v0, v11, :cond_d8

    const/16 v11, 0xb

    .line 252
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d8
    const/16 v11, 0xd9

    if-ne v0, v11, :cond_d9

    const/16 v11, 0x6d

    .line 253
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_d9
    const/16 v11, 0xda

    if-ne v0, v11, :cond_da

    const/16 v11, 0x10

    .line 254
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_da
    const/16 v11, 0xdb

    if-ne v0, v11, :cond_db

    const/16 v11, 0xf9

    .line 255
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_db
    const/16 v11, 0xdc

    if-ne v0, v11, :cond_dc

    const/16 v11, 0xa8

    .line 256
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_dc
    const/16 v11, 0xdd

    if-ne v0, v11, :cond_dd

    const/16 v11, 0xe6

    .line 257
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_dd
    const/16 v11, 0xde

    if-ne v0, v11, :cond_de

    const/16 v11, 0xd7

    .line 258
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_de
    const/16 v11, 0xdf

    if-ne v0, v11, :cond_df

    const/16 v11, 0xae

    .line 259
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_df
    const/16 v11, 0xe0

    if-ne v0, v11, :cond_e0

    const/16 v11, 0xcc

    .line 260
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e0
    const/16 v11, 0xe1

    if-ne v0, v11, :cond_e1

    const/16 v11, 0xa4

    .line 261
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e1
    const/16 v11, 0xe2

    if-ne v0, v11, :cond_e2

    const/4 v11, 0x2

    .line 262
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e2
    const/16 v11, 0xe3

    if-ne v0, v11, :cond_e3

    const/16 v11, 0xfd

    .line 263
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e3
    const/16 v11, 0xe4

    if-ne v0, v11, :cond_e4

    const/16 v11, 0x5e

    .line 264
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e4
    const/16 v11, 0xe5

    if-ne v0, v11, :cond_e5

    const/16 v11, 0x1f

    .line 265
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e5
    const/16 v11, 0xe6

    if-ne v0, v11, :cond_e6

    const/16 v11, 0xbd

    .line 266
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e6
    const/16 v11, 0xe7

    if-ne v0, v11, :cond_e7

    const/16 v11, 0x23

    .line 267
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e7
    const/16 v11, 0xe8

    if-ne v0, v11, :cond_e8

    const/16 v11, 0x99

    .line 268
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e8
    const/16 v11, 0xe9

    if-ne v0, v11, :cond_e9

    const/16 v11, 0xb4

    .line 269
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_e9
    const/16 v11, 0xea

    if-ne v0, v11, :cond_ea

    const/16 v11, 0x67

    .line 270
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ea
    const/16 v11, 0xeb

    if-ne v0, v11, :cond_eb

    .line 271
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v15, 0x8e

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_eb
    const/16 v11, 0xec

    if-ne v0, v11, :cond_ec

    .line 272
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v13, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ec
    const/16 v11, 0xed

    if-ne v0, v11, :cond_ed

    const/16 v11, 0x89

    .line 273
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ed
    const/16 v11, 0xee

    if-ne v0, v11, :cond_ee

    const/16 v11, 0xbb

    .line 274
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ee
    const/16 v11, 0xef

    if-ne v0, v11, :cond_ef

    const/16 v11, 0x54

    .line 275
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_ef
    const/16 v11, 0xf0

    if-ne v0, v11, :cond_f0

    const/16 v11, 0xa5

    .line 276
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f0
    const/16 v11, 0xf1

    if-ne v0, v11, :cond_f1

    const/16 v11, 0x1a

    .line 277
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f1
    const/16 v11, 0xf2

    if-ne v0, v11, :cond_f2

    const/16 v11, 0x57

    .line 278
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f2
    const/16 v11, 0xf3

    if-ne v0, v11, :cond_f3

    const/16 v11, 0x5d

    .line 279
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f3
    const/16 v11, 0xf4

    if-ne v0, v11, :cond_f4

    const/16 v11, 0x53

    .line 280
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f4
    const/16 v11, 0xf5

    if-ne v0, v11, :cond_f5

    const/16 v11, 0x56

    .line 281
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f5
    const/16 v11, 0xf6

    if-ne v0, v11, :cond_f6

    .line 282
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/4 v15, 0x0

    invoke-static {v15, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f6
    const/16 v11, 0xf7

    if-ne v0, v11, :cond_f7

    const/16 v11, 0x97

    .line 283
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f7
    const/16 v11, 0xf8

    if-ne v0, v11, :cond_f8

    const/4 v11, 0x3

    .line 284
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f8
    const/16 v11, 0xf9

    if-ne v0, v11, :cond_f9

    const/16 v11, 0xa7

    .line 285
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_0

    :cond_f9
    const/16 v11, 0xfa

    if-ne v0, v11, :cond_fa

    const/16 v11, 0x35

    .line 286
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_0

    :cond_fa
    const/16 v11, 0xfb

    if-ne v0, v11, :cond_fb

    const/16 v11, 0xb0

    .line 287
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_0

    :cond_fb
    const/16 v11, 0xfc

    if-ne v0, v11, :cond_fc

    const/16 v11, 0xe3

    .line 288
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_0

    :cond_fc
    const/16 v11, 0xfd

    if-ne v0, v11, :cond_fd

    const/16 v11, 0xa3

    .line 289
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_0

    :cond_fd
    const/16 v11, 0xfe

    if-ne v0, v11, :cond_fe

    const/16 v11, 0xe5

    .line 290
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v11, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_0

    :cond_fe
    const/16 v11, 0xff

    if-ne v0, v11, :cond_ff

    const/16 v15, 0x3d

    .line 291
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v15, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m0(II)I

    move-result v12

    goto :goto_0

    :cond_ff
    const/4 v12, 0x0

    :goto_0
    and-int/2addr v12, v11

    const/16 v11, 0xac

    if-eq v12, v11, :cond_100

    const/4 v11, 0x0

    return v11

    .line 296
    :cond_100
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->scramble(I)I

    move-result v10

    if-nez v1, :cond_101

    const/16 v11, 0x1d

    .line 297
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_101
    if-ne v1, v13, :cond_102

    const/16 v11, 0x83

    .line 298
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_102
    const/4 v11, 0x2

    if-ne v1, v11, :cond_103

    const/16 v11, 0xae

    .line 299
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_103
    const/4 v11, 0x3

    if-ne v1, v11, :cond_104

    const/16 v11, 0x52

    .line 300
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_104
    const/4 v11, 0x4

    if-ne v1, v11, :cond_105

    const/16 v11, 0xc8

    .line 301
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_105
    const/4 v11, 0x5

    if-ne v1, v11, :cond_106

    const/16 v11, 0xb7

    .line 302
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_106
    if-ne v1, v14, :cond_107

    const/16 v11, 0xb3

    .line 303
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_107
    const/4 v11, 0x7

    if-ne v1, v11, :cond_108

    const/16 v11, 0x8f

    .line 304
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_108
    const/16 v11, 0x8

    if-ne v1, v11, :cond_109

    const/16 v11, 0xb6

    .line 305
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_109
    const/16 v11, 0x9

    if-ne v1, v11, :cond_10a

    const/16 v11, 0xd8

    .line 306
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_10a
    const/16 v11, 0xa

    if-ne v1, v11, :cond_10b

    const/16 v11, 0x9

    .line 307
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_10b
    const/16 v11, 0xb

    if-ne v1, v11, :cond_10c

    const/16 v11, 0x4f

    .line 308
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_10c
    const/16 v11, 0xc

    if-ne v1, v11, :cond_10d

    const/16 v11, 0x2c

    .line 309
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_10d
    if-ne v1, v9, :cond_10e

    const/16 v11, 0xcb

    .line 310
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_10e
    const/16 v11, 0xe

    if-ne v1, v11, :cond_10f

    const/16 v11, 0xa7

    .line 311
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_10f
    const/16 v11, 0xf

    if-ne v1, v11, :cond_110

    .line 312
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v14, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_110
    const/16 v11, 0x10

    if-ne v1, v11, :cond_111

    const/16 v11, 0x87

    .line 313
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_111
    const/16 v11, 0x11

    if-ne v1, v11, :cond_112

    const/16 v11, 0x3e

    .line 314
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_112
    const/16 v11, 0x12

    if-ne v1, v11, :cond_113

    const/4 v11, 0x4

    .line 315
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_113
    const/16 v11, 0x13

    if-ne v1, v11, :cond_114

    const/16 v11, 0x3a

    .line 316
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_114
    const/16 v11, 0x14

    if-ne v1, v11, :cond_115

    const/16 v11, 0xf2

    .line 317
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_115
    const/16 v11, 0x15

    if-ne v1, v11, :cond_116

    const/16 v11, 0x54

    .line 318
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_116
    const/16 v11, 0x16

    if-ne v1, v11, :cond_117

    const/16 v11, 0x48

    .line 319
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_117
    const/16 v11, 0x17

    if-ne v1, v11, :cond_118

    const/16 v11, 0xaf

    .line 320
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_118
    const/16 v11, 0x18

    if-ne v1, v11, :cond_119

    const/16 v11, 0xab

    .line 321
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_119
    const/16 v11, 0x19

    if-ne v1, v11, :cond_11a

    const/16 v11, 0x7e

    .line 322
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_11a
    const/16 v11, 0x1a

    if-ne v1, v11, :cond_11b

    const/16 v11, 0x8c

    .line 323
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_11b
    const/16 v11, 0x1b

    if-ne v1, v11, :cond_11c

    const/16 v11, 0xbc

    .line 324
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_11c
    const/16 v11, 0x1c

    if-ne v1, v11, :cond_11d

    const/16 v11, 0x12

    .line 325
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_11d
    const/16 v11, 0x1d

    if-ne v1, v11, :cond_11e

    const/16 v11, 0xfa

    .line 326
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_11e
    const/16 v11, 0x1e

    if-ne v1, v11, :cond_11f

    const/16 v11, 0x72

    .line 327
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_11f
    const/16 v11, 0x1f

    if-ne v1, v11, :cond_120

    const/16 v11, 0xcd

    .line 328
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_120
    const/16 v11, 0x20

    if-ne v1, v11, :cond_121

    const/16 v11, 0x89

    .line 329
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_121
    const/16 v11, 0x21

    if-ne v1, v11, :cond_122

    .line 330
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x8e

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_122
    const/16 v11, 0x22

    if-ne v1, v11, :cond_123

    const/16 v11, 0x10

    .line 331
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_123
    const/16 v11, 0x23

    if-ne v1, v11, :cond_124

    const/16 v11, 0xa3

    .line 332
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_124
    const/16 v11, 0x24

    if-ne v1, v11, :cond_125

    const/16 v11, 0x9f

    .line 333
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_125
    const/16 v11, 0x25

    if-ne v1, v11, :cond_126

    const/16 v11, 0x18

    .line 334
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_126
    const/16 v11, 0x26

    if-ne v1, v11, :cond_127

    const/16 v11, 0x69

    .line 335
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_127
    const/16 v11, 0x27

    if-ne v1, v11, :cond_128

    const/16 v11, 0x9a

    .line 336
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_128
    const/16 v11, 0x28

    if-ne v1, v11, :cond_129

    const/16 v11, 0xba

    .line 337
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_129
    const/16 v11, 0x29

    if-ne v1, v11, :cond_12a

    const/16 v11, 0xd1

    .line 338
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_12a
    const/16 v11, 0x2a

    if-ne v1, v11, :cond_12b

    const/16 v11, 0xa9

    .line 339
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_12b
    const/16 v11, 0x2b

    if-ne v1, v11, :cond_12c

    const/16 v11, 0x74

    .line 340
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_12c
    const/16 v11, 0x2c

    if-ne v1, v11, :cond_12d

    const/16 v11, 0x8a

    .line 341
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_12d
    const/16 v11, 0x2d

    if-ne v1, v11, :cond_12e

    const/16 v11, 0xce

    .line 342
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_12e
    const/16 v11, 0x2e

    if-ne v1, v11, :cond_12f

    const/16 v11, 0x39

    .line 343
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_12f
    const/16 v11, 0x2f

    if-ne v1, v11, :cond_130

    const/16 v11, 0xdb

    .line 344
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_130
    const/16 v11, 0x30

    if-ne v1, v11, :cond_131

    const/16 v11, 0x84

    .line 345
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_131
    const/16 v11, 0x31

    if-ne v1, v11, :cond_132

    const/16 v11, 0xea

    .line 346
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_132
    const/16 v11, 0x32

    if-ne v1, v11, :cond_133

    const/16 v11, 0x81

    .line 347
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_133
    const/16 v11, 0x33

    if-ne v1, v11, :cond_134

    const/16 v11, 0x7f

    .line 348
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_134
    const/16 v11, 0x34

    if-ne v1, v11, :cond_135

    .line 349
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xf7

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_135
    const/16 v11, 0x35

    if-ne v1, v11, :cond_136

    const/16 v11, 0x1c

    .line 350
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_136
    const/16 v11, 0x36

    if-ne v1, v11, :cond_137

    const/16 v11, 0x31

    .line 351
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_137
    const/16 v11, 0x37

    if-ne v1, v11, :cond_138

    const/16 v11, 0xb2

    .line 352
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_138
    const/16 v11, 0x38

    if-ne v1, v11, :cond_139

    const/4 v11, 0x5

    .line 353
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_139
    const/16 v11, 0x39

    if-ne v1, v11, :cond_13a

    const/16 v11, 0x25

    .line 354
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_13a
    const/16 v11, 0x3a

    if-ne v1, v11, :cond_13b

    const/16 v11, 0x5d

    .line 355
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_13b
    const/16 v11, 0x3b

    if-ne v1, v11, :cond_13c

    const/16 v11, 0x94

    .line 356
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_13c
    const/16 v11, 0x3c

    if-ne v1, v11, :cond_13d

    const/16 v11, 0x19

    .line 357
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_13d
    const/16 v11, 0x3d

    if-ne v1, v11, :cond_13e

    const/16 v11, 0xee

    .line 358
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_13e
    const/16 v11, 0x3e

    if-ne v1, v11, :cond_13f

    const/16 v11, 0x76

    .line 359
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_13f
    const/16 v11, 0x3f

    if-ne v1, v11, :cond_140

    const/16 v11, 0x32

    .line 360
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_140
    const/16 v11, 0x40

    if-ne v1, v11, :cond_141

    const/16 v11, 0xa6

    .line 361
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_141
    const/16 v11, 0x41

    if-ne v1, v11, :cond_142

    const/16 v11, 0x66

    .line 362
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_142
    const/16 v11, 0x42

    if-ne v1, v11, :cond_143

    .line 363
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x92

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_143
    const/16 v11, 0x43

    if-ne v1, v11, :cond_144

    const/16 v11, 0xe7

    .line 364
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_144
    const/16 v11, 0x44

    if-ne v1, v11, :cond_145

    const/16 v11, 0x51

    .line 365
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_145
    const/16 v11, 0x45

    if-ne v1, v11, :cond_146

    const/16 v11, 0x56

    .line 366
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_146
    const/16 v11, 0x46

    if-ne v1, v11, :cond_147

    const/16 v11, 0xc9

    .line 367
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_147
    const/16 v11, 0x47

    if-ne v1, v11, :cond_148

    const/16 v11, 0x21

    .line 368
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_148
    const/16 v11, 0x48

    if-ne v1, v11, :cond_149

    const/16 v11, 0xc5

    .line 369
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_149
    const/16 v11, 0x49

    if-ne v1, v11, :cond_14a

    const/16 v11, 0xb5

    .line 370
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_14a
    const/16 v11, 0x4a

    if-ne v1, v11, :cond_14b

    const/16 v11, 0x9b

    .line 371
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_14b
    const/16 v11, 0x4b

    if-ne v1, v11, :cond_14c

    const/16 v11, 0x85

    .line 372
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_14c
    const/16 v11, 0x4c

    if-ne v1, v11, :cond_14d

    const/16 v11, 0x55

    .line 373
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_14d
    const/16 v11, 0x4d

    if-ne v1, v11, :cond_14e

    const/16 v11, 0xe0

    .line 374
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_14e
    const/16 v11, 0x4e

    if-ne v1, v11, :cond_14f

    const/16 v11, 0xb0

    .line 375
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_14f
    const/16 v11, 0x4f

    if-ne v1, v11, :cond_150

    const/16 v11, 0xd0

    .line 376
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_150
    const/16 v11, 0x50

    if-ne v1, v11, :cond_151

    const/16 v11, 0xaa

    .line 377
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_151
    const/16 v11, 0x51

    if-ne v1, v11, :cond_152

    const/16 v11, 0x63

    .line 378
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_152
    const/16 v11, 0x52

    if-ne v1, v11, :cond_153

    const/16 v11, 0x28

    .line 379
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_153
    const/16 v11, 0x53

    if-ne v1, v11, :cond_154

    const/16 v11, 0x26

    .line 380
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_154
    const/16 v11, 0x54

    if-ne v1, v11, :cond_155

    const/16 v11, 0xcc

    .line 381
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_155
    const/16 v11, 0x55

    if-ne v1, v11, :cond_156

    const/16 v11, 0xc2

    .line 382
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_156
    const/16 v11, 0x56

    if-ne v1, v11, :cond_157

    const/16 v11, 0x4a

    .line 383
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_157
    const/16 v11, 0x57

    if-ne v1, v11, :cond_158

    const/16 v11, 0xde

    .line 384
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_158
    const/16 v11, 0x58

    if-ne v1, v11, :cond_159

    const/16 v11, 0x90

    .line 385
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_159
    const/16 v11, 0x59

    if-ne v1, v11, :cond_15a

    const/16 v11, 0x91

    .line 386
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_15a
    const/16 v11, 0x5a

    if-ne v1, v11, :cond_15b

    const/16 v11, 0xd4

    .line 387
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_15b
    const/16 v11, 0x5b

    if-ne v1, v11, :cond_15c

    const/16 v11, 0xa1

    .line 388
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_15c
    const/16 v11, 0x5c

    if-ne v1, v11, :cond_15d

    const/16 v11, 0x8d

    .line 389
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_15d
    const/16 v11, 0x5d

    if-ne v1, v11, :cond_15e

    const/4 v11, 0x7

    .line 390
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_15e
    const/16 v11, 0x5e

    if-ne v1, v11, :cond_15f

    const/16 v11, 0x7b

    .line 391
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_15f
    const/16 v11, 0x5f

    if-ne v1, v11, :cond_160

    const/16 v11, 0x5c

    .line 392
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_160
    const/16 v11, 0x60

    if-ne v1, v11, :cond_161

    const/16 v11, 0x1a

    .line 393
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_161
    const/16 v11, 0x61

    if-ne v1, v11, :cond_162

    const/16 v11, 0xb9

    .line 394
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_162
    const/16 v11, 0x62

    if-ne v1, v11, :cond_163

    const/16 v11, 0x65

    .line 395
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_163
    const/16 v11, 0x63

    if-ne v1, v11, :cond_164

    const/16 v11, 0x77

    .line 396
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_164
    const/16 v11, 0x64

    if-ne v1, v11, :cond_165

    const/16 v11, 0xdf

    .line 397
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_165
    const/16 v11, 0x65

    if-ne v1, v11, :cond_166

    const/16 v11, 0xa4

    .line 398
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_166
    const/16 v11, 0x66

    if-ne v1, v11, :cond_167

    const/16 v11, 0x1f

    .line 399
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_167
    const/16 v11, 0x67

    if-ne v1, v11, :cond_168

    .line 400
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xac

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_168
    const/16 v11, 0x68

    if-ne v1, v11, :cond_169

    const/16 v11, 0xf9

    .line 401
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_169
    const/16 v11, 0x69

    if-ne v1, v11, :cond_16a

    const/16 v11, 0x2b

    .line 402
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_16a
    const/16 v11, 0x6a

    if-ne v1, v11, :cond_16b

    const/16 v11, 0x58

    .line 403
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_16b
    const/16 v11, 0x6b

    if-ne v1, v11, :cond_16c

    const/16 v11, 0x8

    .line 404
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_16c
    const/16 v11, 0x6c

    if-ne v1, v11, :cond_16d

    const/16 v11, 0x13

    .line 405
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_16d
    const/16 v11, 0x6d

    if-ne v1, v11, :cond_16e

    const/16 v11, 0x3d

    .line 406
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_16e
    const/16 v11, 0x6e

    if-ne v1, v11, :cond_16f

    const/16 v11, 0xf1

    .line 407
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_16f
    const/16 v11, 0x6f

    if-ne v1, v11, :cond_170

    const/16 v11, 0x4c

    .line 408
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_170
    const/16 v11, 0x70

    if-ne v1, v11, :cond_171

    const/16 v11, 0x9d

    .line 409
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_171
    const/16 v11, 0x71

    if-ne v1, v11, :cond_172

    const/16 v11, 0x2f

    .line 410
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_172
    const/16 v11, 0x72

    if-ne v1, v11, :cond_173

    const/16 v11, 0x6f

    .line 411
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_173
    const/16 v11, 0x73

    if-ne v1, v11, :cond_174

    .line 412
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x82

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_174
    const/16 v11, 0x74

    if-ne v1, v11, :cond_175

    const/16 v11, 0x3c

    .line 413
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_175
    const/16 v11, 0x75

    if-ne v1, v11, :cond_176

    const/16 v11, 0x78

    .line 414
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_176
    const/16 v11, 0x76

    if-ne v1, v11, :cond_177

    const/16 v11, 0xfc

    .line 415
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_177
    const/16 v11, 0x77

    if-ne v1, v11, :cond_178

    const/16 v11, 0x5a

    .line 416
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_178
    const/16 v11, 0x78

    if-ne v1, v11, :cond_179

    const/16 v11, 0x75

    .line 417
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_179
    const/16 v11, 0x79

    if-ne v1, v11, :cond_17a

    const/16 v11, 0xcf

    .line 418
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_17a
    const/16 v11, 0x7a

    if-ne v1, v11, :cond_17b

    const/16 v11, 0xc0

    .line 419
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_17b
    const/16 v11, 0x7b

    if-ne v1, v11, :cond_17c

    const/16 v11, 0xbd

    .line 420
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_17c
    const/16 v11, 0x7c

    if-ne v1, v11, :cond_17d

    const/16 v11, 0x9e

    .line 421
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_17d
    const/16 v11, 0x7d

    if-ne v1, v11, :cond_17e

    const/16 v11, 0x17

    .line 422
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_17e
    const/16 v11, 0x7e

    if-ne v1, v11, :cond_17f

    const/16 v11, 0xfd

    .line 423
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_17f
    const/16 v11, 0x7f

    if-ne v1, v11, :cond_180

    const/16 v11, 0xc7

    .line 424
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_180
    const/16 v11, 0x80

    if-ne v1, v11, :cond_181

    const/16 v11, 0x50

    .line 425
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_181
    const/16 v11, 0x81

    if-ne v1, v11, :cond_182

    const/16 v11, 0x6a

    .line 426
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_182
    const/16 v11, 0x82

    if-ne v1, v11, :cond_183

    const/16 v11, 0x29

    .line 427
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_183
    const/16 v11, 0x83

    if-ne v1, v11, :cond_184

    const/16 v11, 0xa0

    .line 428
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_184
    const/16 v11, 0x84

    if-ne v1, v11, :cond_185

    const/16 v11, 0xdd

    .line 429
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_185
    const/16 v11, 0x85

    if-ne v1, v11, :cond_186

    const/16 v11, 0xe9

    .line 430
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_186
    const/16 v11, 0x86

    if-ne v1, v11, :cond_187

    const/16 v11, 0x47

    .line 431
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_187
    const/16 v11, 0x87

    if-ne v1, v11, :cond_188

    .line 432
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/4 v12, 0x0

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_188
    const/16 v11, 0x88

    if-ne v1, v11, :cond_189

    const/16 v11, 0x24

    .line 433
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_189
    const/16 v11, 0x89

    if-ne v1, v11, :cond_18a

    const/16 v11, 0x20

    .line 434
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_18a
    const/16 v11, 0x8a

    if-ne v1, v11, :cond_18b

    const/16 v11, 0xe6

    .line 435
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_18b
    const/16 v11, 0x8b

    if-ne v1, v11, :cond_18c

    const/16 v11, 0xf6

    .line 436
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_18c
    const/16 v11, 0x8c

    if-ne v1, v11, :cond_18d

    const/16 v11, 0x34

    .line 437
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_18d
    const/16 v11, 0x8d

    if-ne v1, v11, :cond_18e

    const/16 v11, 0xf8

    .line 438
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_18e
    const/16 v11, 0x8e

    if-ne v1, v11, :cond_18f

    const/16 v11, 0x93

    .line 439
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_18f
    const/16 v11, 0x8f

    if-ne v1, v11, :cond_190

    const/16 v11, 0x96

    .line 440
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_190
    const/16 v11, 0x90

    if-ne v1, v11, :cond_191

    const/16 v11, 0x5f

    .line 441
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_191
    const/16 v11, 0x91

    if-ne v1, v11, :cond_192

    const/16 v11, 0x57

    .line 442
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_192
    const/16 v11, 0x92

    if-ne v1, v11, :cond_193

    const/16 v11, 0x68

    .line 443
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_193
    const/16 v11, 0x93

    if-ne v1, v11, :cond_194

    const/16 v11, 0x22

    .line 444
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_194
    const/16 v11, 0x94

    if-ne v1, v11, :cond_195

    const/16 v11, 0xe8

    .line 445
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_195
    const/16 v11, 0x95

    if-ne v1, v11, :cond_196

    const/16 v11, 0xe5

    .line 446
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_196
    const/16 v11, 0x96

    if-ne v1, v11, :cond_197

    .line 447
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xca

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_197
    const/16 v11, 0x97

    if-ne v1, v11, :cond_198

    const/16 v11, 0x3f

    .line 448
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_198
    const/16 v11, 0x98

    if-ne v1, v11, :cond_199

    const/16 v11, 0x42

    .line 449
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_199
    const/16 v11, 0x99

    if-ne v1, v11, :cond_19a

    const/16 v11, 0x27

    .line 450
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_19a
    const/16 v11, 0x9a

    if-ne v1, v11, :cond_19b

    const/16 v11, 0xa8

    .line 451
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_19b
    const/16 v11, 0x9b

    if-ne v1, v11, :cond_19c

    const/16 v11, 0x6c

    .line 452
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_19c
    const/16 v11, 0x9c

    if-ne v1, v11, :cond_19d

    const/16 v11, 0x8b

    .line 453
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_19d
    const/16 v11, 0x9d

    if-ne v1, v11, :cond_19e

    const/16 v11, 0x16

    .line 454
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_19e
    const/16 v11, 0x9e

    if-ne v1, v11, :cond_19f

    const/16 v11, 0xf4

    .line 455
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_19f
    const/16 v11, 0x9f

    if-ne v1, v11, :cond_1a0

    const/16 v11, 0x4b

    .line 456
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a0
    const/16 v11, 0xa0

    if-ne v1, v11, :cond_1a1

    const/16 v11, 0xbe

    .line 457
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a1
    const/16 v11, 0xa1

    if-ne v1, v11, :cond_1a2

    const/16 v11, 0x62

    .line 458
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a2
    const/16 v11, 0xa2

    if-ne v1, v11, :cond_1a3

    const/16 v11, 0x7c

    .line 459
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a3
    const/16 v11, 0xa3

    if-ne v1, v11, :cond_1a4

    const/16 v11, 0xed

    .line 460
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a4
    const/16 v11, 0xa4

    if-ne v1, v11, :cond_1a5

    const/16 v11, 0x4d

    .line 461
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a5
    const/16 v11, 0xa5

    if-ne v1, v11, :cond_1a6

    const/16 v11, 0xc1

    .line 462
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a6
    const/16 v11, 0xa6

    if-ne v1, v11, :cond_1a7

    const/16 v11, 0x95

    .line 463
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a7
    const/16 v11, 0xa7

    if-ne v1, v11, :cond_1a8

    const/16 v11, 0xb

    .line 464
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a8
    const/16 v11, 0xa8

    if-ne v1, v11, :cond_1a9

    const/16 v11, 0x64

    .line 465
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1a9
    const/16 v11, 0xa9

    if-ne v1, v11, :cond_1aa

    const/16 v11, 0xf0

    .line 466
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1aa
    const/16 v11, 0xaa

    if-ne v1, v11, :cond_1ab

    const/16 v11, 0xe3

    .line 467
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ab
    const/16 v11, 0xab

    if-ne v1, v11, :cond_1ac

    const/16 v11, 0x2a

    .line 468
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ac
    const/16 v11, 0xac

    if-ne v1, v11, :cond_1ad

    const/16 v11, 0x79

    .line 469
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ad
    const/16 v11, 0xad

    if-ne v1, v11, :cond_1ae

    const/16 v11, 0xa2

    .line 470
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ae
    const/16 v11, 0xae

    if-ne v1, v11, :cond_1af

    const/16 v11, 0x37

    .line 471
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1af
    const/16 v11, 0xaf

    if-ne v1, v11, :cond_1b0

    const/16 v11, 0xd7

    .line 472
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b0
    const/16 v11, 0xb0

    if-ne v1, v11, :cond_1b1

    const/16 v11, 0xa5

    .line 473
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b1
    const/16 v11, 0xb1

    if-ne v1, v11, :cond_1b2

    const/16 v11, 0x30

    .line 474
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b2
    const/16 v11, 0xb2

    if-ne v1, v11, :cond_1b3

    const/16 v11, 0x43

    .line 475
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b3
    const/16 v11, 0xb3

    if-ne v1, v11, :cond_1b4

    const/16 v11, 0xd3

    .line 476
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b4
    const/16 v11, 0xb4

    if-ne v1, v11, :cond_1b5

    const/16 v11, 0x23

    .line 477
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b5
    const/16 v11, 0xb5

    if-ne v1, v11, :cond_1b6

    const/16 v11, 0x38

    .line 478
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b6
    const/16 v11, 0xb6

    if-ne v1, v11, :cond_1b7

    const/16 v11, 0x46

    .line 479
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b7
    const/16 v11, 0xb7

    if-ne v1, v11, :cond_1b8

    const/16 v11, 0x36

    .line 480
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b8
    const/16 v11, 0xb8

    if-ne v1, v11, :cond_1b9

    const/16 v11, 0x4e

    .line 481
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1b9
    const/16 v11, 0xb9

    if-ne v1, v11, :cond_1ba

    const/16 v11, 0xe

    .line 482
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ba
    const/16 v11, 0xba

    if-ne v1, v11, :cond_1bb

    const/16 v11, 0x2d

    .line 483
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1bb
    const/16 v11, 0xbb

    if-ne v1, v11, :cond_1bc

    const/16 v11, 0xbb

    .line 484
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1bc
    const/16 v11, 0xbc

    if-ne v1, v11, :cond_1bd

    const/16 v11, 0x59

    .line 485
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1bd
    const/16 v11, 0xbd

    if-ne v1, v11, :cond_1be

    const/16 v11, 0xb8

    .line 486
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1be
    const/16 v11, 0xbe

    if-ne v1, v11, :cond_1bf

    const/16 v11, 0xd5

    .line 487
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1bf
    const/16 v11, 0xbf

    if-ne v1, v11, :cond_1c0

    .line 488
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xff

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c0
    const/16 v11, 0xc0

    if-ne v1, v11, :cond_1c1

    const/16 v11, 0x1b

    .line 489
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c1
    const/16 v11, 0xc1

    if-ne v1, v11, :cond_1c2

    const/16 v11, 0x60

    .line 490
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c2
    const/16 v11, 0xc2

    if-ne v1, v11, :cond_1c3

    .line 491
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v13, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c3
    const/16 v11, 0xc3

    if-ne v1, v11, :cond_1c4

    const/16 v11, 0x45

    .line 492
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c4
    const/16 v11, 0xc4

    if-ne v1, v11, :cond_1c5

    const/16 v11, 0x7a

    .line 493
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c5
    const/16 v11, 0xc5

    if-ne v1, v11, :cond_1c6

    const/16 v11, 0x7d

    .line 494
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c6
    const/16 v11, 0xc6

    if-ne v1, v11, :cond_1c7

    const/16 v11, 0x6e

    .line 495
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c7
    const/16 v11, 0xc7

    if-ne v1, v11, :cond_1c8

    const/16 v11, 0xd9

    .line 496
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c8
    const/16 v11, 0xc8

    if-ne v1, v11, :cond_1c9

    const/16 v11, 0xe4

    .line 497
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1c9
    const/16 v11, 0xc9

    if-ne v1, v11, :cond_1ca

    const/16 v11, 0x5b

    .line 498
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ca
    const/16 v11, 0xca

    if-ne v1, v11, :cond_1cb

    const/16 v11, 0x9c

    .line 499
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1cb
    const/16 v11, 0xcb

    if-ne v1, v11, :cond_1cc

    const/16 v11, 0x71

    .line 500
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1cc
    const/16 v11, 0xcc

    if-ne v1, v11, :cond_1cd

    const/16 v11, 0xf3

    .line 501
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1cd
    const/16 v11, 0xcd

    if-ne v1, v11, :cond_1ce

    .line 502
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x41

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ce
    const/16 v11, 0xce

    if-ne v1, v11, :cond_1cf

    const/16 v11, 0xc4

    .line 503
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1cf
    const/16 v11, 0xcf

    if-ne v1, v11, :cond_1d0

    const/16 v11, 0x40

    .line 504
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d0
    const/16 v11, 0xd0

    if-ne v1, v11, :cond_1d1

    const/4 v11, 0x3

    .line 505
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d1
    const/16 v11, 0xd1

    if-ne v1, v11, :cond_1d2

    const/16 v11, 0x80

    .line 506
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d2
    const/16 v11, 0xd2

    if-ne v1, v11, :cond_1d3

    const/16 v11, 0x6d

    .line 507
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d3
    const/16 v11, 0xd3

    if-ne v1, v11, :cond_1d4

    const/16 v11, 0xc

    .line 508
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d4
    const/16 v11, 0xd4

    if-ne v1, v11, :cond_1d5

    const/16 v11, 0x99

    .line 509
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d5
    const/16 v11, 0xd5

    if-ne v1, v11, :cond_1d6

    const/16 v11, 0xad

    .line 510
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d6
    const/16 v11, 0xd6

    if-ne v1, v11, :cond_1d7

    const/16 v11, 0x35

    .line 511
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d7
    const/16 v11, 0xd7

    if-ne v1, v11, :cond_1d8

    const/16 v11, 0x5e

    .line 512
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d8
    const/16 v11, 0xd8

    if-ne v1, v11, :cond_1d9

    const/16 v11, 0x44

    .line 513
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1d9
    const/16 v11, 0xd9

    if-ne v1, v11, :cond_1da

    .line 514
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x61

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1da
    const/16 v11, 0xda

    if-ne v1, v11, :cond_1db

    const/16 v11, 0x98

    .line 515
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1db
    const/16 v11, 0xdb

    if-ne v1, v11, :cond_1dc

    const/16 v11, 0x97

    .line 516
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1dc
    const/16 v11, 0xdc

    if-ne v1, v11, :cond_1dd

    const/4 v11, 0x2

    .line 517
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1dd
    const/16 v11, 0xdd

    if-ne v1, v11, :cond_1de

    const/16 v11, 0x49

    .line 518
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1de
    const/16 v11, 0xde

    if-ne v1, v11, :cond_1df

    const/16 v11, 0x6b

    .line 519
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1df
    const/16 v11, 0xdf

    if-ne v1, v11, :cond_1e0

    .line 520
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xec

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e0
    const/16 v11, 0xe0

    if-ne v1, v11, :cond_1e1

    const/16 v11, 0x11

    .line 521
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e1
    const/16 v11, 0xe1

    if-ne v1, v11, :cond_1e2

    const/16 v11, 0x2e

    .line 522
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e2
    const/16 v11, 0xe2

    if-ne v1, v11, :cond_1e3

    const/16 v11, 0x70

    .line 523
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e3
    const/16 v11, 0xe3

    if-ne v1, v11, :cond_1e4

    const/16 v11, 0xb1

    .line 524
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e4
    const/16 v11, 0xe4

    if-ne v1, v11, :cond_1e5

    const/16 v11, 0xa

    .line 525
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e5
    const/16 v11, 0xe5

    if-ne v1, v11, :cond_1e6

    const/16 v11, 0x67

    .line 526
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e6
    const/16 v11, 0xe6

    if-ne v1, v11, :cond_1e7

    const/16 v11, 0xe1

    .line 527
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e7
    const/16 v11, 0xe7

    if-ne v1, v11, :cond_1e8

    const/16 v11, 0xfe

    .line 528
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e8
    const/16 v11, 0xe8

    if-ne v1, v11, :cond_1e9

    const/16 v11, 0x88

    .line 529
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1e9
    const/16 v11, 0xe9

    if-ne v1, v11, :cond_1ea

    const/16 v11, 0xf5

    .line 530
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ea
    const/16 v11, 0xea

    if-ne v1, v11, :cond_1eb

    .line 531
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v9, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1eb
    const/16 v11, 0xeb

    if-ne v1, v11, :cond_1ec

    const/16 v11, 0xda

    .line 532
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ec
    const/16 v11, 0xec

    if-ne v1, v11, :cond_1ed

    const/16 v11, 0x73

    .line 533
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ed
    const/16 v11, 0xed

    if-ne v1, v11, :cond_1ee

    const/16 v11, 0xef

    .line 534
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ee
    const/16 v11, 0xee

    if-ne v1, v11, :cond_1ef

    const/16 v11, 0xc3

    .line 535
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1ef
    const/16 v11, 0xef

    if-ne v1, v11, :cond_1f0

    const/16 v11, 0xd6

    .line 536
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f0
    const/16 v11, 0xf0

    if-ne v1, v11, :cond_1f1

    const/16 v11, 0xb4

    .line 537
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f1
    const/16 v11, 0xf1

    if-ne v1, v11, :cond_1f2

    const/16 v11, 0x86

    .line 538
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f2
    const/16 v11, 0xf2

    if-ne v1, v11, :cond_1f3

    const/16 v11, 0x53

    .line 539
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f3
    const/16 v11, 0xf3

    if-ne v1, v11, :cond_1f4

    const/16 v11, 0x1e

    .line 540
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f4
    const/16 v11, 0xf4

    if-ne v1, v11, :cond_1f5

    const/16 v11, 0x3b

    .line 541
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f5
    const/16 v11, 0xf5

    if-ne v1, v11, :cond_1f6

    const/16 v11, 0x14

    .line 542
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f6
    const/16 v11, 0xf6

    if-ne v1, v11, :cond_1f7

    const/16 v11, 0x33

    .line 543
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f7
    const/16 v11, 0xf7

    if-ne v1, v11, :cond_1f8

    const/16 v11, 0xeb

    .line 544
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f8
    const/16 v11, 0xf8

    if-ne v1, v11, :cond_1f9

    const/16 v11, 0xbf

    .line 545
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1f9
    const/16 v11, 0xf9

    if-ne v1, v11, :cond_1fa

    const/16 v11, 0xe2

    .line 546
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_1

    :cond_1fa
    const/16 v11, 0xfa

    if-ne v1, v11, :cond_1fb

    const/16 v11, 0xf

    .line 547
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_1

    :cond_1fb
    const/16 v11, 0xfb

    if-ne v1, v11, :cond_1fc

    const/16 v12, 0x15

    .line 548
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v12, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v12

    const/16 v11, 0xff

    goto :goto_1

    :cond_1fc
    const/16 v12, 0xfc

    if-ne v1, v12, :cond_1fd

    .line 549
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v12

    const/16 v11, 0xff

    goto :goto_1

    :cond_1fd
    const/16 v11, 0xfd

    if-ne v1, v11, :cond_1fe

    const/16 v11, 0xd2

    .line 550
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_1

    :cond_1fe
    const/16 v11, 0xfe

    if-ne v1, v11, :cond_1ff

    const/16 v11, 0xc6

    .line 551
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_1

    :cond_1ff
    const/16 v11, 0xff

    if-ne v1, v11, :cond_200

    const/16 v12, 0xdc

    .line 552
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v12, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m1(II)I

    move-result v12

    goto :goto_1

    :cond_200
    const/4 v12, 0x0

    :goto_1
    and-int/2addr v12, v11

    if-eq v12, v14, :cond_201

    const/4 v12, 0x0

    return v12

    .line 557
    :cond_201
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->scramble(I)I

    move-result v10

    if-nez v2, :cond_202

    .line 558
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v12

    move v11, v12

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_202
    if-ne v2, v13, :cond_203

    const/16 v11, 0x1e

    .line 559
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_203
    const/4 v11, 0x2

    if-ne v2, v11, :cond_204

    const/16 v11, 0x62

    .line 560
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_204
    const/4 v11, 0x3

    if-ne v2, v11, :cond_205

    const/16 v11, 0x4e

    .line 561
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_205
    const/4 v11, 0x4

    if-ne v2, v11, :cond_206

    const/16 v11, 0xc6

    .line 562
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_206
    const/4 v11, 0x5

    if-ne v2, v11, :cond_207

    const/16 v11, 0x97

    .line 563
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_207
    if-ne v2, v14, :cond_208

    const/16 v11, 0xf

    .line 564
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_208
    const/4 v11, 0x7

    if-ne v2, v11, :cond_209

    const/16 v11, 0xab

    .line 565
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_209
    const/16 v11, 0x8

    if-ne v2, v11, :cond_20a

    const/16 v11, 0x5c

    .line 566
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_20a
    const/16 v11, 0x9

    if-ne v2, v11, :cond_20b

    .line 567
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xec

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_20b
    const/16 v11, 0xa

    if-ne v2, v11, :cond_20c

    const/16 v11, 0x5d

    .line 568
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_20c
    const/16 v11, 0xb

    if-ne v2, v11, :cond_20d

    const/16 v11, 0x88

    .line 569
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_20d
    const/16 v11, 0xc

    if-ne v2, v11, :cond_20e

    const/16 v11, 0xce

    .line 570
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_20e
    if-ne v2, v9, :cond_20f

    const/16 v11, 0xdc

    .line 571
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_20f
    const/16 v11, 0xe

    if-ne v2, v11, :cond_210

    const/16 v11, 0x38

    .line 572
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_210
    const/16 v11, 0xf

    if-ne v2, v11, :cond_211

    const/16 v11, 0x9c

    .line 573
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_211
    const/16 v11, 0x10

    if-ne v2, v11, :cond_212

    const/16 v11, 0x36

    .line 574
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_212
    const/16 v11, 0x11

    if-ne v2, v11, :cond_213

    const/16 v11, 0x32

    .line 575
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_213
    const/16 v11, 0x12

    if-ne v2, v11, :cond_214

    const/16 v11, 0x52

    .line 576
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_214
    const/16 v11, 0x13

    if-ne v2, v11, :cond_215

    const/16 v11, 0x70

    .line 577
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_215
    const/16 v11, 0x14

    if-ne v2, v11, :cond_216

    const/16 v11, 0x7b

    .line 578
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_216
    const/16 v11, 0x15

    if-ne v2, v11, :cond_217

    const/16 v11, 0xe

    .line 579
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_217
    const/16 v11, 0x16

    if-ne v2, v11, :cond_218

    const/16 v11, 0x4d

    .line 580
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_218
    const/16 v11, 0x17

    if-ne v2, v11, :cond_219

    const/16 v11, 0xc

    .line 581
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_219
    const/16 v11, 0x18

    if-ne v2, v11, :cond_21a

    const/16 v11, 0xb8

    .line 582
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_21a
    const/16 v11, 0x19

    if-ne v2, v11, :cond_21b

    const/16 v11, 0xd6

    .line 583
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_21b
    const/16 v11, 0x1a

    if-ne v2, v11, :cond_21c

    const/16 v11, 0xd0

    .line 584
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_21c
    const/16 v11, 0x1b

    if-ne v2, v11, :cond_21d

    const/16 v11, 0x91

    .line 585
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_21d
    const/16 v11, 0x1c

    if-ne v2, v11, :cond_21e

    const/16 v11, 0x42

    .line 586
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_21e
    const/16 v11, 0x1d

    if-ne v2, v11, :cond_21f

    const/16 v11, 0x28

    .line 587
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_21f
    const/16 v11, 0x1e

    if-ne v2, v11, :cond_220

    const/16 v11, 0x34

    .line 588
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_220
    const/16 v11, 0x1f

    if-ne v2, v11, :cond_221

    const/16 v11, 0xe0

    .line 589
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_221
    const/16 v11, 0x20

    if-ne v2, v11, :cond_222

    const/16 v11, 0xd5

    .line 590
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_222
    const/16 v11, 0x21

    if-ne v2, v11, :cond_223

    const/16 v11, 0x86

    .line 591
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_223
    const/16 v11, 0x22

    if-ne v2, v11, :cond_224

    const/16 v11, 0xe3

    .line 592
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_224
    const/16 v11, 0x23

    if-ne v2, v11, :cond_225

    const/16 v11, 0xfa

    .line 593
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_225
    const/16 v11, 0x24

    if-ne v2, v11, :cond_226

    const/16 v11, 0x16

    .line 594
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_226
    const/16 v11, 0x25

    if-ne v2, v11, :cond_227

    const/16 v11, 0x72

    .line 595
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_227
    const/16 v11, 0x26

    if-ne v2, v11, :cond_228

    const/16 v11, 0x4f

    .line 596
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_228
    const/16 v11, 0x27

    if-ne v2, v11, :cond_229

    const/16 v11, 0x8f

    .line 597
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_229
    const/16 v11, 0x28

    if-ne v2, v11, :cond_22a

    const/16 v11, 0xa

    .line 598
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_22a
    const/16 v11, 0x29

    if-ne v2, v11, :cond_22b

    const/16 v11, 0x37

    .line 599
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_22b
    const/16 v11, 0x2a

    if-ne v2, v11, :cond_22c

    const/16 v11, 0xae

    .line 600
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_22c
    const/16 v11, 0x2b

    if-ne v2, v11, :cond_22d

    const/16 v11, 0x1c

    .line 601
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_22d
    const/16 v11, 0x2c

    if-ne v2, v11, :cond_22e

    const/16 v11, 0x55

    .line 602
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_22e
    const/16 v11, 0x2d

    if-ne v2, v11, :cond_22f

    const/16 v11, 0xdd

    .line 603
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_22f
    const/16 v11, 0x2e

    if-ne v2, v11, :cond_230

    const/16 v11, 0x9a

    .line 604
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_230
    const/16 v11, 0x2f

    if-ne v2, v11, :cond_231

    const/16 v11, 0xf8

    .line 605
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_231
    const/16 v11, 0x30

    if-ne v2, v11, :cond_232

    const/16 v11, 0x54

    .line 606
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_232
    const/16 v11, 0x31

    if-ne v2, v11, :cond_233

    const/16 v11, 0xaf

    .line 607
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_233
    const/16 v11, 0x32

    if-ne v2, v11, :cond_234

    const/16 v11, 0xa8

    .line 608
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_234
    const/16 v11, 0x33

    if-ne v2, v11, :cond_235

    const/16 v11, 0x90

    .line 609
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_235
    const/16 v11, 0x34

    if-ne v2, v11, :cond_236

    const/16 v11, 0xb

    .line 610
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_236
    const/16 v11, 0x35

    if-ne v2, v11, :cond_237

    const/16 v11, 0x20

    .line 611
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_237
    const/16 v11, 0x36

    if-ne v2, v11, :cond_238

    const/16 v11, 0x40

    .line 612
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_238
    const/16 v11, 0x37

    if-ne v2, v11, :cond_239

    const/16 v11, 0xcf

    .line 613
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_239
    const/16 v11, 0x38

    if-ne v2, v11, :cond_23a

    const/16 v11, 0x93

    .line 614
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_23a
    const/16 v11, 0x39

    if-ne v2, v11, :cond_23b

    const/16 v11, 0x3a

    .line 615
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_23b
    const/16 v11, 0x3a

    if-ne v2, v11, :cond_23c

    const/16 v11, 0xb0

    .line 616
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_23c
    const/16 v11, 0x3b

    if-ne v2, v11, :cond_23d

    const/16 v11, 0x6f

    .line 617
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_23d
    const/16 v11, 0x3c

    if-ne v2, v11, :cond_23e

    const/16 v11, 0x6c

    .line 618
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_23e
    const/16 v11, 0x3d

    if-ne v2, v11, :cond_23f

    .line 619
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x8e

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_23f
    const/16 v11, 0x3e

    if-ne v2, v11, :cond_240

    const/16 v11, 0xd8

    .line 620
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_240
    const/16 v11, 0x3f

    if-ne v2, v11, :cond_241

    const/16 v11, 0xbb

    .line 621
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_241
    const/16 v11, 0x40

    if-ne v2, v11, :cond_242

    const/16 v11, 0x6e

    .line 622
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_242
    const/16 v11, 0x41

    if-ne v2, v11, :cond_243

    const/16 v11, 0xc3

    .line 623
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_243
    const/16 v11, 0x42

    if-ne v2, v11, :cond_244

    const/4 v11, 0x5

    .line 624
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_244
    const/16 v11, 0x43

    if-ne v2, v11, :cond_245

    const/16 v11, 0xdb

    .line 625
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_245
    const/16 v11, 0x44

    if-ne v2, v11, :cond_246

    const/16 v11, 0x48

    .line 626
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_246
    const/16 v11, 0x45

    if-ne v2, v11, :cond_247

    const/16 v11, 0xeb

    .line 627
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_247
    const/16 v11, 0x46

    if-ne v2, v11, :cond_248

    const/16 v11, 0x31

    .line 628
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_248
    const/16 v11, 0x47

    if-ne v2, v11, :cond_249

    const/16 v11, 0x78

    .line 629
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_249
    const/16 v11, 0x48

    if-ne v2, v11, :cond_24a

    const/16 v11, 0xe8

    .line 630
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_24a
    const/16 v11, 0x49

    if-ne v2, v11, :cond_24b

    const/16 v11, 0x2e

    .line 631
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_24b
    const/16 v11, 0x4a

    if-ne v2, v11, :cond_24c

    const/16 v11, 0x9b

    .line 632
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_24c
    const/16 v11, 0x4b

    if-ne v2, v11, :cond_24d

    const/16 v11, 0x17

    .line 633
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_24d
    const/16 v11, 0x4c

    if-ne v2, v11, :cond_24e

    const/16 v11, 0x1b

    .line 634
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_24e
    const/16 v11, 0x4d

    if-ne v2, v11, :cond_24f

    const/16 v11, 0xb9

    .line 635
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_24f
    const/16 v11, 0x4e

    if-ne v2, v11, :cond_250

    const/16 v11, 0xe9

    .line 636
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_250
    const/16 v11, 0x4f

    if-ne v2, v11, :cond_251

    const/16 v11, 0x39

    .line 637
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_251
    const/16 v11, 0x50

    if-ne v2, v11, :cond_252

    const/16 v11, 0xaa

    .line 638
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_252
    const/16 v11, 0x51

    if-ne v2, v11, :cond_253

    const/16 v11, 0x12

    .line 639
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_253
    const/16 v11, 0x52

    if-ne v2, v11, :cond_254

    const/16 v11, 0x47

    .line 640
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_254
    const/16 v11, 0x53

    if-ne v2, v11, :cond_255

    const/16 v11, 0xcb

    .line 641
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_255
    const/16 v11, 0x54

    if-ne v2, v11, :cond_256

    const/16 v11, 0x58

    .line 642
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_256
    const/16 v11, 0x55

    if-ne v2, v11, :cond_257

    const/16 v11, 0xc4

    .line 643
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_257
    const/16 v11, 0x56

    if-ne v2, v11, :cond_258

    const/16 v11, 0x8c

    .line 644
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_258
    const/16 v11, 0x57

    if-ne v2, v11, :cond_259

    const/16 v11, 0xdf

    .line 645
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_259
    const/16 v11, 0x58

    if-ne v2, v11, :cond_25a

    const/16 v11, 0x6d

    .line 646
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_25a
    const/16 v11, 0x59

    if-ne v2, v11, :cond_25b

    const/16 v11, 0x83

    .line 647
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_25b
    const/16 v11, 0x5a

    if-ne v2, v11, :cond_25c

    const/16 v11, 0x67

    .line 648
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_25c
    const/16 v11, 0x5b

    if-ne v2, v11, :cond_25d

    const/16 v11, 0x1a

    .line 649
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_25d
    const/16 v11, 0x5c

    if-ne v2, v11, :cond_25e

    .line 650
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xfb

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    goto/16 :goto_3

    :cond_25e
    const/16 v11, 0x5d

    if-ne v2, v11, :cond_25f

    const/16 v11, 0x30

    .line 651
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_25f
    const/16 v11, 0x5e

    if-ne v2, v11, :cond_260

    const/16 v11, 0xb4

    .line 652
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_260
    const/16 v11, 0x5f

    if-ne v2, v11, :cond_261

    const/16 v11, 0x53

    .line 653
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_261
    const/16 v11, 0x60

    if-ne v2, v11, :cond_262

    const/16 v11, 0x6a

    .line 654
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_262
    const/16 v11, 0x61

    if-ne v2, v11, :cond_263

    const/16 v11, 0x73

    .line 655
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_263
    const/16 v11, 0x62

    if-ne v2, v11, :cond_264

    .line 656
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x82

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_264
    const/16 v11, 0x63

    if-ne v2, v11, :cond_265

    const/16 v11, 0x10

    .line 657
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_265
    const/16 v11, 0x64

    if-ne v2, v11, :cond_266

    const/16 v11, 0x85

    .line 658
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_266
    const/16 v11, 0x65

    if-ne v2, v11, :cond_267

    const/16 v11, 0x2c

    .line 659
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_267
    const/16 v11, 0x66

    if-ne v2, v11, :cond_268

    const/16 v11, 0xa4

    .line 660
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_268
    const/16 v11, 0x67

    if-ne v2, v11, :cond_269

    const/16 v11, 0xf1

    .line 661
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_269
    const/16 v11, 0x68

    if-ne v2, v11, :cond_26a

    const/16 v11, 0xb6

    .line 662
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_26a
    const/16 v11, 0x69

    if-ne v2, v11, :cond_26b

    const/16 v11, 0x46

    .line 663
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_26b
    const/16 v11, 0x6a

    if-ne v2, v11, :cond_26c

    const/16 v11, 0xcc

    .line 664
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_26c
    const/16 v11, 0x6b

    if-ne v2, v11, :cond_26d

    const/16 v11, 0x9

    .line 665
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_26d
    const/16 v11, 0x6c

    if-ne v2, v11, :cond_26e

    const/16 v11, 0xda

    .line 666
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_26e
    const/16 v11, 0x6d

    if-ne v2, v11, :cond_26f

    const/16 v11, 0x6b

    .line 667
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_26f
    const/16 v11, 0x6e

    if-ne v2, v11, :cond_270

    const/16 v11, 0xb3

    .line 668
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_270
    const/16 v11, 0x6f

    if-ne v2, v11, :cond_271

    const/16 v11, 0xbc

    .line 669
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_271
    const/16 v11, 0x70

    if-ne v2, v11, :cond_272

    .line 670
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v14, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_272
    const/16 v11, 0x71

    if-ne v2, v11, :cond_273

    const/16 v11, 0xa0

    .line 671
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_273
    const/16 v11, 0x72

    if-ne v2, v11, :cond_274

    const/16 v11, 0xbe

    .line 672
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_274
    const/16 v11, 0x73

    if-ne v2, v11, :cond_275

    .line 673
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v9, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_275
    const/16 v11, 0x74

    if-ne v2, v11, :cond_276

    const/16 v11, 0xd1

    .line 674
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_276
    const/16 v11, 0x75

    if-ne v2, v11, :cond_277

    const/16 v11, 0xe6

    .line 675
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_277
    const/16 v11, 0x76

    if-ne v2, v11, :cond_278

    const/16 v11, 0x77

    .line 676
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_278
    const/16 v11, 0x77

    if-ne v2, v11, :cond_279

    const/16 v11, 0xc5

    .line 677
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_279
    const/16 v11, 0x78

    if-ne v2, v11, :cond_27a

    const/16 v11, 0xe2

    .line 678
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_27a
    const/16 v11, 0x79

    if-ne v2, v11, :cond_27b

    const/16 v11, 0x7c

    .line 679
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_27b
    const/16 v11, 0x7a

    if-ne v2, v11, :cond_27c

    const/16 v11, 0x79

    .line 680
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_27c
    const/16 v11, 0x7b

    if-ne v2, v11, :cond_27d

    const/16 v11, 0xf0

    .line 681
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_27d
    const/16 v11, 0x7c

    if-ne v2, v11, :cond_27e

    const/16 v11, 0x50

    .line 682
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_27e
    const/16 v11, 0x7d

    if-ne v2, v11, :cond_27f

    const/16 v11, 0xa3

    .line 683
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_27f
    const/16 v11, 0x7e

    if-ne v2, v11, :cond_280

    .line 684
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x61

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_280
    const/16 v11, 0x7f

    if-ne v2, v11, :cond_281

    const/16 v11, 0x26

    .line 685
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_281
    const/16 v11, 0x80

    if-ne v2, v11, :cond_282

    const/16 v11, 0x95

    .line 686
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_282
    const/16 v11, 0x81

    if-ne v2, v11, :cond_283

    const/16 v11, 0x5e

    .line 687
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_283
    const/16 v11, 0x82

    if-ne v2, v11, :cond_284

    .line 688
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xca

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_284
    const/16 v11, 0x83

    if-ne v2, v11, :cond_285

    const/16 v11, 0xf3

    .line 689
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_285
    const/16 v11, 0x84

    if-ne v2, v11, :cond_286

    const/16 v11, 0xc1

    .line 690
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_286
    const/16 v11, 0x85

    if-ne v2, v11, :cond_287

    const/16 v11, 0xee

    .line 691
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_287
    const/16 v11, 0x86

    if-ne v2, v11, :cond_288

    const/16 v11, 0xa7

    .line 692
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_288
    const/16 v11, 0x87

    if-ne v2, v11, :cond_289

    const/16 v11, 0x8a

    .line 693
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_289
    const/16 v11, 0x88

    if-ne v2, v11, :cond_28a

    const/16 v11, 0x94

    .line 694
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_28a
    const/16 v11, 0x89

    if-ne v2, v11, :cond_28b

    const/16 v11, 0x11

    .line 695
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_28b
    const/16 v11, 0x8a

    if-ne v2, v11, :cond_28c

    const/4 v11, 0x3

    .line 696
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_28c
    const/16 v11, 0x8b

    if-ne v2, v11, :cond_28d

    const/16 v11, 0x33

    .line 697
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_28d
    const/16 v11, 0x8c

    if-ne v2, v11, :cond_28e

    const/16 v11, 0x7f

    .line 698
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_28e
    const/16 v11, 0x8d

    if-ne v2, v11, :cond_28f

    const/16 v11, 0xd2

    .line 699
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_28f
    const/16 v11, 0x8e

    if-ne v2, v11, :cond_290

    const/16 v11, 0x3e

    .line 700
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_290
    const/16 v11, 0x8f

    if-ne v2, v11, :cond_291

    const/16 v11, 0xcd

    .line 701
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_291
    const/16 v11, 0x90

    if-ne v2, v11, :cond_292

    const/16 v11, 0xef

    .line 702
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_292
    const/16 v11, 0x91

    if-ne v2, v11, :cond_293

    const/16 v11, 0x7e

    .line 703
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_293
    const/16 v11, 0x92

    if-ne v2, v11, :cond_294

    const/16 v11, 0xa9

    .line 704
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_294
    const/16 v11, 0x93

    if-ne v2, v11, :cond_295

    const/16 v11, 0x3f

    .line 705
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_295
    const/16 v11, 0x94

    if-ne v2, v11, :cond_296

    const/16 v11, 0x5f

    .line 706
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_296
    const/16 v11, 0x95

    if-ne v2, v11, :cond_297

    const/16 v11, 0xe4

    .line 707
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_297
    const/16 v11, 0x96

    if-ne v2, v11, :cond_298

    const/16 v11, 0xc7

    .line 708
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_298
    const/16 v11, 0x97

    if-ne v2, v11, :cond_299

    const/16 v11, 0xba

    .line 709
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_299
    const/16 v11, 0x98

    if-ne v2, v11, :cond_29a

    const/16 v11, 0x51

    .line 710
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_29a
    const/16 v11, 0x99

    if-ne v2, v11, :cond_29b

    const/16 v11, 0x35

    .line 711
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_29b
    const/16 v11, 0x9a

    if-ne v2, v11, :cond_29c

    const/16 v11, 0x98

    .line 712
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_29c
    const/16 v11, 0x9b

    if-ne v2, v11, :cond_29d

    const/16 v11, 0x43

    .line 713
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_29d
    const/16 v11, 0x9c

    if-ne v2, v11, :cond_29e

    const/16 v11, 0x7d

    .line 714
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_29e
    const/16 v11, 0x9d

    if-ne v2, v11, :cond_29f

    .line 715
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/4 v12, 0x0

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_29f
    const/16 v11, 0x9e

    if-ne v2, v11, :cond_2a0

    const/16 v11, 0x99

    .line 716
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a0
    const/16 v11, 0x9f

    if-ne v2, v11, :cond_2a1

    const/16 v11, 0x63

    .line 717
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a1
    const/16 v11, 0xa0

    if-ne v2, v11, :cond_2a2

    const/16 v11, 0x96

    .line 718
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a2
    const/16 v11, 0xa1

    if-ne v2, v11, :cond_2a3

    const/16 v11, 0x19

    .line 719
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a3
    const/16 v11, 0xa2

    if-ne v2, v11, :cond_2a4

    const/16 v11, 0xd9

    .line 720
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a4
    const/16 v11, 0xa3

    if-ne v2, v11, :cond_2a5

    const/16 v11, 0xe5

    .line 721
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a5
    const/16 v11, 0xa4

    if-ne v2, v11, :cond_2a6

    const/16 v11, 0x66

    .line 722
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a6
    const/16 v11, 0xa5

    if-ne v2, v11, :cond_2a7

    const/16 v11, 0x45

    .line 723
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a7
    const/16 v11, 0xa6

    if-ne v2, v11, :cond_2a8

    const/16 v11, 0xf6

    .line 724
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a8
    const/16 v11, 0xa7

    if-ne v2, v11, :cond_2a9

    const/16 v11, 0x5a

    .line 725
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2a9
    const/16 v11, 0xa8

    if-ne v2, v11, :cond_2aa

    const/16 v11, 0x75

    .line 726
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2aa
    const/16 v11, 0xa9

    if-ne v2, v11, :cond_2ab

    const/16 v11, 0xf4

    .line 727
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ab
    const/16 v11, 0xaa

    if-ne v2, v11, :cond_2ac

    const/16 v11, 0x3c

    .line 728
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ac
    const/16 v11, 0xab

    if-ne v2, v11, :cond_2ad

    const/16 v11, 0xb2

    .line 729
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ad
    const/16 v11, 0xac

    if-ne v2, v11, :cond_2ae

    const/16 v11, 0x49

    .line 730
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ae
    const/16 v11, 0xad

    if-ne v2, v11, :cond_2af

    const/16 v11, 0xea

    .line 731
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2af
    const/16 v11, 0xae

    if-ne v2, v11, :cond_2b0

    const/4 v11, 0x2

    .line 732
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b0
    const/16 v11, 0xaf

    if-ne v2, v11, :cond_2b1

    const/16 v11, 0xb5

    .line 733
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b1
    const/16 v11, 0xb0

    if-ne v2, v11, :cond_2b2

    const/16 v11, 0x4b

    .line 734
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b2
    const/16 v11, 0xb1

    if-ne v2, v11, :cond_2b3

    const/16 v11, 0x14

    .line 735
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b3
    const/16 v11, 0xb2

    if-ne v2, v11, :cond_2b4

    const/16 v11, 0x18

    .line 736
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b4
    const/16 v11, 0xb3

    if-ne v2, v11, :cond_2b5

    const/16 v11, 0x15

    .line 737
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b5
    const/16 v11, 0xb4

    if-ne v2, v11, :cond_2b6

    const/16 v11, 0x8

    .line 738
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b6
    const/16 v11, 0xb5

    if-ne v2, v11, :cond_2b7

    const/16 v11, 0x23

    .line 739
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b7
    const/16 v11, 0xb6

    if-ne v2, v11, :cond_2b8

    const/16 v11, 0x8d

    .line 740
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b8
    const/16 v11, 0xb7

    if-ne v2, v11, :cond_2b9

    const/16 v11, 0xa5

    .line 741
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2b9
    const/16 v11, 0xb8

    if-ne v2, v11, :cond_2ba

    const/16 v11, 0xc9

    .line 742
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ba
    const/16 v11, 0xb9

    if-ne v2, v11, :cond_2bb

    const/16 v11, 0xed

    .line 743
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2bb
    const/16 v11, 0xba

    if-ne v2, v11, :cond_2bc

    const/16 v11, 0x60

    .line 744
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2bc
    const/16 v11, 0xbb

    if-ne v2, v11, :cond_2bd

    const/16 v11, 0xd3

    .line 745
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2bd
    const/16 v11, 0xbc

    if-ne v2, v11, :cond_2be

    const/16 v11, 0x81

    .line 746
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2be
    const/16 v11, 0xbd

    if-ne v2, v11, :cond_2bf

    const/16 v11, 0x9f

    .line 747
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2bf
    const/16 v11, 0xbe

    if-ne v2, v11, :cond_2c0

    const/16 v11, 0x13

    .line 748
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c0
    const/16 v11, 0xbf

    if-ne v2, v11, :cond_2c1

    const/16 v11, 0xbd

    .line 749
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c1
    const/16 v11, 0xc0

    if-ne v2, v11, :cond_2c2

    const/16 v11, 0x87

    .line 750
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c2
    const/16 v11, 0xc1

    if-ne v2, v11, :cond_2c3

    const/16 v11, 0x9e

    .line 751
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c3
    const/16 v11, 0xc2

    if-ne v2, v11, :cond_2c4

    const/16 v11, 0x21

    .line 752
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c4
    const/16 v11, 0xc3

    if-ne v2, v11, :cond_2c5

    const/16 v11, 0x68

    .line 753
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c5
    const/16 v11, 0xc4

    if-ne v2, v11, :cond_2c6

    const/16 v11, 0x5b

    .line 754
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c6
    const/16 v11, 0xc5

    if-ne v2, v11, :cond_2c7

    const/16 v11, 0x74

    .line 755
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c7
    const/16 v11, 0xc6

    if-ne v2, v11, :cond_2c8

    const/16 v11, 0xb1

    .line 756
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c8
    const/16 v11, 0xc7

    if-ne v2, v11, :cond_2c9

    const/16 v11, 0x2f

    .line 757
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2c9
    const/16 v11, 0xc8

    if-ne v2, v11, :cond_2ca

    .line 758
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xf7

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ca
    const/16 v11, 0xc9

    if-ne v2, v11, :cond_2cb

    const/16 v11, 0x89

    .line 759
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2cb
    const/16 v11, 0xca

    if-ne v2, v11, :cond_2cc

    const/16 v11, 0x7a

    .line 760
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2cc
    const/16 v11, 0xcb

    if-ne v2, v11, :cond_2cd

    const/16 v11, 0xad

    .line 761
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2cd
    const/16 v11, 0xcc

    if-ne v2, v11, :cond_2ce

    const/16 v11, 0x3b

    .line 762
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ce
    const/16 v11, 0xcd

    if-ne v2, v11, :cond_2cf

    const/16 v11, 0x71

    .line 763
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2cf
    const/16 v11, 0xce

    if-ne v2, v11, :cond_2d0

    const/16 v11, 0x1d

    .line 764
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d0
    const/16 v11, 0xcf

    if-ne v2, v11, :cond_2d1

    const/16 v11, 0xf5

    .line 765
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d1
    const/16 v11, 0xd0

    if-ne v2, v11, :cond_2d2

    const/16 v11, 0xf2

    .line 766
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d2
    const/16 v11, 0xd1

    if-ne v2, v11, :cond_2d3

    const/16 v11, 0x80

    .line 767
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d3
    const/16 v11, 0xd2

    if-ne v2, v11, :cond_2d4

    const/16 v11, 0x27

    .line 768
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d4
    const/16 v11, 0xd3

    if-ne v2, v11, :cond_2d5

    const/16 v11, 0x56

    .line 769
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d5
    const/16 v11, 0xd4

    if-ne v2, v11, :cond_2d6

    const/16 v11, 0xc0

    .line 770
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d6
    const/16 v11, 0xd5

    if-ne v2, v11, :cond_2d7

    const/16 v11, 0xfc

    .line 771
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d7
    const/16 v11, 0xd6

    if-ne v2, v11, :cond_2d8

    const/16 v11, 0x25

    .line 772
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d8
    const/16 v11, 0xd7

    if-ne v2, v11, :cond_2d9

    const/16 v11, 0x3d

    .line 773
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2d9
    const/16 v11, 0xd8

    if-ne v2, v11, :cond_2da

    const/16 v11, 0x59

    .line 774
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2da
    const/16 v11, 0xd9

    if-ne v2, v11, :cond_2db

    const/16 v11, 0xc8

    .line 775
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2db
    const/16 v11, 0xda

    if-ne v2, v11, :cond_2dc

    const/16 v11, 0x9d

    .line 776
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2dc
    const/16 v11, 0xdb

    if-ne v2, v11, :cond_2dd

    const/16 v11, 0x44

    .line 777
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2dd
    const/16 v11, 0xdc

    if-ne v2, v11, :cond_2de

    const/16 v11, 0xe1

    .line 778
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2de
    const/16 v11, 0xdd

    if-ne v2, v11, :cond_2df

    const/16 v11, 0x8b

    .line 779
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2df
    const/16 v11, 0xde

    if-ne v2, v11, :cond_2e0

    .line 780
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v13, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e0
    const/16 v11, 0xdf

    if-ne v2, v11, :cond_2e1

    const/16 v11, 0xfe

    .line 781
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e1
    const/16 v11, 0xe0

    if-ne v2, v11, :cond_2e2

    const/16 v11, 0x24

    .line 782
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e2
    const/16 v11, 0xe1

    if-ne v2, v11, :cond_2e3

    .line 783
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x92

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e3
    const/16 v11, 0xe2

    if-ne v2, v11, :cond_2e4

    const/16 v11, 0xa2

    .line 784
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e4
    const/16 v11, 0xe3

    if-ne v2, v11, :cond_2e5

    const/16 v11, 0x2a

    .line 785
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e5
    const/16 v11, 0xe4

    if-ne v2, v11, :cond_2e6

    const/16 v11, 0x2d

    .line 786
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e6
    const/16 v11, 0xe5

    if-ne v2, v11, :cond_2e7

    const/16 v11, 0xa6

    .line 787
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e7
    const/16 v11, 0xe6

    if-ne v2, v11, :cond_2e8

    .line 788
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xac

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e8
    const/16 v11, 0xe7

    if-ne v2, v11, :cond_2e9

    .line 789
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x41

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2e9
    const/16 v11, 0xe8

    if-ne v2, v11, :cond_2ea

    const/16 v11, 0xe7

    .line 790
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ea
    const/16 v11, 0xe9

    if-ne v2, v11, :cond_2eb

    const/16 v11, 0x1f

    .line 791
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2eb
    const/16 v11, 0xea

    if-ne v2, v11, :cond_2ec

    const/16 v11, 0x69

    .line 792
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ec
    const/16 v11, 0xeb

    if-ne v2, v11, :cond_2ed

    const/16 v11, 0xde

    .line 793
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ed
    const/16 v11, 0xec

    if-ne v2, v11, :cond_2ee

    const/16 v11, 0x2b

    .line 794
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ee
    const/16 v11, 0xed

    if-ne v2, v11, :cond_2ef

    const/16 v11, 0xd4

    .line 795
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2ef
    const/16 v11, 0xee

    if-ne v2, v11, :cond_2f0

    const/16 v11, 0x76

    .line 796
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f0
    const/16 v11, 0xef

    if-ne v2, v11, :cond_2f1

    const/16 v11, 0x22

    .line 797
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f1
    const/16 v11, 0xf0

    if-ne v2, v11, :cond_2f2

    const/16 v11, 0xd7

    .line 798
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f2
    const/16 v11, 0xf1

    if-ne v2, v11, :cond_2f3

    const/16 v11, 0x4a

    .line 799
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f3
    const/16 v11, 0xf2

    if-ne v2, v11, :cond_2f4

    const/16 v11, 0x57

    .line 800
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f4
    const/16 v11, 0xf3

    if-ne v2, v11, :cond_2f5

    const/16 v11, 0xfd

    .line 801
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f5
    const/16 v11, 0xf4

    if-ne v2, v11, :cond_2f6

    const/16 v11, 0xc2

    .line 802
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f6
    const/16 v11, 0xf5

    if-ne v2, v11, :cond_2f7

    const/16 v11, 0xf9

    .line 803
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f7
    const/16 v11, 0xf6

    if-ne v2, v11, :cond_2f8

    const/16 v11, 0x64

    .line 804
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f8
    const/16 v11, 0xf7

    if-ne v2, v11, :cond_2f9

    const/16 v11, 0x29

    .line 805
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2f9
    const/16 v11, 0xf8

    if-ne v2, v11, :cond_2fa

    const/16 v11, 0x4c

    .line 806
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto/16 :goto_3

    :cond_2fa
    const/16 v11, 0xf9

    if-ne v2, v11, :cond_2fb

    const/16 v11, 0x65

    .line 807
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto :goto_3

    :cond_2fb
    const/16 v11, 0xfa

    if-ne v2, v11, :cond_2fc

    const/4 v11, 0x4

    .line 808
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto :goto_3

    :cond_2fc
    const/16 v11, 0xfb

    if-ne v2, v11, :cond_2fd

    const/16 v11, 0xbf

    .line 809
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto :goto_3

    :cond_2fd
    const/16 v11, 0xfc

    if-ne v2, v11, :cond_2fe

    const/16 v11, 0x84

    .line 810
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto :goto_3

    :cond_2fe
    const/16 v11, 0xfd

    if-ne v2, v11, :cond_2ff

    const/16 v11, 0xb7

    .line 811
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto :goto_3

    :cond_2ff
    const/16 v11, 0xfe

    if-ne v2, v11, :cond_300

    const/4 v11, 0x7

    .line 812
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    const/16 v12, 0xfb

    goto :goto_3

    :cond_300
    const/16 v11, 0xff

    if-ne v2, v11, :cond_301

    const/16 v11, 0xa1

    .line 813
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m2(II)I

    move-result v11

    goto :goto_2

    :cond_301
    const/4 v11, 0x0

    :goto_2
    const/16 v12, 0xfb

    :goto_3
    and-int/2addr v11, v12

    const/16 v12, 0x92

    if-eq v11, v12, :cond_302

    const/4 v11, 0x0

    return v11

    .line 818
    :cond_302
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->scramble(I)I

    move-result v10

    if-nez v3, :cond_303

    .line 819
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v13, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_303
    if-ne v3, v13, :cond_304

    const/16 v11, 0xdf

    .line 820
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_304
    const/4 v11, 0x2

    if-ne v3, v11, :cond_305

    const/16 v11, 0x86

    .line 821
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_305
    const/4 v11, 0x3

    if-ne v3, v11, :cond_306

    const/16 v11, 0xa3

    .line 822
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_306
    const/4 v11, 0x4

    if-ne v3, v11, :cond_307

    const/16 v11, 0xb2

    .line 823
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_307
    const/4 v11, 0x5

    if-ne v3, v11, :cond_308

    const/16 v11, 0x3b

    .line 824
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_308
    if-ne v3, v14, :cond_309

    .line 825
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x41

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_309
    const/4 v11, 0x7

    if-ne v3, v11, :cond_30a

    const/16 v11, 0x74

    .line 826
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_30a
    const/16 v11, 0x8

    if-ne v3, v11, :cond_30b

    const/16 v11, 0x75

    .line 827
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_30b
    const/16 v11, 0x9

    if-ne v3, v11, :cond_30c

    const/16 v11, 0x11

    .line 828
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_30c
    const/16 v11, 0xa

    if-ne v3, v11, :cond_30d

    const/16 v11, 0xe0

    .line 829
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_30d
    const/16 v11, 0xb

    if-ne v3, v11, :cond_30e

    const/16 v11, 0x7a

    .line 830
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_30e
    const/16 v11, 0xc

    if-ne v3, v11, :cond_30f

    const/16 v11, 0x63

    .line 831
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_30f
    if-ne v3, v9, :cond_310

    const/16 v11, 0x55

    .line 832
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_310
    const/16 v11, 0xe

    if-ne v3, v11, :cond_311

    const/16 v11, 0x34

    .line 833
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_311
    const/16 v11, 0xf

    if-ne v3, v11, :cond_312

    const/16 v11, 0x3f

    .line 834
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_312
    const/16 v11, 0x10

    if-ne v3, v11, :cond_313

    const/16 v11, 0xce

    .line 835
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_313
    const/16 v11, 0x11

    if-ne v3, v11, :cond_314

    const/16 v11, 0x83

    .line 836
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_314
    const/16 v11, 0x12

    if-ne v3, v11, :cond_315

    const/16 v11, 0xcc

    .line 837
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_315
    const/16 v11, 0x13

    if-ne v3, v11, :cond_316

    const/16 v11, 0x20

    .line 838
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_316
    const/16 v11, 0x14

    if-ne v3, v11, :cond_317

    const/16 v11, 0x28

    .line 839
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_317
    const/16 v11, 0x15

    if-ne v3, v11, :cond_318

    const/16 v11, 0xb1

    .line 840
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_318
    const/16 v11, 0x16

    if-ne v3, v11, :cond_319

    const/16 v11, 0x84

    .line 841
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_319
    const/16 v11, 0x17

    if-ne v3, v11, :cond_31a

    const/16 v11, 0x85

    .line 842
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_31a
    const/16 v11, 0x18

    if-ne v3, v11, :cond_31b

    const/16 v11, 0x5c

    .line 843
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_31b
    const/16 v11, 0x19

    if-ne v3, v11, :cond_31c

    const/16 v11, 0x65

    .line 844
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_31c
    const/16 v11, 0x1a

    if-ne v3, v11, :cond_31d

    .line 845
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x61

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_31d
    const/16 v11, 0x1b

    if-ne v3, v11, :cond_31e

    const/16 v11, 0xe6

    .line 846
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_31e
    const/16 v11, 0x1c

    if-ne v3, v11, :cond_31f

    const/16 v11, 0x6a

    .line 847
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_31f
    const/16 v11, 0x1d

    if-ne v3, v11, :cond_320

    const/16 v11, 0x90

    .line 848
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_320
    const/16 v11, 0x1e

    if-ne v3, v11, :cond_321

    const/16 v11, 0x1e

    .line 849
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_321
    const/16 v11, 0x1f

    if-ne v3, v11, :cond_322

    const/16 v11, 0x49

    .line 850
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_322
    const/16 v11, 0x20

    if-ne v3, v11, :cond_323

    .line 851
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/4 v12, 0x0

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_323
    const/16 v11, 0x21

    if-ne v3, v11, :cond_324

    const/16 v11, 0x99

    .line 852
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_324
    const/16 v11, 0x22

    if-ne v3, v11, :cond_325

    const/16 v11, 0xc0

    .line 853
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_325
    const/16 v11, 0x23

    if-ne v3, v11, :cond_326

    const/16 v11, 0x6b

    .line 854
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_326
    const/16 v11, 0x24

    if-ne v3, v11, :cond_327

    const/16 v11, 0x2c

    .line 855
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_327
    const/16 v11, 0x25

    if-ne v3, v11, :cond_328

    const/16 v11, 0x7b

    .line 856
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_328
    const/16 v11, 0x26

    if-ne v3, v11, :cond_329

    const/16 v11, 0x56

    .line 857
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_329
    const/16 v11, 0x27

    if-ne v3, v11, :cond_32a

    const/16 v11, 0xe9

    .line 858
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_32a
    const/16 v11, 0x28

    if-ne v3, v11, :cond_32b

    const/16 v11, 0x3e

    .line 859
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_32b
    const/16 v11, 0x29

    if-ne v3, v11, :cond_32c

    const/16 v11, 0xa4

    .line 860
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_32c
    const/16 v11, 0x2a

    if-ne v3, v11, :cond_32d

    const/16 v11, 0x76

    .line 861
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_32d
    const/16 v11, 0x2b

    if-ne v3, v11, :cond_32e

    const/16 v11, 0x50

    .line 862
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_32e
    const/16 v11, 0x2c

    if-ne v3, v11, :cond_32f

    const/16 v11, 0x47

    .line 863
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_32f
    const/16 v11, 0x2d

    if-ne v3, v11, :cond_330

    const/16 v11, 0xb3

    .line 864
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_330
    const/16 v11, 0x2e

    if-ne v3, v11, :cond_331

    const/16 v11, 0xc5

    .line 865
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_331
    const/16 v11, 0x2f

    if-ne v3, v11, :cond_332

    const/16 v11, 0xb8

    .line 866
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_332
    const/16 v11, 0x30

    if-ne v3, v11, :cond_333

    const/16 v11, 0x1d

    .line 867
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_333
    const/16 v11, 0x31

    if-ne v3, v11, :cond_334

    const/16 v11, 0x6c

    .line 868
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_334
    const/16 v11, 0x32

    if-ne v3, v11, :cond_335

    const/4 v11, 0x4

    .line 869
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_335
    const/16 v11, 0x33

    if-ne v3, v11, :cond_336

    const/16 v11, 0x3a

    .line 870
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_336
    const/16 v11, 0x34

    if-ne v3, v11, :cond_337

    const/16 v11, 0xf4

    .line 871
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_337
    const/16 v11, 0x35

    if-ne v3, v11, :cond_338

    const/16 v11, 0xeb

    .line 872
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_338
    const/16 v11, 0x36

    if-ne v3, v11, :cond_339

    const/16 v11, 0x8

    .line 873
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_339
    const/16 v11, 0x37

    if-ne v3, v11, :cond_33a

    const/16 v11, 0xd1

    .line 874
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_33a
    const/16 v11, 0x38

    if-ne v3, v11, :cond_33b

    const/16 v11, 0x29

    .line 875
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_33b
    const/16 v11, 0x39

    if-ne v3, v11, :cond_33c

    const/16 v11, 0x1c

    .line 876
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_33c
    const/16 v11, 0x3a

    if-ne v3, v11, :cond_33d

    const/16 v11, 0x96

    .line 877
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_33d
    const/16 v11, 0x3b

    if-ne v3, v11, :cond_33e

    const/16 v11, 0xc7

    .line 878
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_33e
    const/16 v11, 0x3c

    if-ne v3, v11, :cond_33f

    const/16 v11, 0xe

    .line 879
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_33f
    const/16 v11, 0x3d

    if-ne v3, v11, :cond_340

    const/16 v11, 0x5e

    .line 880
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_340
    const/16 v11, 0x3e

    if-ne v3, v11, :cond_341

    const/16 v11, 0x2d

    .line 881
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_341
    const/16 v11, 0x3f

    if-ne v3, v11, :cond_342

    const/16 v11, 0xcb

    .line 882
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_342
    const/16 v11, 0x40

    if-ne v3, v11, :cond_343

    const/16 v11, 0x9f

    .line 883
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_343
    const/16 v11, 0x41

    if-ne v3, v11, :cond_344

    const/16 v11, 0x33

    .line 884
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_344
    const/16 v11, 0x42

    if-ne v3, v11, :cond_345

    const/16 v11, 0xd4

    .line 885
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_345
    const/16 v11, 0x43

    if-ne v3, v11, :cond_346

    const/16 v11, 0xde

    .line 886
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_346
    const/16 v11, 0x44

    if-ne v3, v11, :cond_347

    const/16 v11, 0xb7

    .line 887
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_347
    const/16 v11, 0x45

    if-ne v3, v11, :cond_348

    const/16 v11, 0x9d

    .line 888
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_348
    const/16 v11, 0x46

    if-ne v3, v11, :cond_349

    const/16 v11, 0x5f

    .line 889
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_349
    const/16 v11, 0x47

    if-ne v3, v11, :cond_34a

    const/16 v11, 0x42

    .line 890
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_34a
    const/16 v11, 0x48

    if-ne v3, v11, :cond_34b

    .line 891
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x8e

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_34b
    const/16 v11, 0x49

    if-ne v3, v11, :cond_34c

    const/16 v11, 0x22

    .line 892
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_34c
    const/16 v11, 0x4a

    if-ne v3, v11, :cond_34d

    const/16 v11, 0xb9

    .line 893
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_34d
    const/16 v11, 0x4b

    if-ne v3, v11, :cond_34e

    const/16 v11, 0x3d

    .line 894
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_34e
    const/16 v11, 0x4c

    if-ne v3, v11, :cond_34f

    const/16 v11, 0x4a

    .line 895
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_34f
    const/16 v11, 0x4d

    if-ne v3, v11, :cond_350

    const/16 v11, 0x1a

    .line 896
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_350
    const/16 v11, 0x4e

    if-ne v3, v11, :cond_351

    const/16 v11, 0xa1

    .line 897
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_351
    const/16 v11, 0x4f

    if-ne v3, v11, :cond_352

    const/16 v11, 0x27

    .line 898
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_352
    const/16 v11, 0x50

    if-ne v3, v11, :cond_353

    const/16 v11, 0x37

    .line 899
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_353
    const/16 v11, 0x51

    if-ne v3, v11, :cond_354

    const/16 v11, 0xf8

    .line 900
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_354
    const/16 v11, 0x52

    if-ne v3, v11, :cond_355

    const/16 v11, 0x10

    .line 901
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_355
    const/16 v11, 0x53

    if-ne v3, v11, :cond_356

    const/16 v11, 0xb4

    .line 902
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_356
    const/16 v11, 0x54

    if-ne v3, v11, :cond_357

    const/16 v11, 0xbf

    .line 903
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_357
    const/16 v11, 0x55

    if-ne v3, v11, :cond_358

    .line 904
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xf7

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    goto/16 :goto_5

    :cond_358
    const/16 v11, 0x56

    if-ne v3, v11, :cond_359

    const/16 v11, 0x19

    .line 905
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_359
    const/16 v11, 0x57

    if-ne v3, v11, :cond_35a

    const/16 v11, 0x81

    .line 906
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_35a
    const/16 v11, 0x58

    if-ne v3, v11, :cond_35b

    const/16 v11, 0x5b

    .line 907
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_35b
    const/16 v11, 0x59

    if-ne v3, v11, :cond_35c

    const/16 v11, 0x36

    .line 908
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_35c
    const/16 v11, 0x5a

    if-ne v3, v11, :cond_35d

    const/16 v11, 0xb5

    .line 909
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_35d
    const/16 v11, 0x5b

    if-ne v3, v11, :cond_35e

    const/16 v11, 0x58

    .line 910
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_35e
    const/16 v11, 0x5c

    if-ne v3, v11, :cond_35f

    const/16 v11, 0xcf

    .line 911
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_35f
    const/16 v11, 0x5d

    if-ne v3, v11, :cond_360

    const/16 v11, 0xc1

    .line 912
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_360
    const/16 v11, 0x5e

    if-ne v3, v11, :cond_361

    const/4 v11, 0x5

    .line 913
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_361
    const/16 v11, 0x5f

    if-ne v3, v11, :cond_362

    const/16 v11, 0xd8

    .line 914
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_362
    const/16 v11, 0x60

    if-ne v3, v11, :cond_363

    const/16 v11, 0xe7

    .line 915
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_363
    const/16 v11, 0x61

    if-ne v3, v11, :cond_364

    const/16 v11, 0x79

    .line 916
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_364
    const/16 v11, 0x62

    if-ne v3, v11, :cond_365

    const/16 v11, 0xd3

    .line 917
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_365
    const/16 v11, 0x63

    if-ne v3, v11, :cond_366

    const/16 v11, 0xae

    .line 918
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_366
    const/16 v11, 0x64

    if-ne v3, v11, :cond_367

    const/16 v11, 0xa7

    .line 919
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_367
    const/16 v11, 0x65

    if-ne v3, v11, :cond_368

    .line 920
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xff

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_368
    const/16 v11, 0x66

    if-ne v3, v11, :cond_369

    const/16 v11, 0xe3

    .line 921
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_369
    const/16 v11, 0x67

    if-ne v3, v11, :cond_36a

    const/16 v11, 0xb0

    .line 922
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_36a
    const/16 v11, 0x68

    if-ne v3, v11, :cond_36b

    const/16 v11, 0x52

    .line 923
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_36b
    const/16 v11, 0x69

    if-ne v3, v11, :cond_36c

    const/16 v11, 0x89

    .line 924
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_36c
    const/16 v11, 0x6a

    if-ne v3, v11, :cond_36d

    const/16 v11, 0xc

    .line 925
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_36d
    const/16 v11, 0x6b

    if-ne v3, v11, :cond_36e

    const/16 v11, 0x26

    .line 926
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_36e
    const/16 v11, 0x6c

    if-ne v3, v11, :cond_36f

    const/16 v11, 0xc6

    .line 927
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_36f
    const/16 v11, 0x6d

    if-ne v3, v11, :cond_370

    const/16 v11, 0x6d

    .line 928
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_370
    const/16 v11, 0x6e

    if-ne v3, v11, :cond_371

    const/16 v11, 0x98

    .line 929
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_371
    const/16 v11, 0x6f

    if-ne v3, v11, :cond_372

    const/16 v11, 0xfa

    .line 930
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_372
    const/16 v11, 0x70

    if-ne v3, v11, :cond_373

    const/16 v11, 0x7e

    .line 931
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_373
    const/16 v11, 0x71

    if-ne v3, v11, :cond_374

    const/16 v11, 0xa9

    .line 932
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_374
    const/16 v11, 0x72

    if-ne v3, v11, :cond_375

    const/16 v11, 0xbb

    .line 933
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_375
    const/16 v11, 0x73

    if-ne v3, v11, :cond_376

    const/16 v11, 0x21

    .line 934
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_376
    const/16 v11, 0x74

    if-ne v3, v11, :cond_377

    const/16 v11, 0xfd

    .line 935
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_377
    const/16 v11, 0x75

    if-ne v3, v11, :cond_378

    const/16 v11, 0x57

    .line 936
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_378
    const/16 v11, 0x76

    if-ne v3, v11, :cond_379

    const/16 v11, 0xad

    .line 937
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_379
    const/16 v11, 0x77

    if-ne v3, v11, :cond_37a

    const/16 v11, 0xdd

    .line 938
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_37a
    const/16 v11, 0x78

    if-ne v3, v11, :cond_37b

    const/16 v11, 0x2e

    .line 939
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_37b
    const/16 v11, 0x79

    if-ne v3, v11, :cond_37c

    const/16 v11, 0xb6

    .line 940
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_37c
    const/16 v11, 0x7a

    if-ne v3, v11, :cond_37d

    const/16 v11, 0x18

    .line 941
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_37d
    const/16 v11, 0x7b

    if-ne v3, v11, :cond_37e

    const/16 v11, 0x54

    .line 942
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_37e
    const/16 v11, 0x7c

    if-ne v3, v11, :cond_37f

    const/16 v11, 0xe4

    .line 943
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_37f
    const/16 v11, 0x7d

    if-ne v3, v11, :cond_380

    const/16 v11, 0xef

    .line 944
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_380
    const/16 v11, 0x7e

    if-ne v3, v11, :cond_381

    const/16 v11, 0x4b

    .line 945
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_381
    const/16 v11, 0x7f

    if-ne v3, v11, :cond_382

    const/16 v11, 0x13

    .line 946
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_382
    const/16 v11, 0x80

    if-ne v3, v11, :cond_383

    const/16 v11, 0x48

    .line 947
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_383
    const/16 v11, 0x81

    if-ne v3, v11, :cond_384

    const/16 v11, 0x70

    .line 948
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_384
    const/16 v11, 0x82

    if-ne v3, v11, :cond_385

    const/16 v11, 0xd0

    .line 949
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_385
    const/16 v11, 0x83

    if-ne v3, v11, :cond_386

    .line 950
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xfb

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_386
    const/16 v11, 0x84

    if-ne v3, v11, :cond_387

    const/16 v11, 0xdc

    .line 951
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_387
    const/16 v11, 0x85

    if-ne v3, v11, :cond_388

    const/16 v11, 0xfe

    .line 952
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_388
    const/16 v11, 0x86

    if-ne v3, v11, :cond_389

    const/16 v11, 0x5a

    .line 953
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_389
    const/16 v11, 0x87

    if-ne v3, v11, :cond_38a

    const/16 v11, 0xda

    .line 954
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_38a
    const/16 v11, 0x88

    if-ne v3, v11, :cond_38b

    const/4 v11, 0x2

    .line 955
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_38b
    const/16 v11, 0x89

    if-ne v3, v11, :cond_38c

    const/16 v11, 0x40

    .line 956
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_38c
    const/16 v11, 0x8a

    if-ne v3, v11, :cond_38d

    const/16 v11, 0xf6

    .line 957
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_38d
    const/16 v11, 0x8b

    if-ne v3, v11, :cond_38e

    const/16 v11, 0x32

    .line 958
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_38e
    const/16 v11, 0x8c

    if-ne v3, v11, :cond_38f

    const/16 v11, 0x72

    .line 959
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_38f
    const/16 v11, 0x8d

    if-ne v3, v11, :cond_390

    const/16 v11, 0x9c

    .line 960
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_390
    const/16 v11, 0x8e

    if-ne v3, v11, :cond_391

    const/16 v11, 0xa8

    .line 961
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_391
    const/16 v11, 0x8f

    if-ne v3, v11, :cond_392

    const/16 v11, 0xa0

    .line 962
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_392
    const/16 v11, 0x90

    if-ne v3, v11, :cond_393

    const/16 v11, 0x94

    .line 963
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_393
    const/16 v11, 0x91

    if-ne v3, v11, :cond_394

    const/16 v11, 0x44

    .line 964
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_394
    const/16 v11, 0x92

    if-ne v3, v11, :cond_395

    const/16 v11, 0xf2

    .line 965
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_395
    const/16 v11, 0x93

    if-ne v3, v11, :cond_396

    .line 966
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x82

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_396
    const/16 v11, 0x94

    if-ne v3, v11, :cond_397

    const/16 v11, 0x71

    .line 967
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_397
    const/16 v11, 0x95

    if-ne v3, v11, :cond_398

    const/16 v11, 0xab

    .line 968
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_398
    const/16 v11, 0x96

    if-ne v3, v11, :cond_399

    const/16 v11, 0x8b

    .line 969
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_399
    const/16 v11, 0x97

    if-ne v3, v11, :cond_39a

    const/16 v11, 0x4c

    .line 970
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_39a
    const/16 v11, 0x98

    if-ne v3, v11, :cond_39b

    const/16 v11, 0x17

    .line 971
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_39b
    const/16 v11, 0x99

    if-ne v3, v11, :cond_39c

    const/16 v11, 0x31

    .line 972
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_39c
    const/16 v11, 0x9a

    if-ne v3, v11, :cond_39d

    const/16 v11, 0x8a

    .line 973
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_39d
    const/16 v11, 0x9b

    if-ne v3, v11, :cond_39e

    .line 974
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v14, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_39e
    const/16 v11, 0x9c

    if-ne v3, v11, :cond_39f

    const/16 v11, 0xe1

    .line 975
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_39f
    const/16 v11, 0x9d

    if-ne v3, v11, :cond_3a0

    const/16 v11, 0xf1

    .line 976
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a0
    const/16 v11, 0x9e

    if-ne v3, v11, :cond_3a1

    const/16 v11, 0xb

    .line 977
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a1
    const/16 v11, 0x9f

    if-ne v3, v11, :cond_3a2

    const/16 v11, 0xd5

    .line 978
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a2
    const/16 v11, 0xa0

    if-ne v3, v11, :cond_3a3

    const/16 v11, 0x30

    .line 979
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a3
    const/16 v11, 0xa1

    if-ne v3, v11, :cond_3a4

    const/16 v11, 0xc4

    .line 980
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a4
    const/16 v11, 0xa2

    if-ne v3, v11, :cond_3a5

    const/16 v11, 0x6e

    .line 981
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a5
    const/16 v11, 0xa3

    if-ne v3, v11, :cond_3a6

    .line 982
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x92

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a6
    const/16 v11, 0xa4

    if-ne v3, v11, :cond_3a7

    const/16 v11, 0x77

    .line 983
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a7
    const/16 v11, 0xa5

    if-ne v3, v11, :cond_3a8

    .line 984
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xca

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a8
    const/16 v11, 0xa6

    if-ne v3, v11, :cond_3a9

    const/16 v11, 0x45

    .line 985
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3a9
    const/16 v11, 0xa7

    if-ne v3, v11, :cond_3aa

    const/16 v11, 0xed

    .line 986
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3aa
    const/16 v11, 0xa8

    if-ne v3, v11, :cond_3ab

    const/16 v11, 0x16

    .line 987
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ab
    const/16 v11, 0xa9

    if-ne v3, v11, :cond_3ac

    const/16 v11, 0x5d

    .line 988
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ac
    const/16 v11, 0xaa

    if-ne v3, v11, :cond_3ad

    const/16 v11, 0xaf

    .line 989
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ad
    const/16 v11, 0xab

    if-ne v3, v11, :cond_3ae

    const/16 v11, 0x9a

    .line 990
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ae
    const/16 v11, 0xac

    if-ne v3, v11, :cond_3af

    const/16 v11, 0x66

    .line 991
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3af
    const/16 v11, 0xad

    if-ne v3, v11, :cond_3b0

    const/16 v11, 0x78

    .line 992
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b0
    const/16 v11, 0xae

    if-ne v3, v11, :cond_3b1

    const/16 v11, 0x15

    .line 993
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b1
    const/16 v11, 0xaf

    if-ne v3, v11, :cond_3b2

    const/16 v11, 0x39

    .line 994
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b2
    const/16 v11, 0xb0

    if-ne v3, v11, :cond_3b3

    const/16 v11, 0x8c

    .line 995
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b3
    const/16 v11, 0xb1

    if-ne v3, v11, :cond_3b4

    const/16 v11, 0x9

    .line 996
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b4
    const/16 v11, 0xb2

    if-ne v3, v11, :cond_3b5

    const/16 v11, 0x8d

    .line 997
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b5
    const/16 v11, 0xb3

    if-ne v3, v11, :cond_3b6

    const/16 v11, 0xa2

    .line 998
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b6
    const/16 v11, 0xb4

    if-ne v3, v11, :cond_3b7

    const/16 v11, 0xbe

    .line 999
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b7
    const/16 v11, 0xb5

    if-ne v3, v11, :cond_3b8

    const/16 v11, 0x3c

    .line 1000
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b8
    const/16 v11, 0xb6

    if-ne v3, v11, :cond_3b9

    const/16 v11, 0x35

    .line 1001
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3b9
    const/16 v11, 0xb7

    if-ne v3, v11, :cond_3ba

    const/16 v11, 0xcd

    .line 1002
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ba
    const/16 v11, 0xb8

    if-ne v3, v11, :cond_3bb

    const/16 v11, 0x88

    .line 1003
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3bb
    const/16 v11, 0xb9

    if-ne v3, v11, :cond_3bc

    const/16 v11, 0x9e

    .line 1004
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3bc
    const/16 v11, 0xba

    if-ne v3, v11, :cond_3bd

    const/16 v11, 0x69

    .line 1005
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3bd
    const/16 v11, 0xbb

    if-ne v3, v11, :cond_3be

    const/16 v11, 0x91

    .line 1006
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3be
    const/16 v11, 0xbc

    if-ne v3, v11, :cond_3bf

    const/16 v11, 0xa6

    .line 1007
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3bf
    const/16 v11, 0xbd

    if-ne v3, v11, :cond_3c0

    const/16 v11, 0x73

    .line 1008
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c0
    const/16 v11, 0xbe

    if-ne v3, v11, :cond_3c1

    const/16 v11, 0xf9

    .line 1009
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c1
    const/16 v11, 0xbf

    if-ne v3, v11, :cond_3c2

    const/16 v11, 0x4d

    .line 1010
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c2
    const/16 v11, 0xc0

    if-ne v3, v11, :cond_3c3

    const/16 v11, 0xfc

    .line 1011
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c3
    const/16 v11, 0xc1

    if-ne v3, v11, :cond_3c4

    const/16 v11, 0x46

    .line 1012
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c4
    const/16 v11, 0xc2

    if-ne v3, v11, :cond_3c5

    const/16 v11, 0x4e

    .line 1013
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c5
    const/16 v11, 0xc3

    if-ne v3, v11, :cond_3c6

    const/16 v11, 0xe2

    .line 1014
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c6
    const/16 v11, 0xc4

    if-ne v3, v11, :cond_3c7

    const/16 v11, 0xd9

    .line 1015
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c7
    const/16 v11, 0xc5

    if-ne v3, v11, :cond_3c8

    const/16 v11, 0x25

    .line 1016
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c8
    const/16 v11, 0xc6

    if-ne v3, v11, :cond_3c9

    const/16 v11, 0x6f

    .line 1017
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3c9
    const/16 v11, 0xc7

    if-ne v3, v11, :cond_3ca

    const/16 v11, 0x7f

    .line 1018
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ca
    const/16 v11, 0xc8

    if-ne v3, v11, :cond_3cb

    const/16 v11, 0x1b

    .line 1019
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3cb
    const/16 v11, 0xc9

    if-ne v3, v11, :cond_3cc

    const/16 v11, 0xf3

    .line 1020
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3cc
    const/16 v11, 0xca

    if-ne v3, v11, :cond_3cd

    const/16 v11, 0xc3

    .line 1021
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3cd
    const/16 v11, 0xcb

    if-ne v3, v11, :cond_3ce

    const/16 v11, 0x80

    .line 1022
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ce
    const/16 v11, 0xcc

    if-ne v3, v11, :cond_3cf

    const/16 v11, 0xba

    .line 1023
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3cf
    const/16 v11, 0xcd

    if-ne v3, v11, :cond_3d0

    const/16 v11, 0x53

    .line 1024
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d0
    const/16 v11, 0xce

    if-ne v3, v11, :cond_3d1

    const/16 v11, 0xe5

    .line 1025
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d1
    const/16 v11, 0xcf

    if-ne v3, v11, :cond_3d2

    const/16 v11, 0x60

    .line 1026
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d2
    const/16 v11, 0xd0

    if-ne v3, v11, :cond_3d3

    const/16 v11, 0x59

    .line 1027
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d3
    const/16 v11, 0xd1

    if-ne v3, v11, :cond_3d4

    const/16 v11, 0x51

    .line 1028
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d4
    const/16 v11, 0xd2

    if-ne v3, v11, :cond_3d5

    const/16 v11, 0xbd

    .line 1029
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d5
    const/16 v11, 0xd3

    if-ne v3, v11, :cond_3d6

    const/16 v11, 0xdb

    .line 1030
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d6
    const/16 v11, 0xd4

    if-ne v3, v11, :cond_3d7

    const/16 v11, 0xd2

    .line 1031
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d7
    const/16 v11, 0xd5

    if-ne v3, v11, :cond_3d8

    const/16 v11, 0xf

    .line 1032
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d8
    const/16 v11, 0xd6

    if-ne v3, v11, :cond_3d9

    const/16 v11, 0xc2

    .line 1033
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3d9
    const/16 v11, 0xd7

    if-ne v3, v11, :cond_3da

    const/16 v11, 0x93

    .line 1034
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3da
    const/16 v11, 0xd8

    if-ne v3, v11, :cond_3db

    const/16 v11, 0xa

    .line 1035
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3db
    const/16 v11, 0xd9

    if-ne v3, v11, :cond_3dc

    const/16 v11, 0xf5

    .line 1036
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3dc
    const/16 v11, 0xda

    if-ne v3, v11, :cond_3dd

    const/16 v11, 0xa5

    .line 1037
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3dd
    const/16 v11, 0xdb

    if-ne v3, v11, :cond_3de

    const/16 v11, 0x62

    .line 1038
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3de
    const/16 v11, 0xdc

    if-ne v3, v11, :cond_3df

    const/16 v11, 0x9b

    .line 1039
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3df
    const/16 v11, 0xdd

    if-ne v3, v11, :cond_3e0

    const/16 v11, 0xf0

    .line 1040
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e0
    const/16 v11, 0xde

    if-ne v3, v11, :cond_3e1

    const/16 v11, 0x2b

    .line 1041
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e1
    const/16 v11, 0xdf

    if-ne v3, v11, :cond_3e2

    const/16 v11, 0xd6

    .line 1042
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e2
    const/16 v11, 0xe0

    if-ne v3, v11, :cond_3e3

    const/16 v11, 0xbc

    .line 1043
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e3
    const/16 v11, 0xe1

    if-ne v3, v11, :cond_3e4

    const/16 v11, 0xe8

    .line 1044
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e4
    const/16 v11, 0xe2

    if-ne v3, v11, :cond_3e5

    .line 1045
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xec

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e5
    const/16 v11, 0xe3

    if-ne v3, v11, :cond_3e6

    const/16 v11, 0xc9

    .line 1046
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e6
    const/16 v11, 0xe4

    if-ne v3, v11, :cond_3e7

    const/16 v11, 0x2a

    .line 1047
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e7
    const/16 v11, 0xe5

    if-ne v3, v11, :cond_3e8

    const/16 v11, 0x7d

    .line 1048
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e8
    const/16 v11, 0xe6

    if-ne v3, v11, :cond_3e9

    const/16 v11, 0x8f

    .line 1049
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3e9
    const/16 v11, 0xe7

    if-ne v3, v11, :cond_3ea

    const/16 v11, 0x64

    .line 1050
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ea
    const/16 v11, 0xe8

    if-ne v3, v11, :cond_3eb

    const/16 v11, 0xd7

    .line 1051
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3eb
    const/16 v11, 0xe9

    if-ne v3, v11, :cond_3ec

    const/16 v11, 0x67

    .line 1052
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ec
    const/16 v11, 0xea

    if-ne v3, v11, :cond_3ed

    const/16 v11, 0x43

    .line 1053
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ed
    const/16 v11, 0xeb

    if-ne v3, v11, :cond_3ee

    const/16 v11, 0x24

    .line 1054
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ee
    const/16 v11, 0xec

    if-ne v3, v11, :cond_3ef

    const/4 v11, 0x3

    .line 1055
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3ef
    const/16 v11, 0xed

    if-ne v3, v11, :cond_3f0

    const/16 v11, 0x2f

    .line 1056
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f0
    const/16 v11, 0xee

    if-ne v3, v11, :cond_3f1

    .line 1057
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v9, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f1
    const/16 v11, 0xef

    if-ne v3, v11, :cond_3f2

    const/16 v11, 0x7c

    .line 1058
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f2
    const/16 v11, 0xf0

    if-ne v3, v11, :cond_3f3

    .line 1059
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xac

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f3
    const/16 v11, 0xf1

    if-ne v3, v11, :cond_3f4

    const/16 v11, 0x14

    .line 1060
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f4
    const/16 v11, 0xf2

    if-ne v3, v11, :cond_3f5

    const/16 v11, 0xee

    .line 1061
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f5
    const/16 v11, 0xf3

    if-ne v3, v11, :cond_3f6

    const/4 v11, 0x7

    .line 1062
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f6
    const/16 v11, 0xf4

    if-ne v3, v11, :cond_3f7

    const/16 v11, 0xea

    .line 1063
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f7
    const/16 v11, 0xf5

    if-ne v3, v11, :cond_3f8

    const/16 v11, 0x87

    .line 1064
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f8
    const/16 v11, 0xf6

    if-ne v3, v11, :cond_3f9

    const/16 v11, 0x12

    .line 1065
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3f9
    const/16 v11, 0xf7

    if-ne v3, v11, :cond_3fa

    const/16 v11, 0x97

    .line 1066
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3fa
    const/16 v11, 0xf8

    if-ne v3, v11, :cond_3fb

    const/16 v11, 0x4f

    .line 1067
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto/16 :goto_5

    :cond_3fb
    const/16 v11, 0xf9

    if-ne v3, v11, :cond_3fc

    const/16 v11, 0x95

    .line 1068
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto :goto_5

    :cond_3fc
    const/16 v11, 0xfa

    if-ne v3, v11, :cond_3fd

    const/16 v11, 0x1f

    .line 1069
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto :goto_5

    :cond_3fd
    const/16 v11, 0xfb

    if-ne v3, v11, :cond_3fe

    const/16 v11, 0x38

    .line 1070
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto :goto_5

    :cond_3fe
    const/16 v11, 0xfc

    if-ne v3, v11, :cond_3ff

    const/16 v11, 0xc8

    .line 1071
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto :goto_5

    :cond_3ff
    const/16 v11, 0xfd

    if-ne v3, v11, :cond_400

    const/16 v11, 0x68

    .line 1072
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto :goto_5

    :cond_400
    const/16 v11, 0xfe

    if-ne v3, v11, :cond_401

    const/16 v11, 0xaa

    .line 1073
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    const/16 v12, 0xf7

    goto :goto_5

    :cond_401
    const/16 v11, 0xff

    if-ne v3, v11, :cond_402

    const/16 v11, 0x23

    .line 1074
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m3(II)I

    move-result v11

    goto :goto_4

    :cond_402
    const/4 v11, 0x0

    :goto_4
    const/16 v12, 0xf7

    :goto_5
    and-int/2addr v11, v12

    const/16 v12, 0x61

    if-eq v11, v12, :cond_403

    const/4 v11, 0x0

    return v11

    .line 1079
    :cond_403
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->scramble(I)I

    move-result v10

    if-nez v4, :cond_404

    const/16 v11, 0x90

    .line 1080
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_404
    if-ne v4, v13, :cond_405

    const/16 v11, 0x9e

    .line 1081
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_405
    const/4 v11, 0x2

    if-ne v4, v11, :cond_406

    const/16 v11, 0x3a

    .line 1082
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_406
    const/4 v11, 0x3

    if-ne v4, v11, :cond_407

    const/16 v11, 0x9b

    .line 1083
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_407
    const/4 v11, 0x4

    if-ne v4, v11, :cond_408

    const/16 v11, 0xa

    .line 1084
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_408
    const/4 v11, 0x5

    if-ne v4, v11, :cond_409

    .line 1085
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x82

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_409
    if-ne v4, v14, :cond_40a

    const/16 v11, 0x8f

    .line 1086
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_40a
    const/4 v11, 0x7

    if-ne v4, v11, :cond_40b

    const/16 v11, 0x4e

    .line 1087
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_40b
    const/16 v11, 0x8

    if-ne v4, v11, :cond_40c

    const/16 v11, 0xaa

    .line 1088
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_40c
    const/16 v11, 0x9

    if-ne v4, v11, :cond_40d

    const/16 v11, 0x27

    .line 1089
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_40d
    const/16 v11, 0xa

    if-ne v4, v11, :cond_40e

    const/16 v11, 0x6e

    .line 1090
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_40e
    const/16 v11, 0xb

    if-ne v4, v11, :cond_40f

    const/16 v11, 0xfa

    .line 1091
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_40f
    const/16 v11, 0xc

    if-ne v4, v11, :cond_410

    const/16 v11, 0xf6

    .line 1092
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_410
    if-ne v4, v9, :cond_411

    const/4 v11, 0x7

    .line 1093
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_411
    const/16 v11, 0xe

    if-ne v4, v11, :cond_412

    const/16 v11, 0xd6

    .line 1094
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_412
    const/16 v11, 0xf

    if-ne v4, v11, :cond_413

    const/16 v11, 0xeb

    .line 1095
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_413
    const/16 v11, 0x10

    if-ne v4, v11, :cond_414

    const/16 v11, 0x19

    .line 1096
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_414
    const/16 v11, 0x11

    if-ne v4, v11, :cond_415

    .line 1097
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xca

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    goto/16 :goto_7

    :cond_415
    const/16 v11, 0x12

    if-ne v4, v11, :cond_416

    const/16 v11, 0x9d

    .line 1098
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_416
    const/16 v11, 0x13

    if-ne v4, v11, :cond_417

    const/16 v11, 0x59

    .line 1099
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_417
    const/16 v11, 0x14

    if-ne v4, v11, :cond_418

    const/16 v11, 0xed

    .line 1100
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_418
    const/16 v11, 0x15

    if-ne v4, v11, :cond_419

    const/16 v11, 0x83

    .line 1101
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_419
    const/16 v11, 0x16

    if-ne v4, v11, :cond_41a

    const/16 v11, 0x34

    .line 1102
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_41a
    const/16 v11, 0x17

    if-ne v4, v11, :cond_41b

    const/16 v11, 0xe9

    .line 1103
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_41b
    const/16 v11, 0x18

    if-ne v4, v11, :cond_41c

    const/16 v11, 0xa1

    .line 1104
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_41c
    const/16 v11, 0x19

    if-ne v4, v11, :cond_41d

    const/16 v11, 0xf5

    .line 1105
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_41d
    const/16 v11, 0x1a

    if-ne v4, v11, :cond_41e

    const/16 v11, 0xb5

    .line 1106
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_41e
    const/16 v11, 0x1b

    if-ne v4, v11, :cond_41f

    const/16 v11, 0xb8

    .line 1107
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_41f
    const/16 v11, 0x1c

    if-ne v4, v11, :cond_420

    const/16 v11, 0x74

    .line 1108
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_420
    const/16 v11, 0x1d

    if-ne v4, v11, :cond_421

    const/16 v11, 0x1a

    .line 1109
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_421
    const/16 v11, 0x1e

    if-ne v4, v11, :cond_422

    const/16 v11, 0xfe

    .line 1110
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_422
    const/16 v11, 0x1f

    if-ne v4, v11, :cond_423

    const/16 v11, 0x9f

    .line 1111
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_423
    const/16 v11, 0x20

    if-ne v4, v11, :cond_424

    const/16 v11, 0xf4

    .line 1112
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_424
    const/16 v11, 0x21

    if-ne v4, v11, :cond_425

    const/16 v11, 0x65

    .line 1113
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_425
    const/16 v11, 0x22

    if-ne v4, v11, :cond_426

    const/16 v11, 0xba

    .line 1114
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_426
    const/16 v11, 0x23

    if-ne v4, v11, :cond_427

    const/16 v11, 0xf8

    .line 1115
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_427
    const/16 v11, 0x24

    if-ne v4, v11, :cond_428

    const/16 v11, 0x48

    .line 1116
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_428
    const/16 v11, 0x25

    if-ne v4, v11, :cond_429

    const/16 v11, 0x46

    .line 1117
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_429
    const/16 v11, 0x26

    if-ne v4, v11, :cond_42a

    .line 1118
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x8e

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_42a
    const/16 v11, 0x27

    if-ne v4, v11, :cond_42b

    const/16 v11, 0xcd

    .line 1119
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_42b
    const/16 v11, 0x28

    if-ne v4, v11, :cond_42c

    const/16 v11, 0xa8

    .line 1120
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_42c
    const/16 v11, 0x29

    if-ne v4, v11, :cond_42d

    const/16 v11, 0x86

    .line 1121
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_42d
    const/16 v11, 0x2a

    if-ne v4, v11, :cond_42e

    const/16 v11, 0xad

    .line 1122
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_42e
    const/16 v11, 0x2b

    if-ne v4, v11, :cond_42f

    const/4 v11, 0x3

    .line 1123
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_42f
    const/16 v11, 0x2c

    if-ne v4, v11, :cond_430

    const/16 v11, 0x36

    .line 1124
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_430
    const/16 v11, 0x2d

    if-ne v4, v11, :cond_431

    const/16 v11, 0xde

    .line 1125
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_431
    const/16 v11, 0x2e

    if-ne v4, v11, :cond_432

    const/16 v11, 0x33

    .line 1126
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_432
    const/16 v11, 0x2f

    if-ne v4, v11, :cond_433

    const/16 v11, 0x68

    .line 1127
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_433
    const/16 v11, 0x30

    if-ne v4, v11, :cond_434

    const/16 v11, 0x7b

    .line 1128
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_434
    const/16 v11, 0x31

    if-ne v4, v11, :cond_435

    const/16 v11, 0x22

    .line 1129
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_435
    const/16 v11, 0x32

    if-ne v4, v11, :cond_436

    const/16 v11, 0xce

    .line 1130
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_436
    const/16 v11, 0x33

    if-ne v4, v11, :cond_437

    const/4 v11, 0x2

    .line 1131
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_437
    const/16 v11, 0x34

    if-ne v4, v11, :cond_438

    const/16 v11, 0xbc

    .line 1132
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_438
    const/16 v11, 0x35

    if-ne v4, v11, :cond_439

    const/16 v11, 0x49

    .line 1133
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_439
    const/16 v11, 0x36

    if-ne v4, v11, :cond_43a

    const/16 v11, 0x5f

    .line 1134
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_43a
    const/16 v11, 0x37

    if-ne v4, v11, :cond_43b

    const/16 v11, 0xb

    .line 1135
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_43b
    const/16 v11, 0x38

    if-ne v4, v11, :cond_43c

    const/16 v11, 0x14

    .line 1136
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_43c
    const/16 v11, 0x39

    if-ne v4, v11, :cond_43d

    const/16 v11, 0x26

    .line 1137
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_43d
    const/16 v11, 0x3a

    if-ne v4, v11, :cond_43e

    const/16 v11, 0x45

    .line 1138
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_43e
    const/16 v11, 0x3b

    if-ne v4, v11, :cond_43f

    const/16 v11, 0x71

    .line 1139
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_43f
    const/16 v11, 0x3c

    if-ne v4, v11, :cond_440

    const/16 v11, 0xb3

    .line 1140
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_440
    const/16 v11, 0x3d

    if-ne v4, v11, :cond_441

    const/16 v11, 0xb7

    .line 1141
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_441
    const/16 v11, 0x3e

    if-ne v4, v11, :cond_442

    const/16 v11, 0xc0

    .line 1142
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_442
    const/16 v11, 0x3f

    if-ne v4, v11, :cond_443

    const/16 v11, 0x1e

    .line 1143
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_443
    const/16 v11, 0x40

    if-ne v4, v11, :cond_444

    const/16 v11, 0x63

    .line 1144
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_444
    const/16 v11, 0x41

    if-ne v4, v11, :cond_445

    const/16 v11, 0xd7

    .line 1145
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_445
    const/16 v11, 0x42

    if-ne v4, v11, :cond_446

    const/16 v11, 0x81

    .line 1146
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_446
    const/16 v11, 0x43

    if-ne v4, v11, :cond_447

    .line 1147
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v14, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_447
    const/16 v11, 0x44

    if-ne v4, v11, :cond_448

    const/16 v11, 0x18

    .line 1148
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_448
    const/16 v11, 0x45

    if-ne v4, v11, :cond_449

    const/16 v11, 0x85

    .line 1149
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_449
    const/16 v11, 0x46

    if-ne v4, v11, :cond_44a

    const/16 v11, 0xc6

    .line 1150
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_44a
    const/16 v11, 0x47

    if-ne v4, v11, :cond_44b

    const/16 v11, 0x62

    .line 1151
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_44b
    const/16 v11, 0x48

    if-ne v4, v11, :cond_44c

    const/16 v11, 0x31

    .line 1152
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_44c
    const/16 v11, 0x49

    if-ne v4, v11, :cond_44d

    const/16 v11, 0x5c

    .line 1153
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_44d
    const/16 v11, 0x4a

    if-ne v4, v11, :cond_44e

    const/16 v11, 0x42

    .line 1154
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_44e
    const/16 v11, 0x4b

    if-ne v4, v11, :cond_44f

    const/16 v11, 0x6a

    .line 1155
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_44f
    const/16 v11, 0x4c

    if-ne v4, v11, :cond_450

    const/16 v11, 0x9a

    .line 1156
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_450
    const/16 v11, 0x4d

    if-ne v4, v11, :cond_451

    const/16 v11, 0x76

    .line 1157
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_451
    const/16 v11, 0x4e

    if-ne v4, v11, :cond_452

    const/16 v11, 0xa4

    .line 1158
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_452
    const/16 v11, 0x4f

    if-ne v4, v11, :cond_453

    const/16 v11, 0x91

    .line 1159
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_453
    const/16 v11, 0x50

    if-ne v4, v11, :cond_454

    const/16 v11, 0xb1

    .line 1160
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_454
    const/16 v11, 0x51

    if-ne v4, v11, :cond_455

    const/16 v11, 0x79

    .line 1161
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_455
    const/16 v11, 0x52

    if-ne v4, v11, :cond_456

    const/16 v11, 0xbe

    .line 1162
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_456
    const/16 v11, 0x53

    if-ne v4, v11, :cond_457

    const/16 v11, 0x54

    .line 1163
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_457
    const/16 v11, 0x54

    if-ne v4, v11, :cond_458

    const/16 v11, 0x3b

    .line 1164
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_458
    const/16 v11, 0x55

    if-ne v4, v11, :cond_459

    .line 1165
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xac

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_459
    const/16 v11, 0x56

    if-ne v4, v11, :cond_45a

    const/16 v11, 0x95

    .line 1166
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_45a
    const/16 v11, 0x57

    if-ne v4, v11, :cond_45b

    const/16 v11, 0x4b

    .line 1167
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_45b
    const/16 v11, 0x58

    if-ne v4, v11, :cond_45c

    const/16 v11, 0x17

    .line 1168
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_45c
    const/16 v11, 0x59

    if-ne v4, v11, :cond_45d

    const/16 v11, 0x97

    .line 1169
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_45d
    const/16 v11, 0x5a

    if-ne v4, v11, :cond_45e

    const/16 v11, 0xcf

    .line 1170
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_45e
    const/16 v11, 0x5b

    if-ne v4, v11, :cond_45f

    const/16 v11, 0x13

    .line 1171
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_45f
    const/16 v11, 0x5c

    if-ne v4, v11, :cond_460

    const/16 v11, 0x8

    .line 1172
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_460
    const/16 v11, 0x5d

    if-ne v4, v11, :cond_461

    const/16 v11, 0xf

    .line 1173
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_461
    const/16 v11, 0x5e

    if-ne v4, v11, :cond_462

    .line 1174
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xf7

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_462
    const/16 v11, 0x5f

    if-ne v4, v11, :cond_463

    const/16 v11, 0x25

    .line 1175
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_463
    const/16 v11, 0x60

    if-ne v4, v11, :cond_464

    const/16 v11, 0xa7

    .line 1176
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_464
    const/16 v11, 0x61

    if-ne v4, v11, :cond_465

    .line 1177
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xff

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_465
    const/16 v11, 0x62

    if-ne v4, v11, :cond_466

    const/16 v11, 0x66

    .line 1178
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_466
    const/16 v11, 0x63

    if-ne v4, v11, :cond_467

    const/16 v11, 0xe2

    .line 1179
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_467
    const/16 v11, 0x64

    if-ne v4, v11, :cond_468

    const/16 v11, 0x87

    .line 1180
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_468
    const/16 v11, 0x65

    if-ne v4, v11, :cond_469

    const/16 v11, 0x64

    .line 1181
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_469
    const/16 v11, 0x66

    if-ne v4, v11, :cond_46a

    const/16 v11, 0x12

    .line 1182
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_46a
    const/16 v11, 0x67

    if-ne v4, v11, :cond_46b

    const/16 v11, 0xb0

    .line 1183
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_46b
    const/16 v11, 0x68

    if-ne v4, v11, :cond_46c

    const/16 v11, 0xab

    .line 1184
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_46c
    const/16 v11, 0x69

    if-ne v4, v11, :cond_46d

    const/4 v11, 0x4

    .line 1185
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_46d
    const/16 v11, 0x6a

    if-ne v4, v11, :cond_46e

    const/16 v11, 0x69

    .line 1186
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_46e
    const/16 v11, 0x6b

    if-ne v4, v11, :cond_46f

    const/16 v11, 0x6f

    .line 1187
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_46f
    const/16 v11, 0x6c

    if-ne v4, v11, :cond_470

    .line 1188
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xfb

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_470
    const/16 v11, 0x6d

    if-ne v4, v11, :cond_471

    const/16 v11, 0x9

    .line 1189
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_471
    const/16 v11, 0x6e

    if-ne v4, v11, :cond_472

    const/16 v11, 0xdb

    .line 1190
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_472
    const/16 v11, 0x6f

    if-ne v4, v11, :cond_473

    const/16 v11, 0x58

    .line 1191
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_473
    const/16 v11, 0x70

    if-ne v4, v11, :cond_474

    const/16 v11, 0x5d

    .line 1192
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_474
    const/16 v11, 0x71

    if-ne v4, v11, :cond_475

    const/16 v11, 0xd5

    .line 1193
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_475
    const/16 v11, 0x72

    if-ne v4, v11, :cond_476

    const/16 v11, 0xa9

    .line 1194
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_476
    const/16 v11, 0x73

    if-ne v4, v11, :cond_477

    const/16 v11, 0x10

    .line 1195
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_477
    const/16 v11, 0x74

    if-ne v4, v11, :cond_478

    const/16 v11, 0xe5

    .line 1196
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_478
    const/16 v11, 0x75

    if-ne v4, v11, :cond_479

    const/16 v11, 0x39

    .line 1197
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_479
    const/16 v11, 0x76

    if-ne v4, v11, :cond_47a

    const/16 v11, 0x3d

    .line 1198
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_47a
    const/16 v11, 0x77

    if-ne v4, v11, :cond_47b

    const/16 v11, 0x23

    .line 1199
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_47b
    const/16 v11, 0x78

    if-ne v4, v11, :cond_47c

    .line 1200
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x41

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_47c
    const/16 v11, 0x79

    if-ne v4, v11, :cond_47d

    const/16 v11, 0xee

    .line 1201
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_47d
    const/16 v11, 0x7a

    if-ne v4, v11, :cond_47e

    const/16 v11, 0x8d

    .line 1202
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_47e
    const/16 v11, 0x7b

    if-ne v4, v11, :cond_47f

    const/16 v11, 0xd8

    .line 1203
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_47f
    const/16 v11, 0x7c

    if-ne v4, v11, :cond_480

    const/16 v11, 0xc7

    .line 1204
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_480
    const/16 v11, 0x7d

    if-ne v4, v11, :cond_481

    const/16 v11, 0xb6

    .line 1205
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_481
    const/16 v11, 0x7e

    if-ne v4, v11, :cond_482

    const/16 v11, 0x16

    .line 1206
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_482
    const/16 v11, 0x7f

    if-ne v4, v11, :cond_483

    const/16 v11, 0xe6

    .line 1207
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_483
    const/16 v11, 0x80

    if-ne v4, v11, :cond_484

    const/16 v11, 0xc8

    .line 1208
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_484
    const/16 v11, 0x81

    if-ne v4, v11, :cond_485

    const/16 v11, 0x2a

    .line 1209
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_485
    const/16 v11, 0x82

    if-ne v4, v11, :cond_486

    const/16 v11, 0x4c

    .line 1210
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_486
    const/16 v11, 0x83

    if-ne v4, v11, :cond_487

    const/16 v11, 0xe1

    .line 1211
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_487
    const/16 v11, 0x84

    if-ne v4, v11, :cond_488

    const/16 v11, 0x4a

    .line 1212
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_488
    const/16 v11, 0x85

    if-ne v4, v11, :cond_489

    const/16 v11, 0xa6

    .line 1213
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_489
    const/16 v11, 0x86

    if-ne v4, v11, :cond_48a

    const/16 v11, 0x93

    .line 1214
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_48a
    const/16 v11, 0x87

    if-ne v4, v11, :cond_48b

    const/16 v11, 0xf2

    .line 1215
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_48b
    const/16 v11, 0x88

    if-ne v4, v11, :cond_48c

    const/16 v11, 0x32

    .line 1216
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_48c
    const/16 v11, 0x89

    if-ne v4, v11, :cond_48d

    const/16 v11, 0x67

    .line 1217
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_48d
    const/16 v11, 0x8a

    if-ne v4, v11, :cond_48e

    const/16 v11, 0x44

    .line 1218
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_48e
    const/16 v11, 0x8b

    if-ne v4, v11, :cond_48f

    const/16 v11, 0xc1

    .line 1219
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_48f
    const/16 v11, 0x8c

    if-ne v4, v11, :cond_490

    const/16 v11, 0x43

    .line 1220
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_490
    const/16 v11, 0x8d

    if-ne v4, v11, :cond_491

    const/16 v11, 0x1c

    .line 1221
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_491
    const/16 v11, 0x8e

    if-ne v4, v11, :cond_492

    const/16 v11, 0xf3

    .line 1222
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_492
    const/16 v11, 0x8f

    if-ne v4, v11, :cond_493

    const/16 v11, 0xa2

    .line 1223
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_493
    const/16 v11, 0x90

    if-ne v4, v11, :cond_494

    const/16 v11, 0xc2

    .line 1224
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_494
    const/16 v11, 0x91

    if-ne v4, v11, :cond_495

    const/16 v11, 0x2d

    .line 1225
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_495
    const/16 v11, 0x92

    if-ne v4, v11, :cond_496

    const/16 v11, 0x2b

    .line 1226
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_496
    const/16 v11, 0x93

    if-ne v4, v11, :cond_497

    const/16 v11, 0x11

    .line 1227
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_497
    const/16 v11, 0x94

    if-ne v4, v11, :cond_498

    const/16 v11, 0x7c

    .line 1228
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_498
    const/16 v11, 0x95

    if-ne v4, v11, :cond_499

    const/16 v11, 0x1f

    .line 1229
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_499
    const/16 v11, 0x96

    if-ne v4, v11, :cond_49a

    const/16 v11, 0x37

    .line 1230
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_49a
    const/16 v11, 0x97

    if-ne v4, v11, :cond_49b

    const/16 v11, 0x15

    .line 1231
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_49b
    const/16 v11, 0x98

    if-ne v4, v11, :cond_49c

    const/16 v11, 0x2f

    .line 1232
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_49c
    const/16 v11, 0x99

    if-ne v4, v11, :cond_49d

    const/16 v11, 0xc5

    .line 1233
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_49d
    const/16 v11, 0x9a

    if-ne v4, v11, :cond_49e

    const/16 v11, 0x7e

    .line 1234
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_49e
    const/16 v11, 0x9b

    if-ne v4, v11, :cond_49f

    const/16 v11, 0x7a

    .line 1235
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_49f
    const/16 v11, 0x9c

    if-ne v4, v11, :cond_4a0

    const/16 v11, 0xc4

    .line 1236
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a0
    const/16 v11, 0x9d

    if-ne v4, v11, :cond_4a1

    const/16 v11, 0x88

    .line 1237
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a1
    const/16 v11, 0x9e

    if-ne v4, v11, :cond_4a2

    const/16 v11, 0xcc

    .line 1238
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a2
    const/16 v11, 0x9f

    if-ne v4, v11, :cond_4a3

    const/16 v11, 0x4f

    .line 1239
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a3
    const/16 v11, 0xa0

    if-ne v4, v11, :cond_4a4

    const/16 v11, 0x84

    .line 1240
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a4
    const/16 v11, 0xa1

    if-ne v4, v11, :cond_4a5

    const/16 v11, 0x20

    .line 1241
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a5
    const/16 v11, 0xa2

    if-ne v4, v11, :cond_4a6

    const/16 v11, 0x5b

    .line 1242
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a6
    const/16 v11, 0xa3

    if-ne v4, v11, :cond_4a7

    const/16 v11, 0x8c

    .line 1243
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a7
    const/16 v11, 0xa4

    if-ne v4, v11, :cond_4a8

    const/16 v11, 0xea

    .line 1244
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a8
    const/16 v11, 0xa5

    if-ne v4, v11, :cond_4a9

    .line 1245
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xec

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4a9
    const/16 v11, 0xa6

    if-ne v4, v11, :cond_4aa

    const/16 v11, 0xc3

    .line 1246
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4aa
    const/16 v11, 0xa7

    if-ne v4, v11, :cond_4ab

    const/16 v11, 0x7d

    .line 1247
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ab
    const/16 v11, 0xa8

    if-ne v4, v11, :cond_4ac

    const/16 v11, 0xc

    .line 1248
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ac
    const/16 v11, 0xa9

    if-ne v4, v11, :cond_4ad

    const/16 v11, 0x6d

    .line 1249
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ad
    const/16 v11, 0xaa

    if-ne v4, v11, :cond_4ae

    const/16 v11, 0xb9

    .line 1250
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ae
    const/16 v11, 0xab

    if-ne v4, v11, :cond_4af

    .line 1251
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/4 v12, 0x0

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4af
    const/16 v11, 0xac

    if-ne v4, v11, :cond_4b0

    const/16 v11, 0x40

    .line 1252
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b0
    const/16 v11, 0xad

    if-ne v4, v11, :cond_4b1

    const/16 v11, 0x89

    .line 1253
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b1
    const/16 v11, 0xae

    if-ne v4, v11, :cond_4b2

    const/16 v11, 0x35

    .line 1254
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b2
    const/16 v11, 0xaf

    if-ne v4, v11, :cond_4b3

    const/16 v11, 0xf1

    .line 1255
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b3
    const/16 v11, 0xb0

    if-ne v4, v11, :cond_4b4

    const/16 v11, 0xb2

    .line 1256
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b4
    const/16 v11, 0xb1

    if-ne v4, v11, :cond_4b5

    const/16 v11, 0x8a

    .line 1257
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b5
    const/16 v11, 0xb2

    if-ne v4, v11, :cond_4b6

    const/16 v11, 0x7f

    .line 1258
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b6
    const/16 v11, 0xb3

    if-ne v4, v11, :cond_4b7

    const/16 v11, 0x70

    .line 1259
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b7
    const/16 v11, 0xb4

    if-ne v4, v11, :cond_4b8

    const/16 v11, 0xa0

    .line 1260
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b8
    const/16 v11, 0xb5

    if-ne v4, v11, :cond_4b9

    const/16 v11, 0x47

    .line 1261
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4b9
    const/16 v11, 0xb6

    if-ne v4, v11, :cond_4ba

    const/16 v11, 0x57

    .line 1262
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ba
    const/16 v11, 0xb7

    if-ne v4, v11, :cond_4bb

    const/16 v11, 0x30

    .line 1263
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4bb
    const/16 v11, 0xb8

    if-ne v4, v11, :cond_4bc

    const/16 v11, 0x38

    .line 1264
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4bc
    const/16 v11, 0xb9

    if-ne v4, v11, :cond_4bd

    const/16 v11, 0x78

    .line 1265
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4bd
    const/16 v11, 0xba

    if-ne v4, v11, :cond_4be

    const/16 v11, 0xf0

    .line 1266
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4be
    const/16 v11, 0xbb

    if-ne v4, v11, :cond_4bf

    const/16 v11, 0xaf

    .line 1267
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4bf
    const/16 v11, 0xbc

    if-ne v4, v11, :cond_4c0

    const/16 v11, 0x28

    .line 1268
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c0
    const/16 v11, 0xbd

    if-ne v4, v11, :cond_4c1

    const/16 v11, 0x96

    .line 1269
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c1
    const/16 v11, 0xbe

    if-ne v4, v11, :cond_4c2

    const/16 v11, 0x72

    .line 1270
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c2
    const/16 v11, 0xbf

    if-ne v4, v11, :cond_4c3

    const/16 v11, 0x77

    .line 1271
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c3
    const/16 v11, 0xc0

    if-ne v4, v11, :cond_4c4

    const/16 v11, 0xdd

    .line 1272
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c4
    const/16 v11, 0xc1

    if-ne v4, v11, :cond_4c5

    .line 1273
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x92

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c5
    const/16 v11, 0xc2

    if-ne v4, v11, :cond_4c6

    const/16 v11, 0xc9

    .line 1274
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c6
    const/16 v11, 0xc3

    if-ne v4, v11, :cond_4c7

    const/16 v11, 0xe4

    .line 1275
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c7
    const/16 v11, 0xc4

    if-ne v4, v11, :cond_4c8

    const/16 v11, 0xe0

    .line 1276
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c8
    const/16 v11, 0xc5

    if-ne v4, v11, :cond_4c9

    const/16 v11, 0x2c

    .line 1277
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4c9
    const/16 v11, 0xc6

    if-ne v4, v11, :cond_4ca

    const/16 v11, 0x98

    .line 1278
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ca
    const/16 v11, 0xc7

    if-ne v4, v11, :cond_4cb

    const/16 v11, 0xe3

    .line 1279
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4cb
    const/16 v11, 0xc8

    if-ne v4, v11, :cond_4cc

    const/16 v11, 0x56

    .line 1280
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4cc
    const/16 v11, 0xc9

    if-ne v4, v11, :cond_4cd

    const/16 v11, 0x9c

    .line 1281
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4cd
    const/16 v11, 0xca

    if-ne v4, v11, :cond_4ce

    const/16 v11, 0xd4

    .line 1282
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ce
    const/16 v11, 0xcb

    if-ne v4, v11, :cond_4cf

    const/16 v11, 0x3e

    .line 1283
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4cf
    const/16 v11, 0xcc

    if-ne v4, v11, :cond_4d0

    const/16 v11, 0x50

    .line 1284
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d0
    const/16 v11, 0xcd

    if-ne v4, v11, :cond_4d1

    const/16 v11, 0x60

    .line 1285
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d1
    const/16 v11, 0xce

    if-ne v4, v11, :cond_4d2

    const/16 v11, 0xd0

    .line 1286
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d2
    const/16 v11, 0xcf

    if-ne v4, v11, :cond_4d3

    const/16 v11, 0x3f

    .line 1287
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d3
    const/16 v11, 0xd0

    if-ne v4, v11, :cond_4d4

    const/16 v11, 0xfd

    .line 1288
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d4
    const/16 v11, 0xd1

    if-ne v4, v11, :cond_4d5

    const/16 v11, 0x6c

    .line 1289
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d5
    const/16 v11, 0xd2

    if-ne v4, v11, :cond_4d6

    const/16 v11, 0xcb

    .line 1290
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d6
    const/16 v11, 0xd3

    if-ne v4, v11, :cond_4d7

    const/16 v11, 0xa5

    .line 1291
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d7
    const/16 v11, 0xd4

    if-ne v4, v11, :cond_4d8

    const/16 v11, 0x73

    .line 1292
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d8
    const/16 v11, 0xd5

    if-ne v4, v11, :cond_4d9

    const/16 v11, 0x80

    .line 1293
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4d9
    const/16 v11, 0xd6

    if-ne v4, v11, :cond_4da

    const/16 v11, 0x5a

    .line 1294
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4da
    const/16 v11, 0xd7

    if-ne v4, v11, :cond_4db

    const/16 v11, 0xd2

    .line 1295
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4db
    const/16 v11, 0xd8

    if-ne v4, v11, :cond_4dc

    const/16 v11, 0x99

    .line 1296
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4dc
    const/16 v11, 0xd9

    if-ne v4, v11, :cond_4dd

    .line 1297
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v13, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4dd
    const/16 v11, 0xda

    if-ne v4, v11, :cond_4de

    const/16 v11, 0x55

    .line 1298
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4de
    const/16 v11, 0xdb

    if-ne v4, v11, :cond_4df

    const/16 v11, 0x29

    .line 1299
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4df
    const/16 v11, 0xdc

    if-ne v4, v11, :cond_4e0

    const/16 v11, 0x53

    .line 1300
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e0
    const/16 v11, 0xdd

    if-ne v4, v11, :cond_4e1

    .line 1301
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v9, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e1
    const/16 v11, 0xde

    if-ne v4, v11, :cond_4e2

    const/16 v11, 0x94

    .line 1302
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e2
    const/16 v11, 0xdf

    if-ne v4, v11, :cond_4e3

    const/16 v11, 0xe8

    .line 1303
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e3
    const/16 v11, 0xe0

    if-ne v4, v11, :cond_4e4

    const/16 v11, 0x1b

    .line 1304
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e4
    const/16 v11, 0xe1

    if-ne v4, v11, :cond_4e5

    .line 1305
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x61

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e5
    const/16 v11, 0xe2

    if-ne v4, v11, :cond_4e6

    const/16 v11, 0x3c

    .line 1306
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e6
    const/16 v11, 0xe3

    if-ne v4, v11, :cond_4e7

    const/16 v11, 0x6b

    .line 1307
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e7
    const/16 v11, 0xe4

    if-ne v4, v11, :cond_4e8

    const/16 v11, 0xbd

    .line 1308
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e8
    const/16 v11, 0xe5

    if-ne v4, v11, :cond_4e9

    const/16 v11, 0xda

    .line 1309
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4e9
    const/16 v11, 0xe6

    if-ne v4, v11, :cond_4ea

    const/16 v11, 0xbb

    .line 1310
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ea
    const/16 v11, 0xe7

    if-ne v4, v11, :cond_4eb

    const/16 v11, 0xd3

    .line 1311
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4eb
    const/16 v11, 0xe8

    if-ne v4, v11, :cond_4ec

    const/16 v11, 0xbf

    .line 1312
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ec
    const/16 v11, 0xe9

    if-ne v4, v11, :cond_4ed

    const/16 v11, 0xa3

    .line 1313
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ed
    const/16 v11, 0xea

    if-ne v4, v11, :cond_4ee

    const/16 v11, 0x8b

    .line 1314
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ee
    const/16 v11, 0xeb

    if-ne v4, v11, :cond_4ef

    const/16 v11, 0xef

    .line 1315
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4ef
    const/16 v11, 0xec

    if-ne v4, v11, :cond_4f0

    const/16 v11, 0x4d

    .line 1316
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f0
    const/16 v11, 0xed

    if-ne v4, v11, :cond_4f1

    const/16 v11, 0xd1

    .line 1317
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f1
    const/16 v11, 0xee

    if-ne v4, v11, :cond_4f2

    const/16 v11, 0x1d

    .line 1318
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f2
    const/16 v11, 0xef

    if-ne v4, v11, :cond_4f3

    const/16 v11, 0xdf

    .line 1319
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f3
    const/16 v11, 0xf0

    if-ne v4, v11, :cond_4f4

    const/16 v11, 0x5e

    .line 1320
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f4
    const/16 v11, 0xf1

    if-ne v4, v11, :cond_4f5

    const/16 v11, 0x75

    .line 1321
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f5
    const/16 v11, 0xf2

    if-ne v4, v11, :cond_4f6

    const/16 v11, 0x52

    .line 1322
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f6
    const/16 v11, 0xf3

    if-ne v4, v11, :cond_4f7

    const/16 v11, 0x51

    .line 1323
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f7
    const/16 v11, 0xf4

    if-ne v4, v11, :cond_4f8

    const/16 v11, 0xe

    .line 1324
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f8
    const/16 v11, 0xf5

    if-ne v4, v11, :cond_4f9

    const/16 v11, 0xd9

    .line 1325
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4f9
    const/16 v11, 0xf6

    if-ne v4, v11, :cond_4fa

    const/4 v11, 0x5

    .line 1326
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4fa
    const/16 v11, 0xf7

    if-ne v4, v11, :cond_4fb

    const/16 v11, 0x21

    .line 1327
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4fb
    const/16 v11, 0xf8

    if-ne v4, v11, :cond_4fc

    const/16 v11, 0xae

    .line 1328
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto/16 :goto_7

    :cond_4fc
    const/16 v11, 0xf9

    if-ne v4, v11, :cond_4fd

    const/16 v11, 0xb4

    .line 1329
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto :goto_7

    :cond_4fd
    const/16 v11, 0xfa

    if-ne v4, v11, :cond_4fe

    const/16 v11, 0xfc

    .line 1330
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto :goto_7

    :cond_4fe
    const/16 v11, 0xfb

    if-ne v4, v11, :cond_4ff

    const/16 v11, 0xe7

    .line 1331
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto :goto_7

    :cond_4ff
    const/16 v11, 0xfc

    if-ne v4, v11, :cond_500

    const/16 v11, 0xdc

    .line 1332
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto :goto_7

    :cond_500
    const/16 v11, 0xfd

    if-ne v4, v11, :cond_501

    const/16 v11, 0x24

    .line 1333
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto :goto_7

    :cond_501
    const/16 v11, 0xfe

    if-ne v4, v11, :cond_502

    const/16 v11, 0x2e

    .line 1334
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    const/16 v12, 0xca

    goto :goto_7

    :cond_502
    const/16 v11, 0xff

    if-ne v4, v11, :cond_503

    const/16 v11, 0xf9

    .line 1335
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m4(II)I

    move-result v11

    goto :goto_6

    :cond_503
    const/4 v11, 0x0

    :goto_6
    const/16 v12, 0xca

    :goto_7
    and-int/2addr v11, v12

    const/16 v12, 0x82

    if-eq v11, v12, :cond_504

    const/4 v11, 0x0

    return v11

    :cond_504
    const/4 v11, 0x0

    and-int/lit8 v12, p5, 0x41

    const/16 v15, 0x41

    if-eq v12, v15, :cond_505

    return v11

    .line 1346
    :cond_505
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->scramble(I)I

    move-result v10

    if-nez v5, :cond_506

    .line 1347
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v14, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_506
    if-ne v5, v13, :cond_507

    const/16 v11, 0x70

    .line 1348
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_507
    const/4 v11, 0x2

    if-ne v5, v11, :cond_508

    const/16 v11, 0x43

    .line 1349
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_508
    const/4 v11, 0x3

    if-ne v5, v11, :cond_509

    const/16 v11, 0x98

    .line 1350
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_509
    const/4 v11, 0x4

    if-ne v5, v11, :cond_50a

    const/16 v11, 0x58

    .line 1351
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_50a
    const/4 v11, 0x5

    if-ne v5, v11, :cond_50b

    const/16 v11, 0x4a

    .line 1352
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_50b
    if-ne v5, v14, :cond_50c

    const/16 v11, 0xa1

    .line 1353
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_50c
    const/4 v11, 0x7

    if-ne v5, v11, :cond_50d

    const/16 v11, 0x7c

    .line 1354
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_50d
    const/16 v11, 0x8

    if-ne v5, v11, :cond_50e

    const/16 v11, 0x2a

    .line 1355
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_50e
    const/16 v11, 0x9

    if-ne v5, v11, :cond_50f

    const/16 v11, 0x64

    .line 1356
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_50f
    const/16 v11, 0xa

    if-ne v5, v11, :cond_510

    .line 1357
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xf7

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_510
    const/16 v11, 0xb

    if-ne v5, v11, :cond_511

    const/16 v11, 0x46

    .line 1358
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_511
    const/16 v11, 0xc

    if-ne v5, v11, :cond_512

    const/16 v11, 0xe2

    .line 1359
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_512
    if-ne v5, v9, :cond_513

    const/16 v11, 0x13

    .line 1360
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_513
    const/16 v11, 0xe

    if-ne v5, v11, :cond_514

    const/16 v11, 0xd7

    .line 1361
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_514
    const/16 v11, 0xf

    if-ne v5, v11, :cond_515

    const/16 v11, 0x3d

    .line 1362
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_515
    const/16 v11, 0x10

    if-ne v5, v11, :cond_516

    const/16 v11, 0x8d

    .line 1363
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_516
    const/16 v11, 0x11

    if-ne v5, v11, :cond_517

    const/16 v11, 0xba

    .line 1364
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_517
    const/16 v11, 0x12

    if-ne v5, v11, :cond_518

    const/16 v11, 0xbe

    .line 1365
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_518
    const/16 v11, 0x13

    if-ne v5, v11, :cond_519

    const/16 v11, 0x81

    .line 1366
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_519
    const/16 v11, 0x14

    if-ne v5, v11, :cond_51a

    const/16 v11, 0x18

    .line 1367
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_51a
    const/16 v11, 0x15

    if-ne v5, v11, :cond_51b

    .line 1368
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xff

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_51b
    const/16 v11, 0x16

    if-ne v5, v11, :cond_51c

    const/16 v11, 0xad

    .line 1369
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_51c
    const/16 v11, 0x17

    if-ne v5, v11, :cond_51d

    const/16 v11, 0x83

    .line 1370
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_51d
    const/16 v11, 0x18

    if-ne v5, v11, :cond_51e

    const/16 v11, 0x17

    .line 1371
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_51e
    const/16 v11, 0x19

    if-ne v5, v11, :cond_51f

    const/16 v11, 0xb4

    .line 1372
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_51f
    const/16 v11, 0x1a

    if-ne v5, v11, :cond_520

    const/16 v11, 0x19

    .line 1373
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_520
    const/16 v11, 0x1b

    if-ne v5, v11, :cond_521

    const/16 v11, 0x1b

    .line 1374
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_521
    const/16 v11, 0x1c

    if-ne v5, v11, :cond_522

    const/16 v11, 0x21

    .line 1375
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_522
    const/16 v11, 0x1d

    if-ne v5, v11, :cond_523

    const/16 v11, 0x54

    .line 1376
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_523
    const/16 v11, 0x1e

    if-ne v5, v11, :cond_524

    const/16 v11, 0xed

    .line 1377
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_524
    const/16 v11, 0x1f

    if-ne v5, v11, :cond_525

    const/16 v11, 0xf5

    .line 1378
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_525
    const/16 v11, 0x20

    if-ne v5, v11, :cond_526

    const/16 v11, 0x1e

    .line 1379
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_526
    const/16 v11, 0x21

    if-ne v5, v11, :cond_527

    const/16 v11, 0x2d

    .line 1380
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_527
    const/16 v11, 0x22

    if-ne v5, v11, :cond_528

    const/16 v11, 0x8

    .line 1381
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_528
    const/16 v11, 0x23

    if-ne v5, v11, :cond_529

    const/16 v11, 0x7a

    .line 1382
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_529
    const/16 v11, 0x24

    if-ne v5, v11, :cond_52a

    const/16 v11, 0x7e

    .line 1383
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_52a
    const/16 v11, 0x25

    if-ne v5, v11, :cond_52b

    const/16 v11, 0x85

    .line 1384
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_52b
    const/16 v11, 0x26

    if-ne v5, v11, :cond_52c

    const/16 v11, 0xea

    .line 1385
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_52c
    const/16 v11, 0x27

    if-ne v5, v11, :cond_52d

    const/16 v11, 0x72

    .line 1386
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_52d
    const/16 v11, 0x28

    if-ne v5, v11, :cond_52e

    const/16 v11, 0xb9

    .line 1387
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_52e
    const/16 v11, 0x29

    if-ne v5, v11, :cond_52f

    const/16 v11, 0x59

    .line 1388
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_52f
    const/16 v11, 0x2a

    if-ne v5, v11, :cond_530

    .line 1389
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x61

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_530
    const/16 v11, 0x2b

    if-ne v5, v11, :cond_531

    const/16 v11, 0xcb

    .line 1390
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_531
    const/16 v11, 0x2c

    if-ne v5, v11, :cond_532

    const/16 v11, 0x7d

    .line 1391
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_532
    const/16 v11, 0x2d

    if-ne v5, v11, :cond_533

    const/16 v11, 0xa

    .line 1392
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_533
    const/16 v11, 0x2e

    if-ne v5, v11, :cond_534

    const/16 v11, 0x5a

    .line 1393
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_534
    const/16 v11, 0x2f

    if-ne v5, v11, :cond_535

    const/16 v11, 0xd5

    .line 1394
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_535
    const/16 v11, 0x30

    if-ne v5, v11, :cond_536

    const/16 v11, 0x47

    .line 1395
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_536
    const/16 v11, 0x31

    if-ne v5, v11, :cond_537

    const/16 v11, 0x63

    .line 1396
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_537
    const/16 v11, 0x32

    if-ne v5, v11, :cond_538

    .line 1397
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xac

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_538
    const/16 v11, 0x33

    if-ne v5, v11, :cond_539

    const/16 v11, 0xc4

    .line 1398
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_539
    const/16 v11, 0x34

    if-ne v5, v11, :cond_53a

    const/16 v11, 0xe0

    .line 1399
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_53a
    const/16 v11, 0x35

    if-ne v5, v11, :cond_53b

    const/16 v11, 0xd0

    .line 1400
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_53b
    const/16 v11, 0x36

    if-ne v5, v11, :cond_53c

    .line 1401
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xfb

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_53c
    const/16 v11, 0x37

    if-ne v5, v11, :cond_53d

    const/16 v11, 0xce

    .line 1402
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_53d
    const/16 v11, 0x38

    if-ne v5, v11, :cond_53e

    const/16 v11, 0xd1

    .line 1403
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_53e
    const/16 v11, 0x39

    if-ne v5, v11, :cond_53f

    .line 1404
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x8e

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_53f
    const/16 v11, 0x3a

    if-ne v5, v11, :cond_540

    const/16 v11, 0x5b

    .line 1405
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_540
    const/16 v11, 0x3b

    if-ne v5, v11, :cond_541

    const/16 v11, 0xef

    .line 1406
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_541
    const/16 v11, 0x3c

    if-ne v5, v11, :cond_542

    const/16 v11, 0xae

    .line 1407
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_542
    const/16 v11, 0x3d

    if-ne v5, v11, :cond_543

    const/16 v11, 0xb0

    .line 1408
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_543
    const/16 v11, 0x3e

    if-ne v5, v11, :cond_544

    const/16 v11, 0x5e

    .line 1409
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_544
    const/16 v11, 0x3f

    if-ne v5, v11, :cond_545

    .line 1410
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/4 v12, 0x0

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_545
    const/16 v11, 0x40

    if-ne v5, v11, :cond_546

    const/4 v11, 0x4

    .line 1411
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_546
    const/16 v11, 0x41

    if-ne v5, v11, :cond_547

    const/16 v11, 0x4b

    .line 1412
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_547
    const/16 v11, 0x42

    if-ne v5, v11, :cond_548

    const/16 v11, 0xa7

    .line 1413
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_548
    const/16 v11, 0x43

    if-ne v5, v11, :cond_549

    const/16 v11, 0xde

    .line 1414
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_549
    const/16 v11, 0x44

    if-ne v5, v11, :cond_54a

    const/16 v11, 0xcd

    .line 1415
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_54a
    const/16 v11, 0x45

    if-ne v5, v11, :cond_54b

    .line 1416
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x92

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_54b
    const/16 v11, 0x46

    if-ne v5, v11, :cond_54c

    const/16 v11, 0x9c

    .line 1417
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_54c
    const/16 v11, 0x47

    if-ne v5, v11, :cond_54d

    const/16 v11, 0x6c

    .line 1418
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_54d
    const/16 v11, 0x48

    if-ne v5, v11, :cond_54e

    const/16 v11, 0xf0

    .line 1419
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_54e
    const/16 v11, 0x49

    if-ne v5, v11, :cond_54f

    const/16 v11, 0xc7

    .line 1420
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_54f
    const/16 v11, 0x4a

    if-ne v5, v11, :cond_550

    const/16 v11, 0x4c

    .line 1421
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_550
    const/16 v11, 0x4b

    if-ne v5, v11, :cond_551

    const/16 v11, 0xee

    .line 1422
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_551
    const/16 v11, 0x4c

    if-ne v5, v11, :cond_552

    const/16 v11, 0x12

    .line 1423
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_552
    const/16 v11, 0x4d

    if-ne v5, v11, :cond_553

    const/16 v11, 0x33

    .line 1424
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_553
    const/16 v11, 0x4e

    if-ne v5, v11, :cond_554

    const/16 v11, 0x3f

    .line 1425
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_554
    const/16 v11, 0x4f

    if-ne v5, v11, :cond_555

    const/16 v11, 0xe4

    .line 1426
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_555
    const/16 v11, 0x50

    if-ne v5, v11, :cond_556

    const/16 v11, 0x71

    .line 1427
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_556
    const/16 v11, 0x51

    if-ne v5, v11, :cond_557

    const/16 v11, 0x10

    .line 1428
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_557
    const/16 v11, 0x52

    if-ne v5, v11, :cond_558

    const/16 v11, 0x9e

    .line 1429
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_558
    const/16 v11, 0x53

    if-ne v5, v11, :cond_559

    const/16 v11, 0xb6

    .line 1430
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_559
    const/16 v11, 0x54

    if-ne v5, v11, :cond_55a

    const/16 v11, 0xb7

    .line 1431
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_55a
    const/16 v11, 0x55

    if-ne v5, v11, :cond_55b

    const/16 v11, 0x45

    .line 1432
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_55b
    const/16 v11, 0x56

    if-ne v5, v11, :cond_55c

    const/16 v11, 0x6e

    .line 1433
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_55c
    const/16 v11, 0x57

    if-ne v5, v11, :cond_55d

    const/16 v11, 0x9

    .line 1434
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_55d
    const/16 v11, 0x58

    if-ne v5, v11, :cond_55e

    .line 1435
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x41

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_55e
    const/16 v11, 0x59

    if-ne v5, v11, :cond_55f

    const/16 v11, 0x78

    .line 1436
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_55f
    const/16 v11, 0x5a

    if-ne v5, v11, :cond_560

    const/16 v11, 0xf9

    .line 1437
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_560
    const/16 v11, 0x5b

    if-ne v5, v11, :cond_561

    const/16 v11, 0xcc

    .line 1438
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_561
    const/16 v11, 0x5c

    if-ne v5, v11, :cond_562

    const/16 v11, 0x51

    .line 1439
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_562
    const/16 v11, 0x5d

    if-ne v5, v11, :cond_563

    const/16 v11, 0xe9

    .line 1440
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_563
    const/16 v11, 0x5e

    if-ne v5, v11, :cond_564

    const/16 v11, 0x22

    .line 1441
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_564
    const/16 v11, 0x5f

    if-ne v5, v11, :cond_565

    const/16 v11, 0x3e

    .line 1442
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_565
    const/16 v11, 0x60

    if-ne v5, v11, :cond_566

    const/16 v11, 0xdc

    .line 1443
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_566
    const/16 v11, 0x61

    if-ne v5, v11, :cond_567

    const/16 v11, 0xd8

    .line 1444
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_567
    const/16 v11, 0x62

    if-ne v5, v11, :cond_568

    const/16 v11, 0xa6

    .line 1445
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_568
    const/16 v11, 0x63

    if-ne v5, v11, :cond_569

    const/16 v11, 0xa2

    .line 1446
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_569
    const/16 v11, 0x64

    if-ne v5, v11, :cond_56a

    const/16 v11, 0x39

    .line 1447
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_56a
    const/16 v11, 0x65

    if-ne v5, v11, :cond_56b

    .line 1448
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v9, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_56b
    const/16 v11, 0x66

    if-ne v5, v11, :cond_56c

    const/16 v11, 0x4e

    .line 1449
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_56c
    const/16 v11, 0x67

    if-ne v5, v11, :cond_56d

    const/16 v11, 0xc0

    .line 1450
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_56d
    const/16 v11, 0x68

    if-ne v5, v11, :cond_56e

    const/16 v11, 0x9f

    .line 1451
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_56e
    const/16 v11, 0x69

    if-ne v5, v11, :cond_56f

    const/4 v11, 0x7

    .line 1452
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_56f
    const/16 v11, 0x6a

    if-ne v5, v11, :cond_570

    const/16 v11, 0xbf

    .line 1453
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_570
    const/16 v11, 0x6b

    if-ne v5, v11, :cond_571

    const/16 v11, 0xab

    .line 1454
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_571
    const/16 v11, 0x6c

    if-ne v5, v11, :cond_572

    const/16 v11, 0x11

    .line 1455
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_572
    const/16 v11, 0x6d

    if-ne v5, v11, :cond_573

    const/16 v11, 0xbc

    .line 1456
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_573
    const/16 v11, 0x6e

    if-ne v5, v11, :cond_574

    const/16 v11, 0xd3

    .line 1457
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_574
    const/16 v11, 0x6f

    if-ne v5, v11, :cond_575

    const/16 v11, 0xda

    .line 1458
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_575
    const/16 v11, 0x70

    if-ne v5, v11, :cond_576

    const/16 v11, 0xa8

    .line 1459
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_576
    const/16 v11, 0x71

    if-ne v5, v11, :cond_577

    const/16 v11, 0xf6

    .line 1460
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_577
    const/16 v11, 0x72

    if-ne v5, v11, :cond_578

    const/16 v11, 0x87

    .line 1461
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_578
    const/16 v11, 0x73

    if-ne v5, v11, :cond_579

    const/16 v11, 0x80

    .line 1462
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_579
    const/16 v11, 0x74

    if-ne v5, v11, :cond_57a

    const/16 v11, 0x38

    .line 1463
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_57a
    const/16 v11, 0x75

    if-ne v5, v11, :cond_57b

    const/16 v11, 0xe1

    .line 1464
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_57b
    const/16 v11, 0x76

    if-ne v5, v11, :cond_57c

    const/16 v11, 0x8c

    .line 1465
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_57c
    const/16 v11, 0x77

    if-ne v5, v11, :cond_57d

    const/16 v11, 0xe8

    .line 1466
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_57d
    const/16 v11, 0x78

    if-ne v5, v11, :cond_57e

    const/16 v11, 0xe7

    .line 1467
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_57e
    const/16 v11, 0x79

    if-ne v5, v11, :cond_57f

    const/16 v11, 0x6b

    .line 1468
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_57f
    const/16 v11, 0x7a

    if-ne v5, v11, :cond_580

    const/16 v11, 0xe

    .line 1469
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_580
    const/16 v11, 0x7b

    if-ne v5, v11, :cond_581

    const/16 v11, 0xb

    .line 1470
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_581
    const/16 v11, 0x7c

    if-ne v5, v11, :cond_582

    const/16 v11, 0x3a

    .line 1471
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_582
    const/16 v11, 0x7d

    if-ne v5, v11, :cond_583

    const/16 v11, 0x99

    .line 1472
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_583
    const/16 v11, 0x7e

    if-ne v5, v11, :cond_584

    const/16 v11, 0x88

    .line 1473
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_584
    const/16 v11, 0x7f

    if-ne v5, v11, :cond_585

    const/16 v11, 0xc9

    .line 1474
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_585
    const/16 v11, 0x80

    if-ne v5, v11, :cond_586

    const/16 v11, 0x3c

    .line 1475
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_586
    const/16 v11, 0x81

    if-ne v5, v11, :cond_587

    const/16 v11, 0x24

    .line 1476
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_587
    const/16 v11, 0x82

    if-ne v5, v11, :cond_588

    const/16 v11, 0x84

    .line 1477
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_588
    const/16 v11, 0x83

    if-ne v5, v11, :cond_589

    const/16 v11, 0xf3

    .line 1478
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_589
    const/16 v11, 0x84

    if-ne v5, v11, :cond_58a

    const/16 v11, 0x6f

    .line 1479
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_58a
    const/16 v11, 0x85

    if-ne v5, v11, :cond_58b

    const/16 v11, 0x49

    .line 1480
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_58b
    const/16 v11, 0x86

    if-ne v5, v11, :cond_58c

    const/16 v11, 0xa3

    .line 1481
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_58c
    const/16 v11, 0x87

    if-ne v5, v11, :cond_58d

    const/16 v11, 0x90

    .line 1482
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_58d
    const/16 v11, 0x88

    if-ne v5, v11, :cond_58e

    const/16 v11, 0xa4

    .line 1483
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_58e
    const/16 v11, 0x89

    if-ne v5, v11, :cond_58f

    const/16 v11, 0x27

    .line 1484
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_58f
    const/16 v11, 0x8a

    if-ne v5, v11, :cond_590

    .line 1485
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xec

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_590
    const/16 v11, 0x8b

    if-ne v5, v11, :cond_591

    const/16 v11, 0x89

    .line 1486
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_591
    const/16 v11, 0x8c

    if-ne v5, v11, :cond_592

    const/16 v11, 0x4d

    .line 1487
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_592
    const/16 v11, 0x8d

    if-ne v5, v11, :cond_593

    const/16 v11, 0xa0

    .line 1488
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_593
    const/16 v11, 0x8e

    if-ne v5, v11, :cond_594

    const/16 v11, 0x2f

    .line 1489
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_594
    const/16 v11, 0x8f

    if-ne v5, v11, :cond_595

    const/16 v11, 0xf1

    .line 1490
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_595
    const/16 v11, 0x90

    if-ne v5, v11, :cond_596

    const/16 v11, 0x57

    .line 1491
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_596
    const/16 v11, 0x91

    if-ne v5, v11, :cond_597

    const/16 v11, 0x42

    .line 1492
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_597
    const/16 v11, 0x92

    if-ne v5, v11, :cond_598

    const/16 v11, 0xc8

    .line 1493
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_598
    const/16 v11, 0x93

    if-ne v5, v11, :cond_599

    const/16 v11, 0xdf

    .line 1494
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_599
    const/16 v11, 0x94

    if-ne v5, v11, :cond_59a

    const/16 v11, 0xaa

    .line 1495
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_59a
    const/16 v11, 0x95

    if-ne v5, v11, :cond_59b

    const/16 v11, 0xfa

    .line 1496
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_59b
    const/16 v11, 0x96

    if-ne v5, v11, :cond_59c

    const/16 v11, 0x25

    .line 1497
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_59c
    const/16 v11, 0x97

    if-ne v5, v11, :cond_59d

    const/16 v11, 0x67

    .line 1498
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_59d
    const/16 v11, 0x98

    if-ne v5, v11, :cond_59e

    const/16 v11, 0x5c

    .line 1499
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_59e
    const/16 v11, 0x99

    if-ne v5, v11, :cond_59f

    const/16 v11, 0x9d

    .line 1500
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_59f
    const/16 v11, 0x9a

    if-ne v5, v11, :cond_5a0

    const/16 v11, 0x60

    .line 1501
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a0
    const/16 v11, 0x9b

    if-ne v5, v11, :cond_5a1

    const/16 v11, 0x69

    .line 1502
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a1
    const/16 v11, 0x9c

    if-ne v5, v11, :cond_5a2

    const/16 v11, 0xd9

    .line 1503
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a2
    const/16 v11, 0x9d

    if-ne v5, v11, :cond_5a3

    const/16 v11, 0x1c

    .line 1504
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a3
    const/16 v11, 0x9e

    if-ne v5, v11, :cond_5a4

    const/16 v11, 0x8b

    .line 1505
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a4
    const/16 v11, 0x9f

    if-ne v5, v11, :cond_5a5

    const/16 v11, 0x35

    .line 1506
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a5
    const/16 v11, 0xa0

    if-ne v5, v11, :cond_5a6

    const/16 v11, 0x5d

    .line 1507
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a6
    const/16 v11, 0xa1

    if-ne v5, v11, :cond_5a7

    const/16 v11, 0x52

    .line 1508
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a7
    const/16 v11, 0xa2

    if-ne v5, v11, :cond_5a8

    const/16 v11, 0xb3

    .line 1509
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a8
    const/16 v11, 0xa3

    if-ne v5, v11, :cond_5a9

    .line 1510
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x82

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5a9
    const/16 v11, 0xa4

    if-ne v5, v11, :cond_5aa

    const/16 v11, 0xc3

    .line 1511
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5aa
    const/16 v11, 0xa5

    if-ne v5, v11, :cond_5ab

    const/16 v11, 0x23

    .line 1512
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ab
    const/16 v11, 0xa6

    if-ne v5, v11, :cond_5ac

    const/4 v11, 0x2

    .line 1513
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ac
    const/16 v11, 0xa7

    if-ne v5, v11, :cond_5ad

    const/16 v11, 0x1a

    .line 1514
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ad
    const/16 v11, 0xa8

    if-ne v5, v11, :cond_5ae

    const/16 v11, 0x3b

    .line 1515
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ae
    const/16 v11, 0xa9

    if-ne v5, v11, :cond_5af

    const/16 v11, 0xe5

    .line 1516
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5af
    const/16 v11, 0xaa

    if-ne v5, v11, :cond_5b0

    const/16 v11, 0x65

    .line 1517
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b0
    const/16 v11, 0xab

    if-ne v5, v11, :cond_5b1

    const/16 v11, 0x74

    .line 1518
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b1
    const/16 v11, 0xac

    if-ne v5, v11, :cond_5b2

    const/16 v11, 0x93

    .line 1519
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b2
    const/16 v11, 0xad

    if-ne v5, v11, :cond_5b3

    const/16 v11, 0x6d

    .line 1520
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b3
    const/16 v11, 0xae

    if-ne v5, v11, :cond_5b4

    const/16 v11, 0x28

    .line 1521
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b4
    const/16 v11, 0xaf

    if-ne v5, v11, :cond_5b5

    const/16 v11, 0x2c

    .line 1522
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b5
    const/16 v11, 0xb0

    if-ne v5, v11, :cond_5b6

    const/16 v11, 0xd6

    .line 1523
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b6
    const/16 v11, 0xb1

    if-ne v5, v11, :cond_5b7

    const/16 v11, 0xb8

    .line 1524
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b7
    const/16 v11, 0xb2

    if-ne v5, v11, :cond_5b8

    const/16 v11, 0xeb

    .line 1525
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b8
    const/16 v11, 0xb3

    if-ne v5, v11, :cond_5b9

    const/16 v11, 0x50

    .line 1526
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5b9
    const/16 v11, 0xb4

    if-ne v5, v11, :cond_5ba

    const/16 v11, 0x9a

    .line 1527
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ba
    const/16 v11, 0xb5

    if-ne v5, v11, :cond_5bb

    const/16 v11, 0x4f

    .line 1528
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5bb
    const/16 v11, 0xb6

    if-ne v5, v11, :cond_5bc

    const/16 v11, 0x15

    .line 1529
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5bc
    const/16 v11, 0xb7

    if-ne v5, v11, :cond_5bd

    const/16 v11, 0x2b

    .line 1530
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5bd
    const/16 v11, 0xb8

    if-ne v5, v11, :cond_5be

    const/16 v11, 0x77

    .line 1531
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5be
    const/16 v11, 0xb9

    if-ne v5, v11, :cond_5bf

    const/16 v11, 0xcf

    .line 1532
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5bf
    const/16 v11, 0xba

    if-ne v5, v11, :cond_5c0

    const/16 v11, 0xc1

    .line 1533
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c0
    const/16 v11, 0xbb

    if-ne v5, v11, :cond_5c1

    const/16 v11, 0x68

    .line 1534
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c1
    const/16 v11, 0xbc

    if-ne v5, v11, :cond_5c2

    const/16 v11, 0x66

    .line 1535
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c2
    const/16 v11, 0xbd

    if-ne v5, v11, :cond_5c3

    const/16 v11, 0xf4

    .line 1536
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c3
    const/16 v11, 0xbe

    if-ne v5, v11, :cond_5c4

    const/16 v11, 0x16

    .line 1537
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c4
    const/16 v11, 0xbf

    if-ne v5, v11, :cond_5c5

    const/16 v11, 0x55

    .line 1538
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c5
    const/16 v11, 0xc0

    if-ne v5, v11, :cond_5c6

    const/16 v11, 0x44

    .line 1539
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c6
    const/16 v11, 0xc1

    if-ne v5, v11, :cond_5c7

    const/16 v11, 0x6a

    .line 1540
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c7
    const/16 v11, 0xc2

    if-ne v5, v11, :cond_5c8

    .line 1541
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xca

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c8
    const/16 v11, 0xc3

    if-ne v5, v11, :cond_5c9

    const/16 v11, 0x97

    .line 1542
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5c9
    const/16 v11, 0xc4

    if-ne v5, v11, :cond_5ca

    const/16 v11, 0xfe

    .line 1543
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ca
    const/16 v11, 0xc5

    if-ne v5, v11, :cond_5cb

    const/16 v11, 0x29

    .line 1544
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5cb
    const/16 v11, 0xc6

    if-ne v5, v11, :cond_5cc

    const/16 v11, 0x91

    .line 1545
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5cc
    const/16 v11, 0xc7

    if-ne v5, v11, :cond_5cd

    const/16 v11, 0xf

    .line 1546
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5cd
    const/16 v11, 0xc8

    if-ne v5, v11, :cond_5ce

    const/16 v11, 0x62

    .line 1547
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ce
    const/16 v11, 0xc9

    if-ne v5, v11, :cond_5cf

    const/16 v11, 0xdb

    .line 1548
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5cf
    const/16 v11, 0xca

    if-ne v5, v11, :cond_5d0

    const/16 v11, 0x31

    .line 1549
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d0
    const/16 v11, 0xcb

    if-ne v5, v11, :cond_5d1

    const/16 v11, 0x75

    .line 1550
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d1
    const/16 v11, 0xcc

    if-ne v5, v11, :cond_5d2

    const/16 v11, 0x8f

    .line 1551
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d2
    const/16 v11, 0xcd

    if-ne v5, v11, :cond_5d3

    const/4 v11, 0x5

    .line 1552
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d3
    const/16 v11, 0xce

    if-ne v5, v11, :cond_5d4

    const/16 v11, 0x30

    .line 1553
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d4
    const/16 v11, 0xcf

    if-ne v5, v11, :cond_5d5

    const/16 v11, 0x48

    .line 1554
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d5
    const/16 v11, 0xd0

    if-ne v5, v11, :cond_5d6

    const/16 v11, 0x56

    .line 1555
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d6
    const/16 v11, 0xd1

    if-ne v5, v11, :cond_5d7

    const/16 v11, 0x14

    .line 1556
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d7
    const/16 v11, 0xd2

    if-ne v5, v11, :cond_5d8

    const/16 v11, 0xc6

    .line 1557
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d8
    const/16 v11, 0xd3

    if-ne v5, v11, :cond_5d9

    const/16 v11, 0xc

    .line 1558
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5d9
    const/16 v11, 0xd4

    if-ne v5, v11, :cond_5da

    const/16 v11, 0xfd

    .line 1559
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5da
    const/16 v11, 0xd5

    if-ne v5, v11, :cond_5db

    const/16 v11, 0xf8

    .line 1560
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5db
    const/16 v11, 0xd6

    if-ne v5, v11, :cond_5dc

    .line 1561
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v13, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5dc
    const/16 v11, 0xd7

    if-ne v5, v11, :cond_5dd

    const/16 v11, 0x76

    .line 1562
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5dd
    const/16 v11, 0xd8

    if-ne v5, v11, :cond_5de

    const/16 v11, 0xf2

    .line 1563
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5de
    const/16 v11, 0xd9

    if-ne v5, v11, :cond_5df

    const/16 v11, 0xb1

    .line 1564
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5df
    const/16 v11, 0xda

    if-ne v5, v11, :cond_5e0

    const/16 v11, 0x1d

    .line 1565
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e0
    const/16 v11, 0xdb

    if-ne v5, v11, :cond_5e1

    const/16 v11, 0xaf

    .line 1566
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e1
    const/16 v11, 0xdc

    if-ne v5, v11, :cond_5e2

    const/16 v11, 0x94

    .line 1567
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e2
    const/16 v11, 0xdd

    if-ne v5, v11, :cond_5e3

    const/16 v11, 0xe3

    .line 1568
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e3
    const/16 v11, 0xde

    if-ne v5, v11, :cond_5e4

    const/16 v11, 0x79

    .line 1569
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e4
    const/16 v11, 0xdf

    if-ne v5, v11, :cond_5e5

    const/16 v11, 0x73

    .line 1570
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e5
    const/16 v11, 0xe0

    if-ne v5, v11, :cond_5e6

    const/16 v11, 0x32

    .line 1571
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e6
    const/16 v11, 0xe1

    if-ne v5, v11, :cond_5e7

    const/16 v11, 0x86

    .line 1572
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e7
    const/16 v11, 0xe2

    if-ne v5, v11, :cond_5e8

    const/16 v11, 0x7b

    .line 1573
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e8
    const/16 v11, 0xe3

    if-ne v5, v11, :cond_5e9

    const/4 v11, 0x3

    .line 1574
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5e9
    const/16 v11, 0xe4

    if-ne v5, v11, :cond_5ea

    const/16 v11, 0x53

    .line 1575
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ea
    const/16 v11, 0xe5

    if-ne v5, v11, :cond_5eb

    const/16 v11, 0x26

    .line 1576
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5eb
    const/16 v11, 0xe6

    if-ne v5, v11, :cond_5ec

    const/16 v11, 0xc2

    .line 1577
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ec
    const/16 v11, 0xe7

    if-ne v5, v11, :cond_5ed

    const/16 v11, 0x36

    .line 1578
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ed
    const/16 v11, 0xe8

    if-ne v5, v11, :cond_5ee

    const/16 v11, 0xe6

    .line 1579
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ee
    const/16 v11, 0xe9

    if-ne v5, v11, :cond_5ef

    const/16 v11, 0x7f

    .line 1580
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ef
    const/16 v11, 0xea

    if-ne v5, v11, :cond_5f0

    const/16 v11, 0xd2

    .line 1581
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f0
    const/16 v11, 0xeb

    if-ne v5, v11, :cond_5f1

    const/16 v11, 0x40

    .line 1582
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f1
    const/16 v11, 0xec

    if-ne v5, v11, :cond_5f2

    const/16 v11, 0xbd

    .line 1583
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f2
    const/16 v11, 0xed

    if-ne v5, v11, :cond_5f3

    const/16 v11, 0xa5

    .line 1584
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f3
    const/16 v11, 0xee

    if-ne v5, v11, :cond_5f4

    const/16 v11, 0x95

    .line 1585
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f4
    const/16 v11, 0xef

    if-ne v5, v11, :cond_5f5

    const/16 v11, 0xb5

    .line 1586
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f5
    const/16 v11, 0xf0

    if-ne v5, v11, :cond_5f6

    const/16 v11, 0xfc

    .line 1587
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f6
    const/16 v11, 0xf1

    if-ne v5, v11, :cond_5f7

    const/16 v11, 0xd4

    .line 1588
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f7
    const/16 v11, 0xf2

    if-ne v5, v11, :cond_5f8

    const/16 v11, 0x20

    .line 1589
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f8
    const/16 v11, 0xf3

    if-ne v5, v11, :cond_5f9

    const/16 v11, 0x5f

    .line 1590
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5f9
    const/16 v11, 0xf4

    if-ne v5, v11, :cond_5fa

    const/16 v11, 0xbb

    .line 1591
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5fa
    const/16 v11, 0xf5

    if-ne v5, v11, :cond_5fb

    const/16 v11, 0x9b

    .line 1592
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5fb
    const/16 v11, 0xf6

    if-ne v5, v11, :cond_5fc

    const/16 v11, 0x96

    .line 1593
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5fc
    const/16 v11, 0xf7

    if-ne v5, v11, :cond_5fd

    const/16 v11, 0x37

    .line 1594
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5fd
    const/16 v11, 0xf8

    if-ne v5, v11, :cond_5fe

    const/16 v11, 0xb2

    .line 1595
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5fe
    const/16 v11, 0xf9

    if-ne v5, v11, :cond_5ff

    const/16 v11, 0x2e

    .line 1596
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto/16 :goto_8

    :cond_5ff
    const/16 v11, 0xfa

    if-ne v5, v11, :cond_600

    const/16 v11, 0xdd

    .line 1597
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_8

    :cond_600
    const/16 v11, 0xfb

    if-ne v5, v11, :cond_601

    const/16 v11, 0xa9

    .line 1598
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_8

    :cond_601
    const/16 v11, 0xfc

    if-ne v5, v11, :cond_602

    const/16 v11, 0x1f

    .line 1599
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_8

    :cond_602
    const/16 v11, 0xfd

    if-ne v5, v11, :cond_603

    const/16 v11, 0x34

    .line 1600
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_8

    :cond_603
    const/16 v11, 0xfe

    if-ne v5, v11, :cond_604

    const/16 v11, 0x8a

    .line 1601
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v11

    move v12, v11

    const/16 v11, 0xff

    goto :goto_8

    :cond_604
    const/16 v11, 0xff

    if-ne v5, v11, :cond_605

    const/16 v12, 0xc5

    .line 1602
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v15

    invoke-static {v12, v15}, Looo/defcon2019/quals/veryandroidoso/Solver;->m6(II)I

    move-result v12

    goto :goto_8

    :cond_605
    const/4 v12, 0x0

    :goto_8
    and-int/2addr v12, v11

    const/16 v11, 0xec

    if-eq v12, v11, :cond_606

    const/4 v11, 0x0

    return v11

    .line 1607
    :cond_606
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->scramble(I)I

    move-result v10

    if-nez v6, :cond_607

    const/16 v11, 0xd0

    .line 1608
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_607
    if-ne v6, v13, :cond_608

    const/16 v11, 0xa8

    .line 1609
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_608
    const/4 v11, 0x2

    if-ne v6, v11, :cond_609

    .line 1610
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x61

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_609
    const/4 v11, 0x3

    if-ne v6, v11, :cond_60a

    const/16 v11, 0xf2

    .line 1611
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_60a
    const/4 v11, 0x4

    if-ne v6, v11, :cond_60b

    const/16 v11, 0x4e

    .line 1612
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_60b
    const/4 v11, 0x5

    if-ne v6, v11, :cond_60c

    const/16 v11, 0x3c

    .line 1613
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_60c
    if-ne v6, v14, :cond_60d

    const/16 v11, 0x64

    .line 1614
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_60d
    const/4 v11, 0x7

    if-ne v6, v11, :cond_60e

    const/16 v11, 0x80

    .line 1615
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_60e
    const/16 v11, 0x8

    if-ne v6, v11, :cond_60f

    const/16 v11, 0xe8

    .line 1616
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_60f
    const/16 v11, 0x9

    if-ne v6, v11, :cond_610

    const/16 v11, 0x98

    .line 1617
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_610
    const/16 v11, 0xa

    if-ne v6, v11, :cond_611

    const/16 v11, 0x7f

    .line 1618
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_611
    const/16 v11, 0xb

    if-ne v6, v11, :cond_612

    const/16 v11, 0x73

    .line 1619
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_612
    const/16 v11, 0xc

    if-ne v6, v11, :cond_613

    const/16 v11, 0xfd

    .line 1620
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_613
    if-ne v6, v9, :cond_614

    const/16 v11, 0x24

    .line 1621
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_614
    const/16 v11, 0xe

    if-ne v6, v11, :cond_615

    const/16 v11, 0xae

    .line 1622
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_615
    const/16 v11, 0xf

    if-ne v6, v11, :cond_616

    const/16 v11, 0xd1

    .line 1623
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_616
    const/16 v11, 0x10

    if-ne v6, v11, :cond_617

    const/16 v11, 0xb5

    .line 1624
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_617
    const/16 v11, 0x11

    if-ne v6, v11, :cond_618

    const/16 v11, 0x9f

    .line 1625
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_618
    const/16 v11, 0x12

    if-ne v6, v11, :cond_619

    const/16 v11, 0x58

    .line 1626
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_619
    const/16 v11, 0x13

    if-ne v6, v11, :cond_61a

    const/16 v11, 0xa5

    .line 1627
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_61a
    const/16 v11, 0x14

    if-ne v6, v11, :cond_61b

    const/16 v11, 0x13

    .line 1628
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_61b
    const/16 v11, 0x15

    if-ne v6, v11, :cond_61c

    const/16 v11, 0xd4

    .line 1629
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_61c
    const/16 v11, 0x16

    if-ne v6, v11, :cond_61d

    const/16 v11, 0xd3

    .line 1630
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_61d
    const/16 v11, 0x17

    if-ne v6, v11, :cond_61e

    const/16 v11, 0x6f

    .line 1631
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_61e
    const/16 v11, 0x18

    if-ne v6, v11, :cond_61f

    const/16 v11, 0x1a

    .line 1632
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_61f
    const/16 v11, 0x19

    if-ne v6, v11, :cond_620

    const/16 v11, 0xc

    .line 1633
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_620
    const/16 v11, 0x1a

    if-ne v6, v11, :cond_621

    const/16 v11, 0xe5

    .line 1634
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_621
    const/16 v11, 0x1b

    if-ne v6, v11, :cond_622

    const/16 v11, 0x2b

    .line 1635
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_622
    const/16 v11, 0x1c

    if-ne v6, v11, :cond_623

    const/16 v11, 0x8

    .line 1636
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_623
    const/16 v11, 0x1d

    if-ne v6, v11, :cond_624

    const/16 v11, 0x88

    .line 1637
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_624
    const/16 v11, 0x1e

    if-ne v6, v11, :cond_625

    const/16 v11, 0xc7

    .line 1638
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_625
    const/16 v11, 0x1f

    if-ne v6, v11, :cond_626

    const/16 v11, 0xf0

    .line 1639
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_626
    const/16 v11, 0x20

    if-ne v6, v11, :cond_627

    const/16 v11, 0x87

    .line 1640
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_627
    const/16 v11, 0x21

    if-ne v6, v11, :cond_628

    const/16 v11, 0xb2

    .line 1641
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_628
    const/16 v11, 0x22

    if-ne v6, v11, :cond_629

    const/16 v11, 0x2c

    .line 1642
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_629
    const/16 v11, 0x23

    if-ne v6, v11, :cond_62a

    const/16 v11, 0x30

    .line 1643
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_62a
    const/16 v11, 0x24

    if-ne v6, v11, :cond_62b

    const/16 v11, 0x52

    .line 1644
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_62b
    const/16 v11, 0x25

    if-ne v6, v11, :cond_62c

    const/16 v11, 0x7d

    .line 1645
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_62c
    const/16 v11, 0x26

    if-ne v6, v11, :cond_62d

    const/16 v11, 0xfe

    .line 1646
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_62d
    const/16 v11, 0x27

    if-ne v6, v11, :cond_62e

    const/16 v11, 0xc3

    .line 1647
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_62e
    const/16 v11, 0x28

    if-ne v6, v11, :cond_62f

    const/16 v11, 0xad

    .line 1648
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_62f
    const/16 v11, 0x29

    if-ne v6, v11, :cond_630

    const/16 v11, 0xcf

    .line 1649
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_630
    const/16 v11, 0x2a

    if-ne v6, v11, :cond_631

    const/16 v11, 0x79

    .line 1650
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_631
    const/16 v11, 0x2b

    if-ne v6, v11, :cond_632

    const/16 v11, 0xe9

    .line 1651
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_632
    const/16 v11, 0x2c

    if-ne v6, v11, :cond_633

    const/16 v11, 0x44

    .line 1652
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_633
    const/16 v11, 0x2d

    if-ne v6, v11, :cond_634

    const/16 v11, 0x54

    .line 1653
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_634
    const/16 v11, 0x2e

    if-ne v6, v11, :cond_635

    const/16 v11, 0x34

    .line 1654
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_635
    const/16 v11, 0x2f

    if-ne v6, v11, :cond_636

    const/16 v11, 0xd7

    .line 1655
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_636
    const/16 v11, 0x30

    if-ne v6, v11, :cond_637

    const/16 v11, 0x89

    .line 1656
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_637
    const/16 v11, 0x31

    if-ne v6, v11, :cond_638

    const/16 v11, 0x9e

    .line 1657
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_638
    const/16 v11, 0x32

    if-ne v6, v11, :cond_639

    const/16 v11, 0x9a

    .line 1658
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_639
    const/16 v11, 0x33

    if-ne v6, v11, :cond_63a

    const/16 v11, 0x45

    .line 1659
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_63a
    const/16 v11, 0x34

    if-ne v6, v11, :cond_63b

    const/16 v11, 0xba

    .line 1660
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_63b
    const/16 v11, 0x35

    if-ne v6, v11, :cond_63c

    const/16 v11, 0x85

    .line 1661
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_63c
    const/16 v11, 0x36

    if-ne v6, v11, :cond_63d

    const/16 v11, 0x33

    .line 1662
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_63d
    const/16 v11, 0x37

    if-ne v6, v11, :cond_63e

    const/16 v11, 0xb4

    .line 1663
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_63e
    const/16 v11, 0x38

    if-ne v6, v11, :cond_63f

    const/16 v11, 0x50

    .line 1664
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_63f
    const/16 v11, 0x39

    if-ne v6, v11, :cond_640

    const/16 v11, 0x7e

    .line 1665
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_640
    const/16 v11, 0x3a

    if-ne v6, v11, :cond_641

    const/16 v11, 0x90

    .line 1666
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_641
    const/16 v11, 0x3b

    if-ne v6, v11, :cond_642

    const/16 v11, 0xe2

    .line 1667
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_642
    const/16 v11, 0x3c

    if-ne v6, v11, :cond_643

    const/16 v11, 0x28

    .line 1668
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_643
    const/16 v11, 0x3d

    if-ne v6, v11, :cond_644

    const/4 v11, 0x2

    .line 1669
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_644
    const/16 v11, 0x3e

    if-ne v6, v11, :cond_645

    const/16 v11, 0x42

    .line 1670
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_645
    const/16 v11, 0x3f

    if-ne v6, v11, :cond_646

    const/16 v11, 0x26

    .line 1671
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_646
    const/16 v11, 0x40

    if-ne v6, v11, :cond_647

    const/16 v11, 0xf4

    .line 1672
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_647
    const/16 v11, 0x41

    if-ne v6, v11, :cond_648

    const/16 v11, 0xab

    .line 1673
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_648
    const/16 v11, 0x42

    if-ne v6, v11, :cond_649

    const/16 v11, 0x43

    .line 1674
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_649
    const/16 v11, 0x43

    if-ne v6, v11, :cond_64a

    const/16 v11, 0x76

    .line 1675
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_64a
    const/16 v11, 0x44

    if-ne v6, v11, :cond_64b

    const/16 v11, 0x39

    .line 1676
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_64b
    const/16 v11, 0x45

    if-ne v6, v11, :cond_64c

    .line 1677
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xf7

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_64c
    const/16 v11, 0x46

    if-ne v6, v11, :cond_64d

    const/16 v11, 0x70

    .line 1678
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_64d
    const/16 v11, 0x47

    if-ne v6, v11, :cond_64e

    const/16 v11, 0x12

    .line 1679
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_64e
    const/16 v11, 0x48

    if-ne v6, v11, :cond_64f

    const/16 v11, 0x8a

    .line 1680
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_64f
    const/16 v11, 0x49

    if-ne v6, v11, :cond_650

    const/16 v11, 0xe7

    .line 1681
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_650
    const/16 v11, 0x4a

    if-ne v6, v11, :cond_651

    .line 1682
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xca

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_651
    const/16 v11, 0x4b

    if-ne v6, v11, :cond_652

    const/16 v11, 0x49

    .line 1683
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_652
    const/16 v11, 0x4c

    if-ne v6, v11, :cond_653

    const/16 v11, 0xc9

    .line 1684
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_653
    const/16 v11, 0x4d

    if-ne v6, v11, :cond_654

    const/16 v11, 0xb3

    .line 1685
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_654
    const/16 v11, 0x4e

    if-ne v6, v11, :cond_655

    const/16 v11, 0x55

    .line 1686
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_655
    const/16 v11, 0x4f

    if-ne v6, v11, :cond_656

    const/16 v11, 0x77

    .line 1687
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_656
    const/16 v11, 0x50

    if-ne v6, v11, :cond_657

    const/16 v11, 0x74

    .line 1688
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_657
    const/16 v11, 0x51

    if-ne v6, v11, :cond_658

    const/16 v11, 0x8d

    .line 1689
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_658
    const/16 v11, 0x52

    if-ne v6, v11, :cond_659

    const/16 v11, 0x5a

    .line 1690
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_659
    const/16 v11, 0x53

    if-ne v6, v11, :cond_65a

    const/16 v11, 0xa1

    .line 1691
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_65a
    const/16 v11, 0x54

    if-ne v6, v11, :cond_65b

    const/16 v11, 0xee

    .line 1692
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_65b
    const/16 v11, 0x55

    if-ne v6, v11, :cond_65c

    const/16 v11, 0xa2

    .line 1693
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_65c
    const/16 v11, 0x56

    if-ne v6, v11, :cond_65d

    const/16 v11, 0xcc

    .line 1694
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_65d
    const/16 v11, 0x57

    if-ne v6, v11, :cond_65e

    const/16 v11, 0xe0

    .line 1695
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_65e
    const/16 v11, 0x58

    if-ne v6, v11, :cond_65f

    const/16 v11, 0x51

    .line 1696
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_65f
    const/16 v11, 0x59

    if-ne v6, v11, :cond_660

    const/16 v11, 0x67

    .line 1697
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_660
    const/16 v11, 0x5a

    if-ne v6, v11, :cond_661

    const/16 v11, 0xd6

    .line 1698
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_661
    const/16 v11, 0x5b

    if-ne v6, v11, :cond_662

    const/16 v11, 0xcb

    .line 1699
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_662
    const/16 v11, 0x5c

    if-ne v6, v11, :cond_663

    const/16 v11, 0xc6

    .line 1700
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_663
    const/16 v11, 0x5d

    if-ne v6, v11, :cond_664

    const/16 v11, 0xb8

    .line 1701
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_664
    const/16 v11, 0x5e

    if-ne v6, v11, :cond_665

    const/16 v11, 0x5c

    .line 1702
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_665
    const/16 v11, 0x5f

    if-ne v6, v11, :cond_666

    const/16 v11, 0x93

    .line 1703
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_666
    const/16 v11, 0x60

    if-ne v6, v11, :cond_667

    const/16 v11, 0x69

    .line 1704
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_667
    const/16 v11, 0x61

    if-ne v6, v11, :cond_668

    const/16 v11, 0xdd

    .line 1705
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_668
    const/16 v11, 0x62

    if-ne v6, v11, :cond_669

    const/16 v11, 0xb

    .line 1706
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_669
    const/16 v11, 0x63

    if-ne v6, v11, :cond_66a

    const/16 v11, 0x86

    .line 1707
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_66a
    const/16 v11, 0x64

    if-ne v6, v11, :cond_66b

    const/16 v11, 0x46

    .line 1708
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_66b
    const/16 v11, 0x65

    if-ne v6, v11, :cond_66c

    const/16 v11, 0x5f

    .line 1709
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_66c
    const/16 v11, 0x66

    if-ne v6, v11, :cond_66d

    const/16 v11, 0x1b

    .line 1710
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_66d
    const/16 v11, 0x67

    if-ne v6, v11, :cond_66e

    const/16 v11, 0xa6

    .line 1711
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_66e
    const/16 v11, 0x68

    if-ne v6, v11, :cond_66f

    const/16 v11, 0x18

    .line 1712
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_66f
    const/16 v11, 0x69

    if-ne v6, v11, :cond_670

    const/16 v11, 0x47

    .line 1713
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_670
    const/16 v11, 0x6a

    if-ne v6, v11, :cond_671

    const/16 v11, 0xb9

    .line 1714
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_671
    const/16 v11, 0x6b

    if-ne v6, v11, :cond_672

    const/16 v11, 0x2e

    .line 1715
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_672
    const/16 v11, 0x6c

    if-ne v6, v11, :cond_673

    .line 1716
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xac

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_673
    const/16 v11, 0x6d

    if-ne v6, v11, :cond_674

    const/16 v11, 0xed

    .line 1717
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_674
    const/16 v11, 0x6e

    if-ne v6, v11, :cond_675

    const/16 v11, 0x27

    .line 1718
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_675
    const/16 v11, 0x6f

    if-ne v6, v11, :cond_676

    const/16 v11, 0x7b

    .line 1719
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_676
    const/16 v11, 0x70

    if-ne v6, v11, :cond_677

    const/16 v11, 0x4c

    .line 1720
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_677
    const/16 v11, 0x71

    if-ne v6, v11, :cond_678

    const/16 v11, 0x5b

    .line 1721
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_678
    const/16 v11, 0x72

    if-ne v6, v11, :cond_679

    const/16 v11, 0xe4

    .line 1722
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_679
    const/16 v11, 0x73

    if-ne v6, v11, :cond_67a

    const/16 v11, 0x6c

    .line 1723
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_67a
    const/16 v11, 0x74

    if-ne v6, v11, :cond_67b

    const/16 v11, 0x4a

    .line 1724
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_67b
    const/16 v11, 0x75

    if-ne v6, v11, :cond_67c

    const/16 v11, 0xce

    .line 1725
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_67c
    const/16 v11, 0x76

    if-ne v6, v11, :cond_67d

    const/16 v11, 0x57

    .line 1726
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_67d
    const/16 v11, 0x77

    if-ne v6, v11, :cond_67e

    const/16 v11, 0xc5

    .line 1727
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_67e
    const/16 v11, 0x78

    if-ne v6, v11, :cond_67f

    const/16 v11, 0x32

    .line 1728
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_67f
    const/16 v11, 0x79

    if-ne v6, v11, :cond_680

    const/16 v11, 0x23

    .line 1729
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_680
    const/16 v11, 0x7a

    if-ne v6, v11, :cond_681

    const/16 v11, 0xf

    .line 1730
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_681
    const/16 v11, 0x7b

    if-ne v6, v11, :cond_682

    const/16 v11, 0x19

    .line 1731
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_682
    const/16 v11, 0x7c

    if-ne v6, v11, :cond_683

    const/4 v11, 0x7

    .line 1732
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_683
    const/16 v11, 0x7d

    if-ne v6, v11, :cond_684

    const/16 v11, 0xa4

    .line 1733
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_684
    const/16 v11, 0x7e

    if-ne v6, v11, :cond_685

    const/16 v11, 0xdb

    .line 1734
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_685
    const/16 v11, 0x7f

    if-ne v6, v11, :cond_686

    .line 1735
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x82

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_686
    const/16 v11, 0x80

    if-ne v6, v11, :cond_687

    const/16 v11, 0x36

    .line 1736
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_687
    const/16 v11, 0x81

    if-ne v6, v11, :cond_688

    const/16 v11, 0xbc

    .line 1737
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_688
    const/16 v11, 0x82

    if-ne v6, v11, :cond_689

    const/16 v11, 0xd5

    .line 1738
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_689
    const/16 v11, 0x83

    if-ne v6, v11, :cond_68a

    const/16 v11, 0x78

    .line 1739
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_68a
    const/16 v11, 0x84

    if-ne v6, v11, :cond_68b

    const/16 v11, 0x3d

    .line 1740
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_68b
    const/16 v11, 0x85

    if-ne v6, v11, :cond_68c

    const/16 v11, 0xfa

    .line 1741
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_68c
    const/16 v11, 0x86

    if-ne v6, v11, :cond_68d

    const/16 v11, 0xbd

    .line 1742
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_68d
    const/16 v11, 0x87

    if-ne v6, v11, :cond_68e

    const/16 v11, 0xd9

    .line 1743
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_68e
    const/16 v11, 0x88

    if-ne v6, v11, :cond_68f

    const/16 v11, 0xf1

    .line 1744
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_68f
    const/16 v11, 0x89

    if-ne v6, v11, :cond_690

    const/16 v11, 0xe6

    .line 1745
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_690
    const/16 v11, 0x8a

    if-ne v6, v11, :cond_691

    const/16 v11, 0x37

    .line 1746
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_691
    const/16 v11, 0x8b

    if-ne v6, v11, :cond_692

    const/16 v11, 0xf6

    .line 1747
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_692
    const/16 v11, 0x8c

    if-ne v6, v11, :cond_693

    const/16 v11, 0xc0

    .line 1748
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_693
    const/16 v11, 0x8d

    if-ne v6, v11, :cond_694

    const/16 v11, 0x60

    .line 1749
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_694
    const/16 v11, 0x8e

    if-ne v6, v11, :cond_695

    const/16 v11, 0x5e

    .line 1750
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_695
    const/16 v11, 0x8f

    if-ne v6, v11, :cond_696

    const/16 v11, 0x59

    .line 1751
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_696
    const/16 v11, 0x90

    if-ne v6, v11, :cond_697

    const/16 v11, 0xda

    .line 1752
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_697
    const/16 v11, 0x91

    if-ne v6, v11, :cond_698

    const/16 v11, 0xf5

    .line 1753
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_698
    const/16 v11, 0x92

    if-ne v6, v11, :cond_699

    const/16 v11, 0xb0

    .line 1754
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_699
    const/16 v11, 0x93

    if-ne v6, v11, :cond_69a

    const/16 v11, 0x62

    .line 1755
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_69a
    const/16 v11, 0x94

    if-ne v6, v11, :cond_69b

    const/16 v11, 0x4b

    .line 1756
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_69b
    const/16 v11, 0x95

    if-ne v6, v11, :cond_69c

    const/16 v11, 0x66

    .line 1757
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_69c
    const/16 v11, 0x96

    if-ne v6, v11, :cond_69d

    const/16 v11, 0xc2

    .line 1758
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_69d
    const/16 v11, 0x97

    if-ne v6, v11, :cond_69e

    const/16 v11, 0x2f

    .line 1759
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_69e
    const/16 v11, 0x98

    if-ne v6, v11, :cond_69f

    const/16 v11, 0x65

    .line 1760
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_69f
    const/16 v11, 0x99

    if-ne v6, v11, :cond_6a0

    const/16 v11, 0x3a

    .line 1761
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a0
    const/16 v11, 0x9a

    if-ne v6, v11, :cond_6a1

    const/16 v11, 0x84

    .line 1762
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a1
    const/16 v11, 0x9b

    if-ne v6, v11, :cond_6a2

    const/16 v11, 0xb6

    .line 1763
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a2
    const/16 v11, 0x9c

    if-ne v6, v11, :cond_6a3

    const/16 v11, 0xea

    .line 1764
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a3
    const/16 v11, 0x9d

    if-ne v6, v11, :cond_6a4

    const/16 v11, 0xbe

    .line 1765
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a4
    const/16 v11, 0x9e

    if-ne v6, v11, :cond_6a5

    const/16 v11, 0xdf

    .line 1766
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a5
    const/16 v11, 0x9f

    if-ne v6, v11, :cond_6a6

    const/16 v11, 0x2d

    .line 1767
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a6
    const/16 v11, 0xa0

    if-ne v6, v11, :cond_6a7

    const/16 v11, 0x96

    .line 1768
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a7
    const/16 v11, 0xa1

    if-ne v6, v11, :cond_6a8

    const/16 v11, 0x6b

    .line 1769
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a8
    const/16 v11, 0xa2

    if-ne v6, v11, :cond_6a9

    const/16 v11, 0x56

    .line 1770
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6a9
    const/16 v11, 0xa3

    if-ne v6, v11, :cond_6aa

    const/16 v11, 0x40

    .line 1771
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6aa
    const/16 v11, 0xa4

    if-ne v6, v11, :cond_6ab

    const/16 v11, 0x14

    .line 1772
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ab
    const/16 v11, 0xa5

    if-ne v6, v11, :cond_6ac

    const/16 v11, 0x31

    .line 1773
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ac
    const/16 v11, 0xa6

    if-ne v6, v11, :cond_6ad

    const/16 v11, 0x17

    .line 1774
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ad
    const/16 v11, 0xa7

    if-ne v6, v11, :cond_6ae

    const/16 v11, 0xd2

    .line 1775
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ae
    const/16 v11, 0xa8

    if-ne v6, v11, :cond_6af

    .line 1776
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xfb

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6af
    const/16 v11, 0xa9

    if-ne v6, v11, :cond_6b0

    const/16 v11, 0x15

    .line 1777
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b0
    const/16 v11, 0xaa

    if-ne v6, v11, :cond_6b1

    const/16 v11, 0x3b

    .line 1778
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b1
    const/16 v11, 0xab

    if-ne v6, v11, :cond_6b2

    const/16 v11, 0x48

    .line 1779
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b2
    const/16 v11, 0xac

    if-ne v6, v11, :cond_6b3

    const/16 v11, 0x68

    .line 1780
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b3
    const/16 v11, 0xad

    if-ne v6, v11, :cond_6b4

    const/16 v11, 0x35

    .line 1781
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b4
    const/16 v11, 0xae

    if-ne v6, v11, :cond_6b5

    const/16 v11, 0x9b

    .line 1782
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b5
    const/16 v11, 0xaf

    if-ne v6, v11, :cond_6b6

    const/16 v11, 0x71

    .line 1783
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b6
    const/16 v11, 0xb0

    if-ne v6, v11, :cond_6b7

    const/16 v11, 0x6a

    .line 1784
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b7
    const/16 v11, 0xb1

    if-ne v6, v11, :cond_6b8

    const/16 v11, 0x83

    .line 1785
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b8
    const/16 v11, 0xb2

    if-ne v6, v11, :cond_6b9

    .line 1786
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v14, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6b9
    const/16 v11, 0xb3

    if-ne v6, v11, :cond_6ba

    const/16 v11, 0xe

    .line 1787
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ba
    const/16 v11, 0xb4

    if-ne v6, v11, :cond_6bb

    const/4 v11, 0x3

    .line 1788
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6bb
    const/16 v11, 0xb5

    if-ne v6, v11, :cond_6bc

    .line 1789
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xff

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6bc
    const/16 v11, 0xb6

    if-ne v6, v11, :cond_6bd

    const/16 v11, 0x11

    .line 1790
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6bd
    const/16 v11, 0xb7

    if-ne v6, v11, :cond_6be

    const/16 v11, 0xe1

    .line 1791
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6be
    const/16 v11, 0xb8

    if-ne v6, v11, :cond_6bf

    const/16 v11, 0x8f

    .line 1792
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6bf
    const/16 v11, 0xb9

    if-ne v6, v11, :cond_6c0

    const/16 v11, 0x1c

    .line 1793
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c0
    const/16 v11, 0xba

    if-ne v6, v11, :cond_6c1

    const/16 v11, 0xa7

    .line 1794
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c1
    const/16 v11, 0xbb

    if-ne v6, v11, :cond_6c2

    const/16 v11, 0x5d

    .line 1795
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c2
    const/16 v11, 0xbc

    if-ne v6, v11, :cond_6c3

    const/16 v11, 0xc4

    .line 1796
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c3
    const/16 v11, 0xbd

    if-ne v6, v11, :cond_6c4

    const/16 v11, 0x10

    .line 1797
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c4
    const/16 v11, 0xbe

    if-ne v6, v11, :cond_6c5

    const/16 v11, 0x81

    .line 1798
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c5
    const/16 v11, 0xbf

    if-ne v6, v11, :cond_6c6

    .line 1799
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x41

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c6
    const/16 v11, 0xc0

    if-ne v6, v11, :cond_6c7

    const/16 v11, 0xc8

    .line 1800
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c7
    const/16 v11, 0xc1

    if-ne v6, v11, :cond_6c8

    const/16 v11, 0x29

    .line 1801
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c8
    const/16 v11, 0xc2

    if-ne v6, v11, :cond_6c9

    const/16 v11, 0x1d

    .line 1802
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6c9
    const/16 v11, 0xc3

    if-ne v6, v11, :cond_6ca

    const/16 v11, 0xeb

    .line 1803
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ca
    const/16 v11, 0xc4

    if-ne v6, v11, :cond_6cb

    const/16 v11, 0x95

    .line 1804
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6cb
    const/16 v11, 0xc5

    if-ne v6, v11, :cond_6cc

    const/16 v11, 0x1e

    .line 1805
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6cc
    const/16 v11, 0xc6

    if-ne v6, v11, :cond_6cd

    const/16 v11, 0xa9

    .line 1806
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6cd
    const/16 v11, 0xc7

    if-ne v6, v11, :cond_6ce

    const/16 v11, 0x4f

    .line 1807
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ce
    const/16 v11, 0xc8

    if-ne v6, v11, :cond_6cf

    const/16 v11, 0x21

    .line 1808
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6cf
    const/16 v11, 0xc9

    if-ne v6, v11, :cond_6d0

    const/16 v11, 0x20

    .line 1809
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d0
    const/16 v11, 0xca

    if-ne v6, v11, :cond_6d1

    const/4 v11, 0x5

    .line 1810
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d1
    const/16 v11, 0xcb

    if-ne v6, v11, :cond_6d2

    const/16 v11, 0xa0

    .line 1811
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d2
    const/16 v11, 0xcc

    if-ne v6, v11, :cond_6d3

    const/16 v11, 0x6e

    .line 1812
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d3
    const/16 v11, 0xcd

    if-ne v6, v11, :cond_6d4

    const/16 v11, 0xaf

    .line 1813
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d4
    const/16 v11, 0xce

    if-ne v6, v11, :cond_6d5

    .line 1814
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v13, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d5
    const/16 v11, 0xcf

    if-ne v6, v11, :cond_6d6

    const/16 v11, 0x8c

    .line 1815
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d6
    const/16 v11, 0xd0

    if-ne v6, v11, :cond_6d7

    const/16 v11, 0x6d

    .line 1816
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d7
    const/16 v11, 0xd1

    if-ne v6, v11, :cond_6d8

    const/16 v11, 0xaa

    .line 1817
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d8
    const/16 v11, 0xd2

    if-ne v6, v11, :cond_6d9

    const/16 v11, 0xb7

    .line 1818
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6d9
    const/16 v11, 0xd3

    if-ne v6, v11, :cond_6da

    const/16 v11, 0x2a

    .line 1819
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6da
    const/16 v11, 0xd4

    if-ne v6, v11, :cond_6db

    const/16 v11, 0x63

    .line 1820
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6db
    const/16 v11, 0xd5

    if-ne v6, v11, :cond_6dc

    const/16 v11, 0x3f

    .line 1821
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6dc
    const/16 v11, 0xd6

    if-ne v6, v11, :cond_6dd

    const/16 v11, 0x9d

    .line 1822
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6dd
    const/16 v11, 0xd7

    if-ne v6, v11, :cond_6de

    const/16 v11, 0x75

    .line 1823
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6de
    const/16 v11, 0xd8

    if-ne v6, v11, :cond_6df

    const/16 v11, 0x97

    .line 1824
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6df
    const/16 v11, 0xd9

    if-ne v6, v11, :cond_6e0

    const/16 v11, 0x38

    .line 1825
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e0
    const/16 v11, 0xda

    if-ne v6, v11, :cond_6e1

    const/16 v11, 0x7c

    .line 1826
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e1
    const/16 v11, 0xdb

    if-ne v6, v11, :cond_6e2

    .line 1827
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0xec

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e2
    const/16 v11, 0xdc

    if-ne v6, v11, :cond_6e3

    const/16 v11, 0xb1

    .line 1828
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e3
    const/16 v11, 0xdd

    if-ne v6, v11, :cond_6e4

    const/16 v11, 0xd8

    .line 1829
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e4
    const/16 v11, 0xde

    if-ne v6, v11, :cond_6e5

    const/16 v11, 0x9c

    .line 1830
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e5
    const/16 v11, 0xdf

    if-ne v6, v11, :cond_6e6

    const/16 v11, 0xe3

    .line 1831
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e6
    const/16 v11, 0xe0

    if-ne v6, v11, :cond_6e7

    const/4 v11, 0x4

    .line 1832
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e7
    const/16 v11, 0xe1

    if-ne v6, v11, :cond_6e8

    const/16 v11, 0xf8

    .line 1833
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e8
    const/16 v11, 0xe2

    if-ne v6, v11, :cond_6e9

    const/16 v11, 0x25

    .line 1834
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6e9
    const/16 v11, 0xe3

    if-ne v6, v11, :cond_6ea

    .line 1835
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/4 v12, 0x0

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ea
    const/16 v11, 0xe4

    if-ne v6, v11, :cond_6eb

    const/16 v11, 0x9

    .line 1836
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6eb
    const/16 v11, 0xe5

    if-ne v6, v11, :cond_6ec

    const/16 v11, 0xdc

    .line 1837
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ec
    const/16 v11, 0xe6

    if-ne v6, v11, :cond_6ed

    const/16 v11, 0x1f

    .line 1838
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ed
    const/16 v11, 0xe7

    if-ne v6, v11, :cond_6ee

    const/16 v11, 0xf3

    .line 1839
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ee
    const/16 v11, 0xe8

    if-ne v6, v11, :cond_6ef

    const/16 v11, 0x94

    .line 1840
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ef
    const/16 v11, 0xe9

    if-ne v6, v11, :cond_6f0

    const/16 v11, 0x4d

    .line 1841
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f0
    const/16 v11, 0xea

    if-ne v6, v11, :cond_6f1

    const/16 v11, 0x72

    .line 1842
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f1
    const/16 v11, 0xeb

    if-ne v6, v11, :cond_6f2

    const/16 v11, 0x91

    .line 1843
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f2
    const/16 v11, 0xec

    if-ne v6, v11, :cond_6f3

    const/16 v11, 0xa

    .line 1844
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f3
    const/16 v11, 0xed

    if-ne v6, v11, :cond_6f4

    .line 1845
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    invoke-static {v9, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f4
    const/16 v11, 0xee

    if-ne v6, v11, :cond_6f5

    const/16 v11, 0x8b

    .line 1846
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f5
    const/16 v11, 0xef

    if-ne v6, v11, :cond_6f6

    const/16 v11, 0xf9

    .line 1847
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f6
    const/16 v11, 0xf0

    if-ne v6, v11, :cond_6f7

    const/16 v11, 0xfc

    .line 1848
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f7
    const/16 v11, 0xf1

    if-ne v6, v11, :cond_6f8

    const/16 v11, 0x16

    .line 1849
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f8
    const/16 v11, 0xf2

    if-ne v6, v11, :cond_6f9

    const/16 v11, 0x7a

    .line 1850
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6f9
    const/16 v11, 0xf3

    if-ne v6, v11, :cond_6fa

    const/16 v11, 0xc1

    .line 1851
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6fa
    const/16 v11, 0xf4

    if-ne v6, v11, :cond_6fb

    const/16 v11, 0x22

    .line 1852
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6fb
    const/16 v11, 0xf5

    if-ne v6, v11, :cond_6fc

    const/16 v11, 0x53

    .line 1853
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6fc
    const/16 v11, 0xf6

    if-ne v6, v11, :cond_6fd

    const/16 v11, 0xde

    .line 1854
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6fd
    const/16 v11, 0xf7

    if-ne v6, v11, :cond_6fe

    const/16 v11, 0xbf

    .line 1855
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6fe
    const/16 v11, 0xf8

    if-ne v6, v11, :cond_6ff

    const/16 v11, 0x3e

    .line 1856
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_6ff
    const/16 v11, 0xf9

    if-ne v6, v11, :cond_700

    const/16 v11, 0xef

    .line 1857
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto/16 :goto_9

    :cond_700
    const/16 v11, 0xfa

    if-ne v6, v11, :cond_701

    const/16 v11, 0xcd

    .line 1858
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto :goto_9

    :cond_701
    const/16 v11, 0xfb

    if-ne v6, v11, :cond_702

    const/16 v11, 0xbb

    .line 1859
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto :goto_9

    :cond_702
    const/16 v11, 0xfc

    if-ne v6, v11, :cond_703

    const/16 v11, 0xa3

    .line 1860
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v12

    invoke-static {v11, v12}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto :goto_9

    :cond_703
    const/16 v11, 0xfd

    if-ne v6, v11, :cond_704

    .line 1861
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x92

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    const/16 v12, 0x8e

    goto :goto_9

    :cond_704
    const/16 v11, 0xfe

    if-ne v6, v11, :cond_705

    .line 1862
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v11

    const/16 v12, 0x8e

    invoke-static {v12, v11}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v11

    move v9, v11

    const/16 v11, 0xff

    goto :goto_9

    :cond_705
    const/16 v11, 0xff

    const/16 v12, 0x8e

    if-ne v6, v11, :cond_706

    const/16 v15, 0x99

    .line 1863
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v9

    invoke-static {v15, v9}, Looo/defcon2019/quals/veryandroidoso/Solver;->m7(II)I

    move-result v9

    goto :goto_9

    :cond_706
    const/4 v9, 0x0

    :goto_9
    and-int/2addr v9, v11

    if-eq v9, v12, :cond_707

    const/4 v9, 0x0

    return v9

    .line 1866
    :cond_707
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m9(I)V

    add-int/2addr v10, v6

    .line 1868
    invoke-static {v10}, Looo/defcon2019/quals/veryandroidoso/Solver;->scramble(I)I

    move-result v8

    if-nez v7, :cond_708

    const/16 v9, 0x4a

    .line 1869
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_708
    if-ne v7, v13, :cond_709

    const/16 v9, 0x2a

    .line 1870
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_709
    const/4 v9, 0x2

    if-ne v7, v9, :cond_70a

    const/16 v9, 0x6c

    .line 1871
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_70a
    const/4 v9, 0x3

    if-ne v7, v9, :cond_70b

    const/16 v9, 0x5a

    .line 1872
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_70b
    const/4 v9, 0x4

    if-ne v7, v9, :cond_70c

    const/16 v9, 0xa

    .line 1873
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_70c
    const/4 v9, 0x5

    if-ne v7, v9, :cond_70d

    const/16 v9, 0x52

    .line 1874
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_70d
    if-ne v7, v14, :cond_70e

    const/16 v9, 0xb6

    .line 1875
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_70e
    const/4 v9, 0x7

    if-ne v7, v9, :cond_70f

    const/4 v9, 0x2

    .line 1876
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_70f
    const/16 v9, 0x8

    if-ne v7, v9, :cond_710

    const/16 v9, 0x9c

    .line 1877
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_710
    const/16 v9, 0x9

    if-ne v7, v9, :cond_711

    const/16 v9, 0xbc

    .line 1878
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_711
    const/16 v9, 0xa

    if-ne v7, v9, :cond_712

    const/16 v9, 0x93

    .line 1879
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_712
    const/16 v9, 0xb

    if-ne v7, v9, :cond_713

    const/16 v9, 0xbb

    .line 1880
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_713
    const/16 v9, 0xc

    if-ne v7, v9, :cond_714

    const/16 v9, 0x42

    .line 1881
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_714
    const/16 v9, 0xd

    if-ne v7, v9, :cond_715

    const/16 v9, 0x89

    .line 1882
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_715
    const/16 v9, 0xe

    if-ne v7, v9, :cond_716

    const/16 v9, 0x12

    .line 1883
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_716
    const/16 v9, 0xf

    if-ne v7, v9, :cond_717

    const/16 v9, 0x8c

    .line 1884
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_717
    const/16 v9, 0x10

    if-ne v7, v9, :cond_718

    const/16 v9, 0x2c

    .line 1885
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_718
    const/16 v9, 0x11

    if-ne v7, v9, :cond_719

    const/16 v9, 0x73

    .line 1886
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_719
    const/16 v9, 0x12

    if-ne v7, v9, :cond_71a

    const/16 v9, 0x1a

    .line 1887
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_71a
    const/16 v9, 0x13

    if-ne v7, v9, :cond_71b

    const/16 v9, 0x40

    .line 1888
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_71b
    const/16 v9, 0x14

    if-ne v7, v9, :cond_71c

    .line 1889
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0xff

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    goto/16 :goto_a

    :cond_71c
    const/16 v9, 0x15

    if-ne v7, v9, :cond_71d

    const/16 v9, 0xe5

    .line 1890
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_71d
    const/16 v9, 0x16

    if-ne v7, v9, :cond_71e

    const/16 v9, 0xcc

    .line 1891
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_71e
    const/16 v9, 0x17

    if-ne v7, v9, :cond_71f

    const/16 v9, 0x32

    .line 1892
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_71f
    const/16 v9, 0x18

    if-ne v7, v9, :cond_720

    const/16 v9, 0x99

    .line 1893
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_720
    const/16 v9, 0x19

    if-ne v7, v9, :cond_721

    const/16 v9, 0x35

    .line 1894
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_721
    const/16 v9, 0x1a

    if-ne v7, v9, :cond_722

    const/16 v9, 0x1e

    .line 1895
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_722
    const/16 v9, 0x1b

    if-ne v7, v9, :cond_723

    const/16 v9, 0x65

    .line 1896
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_723
    const/16 v9, 0x1c

    if-ne v7, v9, :cond_724

    const/16 v9, 0xa1

    .line 1897
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_724
    const/16 v9, 0x1d

    if-ne v7, v9, :cond_725

    const/16 v9, 0x91

    .line 1898
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_725
    const/16 v9, 0x1e

    if-ne v7, v9, :cond_726

    const/16 v9, 0x88

    .line 1899
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_726
    const/16 v9, 0x1f

    if-ne v7, v9, :cond_727

    const/16 v9, 0x9b

    .line 1900
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_727
    const/16 v9, 0x20

    if-ne v7, v9, :cond_728

    const/16 v9, 0x9f

    .line 1901
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_728
    const/16 v9, 0x21

    if-ne v7, v9, :cond_729

    const/16 v9, 0x4e

    .line 1902
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_729
    const/16 v9, 0x22

    if-ne v7, v9, :cond_72a

    const/16 v9, 0xb

    .line 1903
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_72a
    const/16 v9, 0x23

    if-ne v7, v9, :cond_72b

    .line 1904
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0x8e

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_72b
    const/16 v9, 0x24

    if-ne v7, v9, :cond_72c

    const/16 v9, 0x83

    .line 1905
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_72c
    const/16 v9, 0x25

    if-ne v7, v9, :cond_72d

    const/16 v9, 0xe2

    .line 1906
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_72d
    const/16 v9, 0x26

    if-ne v7, v9, :cond_72e

    const/16 v9, 0x44

    .line 1907
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_72e
    const/16 v9, 0x27

    if-ne v7, v9, :cond_72f

    const/16 v9, 0xe9

    .line 1908
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_72f
    const/16 v9, 0x28

    if-ne v7, v9, :cond_730

    const/16 v9, 0x6d

    .line 1909
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_730
    const/16 v9, 0x29

    if-ne v7, v9, :cond_731

    const/16 v9, 0x3e

    .line 1910
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_731
    const/16 v9, 0x2a

    if-ne v7, v9, :cond_732

    const/16 v9, 0x58

    .line 1911
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_732
    const/16 v9, 0x2b

    if-ne v7, v9, :cond_733

    const/16 v9, 0x63

    .line 1912
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_733
    const/16 v9, 0x2c

    if-ne v7, v9, :cond_734

    const/16 v9, 0x5e

    .line 1913
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_734
    const/16 v9, 0x2d

    if-ne v7, v9, :cond_735

    const/16 v9, 0x13

    .line 1914
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_735
    const/16 v9, 0x2e

    if-ne v7, v9, :cond_736

    const/16 v9, 0x72

    .line 1915
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_736
    const/16 v9, 0x2f

    if-ne v7, v9, :cond_737

    const/16 v9, 0x64

    .line 1916
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_737
    const/16 v9, 0x30

    if-ne v7, v9, :cond_738

    const/16 v9, 0x27

    .line 1917
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_738
    const/16 v9, 0x31

    if-ne v7, v9, :cond_739

    const/16 v9, 0x8a

    .line 1918
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_739
    const/16 v9, 0x32

    if-ne v7, v9, :cond_73a

    const/16 v9, 0xed

    .line 1919
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_73a
    const/16 v9, 0x33

    if-ne v7, v9, :cond_73b

    const/16 v9, 0x90

    .line 1920
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_73b
    const/16 v9, 0x34

    if-ne v7, v9, :cond_73c

    const/16 v9, 0x8f

    .line 1921
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_73c
    const/16 v9, 0x35

    if-ne v7, v9, :cond_73d

    const/16 v9, 0x62

    .line 1922
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_73d
    const/16 v9, 0x36

    if-ne v7, v9, :cond_73e

    .line 1923
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0xfb

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_73e
    const/16 v9, 0x37

    if-ne v7, v9, :cond_73f

    const/16 v9, 0xf6

    .line 1924
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_73f
    const/16 v9, 0x38

    if-ne v7, v9, :cond_740

    .line 1925
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0x92

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_740
    const/16 v9, 0x39

    if-ne v7, v9, :cond_741

    const/16 v9, 0x21

    .line 1926
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_741
    const/16 v9, 0x3a

    if-ne v7, v9, :cond_742

    const/16 v9, 0xc7

    .line 1927
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_742
    const/16 v9, 0x3b

    if-ne v7, v9, :cond_743

    const/16 v9, 0x5b

    .line 1928
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_743
    const/16 v9, 0x3c

    if-ne v7, v9, :cond_744

    const/16 v9, 0xab

    .line 1929
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_744
    const/16 v9, 0x3d

    if-ne v7, v9, :cond_745

    const/16 v9, 0xc3

    .line 1930
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_745
    const/16 v9, 0x3e

    if-ne v7, v9, :cond_746

    const/16 v9, 0xc8

    .line 1931
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_746
    const/16 v9, 0x3f

    if-ne v7, v9, :cond_747

    const/16 v9, 0xc0

    .line 1932
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_747
    const/16 v9, 0x40

    if-ne v7, v9, :cond_748

    const/16 v9, 0x7e

    .line 1933
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_748
    const/16 v9, 0x41

    if-ne v7, v9, :cond_749

    const/16 v9, 0xf8

    .line 1934
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_749
    const/16 v9, 0x42

    if-ne v7, v9, :cond_74a

    const/16 v9, 0x26

    .line 1935
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_74a
    const/16 v9, 0x43

    if-ne v7, v9, :cond_74b

    const/16 v9, 0x23

    .line 1936
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_74b
    const/16 v9, 0x44

    if-ne v7, v9, :cond_74c

    const/16 v9, 0x1d

    .line 1937
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_74c
    const/16 v9, 0x45

    if-ne v7, v9, :cond_74d

    const/16 v9, 0xcd

    .line 1938
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_74d
    const/16 v9, 0x46

    if-ne v7, v9, :cond_74e

    const/16 v9, 0xe6

    .line 1939
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_74e
    const/16 v9, 0x47

    if-ne v7, v9, :cond_74f

    const/16 v9, 0x47

    .line 1940
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_74f
    const/16 v9, 0x48

    if-ne v7, v9, :cond_750

    const/16 v9, 0xa6

    .line 1941
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_750
    const/16 v9, 0x49

    if-ne v7, v9, :cond_751

    const/16 v9, 0xb0

    .line 1942
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_751
    const/16 v9, 0x4a

    if-ne v7, v9, :cond_752

    const/16 v9, 0xef

    .line 1943
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_752
    const/16 v9, 0x4b

    if-ne v7, v9, :cond_753

    const/16 v9, 0xc5

    .line 1944
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_753
    const/16 v9, 0x4c

    if-ne v7, v9, :cond_754

    .line 1945
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v14, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_754
    const/16 v9, 0x4d

    if-ne v7, v9, :cond_755

    const/16 v9, 0xd9

    .line 1946
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_755
    const/16 v9, 0x4e

    if-ne v7, v9, :cond_756

    const/16 v9, 0x19

    .line 1947
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_756
    const/16 v9, 0x4f

    if-ne v7, v9, :cond_757

    const/16 v9, 0xd1

    .line 1948
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_757
    const/16 v9, 0x50

    if-ne v7, v9, :cond_758

    const/16 v9, 0xf1

    .line 1949
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_758
    const/16 v9, 0x51

    if-ne v7, v9, :cond_759

    const/16 v9, 0x98

    .line 1950
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_759
    const/16 v9, 0x52

    if-ne v7, v9, :cond_75a

    .line 1951
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0xca

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_75a
    const/16 v9, 0x53

    if-ne v7, v9, :cond_75b

    const/16 v9, 0x5d

    .line 1952
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_75b
    const/16 v9, 0x54

    if-ne v7, v9, :cond_75c

    const/16 v9, 0x75

    .line 1953
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_75c
    const/16 v9, 0x55

    if-ne v7, v9, :cond_75d

    .line 1954
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0xd

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_75d
    const/16 v9, 0x56

    if-ne v7, v9, :cond_75e

    const/16 v9, 0xe4

    .line 1955
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_75e
    const/16 v9, 0x57

    if-ne v7, v9, :cond_75f

    const/16 v9, 0x56

    .line 1956
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_75f
    const/16 v9, 0x58

    if-ne v7, v9, :cond_760

    const/16 v9, 0x50

    .line 1957
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_760
    const/16 v9, 0x59

    if-ne v7, v9, :cond_761

    const/16 v9, 0xcf

    .line 1958
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_761
    const/16 v9, 0x5a

    if-ne v7, v9, :cond_762

    const/16 v9, 0x60

    .line 1959
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_762
    const/16 v9, 0x5b

    if-ne v7, v9, :cond_763

    const/16 v9, 0x15

    .line 1960
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_763
    const/16 v9, 0x5c

    if-ne v7, v9, :cond_764

    const/16 v9, 0x30

    .line 1961
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_764
    const/16 v9, 0x5d

    if-ne v7, v9, :cond_765

    const/16 v9, 0xc4

    .line 1962
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_765
    const/16 v9, 0x5e

    if-ne v7, v9, :cond_766

    const/16 v9, 0xe0

    .line 1963
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_766
    const/16 v9, 0x5f

    if-ne v7, v9, :cond_767

    const/16 v9, 0x66

    .line 1964
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_767
    const/16 v9, 0x60

    if-ne v7, v9, :cond_768

    const/16 v9, 0x3a

    .line 1965
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_768
    const/16 v9, 0x61

    if-ne v7, v9, :cond_769

    const/16 v9, 0x95

    .line 1966
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_769
    const/16 v9, 0x62

    if-ne v7, v9, :cond_76a

    const/16 v9, 0x85

    .line 1967
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_76a
    const/16 v9, 0x63

    if-ne v7, v9, :cond_76b

    const/16 v9, 0x59

    .line 1968
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_76b
    const/16 v9, 0x64

    if-ne v7, v9, :cond_76c

    const/16 v9, 0xe8

    .line 1969
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_76c
    const/16 v9, 0x65

    if-ne v7, v9, :cond_76d

    const/16 v9, 0x9d

    .line 1970
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_76d
    const/16 v9, 0x66

    if-ne v7, v9, :cond_76e

    const/16 v9, 0x6a

    .line 1971
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_76e
    const/16 v9, 0x67

    if-ne v7, v9, :cond_76f

    const/16 v9, 0x7d

    .line 1972
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_76f
    const/16 v9, 0x68

    if-ne v7, v9, :cond_770

    const/16 v9, 0x84

    .line 1973
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_770
    const/16 v9, 0x69

    if-ne v7, v9, :cond_771

    const/4 v9, 0x7

    .line 1974
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_771
    const/16 v9, 0x6a

    if-ne v7, v9, :cond_772

    const/16 v9, 0x3f

    .line 1975
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_772
    const/16 v9, 0x6b

    if-ne v7, v9, :cond_773

    const/16 v9, 0x3c

    .line 1976
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_773
    const/16 v9, 0x6c

    if-ne v7, v9, :cond_774

    const/16 v9, 0xa5

    .line 1977
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_774
    const/16 v9, 0x6d

    if-ne v7, v9, :cond_775

    const/16 v9, 0xfe

    .line 1978
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_775
    const/16 v9, 0x6e

    if-ne v7, v9, :cond_776

    const/16 v9, 0x9

    .line 1979
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_776
    const/16 v9, 0x6f

    if-ne v7, v9, :cond_777

    const/16 v9, 0x74

    .line 1980
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_777
    const/16 v9, 0x70

    if-ne v7, v9, :cond_778

    const/16 v9, 0x3b

    .line 1981
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_778
    const/16 v9, 0x71

    if-ne v7, v9, :cond_779

    const/16 v9, 0xd0

    .line 1982
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_779
    const/16 v9, 0x72

    if-ne v7, v9, :cond_77a

    const/16 v9, 0xd8

    .line 1983
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_77a
    const/16 v9, 0x73

    if-ne v7, v9, :cond_77b

    const/16 v9, 0x6f

    .line 1984
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_77b
    const/16 v9, 0x74

    if-ne v7, v9, :cond_77c

    const/16 v9, 0xad

    .line 1985
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_77c
    const/16 v9, 0x75

    if-ne v7, v9, :cond_77d

    const/16 v9, 0x69

    .line 1986
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_77d
    const/16 v9, 0x76

    if-ne v7, v9, :cond_77e

    const/16 v9, 0x54

    .line 1987
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_77e
    const/16 v9, 0x77

    if-ne v7, v9, :cond_77f

    const/16 v9, 0xc9

    .line 1988
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_77f
    const/16 v9, 0x78

    if-ne v7, v9, :cond_780

    const/16 v9, 0x97

    .line 1989
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_780
    const/16 v9, 0x79

    if-ne v7, v9, :cond_781

    const/16 v9, 0xfd

    .line 1990
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_781
    const/16 v9, 0x7a

    if-ne v7, v9, :cond_782

    const/16 v9, 0x7b

    .line 1991
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_782
    const/16 v9, 0x7b

    if-ne v7, v9, :cond_783

    const/16 v9, 0xdc

    .line 1992
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_783
    const/16 v9, 0x7c

    if-ne v7, v9, :cond_784

    const/16 v9, 0x45

    .line 1993
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_784
    const/16 v9, 0x7d

    if-ne v7, v9, :cond_785

    const/16 v9, 0xe1

    .line 1994
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_785
    const/16 v9, 0x7e

    if-ne v7, v9, :cond_786

    .line 1995
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0xec

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_786
    const/16 v9, 0x7f

    if-ne v7, v9, :cond_787

    const/16 v9, 0x18

    .line 1996
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_787
    const/16 v9, 0x80

    if-ne v7, v9, :cond_788

    const/16 v9, 0x16

    .line 1997
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_788
    const/16 v9, 0x81

    if-ne v7, v9, :cond_789

    const/16 v9, 0xf2

    .line 1998
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_789
    const/16 v9, 0x82

    if-ne v7, v9, :cond_78a

    const/16 v9, 0x10

    .line 1999
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_78a
    const/16 v9, 0x83

    if-ne v7, v9, :cond_78b

    const/16 v9, 0xc2

    .line 2000
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_78b
    const/16 v9, 0x84

    if-ne v7, v9, :cond_78c

    const/16 v9, 0x1f

    .line 2001
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_78c
    const/16 v9, 0x85

    if-ne v7, v9, :cond_78d

    const/16 v9, 0x6e

    .line 2002
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_78d
    const/16 v9, 0x86

    if-ne v7, v9, :cond_78e

    const/16 v9, 0xc1

    .line 2003
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_78e
    const/16 v9, 0x87

    if-ne v7, v9, :cond_78f

    const/16 v9, 0x24

    .line 2004
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_78f
    const/16 v9, 0x88

    if-ne v7, v9, :cond_790

    const/16 v9, 0x14

    .line 2005
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_790
    const/16 v9, 0x89

    if-ne v7, v9, :cond_791

    const/16 v9, 0x3d

    .line 2006
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_791
    const/16 v9, 0x8a

    if-ne v7, v9, :cond_792

    const/16 v9, 0x96

    .line 2007
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_792
    const/16 v9, 0x8b

    if-ne v7, v9, :cond_793

    const/16 v9, 0xa7

    .line 2008
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_793
    const/16 v9, 0x8c

    if-ne v7, v9, :cond_794

    const/16 v9, 0xa2

    .line 2009
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_794
    const/16 v9, 0x8d

    if-ne v7, v9, :cond_795

    const/16 v9, 0xb8

    .line 2010
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_795
    const/16 v9, 0x8e

    if-ne v7, v9, :cond_796

    const/16 v9, 0xbe

    .line 2011
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_796
    const/16 v9, 0x8f

    if-ne v7, v9, :cond_797

    const/16 v9, 0x7f

    .line 2012
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_797
    const/16 v9, 0x90

    if-ne v7, v9, :cond_798

    const/16 v9, 0x48

    .line 2013
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_798
    const/16 v9, 0x91

    if-ne v7, v9, :cond_799

    const/16 v9, 0xea

    .line 2014
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_799
    const/16 v9, 0x92

    if-ne v7, v9, :cond_79a

    .line 2015
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0xac

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_79a
    const/16 v9, 0x93

    if-ne v7, v9, :cond_79b

    const/16 v9, 0x8d

    .line 2016
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_79b
    const/16 v9, 0x94

    if-ne v7, v9, :cond_79c

    const/16 v9, 0xaf

    .line 2017
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_79c
    const/16 v9, 0x95

    if-ne v7, v9, :cond_79d

    const/16 v9, 0x36

    .line 2018
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_79d
    const/16 v9, 0x96

    if-ne v7, v9, :cond_79e

    const/16 v9, 0x8

    .line 2019
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_79e
    const/16 v9, 0x97

    if-ne v7, v9, :cond_79f

    const/16 v9, 0xae

    .line 2020
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_79f
    const/16 v9, 0x98

    if-ne v7, v9, :cond_7a0

    const/4 v9, 0x5

    .line 2021
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a0
    const/16 v9, 0x99

    if-ne v7, v9, :cond_7a1

    const/16 v9, 0xce

    .line 2022
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a1
    const/16 v9, 0x9a

    if-ne v7, v9, :cond_7a2

    const/16 v9, 0xa8

    .line 2023
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a2
    const/16 v9, 0x9b

    if-ne v7, v9, :cond_7a3

    const/16 v9, 0x2d

    .line 2024
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a3
    const/16 v9, 0x9c

    if-ne v7, v9, :cond_7a4

    const/16 v9, 0x43

    .line 2025
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a4
    const/16 v9, 0x9d

    if-ne v7, v9, :cond_7a5

    const/16 v9, 0x2b

    .line 2026
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a5
    const/16 v9, 0x9e

    if-ne v7, v9, :cond_7a6

    const/16 v9, 0x94

    .line 2027
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a6
    const/16 v9, 0x9f

    if-ne v7, v9, :cond_7a7

    const/16 v9, 0xfa

    .line 2028
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a7
    const/16 v9, 0xa0

    if-ne v7, v9, :cond_7a8

    const/16 v9, 0x33

    .line 2029
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a8
    const/16 v9, 0xa1

    if-ne v7, v9, :cond_7a9

    const/16 v9, 0x57

    .line 2030
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7a9
    const/16 v9, 0xa2

    if-ne v7, v9, :cond_7aa

    const/16 v9, 0x67

    .line 2031
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7aa
    const/16 v9, 0xa3

    if-ne v7, v9, :cond_7ab

    const/16 v9, 0x51

    .line 2032
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ab
    const/16 v9, 0xa4

    if-ne v7, v9, :cond_7ac

    const/16 v9, 0x77

    .line 2033
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ac
    const/16 v9, 0xa5

    if-ne v7, v9, :cond_7ad

    const/16 v9, 0x49

    .line 2034
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ad
    const/16 v9, 0xa6

    if-ne v7, v9, :cond_7ae

    const/16 v9, 0xbd

    .line 2035
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ae
    const/16 v9, 0xa7

    if-ne v7, v9, :cond_7af

    const/16 v9, 0xa3

    .line 2036
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7af
    const/16 v9, 0xa8

    if-ne v7, v9, :cond_7b0

    const/16 v9, 0xd6

    .line 2037
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b0
    const/16 v9, 0xa9

    if-ne v7, v9, :cond_7b1

    const/16 v9, 0xb2

    .line 2038
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b1
    const/16 v9, 0xaa

    if-ne v7, v9, :cond_7b2

    const/16 v9, 0xdd

    .line 2039
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b2
    const/16 v9, 0xab

    if-ne v7, v9, :cond_7b3

    const/16 v9, 0xe3

    .line 2040
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b3
    const/16 v9, 0xac

    if-ne v7, v9, :cond_7b4

    const/4 v9, 0x4

    .line 2041
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b4
    const/16 v9, 0xad

    if-ne v7, v9, :cond_7b5

    const/16 v9, 0x17

    .line 2042
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b5
    const/16 v9, 0xae

    if-ne v7, v9, :cond_7b6

    .line 2043
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0x82

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b6
    const/16 v9, 0xaf

    if-ne v7, v9, :cond_7b7

    const/16 v9, 0xf0

    .line 2044
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b7
    const/16 v9, 0xb0

    if-ne v7, v9, :cond_7b8

    const/16 v9, 0x78

    .line 2045
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b8
    const/16 v9, 0xb1

    if-ne v7, v9, :cond_7b9

    const/16 v9, 0x37

    .line 2046
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7b9
    const/16 v9, 0xb2

    if-ne v7, v9, :cond_7ba

    const/16 v9, 0xb1

    .line 2047
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ba
    const/16 v9, 0xb3

    if-ne v7, v9, :cond_7bb

    const/16 v9, 0x55

    .line 2048
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7bb
    const/16 v9, 0xb4

    if-ne v7, v9, :cond_7bc

    const/16 v9, 0xf3

    .line 2049
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7bc
    const/16 v9, 0xb5

    if-ne v7, v9, :cond_7bd

    .line 2050
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0xf7

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7bd
    const/16 v9, 0xb6

    if-ne v7, v9, :cond_7be

    const/16 v9, 0xf9

    .line 2051
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7be
    const/16 v9, 0xb7

    if-ne v7, v9, :cond_7bf

    const/16 v9, 0xb4

    .line 2052
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7bf
    const/16 v9, 0xb8

    if-ne v7, v9, :cond_7c0

    const/16 v9, 0xe7

    .line 2053
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c0
    const/16 v9, 0xb9

    if-ne v7, v9, :cond_7c1

    const/16 v9, 0x34

    .line 2054
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c1
    const/16 v9, 0xba

    if-ne v7, v9, :cond_7c2

    const/16 v9, 0xdf

    .line 2055
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c2
    const/16 v9, 0xbb

    if-ne v7, v9, :cond_7c3

    const/16 v9, 0xda

    .line 2056
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c3
    const/16 v9, 0xbc

    if-ne v7, v9, :cond_7c4

    const/16 v9, 0xb7

    .line 2057
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c4
    const/16 v9, 0xbd

    if-ne v7, v9, :cond_7c5

    const/16 v9, 0x22

    .line 2058
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c5
    const/16 v9, 0xbe

    if-ne v7, v9, :cond_7c6

    const/16 v9, 0x2e

    .line 2059
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c6
    const/16 v9, 0xbf

    if-ne v7, v9, :cond_7c7

    const/16 v9, 0x80

    .line 2060
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c7
    const/16 v9, 0xc0

    if-ne v7, v9, :cond_7c8

    const/16 v9, 0x46

    .line 2061
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c8
    const/16 v9, 0xc1

    if-ne v7, v9, :cond_7c9

    const/16 v9, 0x4d

    .line 2062
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7c9
    const/16 v9, 0xc2

    if-ne v7, v9, :cond_7ca

    .line 2063
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0x41

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ca
    const/16 v9, 0xc3

    if-ne v7, v9, :cond_7cb

    const/16 v9, 0x20

    .line 2064
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7cb
    const/16 v9, 0xc4

    if-ne v7, v9, :cond_7cc

    .line 2065
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/16 v9, 0x61

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7cc
    const/16 v9, 0xc5

    if-ne v7, v9, :cond_7cd

    const/16 v9, 0xcb

    .line 2066
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7cd
    const/16 v9, 0xc6

    if-ne v7, v9, :cond_7ce

    const/16 v9, 0x31

    .line 2067
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ce
    const/16 v9, 0xc7

    if-ne v7, v9, :cond_7cf

    const/16 v9, 0x5f

    .line 2068
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7cf
    const/16 v9, 0xc8

    if-ne v7, v9, :cond_7d0

    const/16 v9, 0xdb

    .line 2069
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d0
    const/16 v9, 0xc9

    if-ne v7, v9, :cond_7d1

    const/16 v9, 0x38

    .line 2070
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d1
    const/16 v9, 0xca

    if-ne v7, v9, :cond_7d2

    const/16 v9, 0xb9

    .line 2071
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d2
    const/16 v9, 0xcb

    if-ne v7, v9, :cond_7d3

    const/16 v9, 0xd7

    .line 2072
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d3
    const/16 v9, 0xcc

    if-ne v7, v9, :cond_7d4

    const/16 v9, 0xf

    .line 2073
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d4
    const/16 v9, 0xcd

    if-ne v7, v9, :cond_7d5

    const/16 v9, 0x7c

    .line 2074
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d5
    const/16 v9, 0xce

    if-ne v7, v9, :cond_7d6

    const/16 v9, 0x25

    .line 2075
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d6
    const/16 v9, 0xcf

    if-ne v7, v9, :cond_7d7

    const/16 v9, 0xee

    .line 2076
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d7
    const/16 v9, 0xd0

    if-ne v7, v9, :cond_7d8

    const/16 v9, 0xc

    .line 2077
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d8
    const/16 v9, 0xd1

    if-ne v7, v9, :cond_7d9

    const/16 v9, 0xd2

    .line 2078
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7d9
    const/16 v9, 0xd2

    if-ne v7, v9, :cond_7da

    .line 2079
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v13, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7da
    const/16 v9, 0xd3

    if-ne v7, v9, :cond_7db

    const/16 v9, 0xf4

    .line 2080
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7db
    const/16 v9, 0xd4

    if-ne v7, v9, :cond_7dc

    const/16 v9, 0x4c

    .line 2081
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7dc
    const/16 v9, 0xd5

    if-ne v7, v9, :cond_7dd

    const/16 v9, 0x39

    .line 2082
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7dd
    const/16 v9, 0xd6

    if-ne v7, v9, :cond_7de

    const/16 v9, 0xd3

    .line 2083
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7de
    const/16 v9, 0xd7

    if-ne v7, v9, :cond_7df

    const/16 v9, 0x81

    .line 2084
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7df
    const/16 v9, 0xd8

    if-ne v7, v9, :cond_7e0

    const/16 v9, 0x4b

    .line 2085
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e0
    const/16 v9, 0xd9

    if-ne v7, v9, :cond_7e1

    const/16 v9, 0x1c

    .line 2086
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e1
    const/16 v9, 0xda

    if-ne v7, v9, :cond_7e2

    const/16 v9, 0xd4

    .line 2087
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e2
    const/16 v9, 0xdb

    if-ne v7, v9, :cond_7e3

    const/4 v9, 0x3

    .line 2088
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e3
    const/16 v9, 0xdc

    if-ne v7, v9, :cond_7e4

    const/16 v9, 0x71

    .line 2089
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e4
    const/16 v9, 0xdd

    if-ne v7, v9, :cond_7e5

    const/16 v9, 0x79

    .line 2090
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e5
    const/16 v9, 0xde

    if-ne v7, v9, :cond_7e6

    const/16 v9, 0x6b

    .line 2091
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e6
    const/16 v9, 0xdf

    if-ne v7, v9, :cond_7e7

    const/16 v9, 0xa9

    .line 2092
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e7
    const/16 v9, 0xe0

    if-ne v7, v9, :cond_7e8

    const/16 v9, 0x5c

    .line 2093
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e8
    const/16 v9, 0xe1

    if-ne v7, v9, :cond_7e9

    const/16 v9, 0xaa

    .line 2094
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7e9
    const/16 v9, 0xe2

    if-ne v7, v9, :cond_7ea

    const/16 v9, 0x87

    .line 2095
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ea
    const/16 v9, 0xe3

    if-ne v7, v9, :cond_7eb

    const/16 v9, 0x9a

    .line 2096
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7eb
    const/16 v9, 0xe4

    if-ne v7, v9, :cond_7ec

    const/16 v9, 0xb5

    .line 2097
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ec
    const/16 v9, 0xe5

    if-ne v7, v9, :cond_7ed

    const/16 v9, 0x29

    .line 2098
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ed
    const/16 v9, 0xe6

    if-ne v7, v9, :cond_7ee

    const/16 v9, 0xd5

    .line 2099
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ee
    const/16 v9, 0xe7

    if-ne v7, v9, :cond_7ef

    const/16 v9, 0xde

    .line 2100
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ef
    const/16 v9, 0xe8

    if-ne v7, v9, :cond_7f0

    const/16 v9, 0x70

    .line 2101
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f0
    const/16 v9, 0xe9

    if-ne v7, v9, :cond_7f1

    const/16 v9, 0xa4

    .line 2102
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f1
    const/16 v9, 0xea

    if-ne v7, v9, :cond_7f2

    const/16 v9, 0xfc

    .line 2103
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f2
    const/16 v9, 0xeb

    if-ne v7, v9, :cond_7f3

    .line 2104
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    const/4 v9, 0x0

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f3
    const/16 v9, 0xec

    if-ne v7, v9, :cond_7f4

    const/16 v9, 0x86

    .line 2105
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f4
    const/16 v9, 0xed

    if-ne v7, v9, :cond_7f5

    const/16 v9, 0x1b

    .line 2106
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f5
    const/16 v9, 0xee

    if-ne v7, v9, :cond_7f6

    const/16 v9, 0xe

    .line 2107
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f6
    const/16 v9, 0xef

    if-ne v7, v9, :cond_7f7

    const/16 v9, 0x28

    .line 2108
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f7
    const/16 v9, 0xf0

    if-ne v7, v9, :cond_7f8

    const/16 v9, 0x76

    .line 2109
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f8
    const/16 v9, 0xf1

    if-ne v7, v9, :cond_7f9

    const/16 v9, 0xf5

    .line 2110
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7f9
    const/16 v9, 0xf2

    if-ne v7, v9, :cond_7fa

    const/16 v9, 0xeb

    .line 2111
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7fa
    const/16 v9, 0xf3

    if-ne v7, v9, :cond_7fb

    const/16 v9, 0xbf

    .line 2112
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7fb
    const/16 v9, 0xf4

    if-ne v7, v9, :cond_7fc

    const/16 v9, 0x68

    .line 2113
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7fc
    const/16 v9, 0xf5

    if-ne v7, v9, :cond_7fd

    const/16 v9, 0x11

    .line 2114
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7fd
    const/16 v9, 0xf6

    if-ne v7, v9, :cond_7fe

    const/16 v9, 0x4f

    .line 2115
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7fe
    const/16 v9, 0xf7

    if-ne v7, v9, :cond_7ff

    const/16 v9, 0xba

    .line 2116
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_7ff
    const/16 v9, 0xf8

    if-ne v7, v9, :cond_800

    const/16 v9, 0xc6

    .line 2117
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto/16 :goto_a

    :cond_800
    const/16 v9, 0xf9

    if-ne v7, v9, :cond_801

    const/16 v9, 0xb3

    .line 2118
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto :goto_a

    :cond_801
    const/16 v9, 0xfa

    if-ne v7, v9, :cond_802

    const/16 v9, 0x53

    .line 2119
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto :goto_a

    :cond_802
    const/16 v9, 0xfb

    if-ne v7, v9, :cond_803

    const/16 v9, 0x9e

    .line 2120
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto :goto_a

    :cond_803
    const/16 v9, 0xfc

    if-ne v7, v9, :cond_804

    const/16 v9, 0x8b

    .line 2121
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto :goto_a

    :cond_804
    const/16 v9, 0xfd

    if-ne v7, v9, :cond_805

    const/16 v9, 0x2f

    .line 2122
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto :goto_a

    :cond_805
    const/16 v9, 0xfe

    if-ne v7, v9, :cond_806

    const/16 v9, 0x7a

    .line 2123
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v9, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    const/16 v9, 0xff

    goto :goto_a

    :cond_806
    const/16 v9, 0xff

    if-ne v7, v9, :cond_807

    const/16 v10, 0xa0

    .line 2124
    invoke-static {v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v8

    invoke-static {v10, v8}, Looo/defcon2019/quals/veryandroidoso/Solver;->m8(II)I

    move-result v11

    goto :goto_a

    :cond_807
    const/4 v11, 0x0

    :goto_a
    and-int/lit16 v8, v11, 0xff

    const/16 v9, 0x67

    if-eq v8, v9, :cond_808

    const/4 v8, 0x0

    return v8

    .line 2128
    :cond_808
    invoke-static/range {p0 .. p0}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v0

    int-to-long v8, v0

    invoke-static/range {p1 .. p1}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v0

    int-to-long v0, v0

    mul-long v8, v8, v0

    invoke-static/range {p2 .. p2}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v0

    int-to-long v0, v0

    mul-long v8, v8, v0

    invoke-static/range {p3 .. p3}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v0

    int-to-long v0, v0

    mul-long v8, v8, v0

    invoke-static/range {p4 .. p4}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v0

    int-to-long v0, v0

    mul-long v8, v8, v0

    invoke-static/range {p5 .. p5}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v0

    int-to-long v0, v0

    mul-long v8, v8, v0

    invoke-static/range {p6 .. p6}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v0

    int-to-long v0, v0

    mul-long v8, v8, v0

    int-to-long v0, v6

    add-long/2addr v8, v0

    invoke-static/range {p8 .. p8}, Looo/defcon2019/quals/veryandroidoso/Solver;->getSecretNumber(I)I

    move-result v0

    int-to-long v0, v0

    add-long/2addr v8, v0

    const-wide/16 v0, 0x90

    rem-long/2addr v8, v0

    const-wide/16 v0, 0x25

    cmp-long v0, v8, v0

    if-eqz v0, :cond_809

    const/4 v0, 0x0

    return v0

    :cond_809
    return v13
.end method

.method public static native ttt(II)I
.end method
