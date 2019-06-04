.class public Landroid/support/constraint/solver/widgets/ResolutionDimension;
.super Landroid/support/constraint/solver/widgets/ResolutionNode;
.source "ResolutionDimension.java"


# instance fields
.field value:F


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 21
    invoke-direct {p0}, Landroid/support/constraint/solver/widgets/ResolutionNode;-><init>()V

    const/4 v0, 0x0

    .line 23
    iput v0, p0, Landroid/support/constraint/solver/widgets/ResolutionDimension;->value:F

    return-void
.end method


# virtual methods
.method public remove()V
    .locals 1

    const/4 v0, 0x2

    .line 41
    iput v0, p0, Landroid/support/constraint/solver/widgets/ResolutionDimension;->state:I

    return-void
.end method

.method public reset()V
    .locals 1

    .line 26
    invoke-super {p0}, Landroid/support/constraint/solver/widgets/ResolutionNode;->reset()V

    const/4 v0, 0x0

    .line 27
    iput v0, p0, Landroid/support/constraint/solver/widgets/ResolutionDimension;->value:F

    return-void
.end method

.method public resolve(I)V
    .locals 2

    .line 31
    iget v0, p0, Landroid/support/constraint/solver/widgets/ResolutionDimension;->state:I

    if-eqz v0, :cond_0

    iget v0, p0, Landroid/support/constraint/solver/widgets/ResolutionDimension;->value:F

    int-to-float v1, p1

    cmpl-float v0, v0, v1

    if-eqz v0, :cond_2

    :cond_0
    int-to-float p1, p1

    .line 32
    iput p1, p0, Landroid/support/constraint/solver/widgets/ResolutionDimension;->value:F

    .line 33
    iget p1, p0, Landroid/support/constraint/solver/widgets/ResolutionDimension;->state:I

    const/4 v0, 0x1

    if-ne p1, v0, :cond_1

    .line 34
    invoke-virtual {p0}, Landroid/support/constraint/solver/widgets/ResolutionDimension;->invalidate()V

    .line 36
    :cond_1
    invoke-virtual {p0}, Landroid/support/constraint/solver/widgets/ResolutionDimension;->didResolve()V

    :cond_2
    return-void
.end method
