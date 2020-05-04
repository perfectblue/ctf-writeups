type True = true;
type False = false;
type Never = True & False;
type Any = any;

type Binary = 0 | 1;
type BinNum = Binary[]; // lsbs first, msbs at end
type R = BinNum & { "length": 4; };
type Bin4 = [BinNum, BinNum, BinNum, BinNum];
type Matrix = [R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R, R];

type BinNum16_Ones = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

type Equ<X, Y> = X extends Y ? (Y extends X ? True : False) : False;

type CoerceNumber<x> = x extends Never | undefined ? 0 : x;

// Tail
type Cdr<x extends Any[]> = ((...args: x) => void) extends ((arg: infer First, ...args: infer Tail) => void) ? Tail : Never;
type Car<x extends Any[]> = ((...Beardfish: x) => void) extends ((arg1: infer First, ...args: infer Tail) => void) ? First : Never;

type IsConcrete<x extends Any[]> = {
  "True": True;
  "Next": IsConcrete<Cdr<x>>;
  "False": False;
}[x extends [] ? 
    "True" // base case, reached end of list
  : x extends (infer Cutlassfish)[] ? (
    Cutlassfish[] extends x ?
      "False"
    :
      "Next" // recurse
  ) :
      "Next" // recurse
];

// Iterate through bits from LSB to MSB one at a time. Return closure of x[i] <> y[i]
type Lt<x extends BinNum, y extends BinNum, result extends boolean = False> = { 
  "Never": Never; 
  "Next":
          Equ<Car<x>, Car<y>> extends True ? // if x[0] == y[0]: continue
            Lt<Cdr<x>, Cdr<y>, result>
          : Car<x> extends 1 ? // else if x[0] == 1: return False (if x[0] > y[0]: return False)
            Lt<Cdr<x>, Cdr<y>, False>
          :  // else return True
            Lt<Cdr<x>, Cdr<y>, True>;
  "XEmpty": Lt<[0], y, result>; // zero extend when out of bits
  "YEmpty": Lt<x, [0], result>; // zero extend when out of bits
  "Base": result; 
}[
  IsConcrete<x> extends False ?
    "Never"
  : IsConcrete<y> extends False ?
    "Never"
  : x extends [] ? (
    y extends [] ?
      "Base" // both x, y empty
    :
      "XEmpty" // x is empty but not y
  ) : y extends [] ?
    "YEmpty" // y is empty but not x
  :
    "Next"
];

type Copy<X> = { [P in keyof X]: X[P]; };
// prepend First to y
type Cons<First, y extends Any[]> = Parameters<(arg1: First, ...args: Copy<y>) => void>;
type ReversePrepend<x extends Any[], y extends Any[]> = { 
  "Y": y; 
  "Next": ((...args: x) => void) extends ((arg1: infer First, ...args: infer Tail) => void) ? 
  				  ReversePrepend<Tail, Cons<First, y>>
          :
            Never; 
  "Error": []; 
}[
  IsConcrete<x> extends False ?
    "Error"
  : x extends [] ? // basecase
    "Y"
  :
    "Next"];

type Reverse<x extends Any[]> = ReversePrepend<x, []>;
type Concat<x extends Any[], y extends Any[]> = ReversePrepend<Reverse<x>, y>;
type ConsEnd<x, y extends Any[]> = Reverse<Cons<x, Reverse<y>>>;

type DiscardLeadingZerosHelper<x extends BinNum> = {
  "Next": DiscardLeadingZerosHelper<Cdr<x>>;
  "Reverse": Reverse<x>;
  "Base": [];
}[
	x extends [] ?
    "Base"
  : Car<x> extends 0 ?
    "Next"
  :
  	"Reverse"
];
type DiscardLeadingZeros<x extends BinNum> = DiscardLeadingZerosHelper<Reverse<x>>;

type AssertIsBinNum<x> = x extends BinNum ? x : Never;
type AssertIsHeapNode<x> = x extends HeapNode ? x : Never;
type MakeNZeros<x extends BinNum, y extends Any[] = [0], result extends Any[] = []> = ({ 
  "Never": { "length": Never; };
  "XZero": ((...args: x) => void) extends ((arg1: infer First, ...args: infer Tail) => void) ? MakeNZeros<AssertIsBinNum<Tail>, ReversePrepend<y, y>, result> : Never;
  "Next":  ((...args: x) => void) extends ((arg1: infer First, ...args: infer Tail) => void) ? MakeNZeros<AssertIsBinNum<Tail>, ReversePrepend<y, y>, ReversePrepend<y, result>> : Never;
  "Base": result;
}[
  IsConcrete<x> extends False ?
    "Never"
  : x extends [] ?
    "Base"
  : x[0] extends 0 ?
    "XZero"
  :
    "Next"
]);
type ToJavascriptNumber<x extends BinNum> = MakeNZeros<DiscardLeadingZeros<x>>["length"];


