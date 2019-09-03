# Generated from EBC.g4 by ANTLR 4.7.2
# encoding: utf-8
from __future__ import print_function
from antlr4 import *
from io import StringIO
import sys


def serializedATN():
    with StringIO() as buf:
        buf.write(u"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3")
        buf.write(u"\17.\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7")
        buf.write(u"\3\2\7\2\20\n\2\f\2\16\2\23\13\2\3\3\3\3\3\3\3\3\3\3")
        buf.write(u"\3\3\3\3\5\3\34\n\3\3\4\3\4\3\4\3\4\5\4\"\n\4\3\5\3\5")
        buf.write(u"\3\5\3\5\3\6\3\6\3\7\3\7\3\7\3\7\3\7\2\2\b\2\4\6\b\n")
        buf.write(u"\f\2\2\2,\2\21\3\2\2\2\4\33\3\2\2\2\6!\3\2\2\2\b#\3\2")
        buf.write(u"\2\2\n\'\3\2\2\2\f)\3\2\2\2\16\20\5\4\3\2\17\16\3\2\2")
        buf.write(u"\2\20\23\3\2\2\2\21\17\3\2\2\2\21\22\3\2\2\2\22\3\3\2")
        buf.write(u"\2\2\23\21\3\2\2\2\24\25\7\5\2\2\25\26\5\6\4\2\26\27")
        buf.write(u"\7\6\2\2\27\30\5\6\4\2\30\34\3\2\2\2\31\32\7\5\2\2\32")
        buf.write(u"\34\5\6\4\2\33\24\3\2\2\2\33\31\3\2\2\2\34\5\3\2\2\2")
        buf.write(u"\35\"\7\t\2\2\36\"\7\f\2\2\37\"\7\n\2\2 \"\5\b\5\2!\35")
        buf.write(u"\3\2\2\2!\36\3\2\2\2!\37\3\2\2\2! \3\2\2\2\"\7\3\2\2")
        buf.write(u"\2#$\7\3\2\2$%\5\n\6\2%&\7\4\2\2&\t\3\2\2\2\'(\5\f\7")
        buf.write(u"\2(\13\3\2\2\2)*\7\b\2\2*+\7\7\2\2+,\7\13\2\2,\r\3\2")
        buf.write(u"\2\2\5\21\33!")
        return buf.getvalue()


