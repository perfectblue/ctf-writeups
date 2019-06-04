.class Looo/defcon2019/quals/veryandroidoso/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Looo/defcon2019/quals/veryandroidoso/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Looo/defcon2019/quals/veryandroidoso/MainActivity;

.field final synthetic val$et:Landroid/widget/EditText;


# direct methods
.method constructor <init>(Looo/defcon2019/quals/veryandroidoso/MainActivity;Landroid/widget/EditText;)V
    .locals 0

    .line 32
    iput-object p1, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->this$0:Looo/defcon2019/quals/veryandroidoso/MainActivity;

    iput-object p2, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->val$et:Landroid/widget/EditText;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 10

    .line 35
    iget-object p1, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->this$0:Looo/defcon2019/quals/veryandroidoso/MainActivity;

    iget-object v0, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->val$et:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p1, v0}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->access$000(Looo/defcon2019/quals/veryandroidoso/MainActivity;Ljava/lang/String;)[I

    move-result-object p1

    if-eqz p1, :cond_1

    const/4 v0, 0x0

    .line 37
    aget v1, p1, v0

    const/4 v0, 0x1

    aget v2, p1, v0

    const/4 v0, 0x2

    aget v3, p1, v0

    const/4 v0, 0x3

    aget v4, p1, v0

    const/4 v0, 0x4

    aget v5, p1, v0

    const/4 v0, 0x5

    aget v6, p1, v0

    const/4 v0, 0x6

    aget v7, p1, v0

    const/4 v0, 0x7

    aget v8, p1, v0

    const/16 v0, 0x8

    aget v9, p1, v0

    invoke-static/range {v1 .. v9}, Looo/defcon2019/quals/veryandroidoso/Solver;->solve(IIIIIIIII)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 38
    iget-object p1, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->this$0:Looo/defcon2019/quals/veryandroidoso/MainActivity;

    invoke-static {p1}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->access$100(Looo/defcon2019/quals/veryandroidoso/MainActivity;)V

    goto :goto_0

    .line 40
    :cond_0
    iget-object p1, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->this$0:Looo/defcon2019/quals/veryandroidoso/MainActivity;

    invoke-static {p1}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->access$200(Looo/defcon2019/quals/veryandroidoso/MainActivity;)V

    .line 42
    :goto_0
    iget-object p1, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->this$0:Looo/defcon2019/quals/veryandroidoso/MainActivity;

    invoke-virtual {p1}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->finish()V

    return-void

    .line 45
    :cond_1
    iget-object p1, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->this$0:Looo/defcon2019/quals/veryandroidoso/MainActivity;

    invoke-static {p1}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->access$200(Looo/defcon2019/quals/veryandroidoso/MainActivity;)V

    .line 46
    iget-object p1, p0, Looo/defcon2019/quals/veryandroidoso/MainActivity$1;->this$0:Looo/defcon2019/quals/veryandroidoso/MainActivity;

    invoke-virtual {p1}, Looo/defcon2019/quals/veryandroidoso/MainActivity;->finish()V

    return-void
.end method