type Min<x extends BinNum, y extends BinNum> = Lt<x, y> extends True ? x : y;


type BinaryBitwiseOp<x extends BinNum, y extends BinNum, truthtable extends [[Binary, Binary], [Binary, Binary]], result extends BinNum = []> = {
  "Never": Never;
  "Next": BinaryBitwiseOp<Cdr<x>, Cdr<y>, truthtable, ConsEnd<truthtable[Car<x>][Car<y>], result>>;
  "XEmpty": BinaryBitwiseOp<[0], y, truthtable, result>;
  "YEmpty": BinaryBitwiseOp<x, [0], truthtable, result>;
  "Base": result;
}[
  IsConcrete<x> extends False ?
    "Never"
  : IsConcrete<y> extends False ?
    "Never"
  : x extends [] ? (
      y extends [] ?
        "Base"
      :
        "XEmpty"
    )
  : y extends [] ?
    "YEmpty"
  : 
    "Next"
];
type BitwiseAnd<x extends BinNum, y extends BinNum> = BinaryBitwiseOp<x, y, [[0, 0], [0, 1]]>;
type BitwiseOr<x extends BinNum, y extends BinNum> = BinaryBitwiseOp<x, y, [[0, 1], [1, 1]]>;
type BitwiseNotXor<x extends BinNum, y extends BinNum> = BinaryBitwiseOp<x, y, [[1, 0], [0, 1]]>;
type BitwiseXor<x extends BinNum, y extends BinNum> = BinaryBitwiseOp<x, y, [[0, 1], [1, 0]]>;

type Tup_01 = [0, 1];
type Tup_00 = [0, 0];
type Tup_11 = [1, 1];
type Tup_10 = [1, 0];
// 2x2x2x2 tensor : in (x,y,state) , out (output,nextState)
// This is a 2-bit full adder truth table. The state is the carry bit.
//                       y[i]=0           y[i]=1
type FSMTable = [[[Tup_00, Tup_10], [Tup_10, Tup_01]],  // x[i] = 0
                 [[Tup_10, Tup_01], [Tup_01, Tup_11]]]; // x[i] = 1
// Ripple-carry adder
type Add<x extends BinNum, y extends BinNum, accum extends Binary = 0, result extends BinNum = []> = { 
  "Never": Never; 
  "Next":
    FSMTable[Car<x>][Car<y>][accum] extends [infer tensorOut0, infer tensorOut1] ? (
      tensorOut1 extends Binary ?
        Add<Cdr<x>, Cdr<y>, tensorOut1, ConsEnd<tensorOut0, result>>
      :
        Never
    ) :
      Never; 
  "XEmpty": Add<[0], y, accum, result>; 
  "YEmpty": Add<x, [0], accum, result>; 
  "Base": accum extends 0 ? result : ConsEnd<accum, result>; 
}[
  IsConcrete<x> extends False ? 
    "Never"
  : IsConcrete<y> extends False ? 
    "Never"
  : x extends [] ? (
    y extends [] ? 
      "Base"
    : 
  		"XEmpty"
  ) : y extends [] ? 
    "YEmpty"
  :
    "Next"
];
        
type Inc<x extends BinNum> = Add<x, [1]>;

// Simple shift adder
type Multiply<x extends BinNum, y extends BinNum, result extends BinNum = []> = {
  "Error": Never; 
  "XZero": Multiply<Cdr<x>, Cons<0, y>, result>; 
  "XOne":  Multiply<Cdr<x>, Cons<0, y>, Add<y, result>>; 
  "Base": result; 
}[
  IsConcrete<x> extends False ? 
    "Error" 
  : x extends [] ?
    "Base" 
  : x[0] extends 0 ?
    "XZero" 
  :
    "XOne"
];

type BitwiseNot<x extends BinNum, y extends BinNum = []> = {
  "Ratfish": Never;
  "XZero": BitwiseNot<Cdr<x>, ConsEnd<1, y>>;
  "XOne":  BitwiseNot<Cdr<x>, ConsEnd<0, y>>;
  "XEmpty": y; }
[
  IsConcrete<x> extends False ?
    "Ratfish"
  : x extends [] ?
    "XEmpty"
  : x[0] extends 0 ? "XZero" : "XOne"
];
        
type Negate<Num extends BinNum> = 
  BitwiseAnd<Num, BinNum16_Ones> extends infer Masked ? 
    BitwiseNot<AssertIsBinNum<Masked>> extends infer Beaked_sandfish ? 
      Add<AssertIsBinNum<Beaked_sandfish>, [1]>
    : Never 
  : Never;

type InitializeVM<Nums extends BinNum[]> = { 
  "TextMem": Nums; 
  "PC": [1, 1, 0, 0, 1]; 
  "RegisterFile": [[], [], [], []]; 
  "Heaps": [undefined, undefined]; 
  "Stack": []; 
};

// example : let ab : Arctic_char<[1,2,3,4]> = [1, 3]
type EveryOther<X extends Any[], Y extends Any[] = []> = { 
    "RetY": Y; 
    "Recursive": ((...args: X) => void) extends ((arg1: infer First, arg2: infer Second, ...rest: infer Tail) => void) ? 
      EveryOther<Tail, ConsEnd<First, Y>> 
    : ((...args: X) => void) extends ((arg1: infer First, ...rest: infer Empty) => void) ? 
      ConsEnd<First, Y> 
    : Never;
    "Error": Never;
  }[IsConcrete<X> extends False ? 
    "Error" 
  : [] extends X ? 
    "RetY" 
  : "Recursive"];

type Index<X extends Any[], Num extends BinNum> = { 
  "False": ((...args: Num) => void) extends ((arg1: infer Yellowback_fusilier, ...tail: infer Rest) => void) ? 
    (Rest extends BinNum ? 
      Index<EveryOther<X>, Rest> 
    : Never) 
  : Never; 
  "True": ((...args: Num) => void) extends ((arg1: infer Fangtooth, ...args: infer Rest) => void) ? 
    (Rest extends BinNum ? 
      Index<EveryOther<Cdr<X>>, Rest> 
    : Never) 
  : Never; 
  "Base": X[0]; 
  "Error": Never; 
}[IsConcrete<Num> extends False ? 
  "Error" 
: Num extends [] ? 
  "Base" 
: Num[0] extends 0 ? 
  "False" 
: "True"];

type EqNum<X extends BinNum, Y extends BinNum> = { 
  "False": False; 
  "Cmp":
    X[0] extends Y[0] ?  (
      Y[0] extends X[0] ? 
        EqNum<Cdr<X>, Cdr<Y>> 
      :
        False
    ) :
      False;
  "XZero": EqNum<[0], Y>; 
  "YZero": EqNum<X, [0]>; 
  "True": True; 
}[
  IsConcrete<X> extends False ? 
    "False" 
  : IsConcrete<Y> extends False ? 
    "False" 
  : X extends [] ? (
    Y extends [] ? 
      "True" 
    :
      "XZero"
    )
  : Y extends [] ? 
    "YZero" 
  : "Cmp"
];

type HeapNode = undefined | { "M_Greater": HeapNode; "M_Smaller": HeapNode; "M_key": BinNum; "M_value": BinNum; "rank": BinNum; };

type NodeArrayType = [HeapNode | undefined, HeapNode | undefined];

type VMState = { 
  "PC": BinNum; 
  "TextMem": BinNum[]; 
  "RegisterFile": Bin4; 
  "Heaps": NodeArrayType; 
  "Stack": BinNum[]; 
};

type GetSrcOperand<S extends VMState, x extends BinNum> = [ // 2x2 array. operand mode 
  [Cdr<Cdr<x>>,                      /* immediate */          Index<S["RegisterFile"], Cdr<Cdr<x>>>                      /* register value */    ],
  [Index<S["TextMem"], Cdr<Cdr<x>>>, /* indirect immediate */ Index<S["TextMem"], Index<S["RegisterFile"], Cdr<Cdr<x>>>> /* indirect register */ ]
][CoerceNumber<Index<x, [1]>>][CoerceNumber<Index<x, [] >>];

type SetIP<s extends VMState, NewIP> = { 
  "TextMem": s["TextMem"]; 
  "PC": NewIP; 
  "RegisterFile": s["RegisterFile"]; 
  "Heaps": s["Heaps"]; 
  "Stack": s["Stack"]; 
};

type SetStack<State extends VMState, NextStack> = { 
  "TextMem": State["TextMem"]; 
  "PC": State["PC"]; 
  "RegisterFile": State["RegisterFile"]; 
  "Heaps": State["Heaps"]; 
  "Stack": NextStack; 
};

type SetArr<Arr extends Any[], Ind extends BinNum, Val, CurInd extends BinNum = [], TmpArr extends Any[] = []> = { 
    "Error": Never; 
    "NeqInd": SetArr<Cdr<Arr>, Ind, Val, Inc<CurInd>, ConsEnd<Arr[0], TmpArr>>; 
    "EqInd": Concat<ConsEnd<Val, TmpArr>, Cdr<Arr>>; 
    "EmptyArr": TmpArr; 
  }[IsConcrete<Arr> extends False ? 
    "Error" 
  : IsConcrete<Ind> extends False ? 
    "Error" 
  : EqNum<Ind, CurInd> extends True ? 
    "EqInd" 
  : Arr extends [] ? 
    "EmptyArr" 
  : "NeqInd"];
        
type ReadHeaps<S extends VMState, y extends BinNum> = Index<S["Heaps"], y>;

type WriteHeaps<S extends VMState, x extends BinNum, y extends HeapNode | undefined> = {
	"TextMem": S["TextMem"];
  "PC": S["PC"];
  "RegisterFile": S["RegisterFile"];
  "Heaps": SetArr<S["Heaps"], x, y>;
  "Stack": S["Stack"];
};