class EBCParser ( Parser ):

    grammarFileName = "EBC.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ u"<INVALID>", u"'['", u"']'", u"<INVALID>", u"','", 
                     u"'+'", u"'SP'" ]

    symbolicNames = [ u"<INVALID>", u"<INVALID>", u"<INVALID>", u"Opcode", 
                      u"Comma", u"Plus", u"StackPointer", u"Register", u"Label", 
                      u"StackVar", u"Number", u"Newline", u"Comment", u"Whitespace" ]

    RULE_asm = 0
    RULE_insn = 1
    RULE_operand = 2
    RULE_derefExpr = 3
    RULE_expr = 4
    RULE_stackExpr = 5

    ruleNames =  [ u"asm", u"insn", u"operand", u"derefExpr", u"expr", u"stackExpr" ]

    EOF = Token.EOF
    T__0=1
    T__1=2
    Opcode=3
    Comma=4
    Plus=5
    StackPointer=6
    Register=7
    Label=8
    StackVar=9
    Number=10
    Newline=11
    Comment=12
    Whitespace=13

    def __init__(self, input, output=sys.stdout):
        super(EBCParser, self).__init__(input, output=output)
        self.checkVersion("4.7.2")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None




    class AsmContext(ParserRuleContext):

        def __init__(self, parser, parent=None, invokingState=-1):
            super(EBCParser.AsmContext, self).__init__(parent, invokingState)
            self.parser = parser

        def insn(self, i=None):
            if i is None:
                return self.getTypedRuleContexts(EBCParser.InsnContext)
            else:
                return self.getTypedRuleContext(EBCParser.InsnContext,i)


        def getRuleIndex(self):
            return EBCParser.RULE_asm

        def enterRule(self, listener):
            if hasattr(listener, "enterAsm"):
                listener.enterAsm(self)

        def exitRule(self, listener):
            if hasattr(listener, "exitAsm"):
                listener.exitAsm(self)




    def asm(self):

        localctx = EBCParser.AsmContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_asm)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 15
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==EBCParser.Opcode:
                self.state = 12
                self.insn()
                self.state = 17
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class InsnContext(ParserRuleContext):

        def __init__(self, parser, parent=None, invokingState=-1):
            super(EBCParser.InsnContext, self).__init__(parent, invokingState)
            self.parser = parser
            self.op = None # Token
            self.dst = None # OperandContext
            self.src = None # OperandContext

        def Comma(self):
            return self.getToken(EBCParser.Comma, 0)

        def Opcode(self):
            return self.getToken(EBCParser.Opcode, 0)

        def operand(self, i=None):
            if i is None:
                return self.getTypedRuleContexts(EBCParser.OperandContext)
            else:
                return self.getTypedRuleContext(EBCParser.OperandContext,i)


        def getRuleIndex(self):
            return EBCParser.RULE_insn

        def enterRule(self, listener):
            if hasattr(listener, "enterInsn"):
                listener.enterInsn(self)

        def exitRule(self, listener):
            if hasattr(listener, "exitInsn"):
                listener.exitInsn(self)




    def insn(self):

        localctx = EBCParser.InsnContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_insn)
        try:
            self.state = 25
            self._errHandler.sync(self)
            la_ = self._interp.adaptivePredict(self._input,1,self._ctx)
            if la_ == 1:
                self.enterOuterAlt(localctx, 1)
                self.state = 18
                localctx.op = self.match(EBCParser.Opcode)
                self.state = 19
                localctx.dst = self.operand()
                self.state = 20
                self.match(EBCParser.Comma)
                self.state = 21
                localctx.src = self.operand()
                pass

            elif la_ == 2:
                self.enterOuterAlt(localctx, 2)
                self.state = 23
                localctx.op = self.match(EBCParser.Opcode)
                self.state = 24
                localctx.dst = self.operand()
                pass


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class OperandContext(ParserRuleContext):

        def __init__(self, parser, parent=None, invokingState=-1):
            super(EBCParser.OperandContext, self).__init__(parent, invokingState)
            self.parser = parser

        def Register(self):
            return self.getToken(EBCParser.Register, 0)

        def Number(self):
            return self.getToken(EBCParser.Number, 0)

        def Label(self):
            return self.getToken(EBCParser.Label, 0)

        def derefExpr(self):
            return self.getTypedRuleContext(EBCParser.DerefExprContext,0)


        def getRuleIndex(self):
            return EBCParser.RULE_operand

        def enterRule(self, listener):
            if hasattr(listener, "enterOperand"):
                listener.enterOperand(self)

        def exitRule(self, listener):
            if hasattr(listener, "exitOperand"):
                listener.exitOperand(self)




    def operand(self):

        localctx = EBCParser.OperandContext(self, self._ctx, self.state)
        self.enterRule(localctx, 4, self.RULE_operand)
        try:
            self.state = 31
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [EBCParser.Register]:
                self.enterOuterAlt(localctx, 1)
                self.state = 27
                self.match(EBCParser.Register)
                pass
            elif token in [EBCParser.Number]:
                self.enterOuterAlt(localctx, 2)
                self.state = 28
                self.match(EBCParser.Number)
                pass
            elif token in [EBCParser.Label]:
                self.enterOuterAlt(localctx, 3)
                self.state = 29
                self.match(EBCParser.Label)
                pass
            elif token in [EBCParser.T__0]:
                self.enterOuterAlt(localctx, 4)
                self.state = 30
                self.derefExpr()
                pass
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class DerefExprContext(ParserRuleContext):

        def __init__(self, parser, parent=None, invokingState=-1):
            super(EBCParser.DerefExprContext, self).__init__(parent, invokingState)
            self.parser = parser

        def expr(self):
            return self.getTypedRuleContext(EBCParser.ExprContext,0)


        def getRuleIndex(self):
            return EBCParser.RULE_derefExpr

        def enterRule(self, listener):
            if hasattr(listener, "enterDerefExpr"):
                listener.enterDerefExpr(self)

        def exitRule(self, listener):
            if hasattr(listener, "exitDerefExpr"):
                listener.exitDerefExpr(self)




    def derefExpr(self):

        localctx = EBCParser.DerefExprContext(self, self._ctx, self.state)
        self.enterRule(localctx, 6, self.RULE_derefExpr)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 33
            self.match(EBCParser.T__0)
            self.state = 34
            self.expr()
            self.state = 35
            self.match(EBCParser.T__1)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class ExprContext(ParserRuleContext):

        def __init__(self, parser, parent=None, invokingState=-1):
            super(EBCParser.ExprContext, self).__init__(parent, invokingState)
            self.parser = parser

        def stackExpr(self):
            return self.getTypedRuleContext(EBCParser.StackExprContext,0)


        def getRuleIndex(self):
            return EBCParser.RULE_expr

        def enterRule(self, listener):
            if hasattr(listener, "enterExpr"):
                listener.enterExpr(self)

        def exitRule(self, listener):
            if hasattr(listener, "exitExpr"):
                listener.exitExpr(self)




    def expr(self):

        localctx = EBCParser.ExprContext(self, self._ctx, self.state)
        self.enterRule(localctx, 8, self.RULE_expr)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 37
            self.stackExpr()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class StackExprContext(ParserRuleContext):

        def __init__(self, parser, parent=None, invokingState=-1):
            super(EBCParser.StackExprContext, self).__init__(parent, invokingState)
            self.parser = parser

        def StackPointer(self):
            return self.getToken(EBCParser.StackPointer, 0)

        def Plus(self):
            return self.getToken(EBCParser.Plus, 0)

        def StackVar(self):
            return self.getToken(EBCParser.StackVar, 0)

        def getRuleIndex(self):
            return EBCParser.RULE_stackExpr

        def enterRule(self, listener):
            if hasattr(listener, "enterStackExpr"):
                listener.enterStackExpr(self)

        def exitRule(self, listener):
            if hasattr(listener, "exitStackExpr"):
                listener.exitStackExpr(self)




    def stackExpr(self):

        localctx = EBCParser.StackExprContext(self, self._ctx, self.state)
        self.enterRule(localctx, 10, self.RULE_stackExpr)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 39
            self.match(EBCParser.StackPointer)
            self.state = 40
            self.match(EBCParser.Plus)
            self.state = 41
            self.match(EBCParser.StackVar)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx





