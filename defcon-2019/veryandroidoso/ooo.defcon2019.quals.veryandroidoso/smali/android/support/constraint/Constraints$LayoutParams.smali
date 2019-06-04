.class public Landroid/support/constraint/Constraints$LayoutParams;
.super Landroid/support/constraint/ConstraintLayout$LayoutParams;
.source "Constraints.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroid/support/constraint/Constraints;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "LayoutParams"
.end annotation


# instance fields
.field public alpha:F

.field public applyElevation:Z

.field public elevation:F

.field public rotation:F

.field public rotationX:F

.field public rotationY:F

.field public scaleX:F

.field public scaleY:F

.field public transformPivotX:F

.field public transformPivotY:F

.field public translationX:F

.field public translationY:F

.field public translationZ:F


# direct methods
.method public constructor <init>(II)V
    .locals 0

    .line 82
    invoke-direct {p0, p1, p2}, Landroid/support/constraint/ConstraintLayout$LayoutParams;-><init>(II)V

    const/high16 p1, 0x3f800000    # 1.0f

    .line 67
    iput p1, p0, Landroid/support/constraint/Constraints$LayoutParams;->alpha:F

    const/4 p2, 0x0

    .line 68
    iput-boolean p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->applyElevation:Z

    const/4 p2, 0x0

    .line 69
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->elevation:F

    .line 70
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotation:F

    .line 71
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationX:F

    .line 72
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationY:F

    .line 73
    iput p1, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleX:F

    .line 74
    iput p1, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleY:F

    .line 75
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotX:F

    .line 76
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotY:F

    .line 77
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationX:F

    .line 78
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationY:F

    .line 79
    iput p2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationZ:F

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 3

    .line 90
    invoke-direct {p0, p1, p2}, Landroid/support/constraint/ConstraintLayout$LayoutParams;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    const/high16 v0, 0x3f800000    # 1.0f

    .line 67
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->alpha:F

    const/4 v1, 0x0

    .line 68
    iput-boolean v1, p0, Landroid/support/constraint/Constraints$LayoutParams;->applyElevation:Z

    const/4 v2, 0x0

    .line 69
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->elevation:F

    .line 70
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotation:F

    .line 71
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationX:F

    .line 72
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationY:F

    .line 73
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleX:F

    .line 74
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleY:F

    .line 75
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotX:F

    .line 76
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotY:F

    .line 77
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationX:F

    .line 78
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationY:F

    .line 79
    iput v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationZ:F

    .line 91
    sget-object v0, Landroid/support/constraint/R$styleable;->ConstraintSet:[I

    invoke-virtual {p1, p2, v0}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object p1

    .line 92
    invoke-virtual {p1}, Landroid/content/res/TypedArray;->getIndexCount()I

    move-result p2

    :goto_0
    if-ge v1, p2, :cond_c

    .line 94
    invoke-virtual {p1, v1}, Landroid/content/res/TypedArray;->getIndex(I)I

    move-result v0

    .line 95
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_alpha:I

    if-ne v0, v2, :cond_0

    .line 96
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->alpha:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->alpha:F

    goto/16 :goto_1

    .line 97
    :cond_0
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_elevation:I

    if-ne v0, v2, :cond_1

    .line 98
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->elevation:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->elevation:F

    const/4 v0, 0x1

    .line 99
    iput-boolean v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->applyElevation:Z

    goto/16 :goto_1

    .line 100
    :cond_1
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_rotationX:I

    if-ne v0, v2, :cond_2

    .line 101
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationX:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationX:F

    goto/16 :goto_1

    .line 102
    :cond_2
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_rotationY:I

    if-ne v0, v2, :cond_3

    .line 103
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationY:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationY:F

    goto/16 :goto_1

    .line 104
    :cond_3
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_rotation:I

    if-ne v0, v2, :cond_4

    .line 105
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotation:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotation:F

    goto :goto_1

    .line 106
    :cond_4
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_scaleX:I

    if-ne v0, v2, :cond_5

    .line 107
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleX:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleX:F

    goto :goto_1

    .line 108
    :cond_5
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_scaleY:I

    if-ne v0, v2, :cond_6

    .line 109
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleY:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleY:F

    goto :goto_1

    .line 110
    :cond_6
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_transformPivotX:I

    if-ne v0, v2, :cond_7

    .line 111
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotX:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotX:F

    goto :goto_1

    .line 112
    :cond_7
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_transformPivotY:I

    if-ne v0, v2, :cond_8

    .line 113
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotY:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotY:F

    goto :goto_1

    .line 114
    :cond_8
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_translationX:I

    if-ne v0, v2, :cond_9

    .line 115
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationX:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationX:F

    goto :goto_1

    .line 116
    :cond_9
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_translationY:I

    if-ne v0, v2, :cond_a

    .line 117
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationY:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationY:F

    goto :goto_1

    .line 118
    :cond_a
    sget v2, Landroid/support/constraint/R$styleable;->ConstraintSet_android_translationZ:I

    if-ne v0, v2, :cond_b

    .line 119
    iget v2, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationZ:F

    invoke-virtual {p1, v0, v2}, Landroid/content/res/TypedArray;->getFloat(IF)F

    move-result v0

    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationX:F

    :cond_b
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto/16 :goto_0

    :cond_c
    return-void
.end method

.method public constructor <init>(Landroid/support/constraint/Constraints$LayoutParams;)V
    .locals 1

    .line 86
    invoke-direct {p0, p1}, Landroid/support/constraint/ConstraintLayout$LayoutParams;-><init>(Landroid/support/constraint/ConstraintLayout$LayoutParams;)V

    const/high16 p1, 0x3f800000    # 1.0f

    .line 67
    iput p1, p0, Landroid/support/constraint/Constraints$LayoutParams;->alpha:F

    const/4 v0, 0x0

    .line 68
    iput-boolean v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->applyElevation:Z

    const/4 v0, 0x0

    .line 69
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->elevation:F

    .line 70
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotation:F

    .line 71
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationX:F

    .line 72
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->rotationY:F

    .line 73
    iput p1, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleX:F

    .line 74
    iput p1, p0, Landroid/support/constraint/Constraints$LayoutParams;->scaleY:F

    .line 75
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotX:F

    .line 76
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->transformPivotY:F

    .line 77
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationX:F

    .line 78
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationY:F

    .line 79
    iput v0, p0, Landroid/support/constraint/Constraints$LayoutParams;->translationZ:F

    return-void
.end method