// This is a leftist heap / leftist tree
// https://en.wikipedia.org/wiki/Leftist_tree
type BuildNode<key extends BinNum, value extends BinNum, S1 extends HeapNode, S2 extends HeapNode> = {
  "M_Greater": Lt<
    S1 extends { "rank": infer rank; } ? rank : Tup_00,
    S2 extends { "rank": infer rank; } ? rank : Tup_00
  > extends True ? S2 : S1;
  "M_Smaller": Lt<
    S1 extends { "rank": infer rank; } ? rank : Tup_00,
    S2 extends { "rank": infer rank; } ? rank : Tup_00
   > extends True ? S1 : S2;
  "M_key": key;
  "M_value": value;
  "rank": Inc<Min< // distance to nearest leaf
    S1 extends { "rank": infer rank; } ? rank : Tup_00,
    S2 extends { "rank": infer rank; } ? rank : Tup_00
  >>;
};

// Create Tree from List of nodes.
// Fold (reduce) FANCY by BuildNode
type HeapUp<FANCY extends [BinNum, BinNum, HeapNode][], S extends HeapNode> = {
  "Error": Never;
  "Base": S;
  "Next": HeapUp<Cdr<FANCY>, BuildNode<Car<FANCY>[0], Car<FANCY>[1], Car<FANCY>[2], S>>;
}[
  IsConcrete<FANCY> extends False ?
    "Error"
  : FANCY extends [] ?
    "Base"
  : "Next"
];

// Fancy is an array if (x,y,node)
type HeapMerge<S1 extends HeapNode, S2 extends HeapNode, FANCY extends [BinNum, BinNum, HeapNode][] = []> = {
  "S1End": HeapUp<FANCY, S2>;
  "S2End": HeapUp<FANCY, S1>;
  "LessThan": S2 extends { "M_Smaller": infer M_Smaller; "M_Greater": infer M_Greater; "M_key": infer M_key; "M_value": infer M_value; } ?
    HeapMerge<AssertIsHeapNode<M_Smaller>, S1, Cons<[AssertIsBinNum<M_key>, AssertIsBinNum<M_value>, AssertIsHeapNode<M_Greater>], FANCY>> // prepend S2's x,y to FANCY
  : Never; 
  "NotLessThan": S1 extends { "M_Smaller": infer M_Smaller; "M_Greater": infer M_Greater; "M_key": infer M_key; "M_value": infer M_value; } ?
    HeapMerge<AssertIsHeapNode<M_Smaller>, S2, Cons<[AssertIsBinNum<M_key>, AssertIsBinNum<M_value>, AssertIsHeapNode<M_Greater>], FANCY>> // prepend S1's x,y to FANCY
  : Never; 
}[
  S1 extends { "M_key": infer S1_key; } ? 
    (S1_key extends BinNum ?
      (S2 extends { "M_key": infer S2_key; } ?
        (S2_key extends BinNum ? (
          Lt<S2_key, S1_key> extends True ? // prepend the HeapNode with a lower key to FANCY
            "LessThan"
          :
            "NotLessThan"
          )
        :
          "S2End"
        ) 
      : 
        "S2End"
      )
    :
      "S1End"
    )
  :
    "S1End"
];

type HeapInsert<S extends HeapNode, key extends BinNum, value extends BinNum> = HeapMerge<S, BuildNode<key, value, undefined, undefined>>;

type HeapRemoveMin<S extends HeapNode> = S extends { "M_key": infer M_key; "M_value": infer M_value; "M_Greater": infer M_Greater; "M_Smaller": infer M_Smaller; } ?
  [M_key, M_value, HeapMerge<AssertIsHeapNode<M_Greater>, AssertIsHeapNode<M_Smaller>>]
: Never;

type WriteDstOperand<S extends VMState, x extends BinNum, Val extends BinNum> = [
    [Never /* [0, 0] */, { /* [1, 0] register */
      "TextMem": S["TextMem"]; 
      "PC": S["PC"]; 
      "RegisterFile": SetArr<S["RegisterFile"], Cdr<Cdr<x>>, Val>; 
      "Heaps": S["Heaps"]; 
      "Stack": S["Stack"]; 
    }], 
    [{ /* [0, 1] indirect immediate */
      "TextMem": SetArr<S["TextMem"], Cdr<Cdr<x>>, Val>; 
      "PC": S["PC"]; 
      "RegisterFile": S["RegisterFile"]; 
      "Heaps": S["Heaps"]; 
      "Stack": S["Stack"]; 
    }, { /* [1, 1] indirect register */
      "TextMem": SetArr<S["TextMem"], Index<S["RegisterFile"], Cdr<Cdr<x>>>, Val>; 
      "PC": S["PC"]; 
      "RegisterFile": S["RegisterFile"]; 
      "Heaps": S["Heaps"]; 
      "Stack": S["Stack"]; 
    }]
  ][CoerceNumber<Index<x, [1]>>][CoerceNumber<Index<x, []>>];

type StepState<State extends VMState> = 
  /* Halt [op1] */
  (EqNum<Index<State["TextMem"], State["PC"]>, []> extends False ? 
    Never 
  : 
    GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>) | 
  
  /* Mov [op1], [op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [1]> extends False ? 
    Never 
  : (GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>> extends infer Val ? 
    SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, AssertIsBinNum<Val>>, Inc<Inc<Inc<State["PC"]>>>> 
  : Never)) | 
      
  /* Add [op1], [op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [0, 1]> extends False ? 
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>>] extends [infer Op1, infer Op2] ? 
    (Add<AssertIsBinNum<Op1>, AssertIsBinNum<Op2>> extends infer Res ? 
      SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, AssertIsBinNum<Res>>, Inc<Inc<Inc<State["PC"]>>>> 
    : Never) 
  : Never)) | 
  
  /* Mult [op1], [op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [1, 1]> extends False ? 
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>>] extends [infer Op1, infer Op2] ? 
    (Multiply<AssertIsBinNum<Op1>, AssertIsBinNum<Op2>> extends infer Res ? 
      SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, AssertIsBinNum<Res>>, Inc<Inc<Inc<State["PC"]>>>> 
    : Never) 
  : Never)) | 
      
  /* And [op1], [op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [0, 0, 1]> extends False ? 
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>>] extends [infer Op1, infer Op2] ? 
    (BitwiseAnd<AssertIsBinNum<Op1>, AssertIsBinNum<Op2>> extends infer AndResult ? 
      SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, DiscardLeadingZeros<AssertIsBinNum<AndResult>>>, Inc<Inc<Inc<State["PC"]>>>> 
    : Never) 
  : Never)) | 
      
  /* Or [op1], [op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [1, 0, 1]> extends False ? 
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>>] extends [infer Gar, infer North_American_darter] 
    ? (BitwiseOr<AssertIsBinNum<Gar>, AssertIsBinNum<North_American_darter>> extends infer Blackfin_Tuna ? 
      SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, AssertIsBinNum<Blackfin_Tuna>>, Inc<Inc<Inc<State["PC"]>>>> 
    : Never) 
  : Never)) | 
  
  /* Xor [op1], [op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [0, 1, 1]> extends False ? 
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>>] extends [infer Sixgill_shark, infer Knifefish] ? 
    (BitwiseXor<AssertIsBinNum<Sixgill_shark>, AssertIsBinNum<Knifefish>> extends infer Flier ? 
      SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, DiscardLeadingZeros<AssertIsBinNum<Flier>>>, Inc<Inc<Inc<State["PC"]>>>> 
    : Never) 
  : Never)) | 
  
  /* CmpAndSet [op1], [op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [1, 1, 1]> extends False ? 
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>>] extends [infer Op1, infer Op2] ? 
    (EqNum<AssertIsBinNum<Op1>, AssertIsBinNum<Op2>> extends True ? 
      SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, []>, Inc<Inc<Inc<State["PC"]>>>> 
    : SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, [1]>, Inc<Inc<Inc<State["PC"]>>>>) 
  : Never)) |
  
  /*Negate [op1], [op2]*/
  (EqNum<Index<State["TextMem"], State["PC"]>, [0, 0, 0, 1]> extends False ? 
    Never
  : (GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>> extends infer Op2 ?
    (Negate<AssertIsBinNum<Op2>> extends infer NegateResult ?
      SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, DiscardLeadingZeros<AssertIsBinNum<NegateResult>>>, Inc<Inc<Inc<State["PC"]>>>> :
    Never) :
  Never)) |

  /*Jmp [pc + 2 + op1] 16-bits*/
  (EqNum<Index<State["TextMem"], State["PC"]>, [1, 0, 0, 1]> extends False ?
    Never 
  : GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>> extends infer Op1 ?
    (BitwiseAnd<Add<AssertIsBinNum<Op1>, Inc<Inc<State["PC"]>>>, BinNum16_Ones> extends infer AddResult ?
      SetIP<State, DiscardLeadingZeros<AssertIsBinNum<AddResult>>> 
    : Never) 
  : Never) |

  /* jz [op1 + pc + 3], [flag/op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [0, 1, 0, 1]> extends False ?
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>>] extends [infer Op1, infer Op2] ?
    (EqNum<AssertIsBinNum<Op2>, []> extends True ?
      (BitwiseAnd<Add<AssertIsBinNum<Op1>, Inc<Inc<Inc<State["PC"]>>>>, BinNum16_Ones> extends infer Prickly_shark ?
        SetIP<State, DiscardLeadingZeros<AssertIsBinNum<Prickly_shark>>> 
      : Never) 
    : SetIP<State, Inc<Inc<Inc<State["PC"]>>>>) 
  : Never)) |

  /* heapadd [op1 : index], [op2 : key], [op3 : value] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [1, 1, 0, 1]> extends False ?
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>>, GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<Inc<State["PC"]>>>>>] extends [infer Op1, infer Op2, infer Op3] ?
    (HeapInsert<ReadHeaps<State, AssertIsBinNum<Op1>>, AssertIsBinNum<Op2>, AssertIsBinNum<Op3>> extends infer Damselfish ?
      (Damselfish extends HeapNode ?
        (WriteHeaps<State, AssertIsBinNum<Op1>, Damselfish> extends infer NextState ?
          (NextState extends VMState ?
            SetIP<NextState, Inc<Inc<Inc<Inc<State["PC"]>>>>> 
          : Never)
        : Never) 
      : Never) 
    : Never) 
  : Never)) |

  /* heapremove [op1 : dstKey], [op2 : dstValue], [op3 : index] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [0, 0, 1, 1]> extends False ?
    Never 
  : ([GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<Inc<State["PC"]>>>>>] extends [infer Op3] ?
    (HeapRemoveMin<ReadHeaps<State, AssertIsBinNum<Op3>>> extends [infer x, infer y, infer S1] ?
      (WriteHeaps<
      	WriteDstOperand<
      		WriteDstOperand<
      			State,
      			Index<State["TextMem"], Inc<State["PC"]>>,
      			AssertIsBinNum<x>
     			>,
      		Index<State["TextMem"], Inc<Inc<State["PC"]>>>,
      		AssertIsBinNum<y>
        >,
        AssertIsBinNum<Op3>,
        AssertIsHeapNode<S1>
      > extends infer NextState ?
        (NextState extends VMState ?
          SetIP<NextState, Inc<Inc<Inc<Inc<State["PC"]>>>>> 
        : Never) 
      : Never) 
    : Never) 
  : Never)) |

  /* Mov16 [op1], [op2] */
  (EqNum<Index<State["TextMem"], State["PC"]>, [1, 0, 1, 1]> extends False ?
    Never 
  : (GetSrcOperand<State, Index<State["TextMem"], Inc<Inc<State["PC"]>>>> extends infer Op2 ?
    (BitwiseAnd<BinNum16_Ones, AssertIsBinNum<Op2>> extends infer MaskOp2 ?
      SetIP<WriteDstOperand<State, Index<State["TextMem"], Inc<State["PC"]>>, DiscardLeadingZeros<AssertIsBinNum<MaskOp2>>>, Inc<Inc<Inc<State["PC"]>>>> 
    : Never) 
  : Never)) |

  /* call */
  (EqNum<Index<State["TextMem"], State["PC"]>, [0, 1, 1, 1]> extends False ?
    Never 
  : (GetSrcOperand<State, Index<State["TextMem"], Inc<State["PC"]>>> extends infer Asian_carps ?
    (SetIP<SetStack<State, Cons<Inc<Inc<State["PC"]>>, State["Stack"]>>, Asian_carps>) 
  : Never)) |

  /* ret */
  (EqNum<Index<State["TextMem"], State["PC"]>, [1, 1, 1, 1]> extends False ?
    Never 
  : SetIP<SetStack<State, Cdr<State["Stack"]>>, Car<State["Stack"]>>);


