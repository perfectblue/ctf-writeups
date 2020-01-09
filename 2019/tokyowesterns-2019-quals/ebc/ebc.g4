// java -jar antlr-4.7.2-complete.jar -Dlanguage=Python2 EBC.g4
grammar EBC;

asm : insn* ;
insn :
    op = Opcode dst = operand Comma src = operand
    | op = Opcode dst = operand
    ;
operand : Register | Number | Label | derefExpr;

derefExpr : '[' expr ']' ;
expr : stackExpr ;
stackExpr : StackPointer Plus StackVar ;

fragment HexDigit : [0-9a-fA-F] ;
Opcode : 'MOV'([q][qwd]) | 'MOVI'([q][qwd]) | 'JMP8cc' | 'ADD64' | 'SUB64' | 'MULU64' | 'AND64' | 'OR64' | 'XOR64' | 'SHL64' | 'SHR64' | 'NOT64' | 'NEG64' | 'CMP64eq' ;
Comma : ',' ;
Plus : '+' ;
StackPointer : 'SP' ;
Register : 'R'[0-7];
Label : 'loc_' HexDigit+ ;
StackVar : 'var_s' HexDigit+ ;
Number : '0x'?HexDigit+ ;

Newline : ('\r' '\n'? | '\n') -> skip;
fragment Any : ~[\r\n] ;
Comment : ';' Any* -> skip ;
Whitespace : [ \t]+ -> skip ;
