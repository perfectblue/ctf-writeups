.class public Looo/defcon2019/quals/veryandroidoso/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"


# static fields
.field public static final TAG:Ljava/lang/String; = "veryandroidoso"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 15
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Looo/defcon2019/quals/veryandroidoso/MainActivity;Ljava/lang/String;)[I
    .locals 0

    .line 15
    invoke-direct {p0, p1}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->parse(Ljava/lang/String;)[I

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100(Looo/defcon2019/quals/veryandroidoso/MainActivity;)V
    .locals 0

    .line 15
    invoke-direct {p0}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->win()V

    return-void
.end method

.method static synthetic access$200(Looo/defcon2019/quals/veryandroidoso/MainActivity;)V
    .locals 0

    .line 15
    invoke-direct {p0}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->fail()V

    return-void
.end method

.method private fail()V
    .locals 2

    const-string v0, "Fail!"

    const/4 v1, 0x1

    .line 99
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    const-string v0, "veryandroidoso"

    const-string v1, "Fail!"

    .line 100
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private parse(Ljava/lang/String;)[I
    .locals 5

    .line 66
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x0

    const/16 v2, 0x17

    if-eq v0, v2, :cond_0

    return-object v1

    :cond_0
    const-string v0, "OOO{"

    .line 69
    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    return-object v1

    :cond_1
    const-string v0, "}"

    .line 72
    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2

    return-object v1

    :cond_2
    const/4 v0, 0x4

    .line 76
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    add-int/lit8 v2, v2, -0x1

    invoke-virtual {p1, v0, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    .line 77
    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_3

    return-object v1

    :cond_3
    const-string v0, "^\\p{XDigit}+$"

    .line 81
    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    .line 82
    invoke-virtual {v0, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/regex/Matcher;->matches()Z

    move-result v0

    if-nez v0, :cond_4

    return-object v1

    :cond_4
    const/16 v0, 0x9

    .line 86
    new-array v0, v0, [I

    const/4 v1, 0x0

    .line 87
    :goto_0
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    div-int/lit8 v2, v2, 0x2

    if-ge v1, v2, :cond_5

    mul-int/lit8 v2, v1, 0x2

    add-int/lit8 v3, v1, 0x1

    mul-int/lit8 v4, v3, 0x2

    .line 88
    invoke-virtual {p1, v2, v4}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    const/16 v4, 0x10

    invoke-static {v2, v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;I)I

    move-result v2

    aput v2, v0, v1

    move v1, v3

    goto :goto_0

    :cond_5
    return-object v0
.end method

.method private win()V
    .locals 2

    const-string v0, "Success!"

    const/4 v1, 0x1

    .line 94
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    const-string v0, "veryandroidoso"

    const-string v1, "Success!"

    .line 95
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6

    .line 21
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    const/high16 p1, 0x7f060000

    .line 22
    invoke-virtual {p0, p1}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->setContentView(I)V

    const-string p1, "veryandroidoso"

    const-string v0, "started!"

    .line 24
    invoke-static {p1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 25
    sput-object p0, Looo/defcon2019/quals/veryandroidoso/Solver;->cc:Landroid/content/Context;

    const p1, 0x7f050002

    .line 27
    invoke-virtual {p0, p1}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    const v0, 0x7f050006

    .line 28
    invoke-virtual {p0, v0}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 32
    new-instance v1, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;

    invoke-direct {v1, p0, v0}, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;-><init>(Looo/defcon2019/quals/veryandroidoso/MainActivity;Landroid/widget/EditText;)V

    invoke-virtual {p1, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 50
    invoke-virtual {p0}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->getIntent()Landroid/content/Intent;

    move-result-object v1

    const-string v2, "flag"

    .line 52
    invoke-virtual {v1, v2}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_1

    const/16 v2, 0xbb8

    .line 54
    invoke-static {v2}, Looo/defcon2019/quals/veryandroidoso/Solver;->sleep(I)J

    move-result-wide v2

    const-wide/16 v4, 0xbb8

    cmp-long v2, v2, v4

    if-gez v2, :cond_0

    .line 55
    invoke-direct {p0}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->fail()V

    .line 56
    invoke-virtual {p0}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->finish()V

    return-void

    .line 59
    :cond_0
    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 60
    invoke-virtual {p1}, Landroid/widget/Button;->performClick()Z

    :cond_1
    return-void
.end method