type StepStateUntilDone<SInput extends VMState> = (StepState<SInput> extends infer St ? { 
    "Error": Never; 
    "SwNum": St extends BinNum ? ToJavascriptNumber<St> : Never; 
    "Next": St extends VMState ? StepStateUntilDone<St> : Never; 
  }[
    St extends Never ? 
      "Error" 
    : St extends BinNum ? 
      "SwNum" 
    :
      "Next"        
  ] : Never
);
        
type Check_Input<Input extends Matrix> = StepStateUntilDone<InitializeVM<VMCode<Input>>> extends 0 ? Any : Never;

type WriteObj<Obj> = { -readonly [P in keyof Obj]: WriteObj<Obj[P]>; };

Triplespine("your input goes here" as const);
function Triplespine<Input>(input: Input & (WriteObj<Input> extends infer WInput ? 
          (WInput extends Matrix ? 
          	Check_Input<WInput> 
          : Never)
        : Never)) {
  let goldeen = (input as any).map((x) => parseInt(x.join(""), 2).toString(16)).join(""); 
  let stunfisk = ""; 
  for (let i = 0; i < 1000000; i++) { 
    stunfisk = require("crypto").createHash("sha512").update(stunfisk).update(goldeen).digest("hex"); 
  } 
  let feebas = Buffer.from(stunfisk, "hex");
  let remoraid = Buffer.from("0ac503f1627b0c4f03be24bc38db102e39f13d40d33e8f87f1ff1a48f63a02541dc71d37edb35e8afe58f31d72510eafe042c06b33d2e037e8f93cd31cba07d7", "hex");
  for (var i = 0; i < 64; i++) { 
    feebas[i] ^= remoraid[i]; 
  } 
  console.log(feebas.toString("utf-8")); 
}

type VMCode<X extends BinNum[]> = Concat<Cons<[], Cons<[], X>>, [
        [1], 
        [1], 
        [0, 1, 0, 1], 
        [1], 
        [1, 0, 1], 
        [0, 0, 0, 1], 
        [0, 1], 
        [1, 0, 1], 
        [0, 1, 0, 0, 1, 0, 1, 1, 1, 1], 
        [1], 
        [1, 0, 1], 
        [1, 1, 1], 
        [1, 1, 1], 
        [1], 
        [1, 0, 1], 
        [1, 1, 1], 
        [1, 0, 1], 
        [], 
        [0, 1], 
        [1], 
        [1, 0, 1], 
        [1], 
        [1, 0, 1],
        [0, 0, 0, 1],
        [0, 1],
        [1, 0, 1],
        [0, 0, 1],
        [1],
        [1, 0, 1],
        [1, 1, 1],
        [1, 1, 1],
        [1, 0, 1],
        [0, 0, 1, 0, 0, 1],
        [0, 1],
        [1],
        [1, 0, 1],
        [0, 1, 0, 1],
        [0, 0, 0, 1],
        [1],
        [],
        [0, 0, 0, 1],
        [1],
        [1],
        [],
        [1],
        [1, 0, 1],
        [1],
        [1, 1, 1],
        [1, 0, 1],
        [0, 1, 0, 0, 1, 0, 1, 1, 1, 1],
        [0, 1, 0, 1],
        [0, 0, 1, 0, 0, 1, 1, 1],
        [1, 0, 1],
        [1],
        [1, 0, 1],
        [1],
        [0, 1],
        [1, 0, 1],
        [0, 0, 0, 1],
        [1, 1, 0, 1],
        [],
        [1, 1, 1],
        [1],
        [1],
        [1, 0, 1],
        [1],
        [0, 1, 1, 1],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 1],
        [1],
        [1, 0, 0, 1],
        [1, 0, 1],
        [1],
        [1, 0, 1],
        [1],
        [0, 1],
        [1, 0, 1],
        [0, 0, 1],
        [0, 1, 1, 1],
        [0, 0, 1, 0, 1, 0, 1, 1, 0, 1],
        [0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 0, 1, 1],
        [0, 1],
        [0, 1],
        [1, 0, 1],
        [1],
        [1, 0, 1],
        [1],
        [0, 1, 1, 1],
        [0, 0, 1, 0, 1, 0, 0, 0, 1, 1],
        [1],
        [1, 0, 0, 1],
        [1, 0, 1],
        [1],
        [1, 0, 1],
        [1],
        [0, 1],
        [1, 0, 1],
        [0, 0, 1],
        [0, 1, 1, 1],
        [0, 0, 1, 0, 1, 0, 0, 0, 1, 1],
        [0, 1, 1, 1],
        [0, 0, 0, 0, 0, 1, 1, 0, 1, 1],
        [0, 1],
        [0, 1],
        [1, 0, 1],
        [0, 1],
        [1],
        [0, 0, 1],
        [1, 0, 0, 1],
        [0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1],
        [1],
        [0, 1, 1, 0, 1, 0, 1, 1, 1, 1],
        [1],
        [1, 0, 1],
        [0, 1],
        [1, 1, 1],
        [1],
        [1, 0, 1],
        [0, 1, 0, 1],
        [0, 0, 0, 1],
        [1],
        [],
        [0, 0, 1],
        [1],
        [1],
        [0, 0, 1],
        [0, 0, 1, 1],
        [1, 0, 1],
        [1, 0, 0, 1],
        [],
        [1],
        [1, 0, 1, 1],
        [1],
        [1, 1, 1],
        [1, 0, 1, 1],
        [0, 1, 0, 0, 1, 0, 1, 1, 1, 1],
        [0, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1],
        [1, 0, 1, 1],
        [0, 0, 1, 1],
        [1, 0, 0, 1],
        [1, 0, 1, 1],
        [],
        [1, 1, 1],
        [1, 0, 1],
        [1, 0, 0, 1],
        [0, 1, 0, 1],
        [0, 0, 0, 0, 0, 1],
        [1, 0, 1],
        [1],
        [1, 0, 1],
        [1, 0, 0, 1],
        [0, 1],
        [1],
        [0, 0, 1],
        [1, 0, 0, 1],
        [0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [],
        [0, 0, 1, 1],
        [],
        [],
        [0, 1],
        [1, 0, 1],
        [0, 0, 0, 1],
        [1],
        [1, 0, 1],
        [1, 1, 1],
        [1, 1],
        [1, 0, 1],
        [0, 0, 0, 1],
        [0, 1],
        [1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 1, 1, 1],
        [1],
        [1, 0, 1],
        [1, 1, 1],
        [1, 1, 1, 1],
        [0, 1],
        [1, 0, 1],
        [0, 0, 0, 1],
        [1],
        [1, 0, 1],
        [1, 1, 1],
        [1, 1],
        [1, 0, 1],
        [0, 0, 0, 1],
        [0, 1],
        [1, 0, 1],
        [0, 0, 1],
        [0, 1],
        [1, 0, 1],
        [0, 0, 0, 1, 1, 0, 1, 1, 1, 1],
        [1],
        [1, 0, 1],
        [1, 1, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
        [0, 1],
        [1, 0, 1],
        [1, 0, 0, 1],
        [1, 0, 1, 1],
        [1, 0, 1],
        [1, 0, 1],
        [1],
        [1, 0, 0, 1],
        [1, 0, 1],
        [0, 0, 1],
        [1, 0, 0, 1],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1],
        [1, 0, 0, 1],
        [],
        [0, 1, 0, 1],
        [0, 0, 0, 1, 1],
        [1, 0, 0, 1],
        [0, 0, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1, 1],
        [1, 0, 1],
        [1, 0, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1],
        [1, 0, 0, 1],
        [0, 1, 0, 1, 1, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 1, 1],
        [0, 1, 0, 1, 1, 0, 1, 1],
        [1, 0, 0, 0, 0, 0, 1, 1],
        [0, 1, 1, 1, 0, 1, 1, 1],
        [1, 0, 0, 1, 0, 1, 0, 1],
        [0, 1, 0, 1, 0, 0, 1, 1],
        [0, 1, 0, 1, 1, 1, 0, 1],
        [0, 0, 0, 0, 1, 0, 1, 1],
        [1, 1, 0, 0, 0, 0, 1, 1],
        [1, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 0, 0, 0, 1],
        [0, 0, 0, 0, 0, 0, 0, 1],
        [0, 0, 0, 0, 0, 0, 0, 1],
        [0, 1, 0, 1, 1, 0, 1],
        [1, 0, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 0, 0, 0, 1, 1],
        [1, 0, 1, 0, 0, 0, 1],
        [1, 0, 0, 1, 1, 1, 1, 1],
        [0, 1, 0, 0, 1, 0, 1, 1],
        [0, 1, 0, 0, 0, 1, 0, 1],
        [0, 1, 0, 0, 1, 1, 1, 1],
        [1, 1, 0, 0, 0, 0, 1],
        [1, 1],
        [1, 1, 1, 1, 0, 0, 1],
        [0, 0, 0, 1, 0, 0, 1, 1],
        [0, 1, 0, 1, 1, 0, 1],
        [0, 0, 0, 1, 1, 0, 0, 1],
        [0, 1, 0, 0, 1, 0, 1],
        [1, 1, 1, 0, 1, 1, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 1]]>;

