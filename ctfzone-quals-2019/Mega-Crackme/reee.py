from z3 import *

s = Solver()

c1 = []
c2 = []
c3 = []
c4 = []

for i in range(4):
  c1.append(BitVec("c1_" + str(i), 8))
  c2.append(BitVec("c2_" + str(i), 8))
  c3.append(BitVec("c3_" + str(i), 8))
  c4.append(BitVec("c4_" + str(i), 8))

for i in c1 + c2 + c3 + c4:
  s.add(i >= 48)
  s.add(i <= 90)

#                 if ((((byte)(local_8c._0_1_ * 'O' + local_8c._1_1_ * '(' + local_7c._0_1_ +
#                              local_8c._2_1_ * '\x04' + (char)local_8c * '\x1c') == -9) &&
#                     ((byte)(local_8c._1_1_ * '?' + local_8c._0_1_ * '%' + local_7c._1_1_ +
#                             local_8c._2_1_ * '\x05' + (char)local_8c * '<') == '/')) &&
#                    ((byte)(local_8c._1_1_ * '@' + local_8c._0_1_ * '`' + local_7c._2_1_ +
#                            local_8c._2_1_ * '^' + (char)local_8c * '\b') == '\x02')) {
#                   iVar5 = (int)(short)-((byte)(local_8c._2_1_ * 'N' +
#                                                local_8c._1_1_ + (char)local_7c +
#                                                local_8c._0_1_ * ';' + (char)local_8c * '\x10') !=
#                                        -0x4a) + 0x69;

# ((byte)(local_8c._2_1_ * 'N' +
#                                                local_8c._1_1_ + (char)local_7c +
#                                                local_8c._0_1_ * ';' + (char)local_8c * '\x10')


s.add((c1[0] * ord("O") + c1[1] * ord("(") + c1[2] * ord("\x04") + c1[3] * ord("\x1c")) & 0xff == 0x100-9)
s.add((c1[1] * ord("?") + c1[0] * ord("%") + c1[2] * ord("\x05") + c1[3] * ord("<")) & 0xff == ord("/"))
s.add((c1[1] * ord("@") + c1[0] * ord("`") + c1[2] * ord("^") + c1[3] * ord("\b")) & 0xff == 2)
s.add((c1[2] * ord("N") + c1[1] + c1[0] * ord(";") + c1[3] * ord("\x10")) & 0xff == 0x100 - 0x4a)


                # if ((((char)(local_88._1_1_ * '(' + local_88._0_1_ * 'O' + local_78._0_1_ +
                #              local_88._2_1_ * '\x04' + (char)local_88 * '\x1c') != -0x48) ||
                #     ((char)((char)local_88 * '<' +
                #            local_88._2_1_ * '\x05' +
                #            local_88._1_1_ * '?' + local_88._0_1_ * '%' + local_78._1_1_) != -3)) ||
                #    (((char)((char)local_88 * '\b' +
                #            local_88._0_1_ * '`' + local_88._1_1_ * '@' + local_78._2_1_ +
                #            local_88._2_1_ * '^') != '\x18' ||
                #     ((char)(local_88._0_1_ * ';' + local_88._1_1_ + (char)local_78 +
                #             local_88._2_1_ * 'N' + (char)local_88 * '\x10') != -0x71)))) {
                #   iVar5 = 0x68;
                # }

s.add((c2[1] * ord("(") + c2[0] * ord("O") + c2[2] * 4 + c2[3] * 0x1c) & 0xff == 0x100-0x48)
s.add((c2[3] * ord("<") + c2[2] * ord("\x05") + c2[1] * ord("?") + c2[0] * ord("%")) & 0xff == 0x100-3)
s.add((c2[3] * ord("\b") + c2[0] * ord("`") + c2[1] * ord("@") + c2[2] * ord("^")) & 0xff == 0x18)
s.add((c2[0] * ord(";") + c2[1] + c2[2] * ord("N") + c2[3] * ord("\x10")) & 0xff == 0x100 - 0x71)

                # if ((((char)(local_84._1_1_ * '(' + local_84._0_1_ * 'O' + local_74._0_1_ +
                #              local_84._2_1_ * '\x04' + (char)local_84 * '\x1c') != '>') ||
                #     ((char)((char)local_84 * '<' +
                #            local_84._2_1_ * '\x05' +
                #            local_84._1_1_ * '?' + local_84._0_1_ * '%' + local_74._1_1_) != -0x48))
                #    || (((char)((char)local_84 * '\b' +
                #               local_84._0_1_ * '`' + local_84._1_1_ * '@' + local_74._2_1_ +
                #               local_84._2_1_ * '^') != -0x70 ||
                #        ((char)(local_84._0_1_ * ';' + local_84._1_1_ + (char)local_74 +
                #                local_84._2_1_ * 'N' + (char)local_84 * '\x10') != -0x20)))) {
                #   iVar5 = 0x68;
                # }


s.add((c3[1] * ord("(") + c3[0] * ord("O") + c3[2] * 4 + c3[3] * 0x1c) & 0xff == ord(">"))
s.add((c3[3] * ord("<") + c3[2] * ord("\x05") + c3[1] * ord("?") + c3[0] * ord("%")) & 0xff == 0x100 - 0x48)
s.add((c3[3] * ord("\b") + c3[0] * ord("`") + c3[1] * ord("@") + c3[2] * ord("^")) & 0xff == 0x100 - 0x70)
s.add((c3[0] * ord(";") + c3[1] + c3[2] * ord("N") + c3[3] * ord("\x10")) & 0xff == 0x100 - 0x20)

                # if (((((char)(local_80._0_1_ * 'O' + local_80._1_1_ * '(' + local_70._0_1_ +
                #               local_80._2_1_ * '\x04' + (char)local_80 * '\x1c') == -0x31) &&
                #      ((char)((char)local_80 * '<' +
                #             local_80._2_1_ * '\x05' +
                #             local_80._1_1_ * '?' + local_80._0_1_ * '%' + local_70._1_1_) == -0x7b))
                #     && ((char)(local_80._0_1_ * '`' + local_80._1_1_ * '@' + local_70._2_1_ +
                #                local_80._2_1_ * '^' + (char)local_80 * '\b') == -0x34)) &&
                #    ((char)(local_80._0_1_ * ';' + local_80._1_1_ + (char)local_70 +
                #            local_80._2_1_ * 'N' + (char)local_80 * '\x10') == 'A')) 

s.add((c4[0] * ord("O") + c4[1] * ord("(") + c4[2] * ord("\x04") + c4[3] * ord("\x1c")) & 0xff == 0x100 - 0x31)
s.add((c4[3] * ord("<") + c4[2] * ord("\x05") + c4[1] * ord("?") + c4[0] * ord("%")) & 0xff == 0x100 - 0x7b)
s.add((c4[0] * ord("`") + c4[1] * ord("@") + c4[2] * ord("^") + c4[3] * ord("\b")) & 0xff == 0x100 - 0x34)
s.add((c4[0] * ord(";") + c4[1] + c4[2] * ord("N") + c4[3] * ord("\x10")) & 0xff == ord("A"))

print s.check()
model = s.model()

flag = ""
for i in c1 + c2 + c3 + c4:
  flag +=  chr(int(str(model[i])))

print flag