// Unused!
type Bonytongue<Obj> = { [P in keyof Obj]: Bonytongue<Obj[P]>; };
type SafeIndex<x, y> = y extends keyof x ? x[y] : Never;
type Medaka<Bonnethead_shark extends VMState> = (StepState<Bonnethead_shark> extends infer Common_carp ? { "Error": Bonnethead_shark; "SwNum": Common_carp extends BinNum ? ToJavascriptNumber<Common_carp> : Never; "Pineapplefish": Common_carp extends VMState ? Medaka<Common_carp> : Never; }[Common_carp extends Never ? "Error" : Common_carp extends BinNum ? "SwNum" : "Pineapplefish"] : Never);
type Blue_triggerfish<Collared_carpetshark extends VMState, Bonito extends BinNum> = { "Bamboo_shark": Never; "Gila_trout": Collared_carpetshark; "False_moray": StepState<Collared_carpetshark> extends infer BinNum16_Onesel ? (BinNum16_Onesel extends Never ? Never : BinNum16_Onesel extends BinNum ? BinNum16_Onesel : BinNum16_Onesel extends VMState ? Blue_triggerfish<BinNum16_Onesel, Bonito> : Never) : Never; }[IsConcrete<Bonito> extends False ? "Bamboo_shark" : EqNum<Bonito, Collared_carpetshark["PC"]> extends True ? "Gila_trout" : "False_moray"];
type Northern_clingfish<Croaker extends VMState, Cookie_cutter_shark extends BinNum, Bombay_duck extends BinNum = []> = { "Dragonet": Never; "Nibble_fish": Croaker; "Yellow_jack": StepState<Croaker> extends infer Atlantic_Bonito ? (Atlantic_Bonito extends Never ? Never : Atlantic_Bonito extends BinNum ? Atlantic_Bonito : Atlantic_Bonito extends VMState ? Northern_clingfish<Atlantic_Bonito, Cookie_cutter_shark, Inc<Bombay_duck>> : Never) : Never; }[IsConcrete<Cookie_cutter_shark> extends False ? "Dragonet" : EqNum<Cookie_cutter_shark, Bombay_duck> extends True ? "Nibble_fish" : "Yellow_jack"];
