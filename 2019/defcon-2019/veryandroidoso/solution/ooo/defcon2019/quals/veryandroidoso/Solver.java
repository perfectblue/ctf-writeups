package ooo.defcon2019.quals.veryandroidoso;

import java.util.ArrayList;

// $ LD_LIBRARY_PATH=. java -Djava.library.path=. ooo.defcon2019.quals.veryandroidoso.Solver
// search space 1*1*2*2*16*64*1*1*256=1048576
// .....................................................................................................................................*
// true
// true
// true
// OOO{fab43416484944beba}


/*
int (n\d{0,3});\n(\s+(else )?if \(n(\d)? == \d{1,3}\) {\n\s+\1 = m\d\(\d{1,3}, getSecretNumber\(scramble\d?\)\);\n\s.+}\n)+\s+else {\n\s+\1 = 0;\n\s+}
(?:else )?if \(n(?:\d)? == (\d{1,3})\) {\n\s+n\d{1,2} = m\d\((\d{1,3}), getSecretNumber\(scramble\d?\)\);\n\s.+}\n\s+
int (n\d{1,3});\n\s+int gay(\d) = (new int\[\] {[\d, ]+});
*/

class Solver {
    static int getSecretNumber(int n) {
    // int fuck[] = {190, 204, 118, 29, 61, 80, 68, 171, 50, 9, 137, 170, 218, 171, 33, 81, 148, 136, 125, 46, 143, 47, 5, 109, 131, 1, 129, 252, 175, 65, 9, 42, 190, 204, 118, 29, 61, 80, 68, 171, 50, 9, 137, 170, 218, 171, 33, 81, 148, 136, 125, 46, 143, 47, 5, 109, 131, 1, 129, 252, 175, 65, 9, 42, 190, 204, 118, 29, 61, 80, 68, 171, 50, 9, 137, 170, 218, 171, 33, 81, 148, 136, 125, 46, 143, 47, 5, 109, 131, 1, 129, 252, 175, 65, 9, 42, 190, 204, 118, 29, 61, 80, 68, 171, 50, 9, 137, 170, 218, 171, 33, 81, 148, 136, 125, 46, 143, 47, 5, 109, 131, 1, 129, 252, 175, 65, 9, 42, 190, 204, 118, 29, 61, 80, 68, 171, 50, 9, 137, 170, 218, 171, 33, 81, 148, 136, 125, 46, 143, 47, 5, 109, 131, 1, 129, 252, 175, 65, 9, 42, 190, 204, 118, 29, 61, 80, 68, 171, 50, 9, 137, 170, 218, 171, 33, 81, 148, 136, 125, 46, 143, 47, 5, 109, 131, 1, 129, 252, 175, 65, 9, 42, 190, 204, 118, 29, 61, 80, 68, 171, 50, 9, 137, 170, 218, 171, 33, 81, 148, 136, 125, 46, 143, 47, 5, 109, 131, 1, 129, 252, 175, 65, 9, 42, 190, 204, 118, 29, 61, 80, 68, 171, 50, 9, 137, 170, 218, 171, 33, 81, 148, 136, 125, 46, 143, 47, 5, 109, 131, 1, 129, 252, 175, 65, 9, 42, };
    int fuck[] = { 105, 71, 127, 221, 12, 24, 237, 85, 2, 143, 81, 214, 5, 79, 100, 82, 44, 225, 80, 5, 2, 177, 133, 113, 244, 238, 241, 218, 214, 83, 169, 112, 233, 154, 245, 14, 26, 167, 104, 50, 208, 241, 229, 70, 12, 3, 219, 15, 88, 34, 197, 185, 97, 205, 147, 95, 218, 159, 70, 129, 255, 145, 43, 49, 17, 197, 210, 68, 69, 210, 74, 59, 249, 41, 182, 11, 99, 106, 146, 250, 113, 183, 183, 193, 202, 81, 227, 242, 44, 1, 199, 153, 120, 48, 78, 65, 230, 173, 71, 15, 103, 89, 61, 109, 172, 7, 97, 101, 58, 126, 169, 97, 105, 80, 198, 188, 240, 219, 29, 14, 41, 139, 157, 117, 107, 98, 191, 222, 136, 247, 45, 93, 4, 154, 113, 108, 192, 154, 5, 76, 66, 134, 244, 227, 132, 238, 150, 201, 86, 237, 124, 152, 134, 199, 152, 117, 168, 43, 61, 129, 222, 245, 111, 109, 155, 142, 16, 101, 72, 191, 231, 213, 224, 26, 149, 87, 171, 79, 174, 23, 108, 245, 195, 70, 253, 36, 207, 226, 39, 13, 210, 175, 223, 178, 93, 16, 96, 209, 52, 247, 230, 58, 198, 1, 40, 75, 203, 45, 234, 156, 214, 244, 141, 89, 132, 229, 29, 156, 190, 108, 88, 10, 28, 105, 180, 182, 157, 23, 234, 17, 249, 18, 210, 62, 31, 236, 97, 190, 1, 236, 17, 102, 33, 84, 5, 131, 149, 198, 122, 86, 126, 90, 235, 175, 58, 176, };
        return fuck[n];
    }


    public static int scramble(final int n) {
        final int n2 = (int)sleep(500) - 499;
        int shit = (int)Math.round(Math.sqrt(n2 * 4 * n2) / n2); // basically always 2?
        return (n + shit + 321) % 256;
    }

    static long sleep(final int n) {
        // final long nanoTime = System.nanoTime();
        // final long n2 = n;
        // try {
        //     Thread.sleep(n2);
        // }
        // catch (InterruptedException ex) {
        //     throw new ArithmeticException("divide by zero");
        // }
        // return (int)((System.nanoTime() - nanoTime) / 1000000.0f) + 1;

        return n; // there's some random fluctuation ofc ? very weird
    }

    static {
        System.loadLibrary("native-lib");
    }
    public static native int m0(int var0, int var1);

    public static native int m1(int var0, int var1);

    public static native int m2(int var0, int var1);

    public static native int m3(int var0, int var1);

    public static native int m4(int var0, int var1);

    public static native int m5(int var0, int var1);

    public static native int m6(int var0, int var1);

    public static native int m7(int var0, int var1);

    public static native int m8(int var0, int var1);

    public static native void m9(int var0);

    static boolean solve(final int n, final int n2, final int n3, final int n4, final int n5, final int n6, final int n7, final int n8, final int n9) {
        final int scramble = scramble(13);
        int n10;
        if (n == 0) {
            n10 = m0(100, getSecretNumber(scramble));
        }
        else if (n == 1) {
            n10 = m0(190, getSecretNumber(scramble));
        }
        else if (n == 2) {
            n10 = m0(88, getSecretNumber(scramble));
        }
        else if (n == 3) {
            n10 = m0(240, getSecretNumber(scramble));
        }
        else if (n == 4) {
            n10 = m0(97, getSecretNumber(scramble));
        }
        else if (n == 5) {
            n10 = m0(216, getSecretNumber(scramble));
        }
        else if (n == 6) {
            n10 = m0(47, getSecretNumber(scramble));
        }
        else if (n == 7) {
            n10 = m0(243, getSecretNumber(scramble));
        }
        else if (n == 8) {
            n10 = m0(39, getSecretNumber(scramble));
        }
        else if (n == 9) {
            n10 = m0(18, getSecretNumber(scramble));
        }
        else if (n == 10) {
            n10 = m0(173, getSecretNumber(scramble));
        }
        else if (n == 11) {
            n10 = m0(144, getSecretNumber(scramble));
        }
        else if (n == 12) {
            n10 = m0(157, getSecretNumber(scramble));
        }
        else if (n == 13) {
            n10 = m0(114, getSecretNumber(scramble));
        }
        else if (n == 14) {
            n10 = m0(116, getSecretNumber(scramble));
        }
        else if (n == 15) {
            n10 = m0(250, getSecretNumber(scramble));
        }
        else if (n == 16) {
            n10 = m0(152, getSecretNumber(scramble));
        }
        else if (n == 17) {
            n10 = m0(150, getSecretNumber(scramble));
        }
        else if (n == 18) {
            n10 = m0(196, getSecretNumber(scramble));
        }
        else if (n == 19) {
            n10 = m0(175, getSecretNumber(scramble));
        }
        else if (n == 20) {
            n10 = m0(28, getSecretNumber(scramble));
        }
        else if (n == 21) {
            n10 = m0(179, getSecretNumber(scramble));
        }
        else if (n == 22) {
            n10 = m0(23, getSecretNumber(scramble));
        }
        else if (n == 23) {
            n10 = m0(213, getSecretNumber(scramble));
        }
        else if (n == 24) {
            n10 = m0(73, getSecretNumber(scramble));
        }
        else if (n == 25) {
            n10 = m0(66, getSecretNumber(scramble));
        }
        else if (n == 26) {
            n10 = m0(20, getSecretNumber(scramble));
        }
        else if (n == 27) {
            n10 = m0(228, getSecretNumber(scramble));
        }
        else if (n == 28) {
            n10 = m0(67, getSecretNumber(scramble));
        }
        else if (n == 29) {
            n10 = m0(200, getSecretNumber(scramble));
        }
        else if (n == 30) {
            n10 = m0(156, getSecretNumber(scramble));
        }
        else if (n == 31) {
            n10 = m0(7, getSecretNumber(scramble));
        }
        else if (n == 32) {
            n10 = m0(221, getSecretNumber(scramble));
        }
        else if (n == 33) {
            n10 = m0(210, getSecretNumber(scramble));
        }
        else if (n == 34) {
            n10 = m0(50, getSecretNumber(scramble));
        }
        else if (n == 35) {
            n10 = m0(233, getSecretNumber(scramble));
        }
        else if (n == 36) {
            n10 = m0(110, getSecretNumber(scramble));
        }
        else if (n == 37) {
            n10 = m0(32, getSecretNumber(scramble));
        }
        else if (n == 38) {
            n10 = m0(71, getSecretNumber(scramble));
        }
        else if (n == 39) {
            n10 = m0(194, getSecretNumber(scramble));
        }
        else if (n == 40) {
            n10 = m0(117, getSecretNumber(scramble));
        }
        else if (n == 41) {
            n10 = m0(220, getSecretNumber(scramble));
        }
        else if (n == 42) {
            n10 = m0(43, getSecretNumber(scramble));
        }
        else if (n == 43) {
            n10 = m0(113, getSecretNumber(scramble));
        }
        else if (n == 44) {
            n10 = m0(148, getSecretNumber(scramble));
        }
        else if (n == 45) {
            n10 = m0(247, getSecretNumber(scramble));
        }
        else if (n == 46) {
            n10 = m0(217, getSecretNumber(scramble));
        }
        else if (n == 47) {
            n10 = m0(185, getSecretNumber(scramble));
        }
        else if (n == 48) {
            n10 = m0(41, getSecretNumber(scramble));
        }
        else if (n == 49) {
            n10 = m0(177, getSecretNumber(scramble));
        }
        else if (n == 50) {
            n10 = m0(239, getSecretNumber(scramble));
        }
        else if (n == 51) {
            n10 = m0(12, getSecretNumber(scramble));
        }
        else if (n == 52) {
            n10 = m0(232, getSecretNumber(scramble));
        }
        else if (n == 53) {
            n10 = m0(101, getSecretNumber(scramble));
        }
        else if (n == 54) {
            n10 = m0(82, getSecretNumber(scramble));
        }
        else if (n == 55) {
            n10 = m0(178, getSecretNumber(scramble));
        }
        else if (n == 56) {
            n10 = m0(128, getSecretNumber(scramble));
        }
        else if (n == 57) {
            n10 = m0(191, getSecretNumber(scramble));
        }
        else if (n == 58) {
            n10 = m0(42, getSecretNumber(scramble));
        }
        else if (n == 59) {
            n10 = m0(172, getSecretNumber(scramble));
        }
        else if (n == 60) {
            n10 = m0(136, getSecretNumber(scramble));
        }
        else if (n == 61) {
            n10 = m0(81, getSecretNumber(scramble));
        }
        else if (n == 62) {
            n10 = m0(115, getSecretNumber(scramble));
        }
        else if (n == 63) {
            n10 = m0(251, getSecretNumber(scramble));
        }
        else if (n == 64) {
            n10 = m0(69, getSecretNumber(scramble));
        }
        else if (n == 65) {
            n10 = m0(89, getSecretNumber(scramble));
        }
        else if (n == 66) {
            n10 = m0(139, getSecretNumber(scramble));
        }
        else if (n == 67) {
            n10 = m0(48, getSecretNumber(scramble));
        }
        else if (n == 68) {
            n10 = m0(129, getSecretNumber(scramble));
        }
        else if (n == 69) {
            n10 = m0(63, getSecretNumber(scramble));
        }
        else if (n == 70) {
            n10 = m0(154, getSecretNumber(scramble));
        }
        else if (n == 71) {
            n10 = m0(125, getSecretNumber(scramble));
        }
        else if (n == 72) {
            n10 = m0(242, getSecretNumber(scramble));
        }
        else if (n == 73) {
            n10 = m0(95, getSecretNumber(scramble));
        }
        else if (n == 74) {
            n10 = m0(132, getSecretNumber(scramble));
        }
        else if (n == 75) {
            n10 = m0(143, getSecretNumber(scramble));
        }
        else if (n == 76) {
            n10 = m0(102, getSecretNumber(scramble));
        }
        else if (n == 77) {
            n10 = m0(29, getSecretNumber(scramble));
        }
        else if (n == 78) {
            n10 = m0(199, getSecretNumber(scramble));
        }
        else if (n == 79) {
            n10 = m0(10, getSecretNumber(scramble));
        }
        else if (n == 80) {
            n10 = m0(146, getSecretNumber(scramble));
        }
        else if (n == 81) {
            n10 = m0(79, getSecretNumber(scramble));
        }
        else if (n == 82) {
            n10 = m0(225, getSecretNumber(scramble));
        }
        else if (n == 83) {
            n10 = m0(149, getSecretNumber(scramble));
        }
        else if (n == 84) {
            n10 = m0(236, getSecretNumber(scramble));
        }
        else if (n == 85) {
            n10 = m0(245, getSecretNumber(scramble));
        }
        else if (n == 86) {
            n10 = m0(56, getSecretNumber(scramble));
        }
        else if (n == 87) {
            n10 = m0(105, getSecretNumber(scramble));
        }
        else if (n == 88) {
            n10 = m0(27, getSecretNumber(scramble));
        }
        else if (n == 89) {
            n10 = m0(235, getSecretNumber(scramble));
        }
        else if (n == 90) {
            n10 = m0(162, getSecretNumber(scramble));
        }
        else if (n == 91) {
            n10 = m0(201, getSecretNumber(scramble));
        }
        else if (n == 92) {
            n10 = m0(193, getSecretNumber(scramble));
        }
        else if (n == 93) {
            n10 = m0(208, getSecretNumber(scramble));
        }
        else if (n == 94) {
            n10 = m0(104, getSecretNumber(scramble));
        }
        else if (n == 95) {
            n10 = m0(96, getSecretNumber(scramble));
        }
        else if (n == 96) {
            n10 = m0(209, getSecretNumber(scramble));
        }
        else if (n == 97) {
            n10 = m0(155, getSecretNumber(scramble));
        }
        else if (n == 98) {
            n10 = m0(34, getSecretNumber(scramble));
        }
        else if (n == 99) {
            n10 = m0(68, getSecretNumber(scramble));
        }
        else if (n == 100) {
            n10 = m0(202, getSecretNumber(scramble));
        }
        else if (n == 101) {
            n10 = m0(169, getSecretNumber(scramble));
        }
        else if (n == 102) {
            n10 = m0(49, getSecretNumber(scramble));
        }
        else if (n == 103) {
            n10 = m0(13, getSecretNumber(scramble));
        }
        else if (n == 104) {
            n10 = m0(134, getSecretNumber(scramble));
        }
        else if (n == 105) {
            n10 = m0(45, getSecretNumber(scramble));
        }
        else if (n == 106) {
            n10 = m0(226, getSecretNumber(scramble));
        }
        else if (n == 107) {
            n10 = m0(255, getSecretNumber(scramble));
        }
        else if (n == 108) {
            n10 = m0(14, getSecretNumber(scramble));
        }
        else if (n == 109) {
            n10 = m0(52, getSecretNumber(scramble));
        }
        else if (n == 110) {
            n10 = m0(33, getSecretNumber(scramble));
        }
        else if (n == 111) {
            n10 = m0(62, getSecretNumber(scramble));
        }
        else if (n == 112) {
            n10 = m0(44, getSecretNumber(scramble));
        }
        else if (n == 113) {
            n10 = m0(186, getSecretNumber(scramble));
        }
        else if (n == 114) {
            n10 = m0(6, getSecretNumber(scramble));
        }
        else if (n == 115) {
            n10 = m0(121, getSecretNumber(scramble));
        }
        else if (n == 116) {
            n10 = m0(21, getSecretNumber(scramble));
        }
        else if (n == 117) {
            n10 = m0(244, getSecretNumber(scramble));
        }
        else if (n == 118) {
            n10 = m0(131, getSecretNumber(scramble));
        }
        else if (n == 119) {
            n10 = m0(64, getSecretNumber(scramble));
        }
        else if (n == 120) {
            n10 = m0(111, getSecretNumber(scramble));
        }
        else if (n == 121) {
            n10 = m0(123, getSecretNumber(scramble));
        }
        else if (n == 122) {
            n10 = m0(248, getSecretNumber(scramble));
        }
        else if (n == 123) {
            n10 = m0(124, getSecretNumber(scramble));
        }
        else if (n == 124) {
            n10 = m0(36, getSecretNumber(scramble));
        }
        else if (n == 125) {
            n10 = m0(9, getSecretNumber(scramble));
        }
        else if (n == 126) {
            n10 = m0(58, getSecretNumber(scramble));
        }
        else if (n == 127) {
            n10 = m0(112, getSecretNumber(scramble));
        }
        else if (n == 128) {
            n10 = m0(222, getSecretNumber(scramble));
        }
        else if (n == 129) {
            n10 = m0(130, getSecretNumber(scramble));
        }
        else if (n == 130) {
            n10 = m0(254, getSecretNumber(scramble));
        }
        else if (n == 131) {
            n10 = m0(120, getSecretNumber(scramble));
        }
        else if (n == 132) {
            n10 = m0(75, getSecretNumber(scramble));
        }
        else if (n == 133) {
            n10 = m0(224, getSecretNumber(scramble));
        }
        else if (n == 134) {
            n10 = m0(76, getSecretNumber(scramble));
        }
        else if (n == 135) {
            n10 = m0(145, getSecretNumber(scramble));
        }
        else if (n == 136) {
            n10 = m0(80, getSecretNumber(scramble));
        }
        else if (n == 137) {
            n10 = m0(231, getSecretNumber(scramble));
        }
        else if (n == 138) {
            n10 = m0(198, getSecretNumber(scramble));
        }
        else if (n == 139) {
            n10 = m0(219, getSecretNumber(scramble));
        }
        else if (n == 140) {
            n10 = m0(182, getSecretNumber(scramble));
        }
        else if (n == 141) {
            n10 = m0(24, getSecretNumber(scramble));
        }
        else if (n == 142) {
            n10 = m0(126, getSecretNumber(scramble));
        }
        else if (n == 143) {
            n10 = m0(40, getSecretNumber(scramble));
        }
        else if (n == 144) {
            n10 = m0(246, getSecretNumber(scramble));
        }
        else if (n == 145) {
            n10 = m0(192, getSecretNumber(scramble));
        }
        else if (n == 146) {
            n10 = m0(78, getSecretNumber(scramble));
        }
        else if (n == 147) {
            n10 = m0(166, getSecretNumber(scramble));
        }
        else if (n == 148) {
            n10 = m0(140, getSecretNumber(scramble));
        }
        else if (n == 149) {
            n10 = m0(158, getSecretNumber(scramble));
        }
        else if (n == 150) {
            n10 = m0(223, getSecretNumber(scramble));
        }
        else if (n == 151) {
            n10 = m0(57, getSecretNumber(scramble));
        }
        else if (n == 152) {
            n10 = m0(207, getSecretNumber(scramble));
        }
        else if (n == 153) {
            n10 = m0(90, getSecretNumber(scramble));
        }
        else if (n == 154) {
            n10 = m0(161, getSecretNumber(scramble));
        }
        else if (n == 155) {
            n10 = m0(54, getSecretNumber(scramble));
        }
        else if (n == 156) {
            n10 = m0(38, getSecretNumber(scramble));
        }
        else if (n == 157) {
            n10 = m0(252, getSecretNumber(scramble));
        }
        else if (n == 158) {
            n10 = m0(72, getSecretNumber(scramble));
        }
        else if (n == 159) {
            n10 = m0(203, getSecretNumber(scramble));
        }
        else if (n == 160) {
            n10 = m0(70, getSecretNumber(scramble));
        }
        else if (n == 161) {
            n10 = m0(85, getSecretNumber(scramble));
        }
        else if (n == 162) {
            n10 = m0(171, getSecretNumber(scramble));
        }
        else if (n == 163) {
            n10 = m0(107, getSecretNumber(scramble));
        }
        else if (n == 164) {
            n10 = m0(98, getSecretNumber(scramble));
        }
        else if (n == 165) {
            n10 = m0(4, getSecretNumber(scramble));
        }
        else if (n == 166) {
            n10 = m0(51, getSecretNumber(scramble));
        }
        else if (n == 167) {
            n10 = m0(188, getSecretNumber(scramble));
        }
        else if (n == 168) {
            n10 = m0(238, getSecretNumber(scramble));
        }
        else if (n == 169) {
            n10 = m0(15, getSecretNumber(scramble));
        }
        else if (n == 170) {
            n10 = m0(147, getSecretNumber(scramble));
        }
        else if (n == 171) {
            n10 = m0(237, getSecretNumber(scramble));
        }
        else if (n == 172) {
            n10 = m0(65, getSecretNumber(scramble));
        }
        else if (n == 173) {
            n10 = m0(214, getSecretNumber(scramble));
        }
        else if (n == 174) {
            n10 = m0(99, getSecretNumber(scramble));
        }
        else if (n == 175) {
            n10 = m0(183, getSecretNumber(scramble));
        }
        else if (n == 176) {
            n10 = m0(22, getSecretNumber(scramble));
        }
        else if (n == 177) {
            n10 = m0(5, getSecretNumber(scramble));
        }
        else if (n == 178) {
            n10 = m0(92, getSecretNumber(scramble));
        }
        else if (n == 179) {
            n10 = m0(141, getSecretNumber(scramble));
        }
        else if (n == 180) {
            n10 = m0(184, getSecretNumber(scramble));
        }
        else if (n == 181) {
            n10 = m0(30, getSecretNumber(scramble));
        }
        else if (n == 182) {
            n10 = m0(108, getSecretNumber(scramble));
        }
        else if (n == 183) {
            n10 = m0(60, getSecretNumber(scramble));
        }
        else if (n == 184) {
            n10 = m0(135, getSecretNumber(scramble));
        }
        else if (n == 185) {
            n10 = m0(118, getSecretNumber(scramble));
        }
        else if (n == 186) {
            n10 = m0(127, getSecretNumber(scramble));
        }
        else if (n == 187) {
            n10 = m0(205, getSecretNumber(scramble));
        }
        else if (n == 188) {
            n10 = m0(133, getSecretNumber(scramble));
        }
        else if (n == 189) {
            n10 = m0(159, getSecretNumber(scramble));
        }
        else if (n == 190) {
            n10 = m0(19, getSecretNumber(scramble));
        }
        else if (n == 191) {
            n10 = m0(197, getSecretNumber(scramble));
        }
        else if (n == 192) {
            n10 = m0(74, getSecretNumber(scramble));
        }
        else if (n == 193) {
            n10 = m0(17, getSecretNumber(scramble));
        }
        else if (n == 194) {
            n10 = m0(59, getSecretNumber(scramble));
        }
        else if (n == 195) {
            n10 = m0(138, getSecretNumber(scramble));
        }
        else if (n == 196) {
            n10 = m0(195, getSecretNumber(scramble));
        }
        else if (n == 197) {
            n10 = m0(119, getSecretNumber(scramble));
        }
        else if (n == 198) {
            n10 = m0(8, getSecretNumber(scramble));
        }
        else if (n == 199) {
            n10 = m0(25, getSecretNumber(scramble));
        }
        else if (n == 200) {
            n10 = m0(206, getSecretNumber(scramble));
        }
        else if (n == 201) {
            n10 = m0(55, getSecretNumber(scramble));
        }
        else if (n == 202) {
            n10 = m0(106, getSecretNumber(scramble));
        }
        else if (n == 203) {
            n10 = m0(91, getSecretNumber(scramble));
        }
        else if (n == 204) {
            n10 = m0(160, getSecretNumber(scramble));
        }
        else if (n == 205) {
            n10 = m0(122, getSecretNumber(scramble));
        }
        else if (n == 206) {
            n10 = m0(218, getSecretNumber(scramble));
        }
        else if (n == 207) {
            n10 = m0(37, getSecretNumber(scramble));
        }
        else if (n == 208) {
            n10 = m0(181, getSecretNumber(scramble));
        }
        else if (n == 209) {
            n10 = m0(211, getSecretNumber(scramble));
        }
        else if (n == 210) {
            n10 = m0(212, getSecretNumber(scramble));
        }
        else if (n == 211) {
            n10 = m0(234, getSecretNumber(scramble));
        }
        else if (n == 212) {
            n10 = m0(241, getSecretNumber(scramble));
        }
        else if (n == 213) {
            n10 = m0(46, getSecretNumber(scramble));
        }
        else if (n == 214) {
            n10 = m0(77, getSecretNumber(scramble));
        }
        else if (n == 215) {
            n10 = m0(170, getSecretNumber(scramble));
        }
        else if (n == 216) {
            n10 = m0(11, getSecretNumber(scramble));
        }
        else if (n == 217) {
            n10 = m0(109, getSecretNumber(scramble));
        }
        else if (n == 218) {
            n10 = m0(16, getSecretNumber(scramble));
        }
        else if (n == 219) {
            n10 = m0(249, getSecretNumber(scramble));
        }
        else if (n == 220) {
            n10 = m0(168, getSecretNumber(scramble));
        }
        else if (n == 221) {
            n10 = m0(230, getSecretNumber(scramble));
        }
        else if (n == 222) {
            n10 = m0(215, getSecretNumber(scramble));
        }
        else if (n == 223) {
            n10 = m0(174, getSecretNumber(scramble));
        }
        else if (n == 224) {
            n10 = m0(204, getSecretNumber(scramble));
        }
        else if (n == 225) {
            n10 = m0(164, getSecretNumber(scramble));
        }
        else if (n == 226) {
            n10 = m0(2, getSecretNumber(scramble));
        }
        else if (n == 227) {
            n10 = m0(253, getSecretNumber(scramble));
        }
        else if (n == 228) {
            n10 = m0(94, getSecretNumber(scramble));
        }
        else if (n == 229) {
            n10 = m0(31, getSecretNumber(scramble));
        }
        else if (n == 230) {
            n10 = m0(189, getSecretNumber(scramble));
        }
        else if (n == 231) {
            n10 = m0(35, getSecretNumber(scramble));
        }
        else if (n == 232) {
            n10 = m0(153, getSecretNumber(scramble));
        }
        else if (n == 233) {
            n10 = m0(180, getSecretNumber(scramble));
        }
        else if (n == 234) {
            n10 = m0(103, getSecretNumber(scramble));
        }
        else if (n == 235) {
            n10 = m0(142, getSecretNumber(scramble));
        }
        else if (n == 236) {
            n10 = m0(1, getSecretNumber(scramble));
        }
        else if (n == 237) {
            n10 = m0(137, getSecretNumber(scramble));
        }
        else if (n == 238) {
            n10 = m0(187, getSecretNumber(scramble));
        }
        else if (n == 239) {
            n10 = m0(84, getSecretNumber(scramble));
        }
        else if (n == 240) {
            n10 = m0(165, getSecretNumber(scramble));
        }
        else if (n == 241) {
            n10 = m0(26, getSecretNumber(scramble));
        }
        else if (n == 242) {
            n10 = m0(87, getSecretNumber(scramble));
        }
        else if (n == 243) {
            n10 = m0(93, getSecretNumber(scramble));
        }
        else if (n == 244) {
            n10 = m0(83, getSecretNumber(scramble));
        }
        else if (n == 245) {
            n10 = m0(86, getSecretNumber(scramble));
        }
        else if (n == 246) {
            n10 = m0(0, getSecretNumber(scramble));
        }
        else if (n == 247) {
            n10 = m0(151, getSecretNumber(scramble));
        }
        else if (n == 248) {
            n10 = m0(3, getSecretNumber(scramble));
        }
        else if (n == 249) {
            n10 = m0(167, getSecretNumber(scramble));
        }
        else if (n == 250) {
            n10 = m0(53, getSecretNumber(scramble));
        }
        else if (n == 251) {
            n10 = m0(176, getSecretNumber(scramble));
        }
        else if (n == 252) {
            n10 = m0(227, getSecretNumber(scramble));
        }
        else if (n == 253) {
            n10 = m0(163, getSecretNumber(scramble));
        }
        else if (n == 254) {
            n10 = m0(229, getSecretNumber(scramble));
        }
        else if (n == 255) {
            n10 = m0(61, getSecretNumber(scramble));
        }
        else {
            n10 = 0;
        }
        if ((n10 & 0xFF) != 0xAC) {
            return false;
        }
        final int scramble2 = scramble(scramble);
        int n11;
        if (n2 == 0) {
            n11 = m1(29, getSecretNumber(scramble2));
        }
        else if (n2 == 1) {
            n11 = m1(131, getSecretNumber(scramble2));
        }
        else if (n2 == 2) {
            n11 = m1(174, getSecretNumber(scramble2));
        }
        else if (n2 == 3) {
            n11 = m1(82, getSecretNumber(scramble2));
        }
        else if (n2 == 4) {
            n11 = m1(200, getSecretNumber(scramble2));
        }
        else if (n2 == 5) {
            n11 = m1(183, getSecretNumber(scramble2));
        }
        else if (n2 == 6) {
            n11 = m1(179, getSecretNumber(scramble2));
        }
        else if (n2 == 7) {
            n11 = m1(143, getSecretNumber(scramble2));
        }
        else if (n2 == 8) {
            n11 = m1(182, getSecretNumber(scramble2));
        }
        else if (n2 == 9) {
            n11 = m1(216, getSecretNumber(scramble2));
        }
        else if (n2 == 10) {
            n11 = m1(9, getSecretNumber(scramble2));
        }
        else if (n2 == 11) {
            n11 = m1(79, getSecretNumber(scramble2));
        }
        else if (n2 == 12) {
            n11 = m1(44, getSecretNumber(scramble2));
        }
        else if (n2 == 13) {
            n11 = m1(203, getSecretNumber(scramble2));
        }
        else if (n2 == 14) {
            n11 = m1(167, getSecretNumber(scramble2));
        }
        else if (n2 == 15) {
            n11 = m1(6, getSecretNumber(scramble2));
        }
        else if (n2 == 16) {
            n11 = m1(135, getSecretNumber(scramble2));
        }
        else if (n2 == 17) {
            n11 = m1(62, getSecretNumber(scramble2));
        }
        else if (n2 == 18) {
            n11 = m1(4, getSecretNumber(scramble2));
        }
        else if (n2 == 19) {
            n11 = m1(58, getSecretNumber(scramble2));
        }
        else if (n2 == 20) {
            n11 = m1(242, getSecretNumber(scramble2));
        }
        else if (n2 == 21) {
            n11 = m1(84, getSecretNumber(scramble2));
        }
        else if (n2 == 22) {
            n11 = m1(72, getSecretNumber(scramble2));
        }
        else if (n2 == 23) {
            n11 = m1(175, getSecretNumber(scramble2));
        }
        else if (n2 == 24) {
            n11 = m1(171, getSecretNumber(scramble2));
        }
        else if (n2 == 25) {
            n11 = m1(126, getSecretNumber(scramble2));
        }
        else if (n2 == 26) {
            n11 = m1(140, getSecretNumber(scramble2));
        }
        else if (n2 == 27) {
            n11 = m1(188, getSecretNumber(scramble2));
        }
        else if (n2 == 28) {
            n11 = m1(18, getSecretNumber(scramble2));
        }
        else if (n2 == 29) {
            n11 = m1(250, getSecretNumber(scramble2));
        }
        else if (n2 == 30) {
            n11 = m1(114, getSecretNumber(scramble2));
        }
        else if (n2 == 31) {
            n11 = m1(205, getSecretNumber(scramble2));
        }
        else if (n2 == 32) {
            n11 = m1(137, getSecretNumber(scramble2));
        }
        else if (n2 == 33) {
            n11 = m1(142, getSecretNumber(scramble2));
        }
        else if (n2 == 34) {
            n11 = m1(16, getSecretNumber(scramble2));
        }
        else if (n2 == 35) {
            n11 = m1(163, getSecretNumber(scramble2));
        }
        else if (n2 == 36) {
            n11 = m1(159, getSecretNumber(scramble2));
        }
        else if (n2 == 37) {
            n11 = m1(24, getSecretNumber(scramble2));
        }
        else if (n2 == 38) {
            n11 = m1(105, getSecretNumber(scramble2));
        }
        else if (n2 == 39) {
            n11 = m1(154, getSecretNumber(scramble2));
        }
        else if (n2 == 40) {
            n11 = m1(186, getSecretNumber(scramble2));
        }
        else if (n2 == 41) {
            n11 = m1(209, getSecretNumber(scramble2));
        }
        else if (n2 == 42) {
            n11 = m1(169, getSecretNumber(scramble2));
        }
        else if (n2 == 43) {
            n11 = m1(116, getSecretNumber(scramble2));
        }
        else if (n2 == 44) {
            n11 = m1(138, getSecretNumber(scramble2));
        }
        else if (n2 == 45) {
            n11 = m1(206, getSecretNumber(scramble2));
        }
        else if (n2 == 46) {
            n11 = m1(57, getSecretNumber(scramble2));
        }
        else if (n2 == 47) {
            n11 = m1(219, getSecretNumber(scramble2));
        }
        else if (n2 == 48) {
            n11 = m1(132, getSecretNumber(scramble2));
        }
        else if (n2 == 49) {
            n11 = m1(234, getSecretNumber(scramble2));
        }
        else if (n2 == 50) {
            n11 = m1(129, getSecretNumber(scramble2));
        }
        else if (n2 == 51) {
            n11 = m1(127, getSecretNumber(scramble2));
        }
        else if (n2 == 52) {
            n11 = m1(247, getSecretNumber(scramble2));
        }
        else if (n2 == 53) {
            n11 = m1(28, getSecretNumber(scramble2));
        }
        else if (n2 == 54) {
            n11 = m1(49, getSecretNumber(scramble2));
        }
        else if (n2 == 55) {
            n11 = m1(178, getSecretNumber(scramble2));
        }
        else if (n2 == 56) {
            n11 = m1(5, getSecretNumber(scramble2));
        }
        else if (n2 == 57) {
            n11 = m1(37, getSecretNumber(scramble2));
        }
        else if (n2 == 58) {
            n11 = m1(93, getSecretNumber(scramble2));
        }
        else if (n2 == 59) {
            n11 = m1(148, getSecretNumber(scramble2));
        }
        else if (n2 == 60) {
            n11 = m1(25, getSecretNumber(scramble2));
        }
        else if (n2 == 61) {
            n11 = m1(238, getSecretNumber(scramble2));
        }
        else if (n2 == 62) {
            n11 = m1(118, getSecretNumber(scramble2));
        }
        else if (n2 == 63) {
            n11 = m1(50, getSecretNumber(scramble2));
        }
        else if (n2 == 64) {
            n11 = m1(166, getSecretNumber(scramble2));
        }
        else if (n2 == 65) {
            n11 = m1(102, getSecretNumber(scramble2));
        }
        else if (n2 == 66) {
            n11 = m1(146, getSecretNumber(scramble2));
        }
        else if (n2 == 67) {
            n11 = m1(231, getSecretNumber(scramble2));
        }
        else if (n2 == 68) {
            n11 = m1(81, getSecretNumber(scramble2));
        }
        else if (n2 == 69) {
            n11 = m1(86, getSecretNumber(scramble2));
        }
        else if (n2 == 70) {
            n11 = m1(201, getSecretNumber(scramble2));
        }
        else if (n2 == 71) {
            n11 = m1(33, getSecretNumber(scramble2));
        }
        else if (n2 == 72) {
            n11 = m1(197, getSecretNumber(scramble2));
        }
        else if (n2 == 73) {
            n11 = m1(181, getSecretNumber(scramble2));
        }
        else if (n2 == 74) {
            n11 = m1(155, getSecretNumber(scramble2));
        }
        else if (n2 == 75) {
            n11 = m1(133, getSecretNumber(scramble2));
        }
        else if (n2 == 76) {
            n11 = m1(85, getSecretNumber(scramble2));
        }
        else if (n2 == 77) {
            n11 = m1(224, getSecretNumber(scramble2));
        }
        else if (n2 == 78) {
            n11 = m1(176, getSecretNumber(scramble2));
        }
        else if (n2 == 79) {
            n11 = m1(208, getSecretNumber(scramble2));
        }
        else if (n2 == 80) {
            n11 = m1(170, getSecretNumber(scramble2));
        }
        else if (n2 == 81) {
            n11 = m1(99, getSecretNumber(scramble2));
        }
        else if (n2 == 82) {
            n11 = m1(40, getSecretNumber(scramble2));
        }
        else if (n2 == 83) {
            n11 = m1(38, getSecretNumber(scramble2));
        }
        else if (n2 == 84) {
            n11 = m1(204, getSecretNumber(scramble2));
        }
        else if (n2 == 85) {
            n11 = m1(194, getSecretNumber(scramble2));
        }
        else if (n2 == 86) {
            n11 = m1(74, getSecretNumber(scramble2));
        }
        else if (n2 == 87) {
            n11 = m1(222, getSecretNumber(scramble2));
        }
        else if (n2 == 88) {
            n11 = m1(144, getSecretNumber(scramble2));
        }
        else if (n2 == 89) {
            n11 = m1(145, getSecretNumber(scramble2));
        }
        else if (n2 == 90) {
            n11 = m1(212, getSecretNumber(scramble2));
        }
        else if (n2 == 91) {
            n11 = m1(161, getSecretNumber(scramble2));
        }
        else if (n2 == 92) {
            n11 = m1(141, getSecretNumber(scramble2));
        }
        else if (n2 == 93) {
            n11 = m1(7, getSecretNumber(scramble2));
        }
        else if (n2 == 94) {
            n11 = m1(123, getSecretNumber(scramble2));
        }
        else if (n2 == 95) {
            n11 = m1(92, getSecretNumber(scramble2));
        }
        else if (n2 == 96) {
            n11 = m1(26, getSecretNumber(scramble2));
        }
        else if (n2 == 97) {
            n11 = m1(185, getSecretNumber(scramble2));
        }
        else if (n2 == 98) {
            n11 = m1(101, getSecretNumber(scramble2));
        }
        else if (n2 == 99) {
            n11 = m1(119, getSecretNumber(scramble2));
        }
        else if (n2 == 100) {
            n11 = m1(223, getSecretNumber(scramble2));
        }
        else if (n2 == 101) {
            n11 = m1(164, getSecretNumber(scramble2));
        }
        else if (n2 == 102) {
            n11 = m1(31, getSecretNumber(scramble2));
        }
        else if (n2 == 103) {
            n11 = m1(172, getSecretNumber(scramble2));
        }
        else if (n2 == 104) {
            n11 = m1(249, getSecretNumber(scramble2));
        }
        else if (n2 == 105) {
            n11 = m1(43, getSecretNumber(scramble2));
        }
        else if (n2 == 106) {
            n11 = m1(88, getSecretNumber(scramble2));
        }
        else if (n2 == 107) {
            n11 = m1(8, getSecretNumber(scramble2));
        }
        else if (n2 == 108) {
            n11 = m1(19, getSecretNumber(scramble2));
        }
        else if (n2 == 109) {
            n11 = m1(61, getSecretNumber(scramble2));
        }
        else if (n2 == 110) {
            n11 = m1(241, getSecretNumber(scramble2));
        }
        else if (n2 == 111) {
            n11 = m1(76, getSecretNumber(scramble2));
        }
        else if (n2 == 112) {
            n11 = m1(157, getSecretNumber(scramble2));
        }
        else if (n2 == 113) {
            n11 = m1(47, getSecretNumber(scramble2));
        }
        else if (n2 == 114) {
            n11 = m1(111, getSecretNumber(scramble2));
        }
        else if (n2 == 115) {
            n11 = m1(130, getSecretNumber(scramble2));
        }
        else if (n2 == 116) {
            n11 = m1(60, getSecretNumber(scramble2));
        }
        else if (n2 == 117) {
            n11 = m1(120, getSecretNumber(scramble2));
        }
        else if (n2 == 118) {
            n11 = m1(252, getSecretNumber(scramble2));
        }
        else if (n2 == 119) {
            n11 = m1(90, getSecretNumber(scramble2));
        }
        else if (n2 == 120) {
            n11 = m1(117, getSecretNumber(scramble2));
        }
        else if (n2 == 121) {
            n11 = m1(207, getSecretNumber(scramble2));
        }
        else if (n2 == 122) {
            n11 = m1(192, getSecretNumber(scramble2));
        }
        else if (n2 == 123) {
            n11 = m1(189, getSecretNumber(scramble2));
        }
        else if (n2 == 124) {
            n11 = m1(158, getSecretNumber(scramble2));
        }
        else if (n2 == 125) {
            n11 = m1(23, getSecretNumber(scramble2));
        }
        else if (n2 == 126) {
            n11 = m1(253, getSecretNumber(scramble2));
        }
        else if (n2 == 127) {
            n11 = m1(199, getSecretNumber(scramble2));
        }
        else if (n2 == 128) {
            n11 = m1(80, getSecretNumber(scramble2));
        }
        else if (n2 == 129) {
            n11 = m1(106, getSecretNumber(scramble2));
        }
        else if (n2 == 130) {
            n11 = m1(41, getSecretNumber(scramble2));
        }
        else if (n2 == 131) {
            n11 = m1(160, getSecretNumber(scramble2));
        }
        else if (n2 == 132) {
            n11 = m1(221, getSecretNumber(scramble2));
        }
        else if (n2 == 133) {
            n11 = m1(233, getSecretNumber(scramble2));
        }
        else if (n2 == 134) {
            n11 = m1(71, getSecretNumber(scramble2));
        }
        else if (n2 == 135) {
            n11 = m1(0, getSecretNumber(scramble2));
        }
        else if (n2 == 136) {
            n11 = m1(36, getSecretNumber(scramble2));
        }
        else if (n2 == 137) {
            n11 = m1(32, getSecretNumber(scramble2));
        }
        else if (n2 == 138) {
            n11 = m1(230, getSecretNumber(scramble2));
        }
        else if (n2 == 139) {
            n11 = m1(246, getSecretNumber(scramble2));
        }
        else if (n2 == 140) {
            n11 = m1(52, getSecretNumber(scramble2));
        }
        else if (n2 == 141) {
            n11 = m1(248, getSecretNumber(scramble2));
        }
        else if (n2 == 142) {
            n11 = m1(147, getSecretNumber(scramble2));
        }
        else if (n2 == 143) {
            n11 = m1(150, getSecretNumber(scramble2));
        }
        else if (n2 == 144) {
            n11 = m1(95, getSecretNumber(scramble2));
        }
        else if (n2 == 145) {
            n11 = m1(87, getSecretNumber(scramble2));
        }
        else if (n2 == 146) {
            n11 = m1(104, getSecretNumber(scramble2));
        }
        else if (n2 == 147) {
            n11 = m1(34, getSecretNumber(scramble2));
        }
        else if (n2 == 148) {
            n11 = m1(232, getSecretNumber(scramble2));
        }
        else if (n2 == 149) {
            n11 = m1(229, getSecretNumber(scramble2));
        }
        else if (n2 == 150) {
            n11 = m1(202, getSecretNumber(scramble2));
        }
        else if (n2 == 151) {
            n11 = m1(63, getSecretNumber(scramble2));
        }
        else if (n2 == 152) {
            n11 = m1(66, getSecretNumber(scramble2));
        }
        else if (n2 == 153) {
            n11 = m1(39, getSecretNumber(scramble2));
        }
        else if (n2 == 154) {
            n11 = m1(168, getSecretNumber(scramble2));
        }
        else if (n2 == 155) {
            n11 = m1(108, getSecretNumber(scramble2));
        }
        else if (n2 == 156) {
            n11 = m1(139, getSecretNumber(scramble2));
        }
        else if (n2 == 157) {
            n11 = m1(22, getSecretNumber(scramble2));
        }
        else if (n2 == 158) {
            n11 = m1(244, getSecretNumber(scramble2));
        }
        else if (n2 == 159) {
            n11 = m1(75, getSecretNumber(scramble2));
        }
        else if (n2 == 160) {
            n11 = m1(190, getSecretNumber(scramble2));
        }
        else if (n2 == 161) {
            n11 = m1(98, getSecretNumber(scramble2));
        }
        else if (n2 == 162) {
            n11 = m1(124, getSecretNumber(scramble2));
        }
        else if (n2 == 163) {
            n11 = m1(237, getSecretNumber(scramble2));
        }
        else if (n2 == 164) {
            n11 = m1(77, getSecretNumber(scramble2));
        }
        else if (n2 == 165) {
            n11 = m1(193, getSecretNumber(scramble2));
        }
        else if (n2 == 166) {
            n11 = m1(149, getSecretNumber(scramble2));
        }
        else if (n2 == 167) {
            n11 = m1(11, getSecretNumber(scramble2));
        }
        else if (n2 == 168) {
            n11 = m1(100, getSecretNumber(scramble2));
        }
        else if (n2 == 169) {
            n11 = m1(240, getSecretNumber(scramble2));
        }
        else if (n2 == 170) {
            n11 = m1(227, getSecretNumber(scramble2));
        }
        else if (n2 == 171) {
            n11 = m1(42, getSecretNumber(scramble2));
        }
        else if (n2 == 172) {
            n11 = m1(121, getSecretNumber(scramble2));
        }
        else if (n2 == 173) {
            n11 = m1(162, getSecretNumber(scramble2));
        }
        else if (n2 == 174) {
            n11 = m1(55, getSecretNumber(scramble2));
        }
        else if (n2 == 175) {
            n11 = m1(215, getSecretNumber(scramble2));
        }
        else if (n2 == 176) {
            n11 = m1(165, getSecretNumber(scramble2));
        }
        else if (n2 == 177) {
            n11 = m1(48, getSecretNumber(scramble2));
        }
        else if (n2 == 178) {
            n11 = m1(67, getSecretNumber(scramble2));
        }
        else if (n2 == 179) {
            n11 = m1(211, getSecretNumber(scramble2));
        }
        else if (n2 == 180) {
            n11 = m1(35, getSecretNumber(scramble2));
        }
        else if (n2 == 181) {
            n11 = m1(56, getSecretNumber(scramble2));
        }
        else if (n2 == 182) {
            n11 = m1(70, getSecretNumber(scramble2));
        }
        else if (n2 == 183) {
            n11 = m1(54, getSecretNumber(scramble2));
        }
        else if (n2 == 184) {
            n11 = m1(78, getSecretNumber(scramble2));
        }
        else if (n2 == 185) {
            n11 = m1(14, getSecretNumber(scramble2));
        }
        else if (n2 == 186) {
            n11 = m1(45, getSecretNumber(scramble2));
        }
        else if (n2 == 187) {
            n11 = m1(187, getSecretNumber(scramble2));
        }
        else if (n2 == 188) {
            n11 = m1(89, getSecretNumber(scramble2));
        }
        else if (n2 == 189) {
            n11 = m1(184, getSecretNumber(scramble2));
        }
        else if (n2 == 190) {
            n11 = m1(213, getSecretNumber(scramble2));
        }
        else if (n2 == 191) {
            n11 = m1(255, getSecretNumber(scramble2));
        }
        else if (n2 == 192) {
            n11 = m1(27, getSecretNumber(scramble2));
        }
        else if (n2 == 193) {
            n11 = m1(96, getSecretNumber(scramble2));
        }
        else if (n2 == 194) {
            n11 = m1(1, getSecretNumber(scramble2));
        }
        else if (n2 == 195) {
            n11 = m1(69, getSecretNumber(scramble2));
        }
        else if (n2 == 196) {
            n11 = m1(122, getSecretNumber(scramble2));
        }
        else if (n2 == 197) {
            n11 = m1(125, getSecretNumber(scramble2));
        }
        else if (n2 == 198) {
            n11 = m1(110, getSecretNumber(scramble2));
        }
        else if (n2 == 199) {
            n11 = m1(217, getSecretNumber(scramble2));
        }
        else if (n2 == 200) {
            n11 = m1(228, getSecretNumber(scramble2));
        }
        else if (n2 == 201) {
            n11 = m1(91, getSecretNumber(scramble2));
        }
        else if (n2 == 202) {
            n11 = m1(156, getSecretNumber(scramble2));
        }
        else if (n2 == 203) {
            n11 = m1(113, getSecretNumber(scramble2));
        }
        else if (n2 == 204) {
            n11 = m1(243, getSecretNumber(scramble2));
        }
        else if (n2 == 205) {
            n11 = m1(65, getSecretNumber(scramble2));
        }
        else if (n2 == 206) {
            n11 = m1(196, getSecretNumber(scramble2));
        }
        else if (n2 == 207) {
            n11 = m1(64, getSecretNumber(scramble2));
        }
        else if (n2 == 208) {
            n11 = m1(3, getSecretNumber(scramble2));
        }
        else if (n2 == 209) {
            n11 = m1(128, getSecretNumber(scramble2));
        }
        else if (n2 == 210) {
            n11 = m1(109, getSecretNumber(scramble2));
        }
        else if (n2 == 211) {
            n11 = m1(12, getSecretNumber(scramble2));
        }
        else if (n2 == 212) {
            n11 = m1(153, getSecretNumber(scramble2));
        }
        else if (n2 == 213) {
            n11 = m1(173, getSecretNumber(scramble2));
        }
        else if (n2 == 214) {
            n11 = m1(53, getSecretNumber(scramble2));
        }
        else if (n2 == 215) {
            n11 = m1(94, getSecretNumber(scramble2));
        }
        else if (n2 == 216) {
            n11 = m1(68, getSecretNumber(scramble2));
        }
        else if (n2 == 217) {
            n11 = m1(97, getSecretNumber(scramble2));
        }
        else if (n2 == 218) {
            n11 = m1(152, getSecretNumber(scramble2));
        }
        else if (n2 == 219) {
            n11 = m1(151, getSecretNumber(scramble2));
        }
        else if (n2 == 220) {
            n11 = m1(2, getSecretNumber(scramble2));
        }
        else if (n2 == 221) {
            n11 = m1(73, getSecretNumber(scramble2));
        }
        else if (n2 == 222) {
            n11 = m1(107, getSecretNumber(scramble2));
        }
        else if (n2 == 223) {
            n11 = m1(236, getSecretNumber(scramble2));
        }
        else if (n2 == 224) {
            n11 = m1(17, getSecretNumber(scramble2));
        }
        else if (n2 == 225) {
            n11 = m1(46, getSecretNumber(scramble2));
        }
        else if (n2 == 226) {
            n11 = m1(112, getSecretNumber(scramble2));
        }
        else if (n2 == 227) {
            n11 = m1(177, getSecretNumber(scramble2));
        }
        else if (n2 == 228) {
            n11 = m1(10, getSecretNumber(scramble2));
        }
        else if (n2 == 229) {
            n11 = m1(103, getSecretNumber(scramble2));
        }
        else if (n2 == 230) {
            n11 = m1(225, getSecretNumber(scramble2));
        }
        else if (n2 == 231) {
            n11 = m1(254, getSecretNumber(scramble2));
        }
        else if (n2 == 232) {
            n11 = m1(136, getSecretNumber(scramble2));
        }
        else if (n2 == 233) {
            n11 = m1(245, getSecretNumber(scramble2));
        }
        else if (n2 == 234) {
            n11 = m1(13, getSecretNumber(scramble2));
        }
        else if (n2 == 235) {
            n11 = m1(218, getSecretNumber(scramble2));
        }
        else if (n2 == 236) {
            n11 = m1(115, getSecretNumber(scramble2));
        }
        else if (n2 == 237) {
            n11 = m1(239, getSecretNumber(scramble2));
        }
        else if (n2 == 238) {
            n11 = m1(195, getSecretNumber(scramble2));
        }
        else if (n2 == 239) {
            n11 = m1(214, getSecretNumber(scramble2));
        }
        else if (n2 == 240) {
            n11 = m1(180, getSecretNumber(scramble2));
        }
        else if (n2 == 241) {
            n11 = m1(134, getSecretNumber(scramble2));
        }
        else if (n2 == 242) {
            n11 = m1(83, getSecretNumber(scramble2));
        }
        else if (n2 == 243) {
            n11 = m1(30, getSecretNumber(scramble2));
        }
        else if (n2 == 244) {
            n11 = m1(59, getSecretNumber(scramble2));
        }
        else if (n2 == 245) {
            n11 = m1(20, getSecretNumber(scramble2));
        }
        else if (n2 == 246) {
            n11 = m1(51, getSecretNumber(scramble2));
        }
        else if (n2 == 247) {
            n11 = m1(235, getSecretNumber(scramble2));
        }
        else if (n2 == 248) {
            n11 = m1(191, getSecretNumber(scramble2));
        }
        else if (n2 == 249) {
            n11 = m1(226, getSecretNumber(scramble2));
        }
        else if (n2 == 250) {
            n11 = m1(15, getSecretNumber(scramble2));
        }
        else if (n2 == 251) {
            n11 = m1(21, getSecretNumber(scramble2));
        }
        else if (n2 == 252) {
            n11 = m1(251, getSecretNumber(scramble2));
        }
        else if (n2 == 253) {
            n11 = m1(210, getSecretNumber(scramble2));
        }
        else if (n2 == 254) {
            n11 = m1(198, getSecretNumber(scramble2));
        }
        else if (n2 == 255) {
            n11 = m1(220, getSecretNumber(scramble2));
        }
        else {
            n11 = 0;
        }
        if ((n11 & 0xFF) != 0x6) {
            return false;
        }
        final int scramble3 = scramble(scramble2);
        int n12;
        if (n3 == 0) {
            n12 = m2(255, getSecretNumber(scramble3));
        }
        else if (n3 == 1) {
            n12 = m2(30, getSecretNumber(scramble3));
        }
        else if (n3 == 2) {
            n12 = m2(98, getSecretNumber(scramble3));
        }
        else if (n3 == 3) {
            n12 = m2(78, getSecretNumber(scramble3));
        }
        else if (n3 == 4) {
            n12 = m2(198, getSecretNumber(scramble3));
        }
        else if (n3 == 5) {
            n12 = m2(151, getSecretNumber(scramble3));
        }
        else if (n3 == 6) {
            n12 = m2(15, getSecretNumber(scramble3));
        }
        else if (n3 == 7) {
            n12 = m2(171, getSecretNumber(scramble3));
        }
        else if (n3 == 8) {
            n12 = m2(92, getSecretNumber(scramble3));
        }
        else if (n3 == 9) {
            n12 = m2(236, getSecretNumber(scramble3));
        }
        else if (n3 == 10) {
            n12 = m2(93, getSecretNumber(scramble3));
        }
        else if (n3 == 11) {
            n12 = m2(136, getSecretNumber(scramble3));
        }
        else if (n3 == 12) {
            n12 = m2(206, getSecretNumber(scramble3));
        }
        else if (n3 == 13) {
            n12 = m2(220, getSecretNumber(scramble3));
        }
        else if (n3 == 14) {
            n12 = m2(56, getSecretNumber(scramble3));
        }
        else if (n3 == 15) {
            n12 = m2(156, getSecretNumber(scramble3));
        }
        else if (n3 == 16) {
            n12 = m2(54, getSecretNumber(scramble3));
        }
        else if (n3 == 17) {
            n12 = m2(50, getSecretNumber(scramble3));
        }
        else if (n3 == 18) {
            n12 = m2(82, getSecretNumber(scramble3));
        }
        else if (n3 == 19) {
            n12 = m2(112, getSecretNumber(scramble3));
        }
        else if (n3 == 20) {
            n12 = m2(123, getSecretNumber(scramble3));
        }
        else if (n3 == 21) {
            n12 = m2(14, getSecretNumber(scramble3));
        }
        else if (n3 == 22) {
            n12 = m2(77, getSecretNumber(scramble3));
        }
        else if (n3 == 23) {
            n12 = m2(12, getSecretNumber(scramble3));
        }
        else if (n3 == 24) {
            n12 = m2(184, getSecretNumber(scramble3));
        }
        else if (n3 == 25) {
            n12 = m2(214, getSecretNumber(scramble3));
        }
        else if (n3 == 26) {
            n12 = m2(208, getSecretNumber(scramble3));
        }
        else if (n3 == 27) {
            n12 = m2(145, getSecretNumber(scramble3));
        }
        else if (n3 == 28) {
            n12 = m2(66, getSecretNumber(scramble3));
        }
        else if (n3 == 29) {
            n12 = m2(40, getSecretNumber(scramble3));
        }
        else if (n3 == 30) {
            n12 = m2(52, getSecretNumber(scramble3));
        }
        else if (n3 == 31) {
            n12 = m2(224, getSecretNumber(scramble3));
        }
        else if (n3 == 32) {
            n12 = m2(213, getSecretNumber(scramble3));
        }
        else if (n3 == 33) {
            n12 = m2(134, getSecretNumber(scramble3));
        }
        else if (n3 == 34) {
            n12 = m2(227, getSecretNumber(scramble3));
        }
        else if (n3 == 35) {
            n12 = m2(250, getSecretNumber(scramble3));
        }
        else if (n3 == 36) {
            n12 = m2(22, getSecretNumber(scramble3));
        }
        else if (n3 == 37) {
            n12 = m2(114, getSecretNumber(scramble3));
        }
        else if (n3 == 38) {
            n12 = m2(79, getSecretNumber(scramble3));
        }
        else if (n3 == 39) {
            n12 = m2(143, getSecretNumber(scramble3));
        }
        else if (n3 == 40) {
            n12 = m2(10, getSecretNumber(scramble3));
        }
        else if (n3 == 41) {
            n12 = m2(55, getSecretNumber(scramble3));
        }
        else if (n3 == 42) {
            n12 = m2(174, getSecretNumber(scramble3));
        }
        else if (n3 == 43) {
            n12 = m2(28, getSecretNumber(scramble3));
        }
        else if (n3 == 44) {
            n12 = m2(85, getSecretNumber(scramble3));
        }
        else if (n3 == 45) {
            n12 = m2(221, getSecretNumber(scramble3));
        }
        else if (n3 == 46) {
            n12 = m2(154, getSecretNumber(scramble3));
        }
        else if (n3 == 47) {
            n12 = m2(248, getSecretNumber(scramble3));
        }
        else if (n3 == 48) {
            n12 = m2(84, getSecretNumber(scramble3));
        }
        else if (n3 == 49) {
            n12 = m2(175, getSecretNumber(scramble3));
        }
        else if (n3 == 50) {
            n12 = m2(168, getSecretNumber(scramble3));
        }
        else if (n3 == 51) {
            n12 = m2(144, getSecretNumber(scramble3));
        }
        else if (n3 == 52) {
            n12 = m2(11, getSecretNumber(scramble3));
        }
        else if (n3 == 53) {
            n12 = m2(32, getSecretNumber(scramble3));
        }
        else if (n3 == 54) {
            n12 = m2(64, getSecretNumber(scramble3));
        }
        else if (n3 == 55) {
            n12 = m2(207, getSecretNumber(scramble3));
        }
        else if (n3 == 56) {
            n12 = m2(147, getSecretNumber(scramble3));
        }
        else if (n3 == 57) {
            n12 = m2(58, getSecretNumber(scramble3));
        }
        else if (n3 == 58) {
            n12 = m2(176, getSecretNumber(scramble3));
        }
        else if (n3 == 59) {
            n12 = m2(111, getSecretNumber(scramble3));
        }
        else if (n3 == 60) {
            n12 = m2(108, getSecretNumber(scramble3));
        }
        else if (n3 == 61) {
            n12 = m2(142, getSecretNumber(scramble3));
        }
        else if (n3 == 62) {
            n12 = m2(216, getSecretNumber(scramble3));
        }
        else if (n3 == 63) {
            n12 = m2(187, getSecretNumber(scramble3));
        }
        else if (n3 == 64) {
            n12 = m2(110, getSecretNumber(scramble3));
        }
        else if (n3 == 65) {
            n12 = m2(195, getSecretNumber(scramble3));
        }
        else if (n3 == 66) {
            n12 = m2(5, getSecretNumber(scramble3));
        }
        else if (n3 == 67) {
            n12 = m2(219, getSecretNumber(scramble3));
        }
        else if (n3 == 68) {
            n12 = m2(72, getSecretNumber(scramble3));
        }
        else if (n3 == 69) {
            n12 = m2(235, getSecretNumber(scramble3));
        }
        else if (n3 == 70) {
            n12 = m2(49, getSecretNumber(scramble3));
        }
        else if (n3 == 71) {
            n12 = m2(120, getSecretNumber(scramble3));
        }
        else if (n3 == 72) {
            n12 = m2(232, getSecretNumber(scramble3));
        }
        else if (n3 == 73) {
            n12 = m2(46, getSecretNumber(scramble3));
        }
        else if (n3 == 74) {
            n12 = m2(155, getSecretNumber(scramble3));
        }
        else if (n3 == 75) {
            n12 = m2(23, getSecretNumber(scramble3));
        }
        else if (n3 == 76) {
            n12 = m2(27, getSecretNumber(scramble3));
        }
        else if (n3 == 77) {
            n12 = m2(185, getSecretNumber(scramble3));
        }
        else if (n3 == 78) {
            n12 = m2(233, getSecretNumber(scramble3));
        }
        else if (n3 == 79) {
            n12 = m2(57, getSecretNumber(scramble3));
        }
        else if (n3 == 80) {
            n12 = m2(170, getSecretNumber(scramble3));
        }
        else if (n3 == 81) {
            n12 = m2(18, getSecretNumber(scramble3));
        }
        else if (n3 == 82) {
            n12 = m2(71, getSecretNumber(scramble3));
        }
        else if (n3 == 83) {
            n12 = m2(203, getSecretNumber(scramble3));
        }
        else if (n3 == 84) {
            n12 = m2(88, getSecretNumber(scramble3));
        }
        else if (n3 == 85) {
            n12 = m2(196, getSecretNumber(scramble3));
        }
        else if (n3 == 86) {
            n12 = m2(140, getSecretNumber(scramble3));
        }
        else if (n3 == 87) {
            n12 = m2(223, getSecretNumber(scramble3));
        }
        else if (n3 == 88) {
            n12 = m2(109, getSecretNumber(scramble3));
        }
        else if (n3 == 89) {
            n12 = m2(131, getSecretNumber(scramble3));
        }
        else if (n3 == 90) {
            n12 = m2(103, getSecretNumber(scramble3));
        }
        else if (n3 == 91) {
            n12 = m2(26, getSecretNumber(scramble3));
        }
        else if (n3 == 92) {
            n12 = m2(251, getSecretNumber(scramble3));
        }
        else if (n3 == 93) {
            n12 = m2(48, getSecretNumber(scramble3));
        }
        else if (n3 == 94) {
            n12 = m2(180, getSecretNumber(scramble3));
        }
        else if (n3 == 95) {
            n12 = m2(83, getSecretNumber(scramble3));
        }
        else if (n3 == 96) {
            n12 = m2(106, getSecretNumber(scramble3));
        }
        else if (n3 == 97) {
            n12 = m2(115, getSecretNumber(scramble3));
        }
        else if (n3 == 98) {
            n12 = m2(130, getSecretNumber(scramble3));
        }
        else if (n3 == 99) {
            n12 = m2(16, getSecretNumber(scramble3));
        }
        else if (n3 == 100) {
            n12 = m2(133, getSecretNumber(scramble3));
        }
        else if (n3 == 101) {
            n12 = m2(44, getSecretNumber(scramble3));
        }
        else if (n3 == 102) {
            n12 = m2(164, getSecretNumber(scramble3));
        }
        else if (n3 == 103) {
            n12 = m2(241, getSecretNumber(scramble3));
        }
        else if (n3 == 104) {
            n12 = m2(182, getSecretNumber(scramble3));
        }
        else if (n3 == 105) {
            n12 = m2(70, getSecretNumber(scramble3));
        }
        else if (n3 == 106) {
            n12 = m2(204, getSecretNumber(scramble3));
        }
        else if (n3 == 107) {
            n12 = m2(9, getSecretNumber(scramble3));
        }
        else if (n3 == 108) {
            n12 = m2(218, getSecretNumber(scramble3));
        }
        else if (n3 == 109) {
            n12 = m2(107, getSecretNumber(scramble3));
        }
        else if (n3 == 110) {
            n12 = m2(179, getSecretNumber(scramble3));
        }
        else if (n3 == 111) {
            n12 = m2(188, getSecretNumber(scramble3));
        }
        else if (n3 == 112) {
            n12 = m2(6, getSecretNumber(scramble3));
        }
        else if (n3 == 113) {
            n12 = m2(160, getSecretNumber(scramble3));
        }
        else if (n3 == 114) {
            n12 = m2(190, getSecretNumber(scramble3));
        }
        else if (n3 == 115) {
            n12 = m2(13, getSecretNumber(scramble3));
        }
        else if (n3 == 116) {
            n12 = m2(209, getSecretNumber(scramble3));
        }
        else if (n3 == 117) {
            n12 = m2(230, getSecretNumber(scramble3));
        }
        else if (n3 == 118) {
            n12 = m2(119, getSecretNumber(scramble3));
        }
        else if (n3 == 119) {
            n12 = m2(197, getSecretNumber(scramble3));
        }
        else if (n3 == 120) {
            n12 = m2(226, getSecretNumber(scramble3));
        }
        else if (n3 == 121) {
            n12 = m2(124, getSecretNumber(scramble3));
        }
        else if (n3 == 122) {
            n12 = m2(121, getSecretNumber(scramble3));
        }
        else if (n3 == 123) {
            n12 = m2(240, getSecretNumber(scramble3));
        }
        else if (n3 == 124) {
            n12 = m2(80, getSecretNumber(scramble3));
        }
        else if (n3 == 125) {
            n12 = m2(163, getSecretNumber(scramble3));
        }
        else if (n3 == 126) {
            n12 = m2(97, getSecretNumber(scramble3));
        }
        else if (n3 == 127) {
            n12 = m2(38, getSecretNumber(scramble3));
        }
        else if (n3 == 128) {
            n12 = m2(149, getSecretNumber(scramble3));
        }
        else if (n3 == 129) {
            n12 = m2(94, getSecretNumber(scramble3));
        }
        else if (n3 == 130) {
            n12 = m2(202, getSecretNumber(scramble3));
        }
        else if (n3 == 131) {
            n12 = m2(243, getSecretNumber(scramble3));
        }
        else if (n3 == 132) {
            n12 = m2(193, getSecretNumber(scramble3));
        }
        else if (n3 == 133) {
            n12 = m2(238, getSecretNumber(scramble3));
        }
        else if (n3 == 134) {
            n12 = m2(167, getSecretNumber(scramble3));
        }
        else if (n3 == 135) {
            n12 = m2(138, getSecretNumber(scramble3));
        }
        else if (n3 == 136) {
            n12 = m2(148, getSecretNumber(scramble3));
        }
        else if (n3 == 137) {
            n12 = m2(17, getSecretNumber(scramble3));
        }
        else if (n3 == 138) {
            n12 = m2(3, getSecretNumber(scramble3));
        }
        else if (n3 == 139) {
            n12 = m2(51, getSecretNumber(scramble3));
        }
        else if (n3 == 140) {
            n12 = m2(127, getSecretNumber(scramble3));
        }
        else if (n3 == 141) {
            n12 = m2(210, getSecretNumber(scramble3));
        }
        else if (n3 == 142) {
            n12 = m2(62, getSecretNumber(scramble3));
        }
        else if (n3 == 143) {
            n12 = m2(205, getSecretNumber(scramble3));
        }
        else if (n3 == 144) {
            n12 = m2(239, getSecretNumber(scramble3));
        }
        else if (n3 == 145) {
            n12 = m2(126, getSecretNumber(scramble3));
        }
        else if (n3 == 146) {
            n12 = m2(169, getSecretNumber(scramble3));
        }
        else if (n3 == 147) {
            n12 = m2(63, getSecretNumber(scramble3));
        }
        else if (n3 == 148) {
            n12 = m2(95, getSecretNumber(scramble3));
        }
        else if (n3 == 149) {
            n12 = m2(228, getSecretNumber(scramble3));
        }
        else if (n3 == 150) {
            n12 = m2(199, getSecretNumber(scramble3));
        }
        else if (n3 == 151) {
            n12 = m2(186, getSecretNumber(scramble3));
        }
        else if (n3 == 152) {
            n12 = m2(81, getSecretNumber(scramble3));
        }
        else if (n3 == 153) {
            n12 = m2(53, getSecretNumber(scramble3));
        }
        else if (n3 == 154) {
            n12 = m2(152, getSecretNumber(scramble3));
        }
        else if (n3 == 155) {
            n12 = m2(67, getSecretNumber(scramble3));
        }
        else if (n3 == 156) {
            n12 = m2(125, getSecretNumber(scramble3));
        }
        else if (n3 == 157) {
            n12 = m2(0, getSecretNumber(scramble3));
        }
        else if (n3 == 158) {
            n12 = m2(153, getSecretNumber(scramble3));
        }
        else if (n3 == 159) {
            n12 = m2(99, getSecretNumber(scramble3));
        }
        else if (n3 == 160) {
            n12 = m2(150, getSecretNumber(scramble3));
        }
        else if (n3 == 161) {
            n12 = m2(25, getSecretNumber(scramble3));
        }
        else if (n3 == 162) {
            n12 = m2(217, getSecretNumber(scramble3));
        }
        else if (n3 == 163) {
            n12 = m2(229, getSecretNumber(scramble3));
        }
        else if (n3 == 164) {
            n12 = m2(102, getSecretNumber(scramble3));
        }
        else if (n3 == 165) {
            n12 = m2(69, getSecretNumber(scramble3));
        }
        else if (n3 == 166) {
            n12 = m2(246, getSecretNumber(scramble3));
        }
        else if (n3 == 167) {
            n12 = m2(90, getSecretNumber(scramble3));
        }
        else if (n3 == 168) {
            n12 = m2(117, getSecretNumber(scramble3));
        }
        else if (n3 == 169) {
            n12 = m2(244, getSecretNumber(scramble3));
        }
        else if (n3 == 170) {
            n12 = m2(60, getSecretNumber(scramble3));
        }
        else if (n3 == 171) {
            n12 = m2(178, getSecretNumber(scramble3));
        }
        else if (n3 == 172) {
            n12 = m2(73, getSecretNumber(scramble3));
        }
        else if (n3 == 173) {
            n12 = m2(234, getSecretNumber(scramble3));
        }
        else if (n3 == 174) {
            n12 = m2(2, getSecretNumber(scramble3));
        }
        else if (n3 == 175) {
            n12 = m2(181, getSecretNumber(scramble3));
        }
        else if (n3 == 176) {
            n12 = m2(75, getSecretNumber(scramble3));
        }
        else if (n3 == 177) {
            n12 = m2(20, getSecretNumber(scramble3));
        }
        else if (n3 == 178) {
            n12 = m2(24, getSecretNumber(scramble3));
        }
        else if (n3 == 179) {
            n12 = m2(21, getSecretNumber(scramble3));
        }
        else if (n3 == 180) {
            n12 = m2(8, getSecretNumber(scramble3));
        }
        else if (n3 == 181) {
            n12 = m2(35, getSecretNumber(scramble3));
        }
        else if (n3 == 182) {
            n12 = m2(141, getSecretNumber(scramble3));
        }
        else if (n3 == 183) {
            n12 = m2(165, getSecretNumber(scramble3));
        }
        else if (n3 == 184) {
            n12 = m2(201, getSecretNumber(scramble3));
        }
        else if (n3 == 185) {
            n12 = m2(237, getSecretNumber(scramble3));
        }
        else if (n3 == 186) {
            n12 = m2(96, getSecretNumber(scramble3));
        }
        else if (n3 == 187) {
            n12 = m2(211, getSecretNumber(scramble3));
        }
        else if (n3 == 188) {
            n12 = m2(129, getSecretNumber(scramble3));
        }
        else if (n3 == 189) {
            n12 = m2(159, getSecretNumber(scramble3));
        }
        else if (n3 == 190) {
            n12 = m2(19, getSecretNumber(scramble3));
        }
        else if (n3 == 191) {
            n12 = m2(189, getSecretNumber(scramble3));
        }
        else if (n3 == 192) {
            n12 = m2(135, getSecretNumber(scramble3));
        }
        else if (n3 == 193) {
            n12 = m2(158, getSecretNumber(scramble3));
        }
        else if (n3 == 194) {
            n12 = m2(33, getSecretNumber(scramble3));
        }
        else if (n3 == 195) {
            n12 = m2(104, getSecretNumber(scramble3));
        }
        else if (n3 == 196) {
            n12 = m2(91, getSecretNumber(scramble3));
        }
        else if (n3 == 197) {
            n12 = m2(116, getSecretNumber(scramble3));
        }
        else if (n3 == 198) {
            n12 = m2(177, getSecretNumber(scramble3));
        }
        else if (n3 == 199) {
            n12 = m2(47, getSecretNumber(scramble3));
        }
        else if (n3 == 200) {
            n12 = m2(247, getSecretNumber(scramble3));
        }
        else if (n3 == 201) {
            n12 = m2(137, getSecretNumber(scramble3));
        }
        else if (n3 == 202) {
            n12 = m2(122, getSecretNumber(scramble3));
        }
        else if (n3 == 203) {
            n12 = m2(173, getSecretNumber(scramble3));
        }
        else if (n3 == 204) {
            n12 = m2(59, getSecretNumber(scramble3));
        }
        else if (n3 == 205) {
            n12 = m2(113, getSecretNumber(scramble3));
        }
        else if (n3 == 206) {
            n12 = m2(29, getSecretNumber(scramble3));
        }
        else if (n3 == 207) {
            n12 = m2(245, getSecretNumber(scramble3));
        }
        else if (n3 == 208) {
            n12 = m2(242, getSecretNumber(scramble3));
        }
        else if (n3 == 209) {
            n12 = m2(128, getSecretNumber(scramble3));
        }
        else if (n3 == 210) {
            n12 = m2(39, getSecretNumber(scramble3));
        }
        else if (n3 == 211) {
            n12 = m2(86, getSecretNumber(scramble3));
        }
        else if (n3 == 212) {
            n12 = m2(192, getSecretNumber(scramble3));
        }
        else if (n3 == 213) {
            n12 = m2(252, getSecretNumber(scramble3));
        }
        else if (n3 == 214) {
            n12 = m2(37, getSecretNumber(scramble3));
        }
        else if (n3 == 215) {
            n12 = m2(61, getSecretNumber(scramble3));
        }
        else if (n3 == 216) {
            n12 = m2(89, getSecretNumber(scramble3));
        }
        else if (n3 == 217) {
            n12 = m2(200, getSecretNumber(scramble3));
        }
        else if (n3 == 218) {
            n12 = m2(157, getSecretNumber(scramble3));
        }
        else if (n3 == 219) {
            n12 = m2(68, getSecretNumber(scramble3));
        }
        else if (n3 == 220) {
            n12 = m2(225, getSecretNumber(scramble3));
        }
        else if (n3 == 221) {
            n12 = m2(139, getSecretNumber(scramble3));
        }
        else if (n3 == 222) {
            n12 = m2(1, getSecretNumber(scramble3));
        }
        else if (n3 == 223) {
            n12 = m2(254, getSecretNumber(scramble3));
        }
        else if (n3 == 224) {
            n12 = m2(36, getSecretNumber(scramble3));
        }
        else if (n3 == 225) {
            n12 = m2(146, getSecretNumber(scramble3));
        }
        else if (n3 == 226) {
            n12 = m2(162, getSecretNumber(scramble3));
        }
        else if (n3 == 227) {
            n12 = m2(42, getSecretNumber(scramble3));
        }
        else if (n3 == 228) {
            n12 = m2(45, getSecretNumber(scramble3));
        }
        else if (n3 == 229) {
            n12 = m2(166, getSecretNumber(scramble3));
        }
        else if (n3 == 230) {
            n12 = m2(172, getSecretNumber(scramble3));
        }
        else if (n3 == 231) {
            n12 = m2(65, getSecretNumber(scramble3));
        }
        else if (n3 == 232) {
            n12 = m2(231, getSecretNumber(scramble3));
        }
        else if (n3 == 233) {
            n12 = m2(31, getSecretNumber(scramble3));
        }
        else if (n3 == 234) {
            n12 = m2(105, getSecretNumber(scramble3));
        }
        else if (n3 == 235) {
            n12 = m2(222, getSecretNumber(scramble3));
        }
        else if (n3 == 236) {
            n12 = m2(43, getSecretNumber(scramble3));
        }
        else if (n3 == 237) {
            n12 = m2(212, getSecretNumber(scramble3));
        }
        else if (n3 == 238) {
            n12 = m2(118, getSecretNumber(scramble3));
        }
        else if (n3 == 239) {
            n12 = m2(34, getSecretNumber(scramble3));
        }
        else if (n3 == 240) {
            n12 = m2(215, getSecretNumber(scramble3));
        }
        else if (n3 == 241) {
            n12 = m2(74, getSecretNumber(scramble3));
        }
        else if (n3 == 242) {
            n12 = m2(87, getSecretNumber(scramble3));
        }
        else if (n3 == 243) {
            n12 = m2(253, getSecretNumber(scramble3));
        }
        else if (n3 == 244) {
            n12 = m2(194, getSecretNumber(scramble3));
        }
        else if (n3 == 245) {
            n12 = m2(249, getSecretNumber(scramble3));
        }
        else if (n3 == 246) {
            n12 = m2(100, getSecretNumber(scramble3));
        }
        else if (n3 == 247) {
            n12 = m2(41, getSecretNumber(scramble3));
        }
        else if (n3 == 248) {
            n12 = m2(76, getSecretNumber(scramble3));
        }
        else if (n3 == 249) {
            n12 = m2(101, getSecretNumber(scramble3));
        }
        else if (n3 == 250) {
            n12 = m2(4, getSecretNumber(scramble3));
        }
        else if (n3 == 251) {
            n12 = m2(191, getSecretNumber(scramble3));
        }
        else if (n3 == 252) {
            n12 = m2(132, getSecretNumber(scramble3));
        }
        else if (n3 == 253) {
            n12 = m2(183, getSecretNumber(scramble3));
        }
        else if (n3 == 254) {
            n12 = m2(7, getSecretNumber(scramble3));
        }
        else if (n3 == 255) {
            n12 = m2(161, getSecretNumber(scramble3));
        }
        else {
            n12 = 0;
        }
        if ((n12 & 0xFB) != 0x92) {
            return false;
        }
        final int scramble4 = scramble(scramble3);
        int n13;
        if (n4 == 0) {
            n13 = m3(1, getSecretNumber(scramble4));
        }
        else if (n4 == 1) {
            n13 = m3(223, getSecretNumber(scramble4));
        }
        else if (n4 == 2) {
            n13 = m3(134, getSecretNumber(scramble4));
        }
        else if (n4 == 3) {
            n13 = m3(163, getSecretNumber(scramble4));
        }
        else if (n4 == 4) {
            n13 = m3(178, getSecretNumber(scramble4));
        }
        else if (n4 == 5) {
            n13 = m3(59, getSecretNumber(scramble4));
        }
        else if (n4 == 6) {
            n13 = m3(65, getSecretNumber(scramble4));
        }
        else if (n4 == 7) {
            n13 = m3(116, getSecretNumber(scramble4));
        }
        else if (n4 == 8) {
            n13 = m3(117, getSecretNumber(scramble4));
        }
        else if (n4 == 9) {
            n13 = m3(17, getSecretNumber(scramble4));
        }
        else if (n4 == 10) {
            n13 = m3(224, getSecretNumber(scramble4));
        }
        else if (n4 == 11) {
            n13 = m3(122, getSecretNumber(scramble4));
        }
        else if (n4 == 12) {
            n13 = m3(99, getSecretNumber(scramble4));
        }
        else if (n4 == 13) {
            n13 = m3(85, getSecretNumber(scramble4));
        }
        else if (n4 == 14) {
            n13 = m3(52, getSecretNumber(scramble4));
        }
        else if (n4 == 15) {
            n13 = m3(63, getSecretNumber(scramble4));
        }
        else if (n4 == 16) {
            n13 = m3(206, getSecretNumber(scramble4));
        }
        else if (n4 == 17) {
            n13 = m3(131, getSecretNumber(scramble4));
        }
        else if (n4 == 18) {
            n13 = m3(204, getSecretNumber(scramble4));
        }
        else if (n4 == 19) {
            n13 = m3(32, getSecretNumber(scramble4));
        }
        else if (n4 == 20) {
            n13 = m3(40, getSecretNumber(scramble4));
        }
        else if (n4 == 21) {
            n13 = m3(177, getSecretNumber(scramble4));
        }
        else if (n4 == 22) {
            n13 = m3(132, getSecretNumber(scramble4));
        }
        else if (n4 == 23) {
            n13 = m3(133, getSecretNumber(scramble4));
        }
        else if (n4 == 24) {
            n13 = m3(92, getSecretNumber(scramble4));
        }
        else if (n4 == 25) {
            n13 = m3(101, getSecretNumber(scramble4));
        }
        else if (n4 == 26) {
            n13 = m3(97, getSecretNumber(scramble4));
        }
        else if (n4 == 27) {
            n13 = m3(230, getSecretNumber(scramble4));
        }
        else if (n4 == 28) {
            n13 = m3(106, getSecretNumber(scramble4));
        }
        else if (n4 == 29) {
            n13 = m3(144, getSecretNumber(scramble4));
        }
        else if (n4 == 30) {
            n13 = m3(30, getSecretNumber(scramble4));
        }
        else if (n4 == 31) {
            n13 = m3(73, getSecretNumber(scramble4));
        }
        else if (n4 == 32) {
            n13 = m3(0, getSecretNumber(scramble4));
        }
        else if (n4 == 33) {
            n13 = m3(153, getSecretNumber(scramble4));
        }
        else if (n4 == 34) {
            n13 = m3(192, getSecretNumber(scramble4));
        }
        else if (n4 == 35) {
            n13 = m3(107, getSecretNumber(scramble4));
        }
        else if (n4 == 36) {
            n13 = m3(44, getSecretNumber(scramble4));
        }
        else if (n4 == 37) {
            n13 = m3(123, getSecretNumber(scramble4));
        }
        else if (n4 == 38) {
            n13 = m3(86, getSecretNumber(scramble4));
        }
        else if (n4 == 39) {
            n13 = m3(233, getSecretNumber(scramble4));
        }
        else if (n4 == 40) {
            n13 = m3(62, getSecretNumber(scramble4));
        }
        else if (n4 == 41) {
            n13 = m3(164, getSecretNumber(scramble4));
        }
        else if (n4 == 42) {
            n13 = m3(118, getSecretNumber(scramble4));
        }
        else if (n4 == 43) {
            n13 = m3(80, getSecretNumber(scramble4));
        }
        else if (n4 == 44) {
            n13 = m3(71, getSecretNumber(scramble4));
        }
        else if (n4 == 45) {
            n13 = m3(179, getSecretNumber(scramble4));
        }
        else if (n4 == 46) {
            n13 = m3(197, getSecretNumber(scramble4));
        }
        else if (n4 == 47) {
            n13 = m3(184, getSecretNumber(scramble4));
        }
        else if (n4 == 48) {
            n13 = m3(29, getSecretNumber(scramble4));
        }
        else if (n4 == 49) {
            n13 = m3(108, getSecretNumber(scramble4));
        }
        else if (n4 == 50) {
            n13 = m3(4, getSecretNumber(scramble4));
        }
        else if (n4 == 51) {
            n13 = m3(58, getSecretNumber(scramble4));
        }
        else if (n4 == 52) {
            n13 = m3(244, getSecretNumber(scramble4));
        }
        else if (n4 == 53) {
            n13 = m3(235, getSecretNumber(scramble4));
        }
        else if (n4 == 54) {
            n13 = m3(8, getSecretNumber(scramble4));
        }
        else if (n4 == 55) {
            n13 = m3(209, getSecretNumber(scramble4));
        }
        else if (n4 == 56) {
            n13 = m3(41, getSecretNumber(scramble4));
        }
        else if (n4 == 57) {
            n13 = m3(28, getSecretNumber(scramble4));
        }
        else if (n4 == 58) {
            n13 = m3(150, getSecretNumber(scramble4));
        }
        else if (n4 == 59) {
            n13 = m3(199, getSecretNumber(scramble4));
        }
        else if (n4 == 60) {
            n13 = m3(14, getSecretNumber(scramble4));
        }
        else if (n4 == 61) {
            n13 = m3(94, getSecretNumber(scramble4));
        }
        else if (n4 == 62) {
            n13 = m3(45, getSecretNumber(scramble4));
        }
        else if (n4 == 63) {
            n13 = m3(203, getSecretNumber(scramble4));
        }
        else if (n4 == 64) {
            n13 = m3(159, getSecretNumber(scramble4));
        }
        else if (n4 == 65) {
            n13 = m3(51, getSecretNumber(scramble4));
        }
        else if (n4 == 66) {
            n13 = m3(212, getSecretNumber(scramble4));
        }
        else if (n4 == 67) {
            n13 = m3(222, getSecretNumber(scramble4));
        }
        else if (n4 == 68) {
            n13 = m3(183, getSecretNumber(scramble4));
        }
        else if (n4 == 69) {
            n13 = m3(157, getSecretNumber(scramble4));
        }
        else if (n4 == 70) {
            n13 = m3(95, getSecretNumber(scramble4));
        }
        else if (n4 == 71) {
            n13 = m3(66, getSecretNumber(scramble4));
        }
        else if (n4 == 72) {
            n13 = m3(142, getSecretNumber(scramble4));
        }
        else if (n4 == 73) {
            n13 = m3(34, getSecretNumber(scramble4));
        }
        else if (n4 == 74) {
            n13 = m3(185, getSecretNumber(scramble4));
        }
        else if (n4 == 75) {
            n13 = m3(61, getSecretNumber(scramble4));
        }
        else if (n4 == 76) {
            n13 = m3(74, getSecretNumber(scramble4));
        }
        else if (n4 == 77) {
            n13 = m3(26, getSecretNumber(scramble4));
        }
        else if (n4 == 78) {
            n13 = m3(161, getSecretNumber(scramble4));
        }
        else if (n4 == 79) {
            n13 = m3(39, getSecretNumber(scramble4));
        }
        else if (n4 == 80) {
            n13 = m3(55, getSecretNumber(scramble4));
        }
        else if (n4 == 81) {
            n13 = m3(248, getSecretNumber(scramble4));
        }
        else if (n4 == 82) {
            n13 = m3(16, getSecretNumber(scramble4));
        }
        else if (n4 == 83) {
            n13 = m3(180, getSecretNumber(scramble4));
        }
        else if (n4 == 84) {
            n13 = m3(191, getSecretNumber(scramble4));
        }
        else if (n4 == 85) {
            n13 = m3(247, getSecretNumber(scramble4));
        }
        else if (n4 == 86) {
            n13 = m3(25, getSecretNumber(scramble4));
        }
        else if (n4 == 87) {
            n13 = m3(129, getSecretNumber(scramble4));
        }
        else if (n4 == 88) {
            n13 = m3(91, getSecretNumber(scramble4));
        }
        else if (n4 == 89) {
            n13 = m3(54, getSecretNumber(scramble4));
        }
        else if (n4 == 90) {
            n13 = m3(181, getSecretNumber(scramble4));
        }
        else if (n4 == 91) {
            n13 = m3(88, getSecretNumber(scramble4));
        }
        else if (n4 == 92) {
            n13 = m3(207, getSecretNumber(scramble4));
        }
        else if (n4 == 93) {
            n13 = m3(193, getSecretNumber(scramble4));
        }
        else if (n4 == 94) {
            n13 = m3(5, getSecretNumber(scramble4));
        }
        else if (n4 == 95) {
            n13 = m3(216, getSecretNumber(scramble4));
        }
        else if (n4 == 96) {
            n13 = m3(231, getSecretNumber(scramble4));
        }
        else if (n4 == 97) {
            n13 = m3(121, getSecretNumber(scramble4));
        }
        else if (n4 == 98) {
            n13 = m3(211, getSecretNumber(scramble4));
        }
        else if (n4 == 99) {
            n13 = m3(174, getSecretNumber(scramble4));
        }
        else if (n4 == 100) {
            n13 = m3(167, getSecretNumber(scramble4));
        }
        else if (n4 == 101) {
            n13 = m3(255, getSecretNumber(scramble4));
        }
        else if (n4 == 102) {
            n13 = m3(227, getSecretNumber(scramble4));
        }
        else if (n4 == 103) {
            n13 = m3(176, getSecretNumber(scramble4));
        }
        else if (n4 == 104) {
            n13 = m3(82, getSecretNumber(scramble4));
        }
        else if (n4 == 105) {
            n13 = m3(137, getSecretNumber(scramble4));
        }
        else if (n4 == 106) {
            n13 = m3(12, getSecretNumber(scramble4));
        }
        else if (n4 == 107) {
            n13 = m3(38, getSecretNumber(scramble4));
        }
        else if (n4 == 108) {
            n13 = m3(198, getSecretNumber(scramble4));
        }
        else if (n4 == 109) {
            n13 = m3(109, getSecretNumber(scramble4));
        }
        else if (n4 == 110) {
            n13 = m3(152, getSecretNumber(scramble4));
        }
        else if (n4 == 111) {
            n13 = m3(250, getSecretNumber(scramble4));
        }
        else if (n4 == 112) {
            n13 = m3(126, getSecretNumber(scramble4));
        }
        else if (n4 == 113) {
            n13 = m3(169, getSecretNumber(scramble4));
        }
        else if (n4 == 114) {
            n13 = m3(187, getSecretNumber(scramble4));
        }
        else if (n4 == 115) {
            n13 = m3(33, getSecretNumber(scramble4));
        }
        else if (n4 == 116) {
            n13 = m3(253, getSecretNumber(scramble4));
        }
        else if (n4 == 117) {
            n13 = m3(87, getSecretNumber(scramble4));
        }
        else if (n4 == 118) {
            n13 = m3(173, getSecretNumber(scramble4));
        }
        else if (n4 == 119) {
            n13 = m3(221, getSecretNumber(scramble4));
        }
        else if (n4 == 120) {
            n13 = m3(46, getSecretNumber(scramble4));
        }
        else if (n4 == 121) {
            n13 = m3(182, getSecretNumber(scramble4));
        }
        else if (n4 == 122) {
            n13 = m3(24, getSecretNumber(scramble4));
        }
        else if (n4 == 123) {
            n13 = m3(84, getSecretNumber(scramble4));
        }
        else if (n4 == 124) {
            n13 = m3(228, getSecretNumber(scramble4));
        }
        else if (n4 == 125) {
            n13 = m3(239, getSecretNumber(scramble4));
        }
        else if (n4 == 126) {
            n13 = m3(75, getSecretNumber(scramble4));
        }
        else if (n4 == 127) {
            n13 = m3(19, getSecretNumber(scramble4));
        }
        else if (n4 == 128) {
            n13 = m3(72, getSecretNumber(scramble4));
        }
        else if (n4 == 129) {
            n13 = m3(112, getSecretNumber(scramble4));
        }
        else if (n4 == 130) {
            n13 = m3(208, getSecretNumber(scramble4));
        }
        else if (n4 == 131) {
            n13 = m3(251, getSecretNumber(scramble4));
        }
        else if (n4 == 132) {
            n13 = m3(220, getSecretNumber(scramble4));
        }
        else if (n4 == 133) {
            n13 = m3(254, getSecretNumber(scramble4));
        }
        else if (n4 == 134) {
            n13 = m3(90, getSecretNumber(scramble4));
        }
        else if (n4 == 135) {
            n13 = m3(218, getSecretNumber(scramble4));
        }
        else if (n4 == 136) {
            n13 = m3(2, getSecretNumber(scramble4));
        }
        else if (n4 == 137) {
            n13 = m3(64, getSecretNumber(scramble4));
        }
        else if (n4 == 138) {
            n13 = m3(246, getSecretNumber(scramble4));
        }
        else if (n4 == 139) {
            n13 = m3(50, getSecretNumber(scramble4));
        }
        else if (n4 == 140) {
            n13 = m3(114, getSecretNumber(scramble4));
        }
        else if (n4 == 141) {
            n13 = m3(156, getSecretNumber(scramble4));
        }
        else if (n4 == 142) {
            n13 = m3(168, getSecretNumber(scramble4));
        }
        else if (n4 == 143) {
            n13 = m3(160, getSecretNumber(scramble4));
        }
        else if (n4 == 144) {
            n13 = m3(148, getSecretNumber(scramble4));
        }
        else if (n4 == 145) {
            n13 = m3(68, getSecretNumber(scramble4));
        }
        else if (n4 == 146) {
            n13 = m3(242, getSecretNumber(scramble4));
        }
        else if (n4 == 147) {
            n13 = m3(130, getSecretNumber(scramble4));
        }
        else if (n4 == 148) {
            n13 = m3(113, getSecretNumber(scramble4));
        }
        else if (n4 == 149) {
            n13 = m3(171, getSecretNumber(scramble4));
        }
        else if (n4 == 150) {
            n13 = m3(139, getSecretNumber(scramble4));
        }
        else if (n4 == 151) {
            n13 = m3(76, getSecretNumber(scramble4));
        }
        else if (n4 == 152) {
            n13 = m3(23, getSecretNumber(scramble4));
        }
        else if (n4 == 153) {
            n13 = m3(49, getSecretNumber(scramble4));
        }
        else if (n4 == 154) {
            n13 = m3(138, getSecretNumber(scramble4));
        }
        else if (n4 == 155) {
            n13 = m3(6, getSecretNumber(scramble4));
        }
        else if (n4 == 156) {
            n13 = m3(225, getSecretNumber(scramble4));
        }
        else if (n4 == 157) {
            n13 = m3(241, getSecretNumber(scramble4));
        }
        else if (n4 == 158) {
            n13 = m3(11, getSecretNumber(scramble4));
        }
        else if (n4 == 159) {
            n13 = m3(213, getSecretNumber(scramble4));
        }
        else if (n4 == 160) {
            n13 = m3(48, getSecretNumber(scramble4));
        }
        else if (n4 == 161) {
            n13 = m3(196, getSecretNumber(scramble4));
        }
        else if (n4 == 162) {
            n13 = m3(110, getSecretNumber(scramble4));
        }
        else if (n4 == 163) {
            n13 = m3(146, getSecretNumber(scramble4));
        }
        else if (n4 == 164) {
            n13 = m3(119, getSecretNumber(scramble4));
        }
        else if (n4 == 165) {
            n13 = m3(202, getSecretNumber(scramble4));
        }
        else if (n4 == 166) {
            n13 = m3(69, getSecretNumber(scramble4));
        }
        else if (n4 == 167) {
            n13 = m3(237, getSecretNumber(scramble4));
        }
        else if (n4 == 168) {
            n13 = m3(22, getSecretNumber(scramble4));
        }
        else if (n4 == 169) {
            n13 = m3(93, getSecretNumber(scramble4));
        }
        else if (n4 == 170) {
            n13 = m3(175, getSecretNumber(scramble4));
        }
        else if (n4 == 171) {
            n13 = m3(154, getSecretNumber(scramble4));
        }
        else if (n4 == 172) {
            n13 = m3(102, getSecretNumber(scramble4));
        }
        else if (n4 == 173) {
            n13 = m3(120, getSecretNumber(scramble4));
        }
        else if (n4 == 174) {
            n13 = m3(21, getSecretNumber(scramble4));
        }
        else if (n4 == 175) {
            n13 = m3(57, getSecretNumber(scramble4));
        }
        else if (n4 == 176) {
            n13 = m3(140, getSecretNumber(scramble4));
        }
        else if (n4 == 177) {
            n13 = m3(9, getSecretNumber(scramble4));
        }
        else if (n4 == 178) {
            n13 = m3(141, getSecretNumber(scramble4));
        }
        else if (n4 == 179) {
            n13 = m3(162, getSecretNumber(scramble4));
        }
        else if (n4 == 180) {
            n13 = m3(190, getSecretNumber(scramble4));
        }
        else if (n4 == 181) {
            n13 = m3(60, getSecretNumber(scramble4));
        }
        else if (n4 == 182) {
            n13 = m3(53, getSecretNumber(scramble4));
        }
        else if (n4 == 183) {
            n13 = m3(205, getSecretNumber(scramble4));
        }
        else if (n4 == 184) {
            n13 = m3(136, getSecretNumber(scramble4));
        }
        else if (n4 == 185) {
            n13 = m3(158, getSecretNumber(scramble4));
        }
        else if (n4 == 186) {
            n13 = m3(105, getSecretNumber(scramble4));
        }
        else if (n4 == 187) {
            n13 = m3(145, getSecretNumber(scramble4));
        }
        else if (n4 == 188) {
            n13 = m3(166, getSecretNumber(scramble4));
        }
        else if (n4 == 189) {
            n13 = m3(115, getSecretNumber(scramble4));
        }
        else if (n4 == 190) {
            n13 = m3(249, getSecretNumber(scramble4));
        }
        else if (n4 == 191) {
            n13 = m3(77, getSecretNumber(scramble4));
        }
        else if (n4 == 192) {
            n13 = m3(252, getSecretNumber(scramble4));
        }
        else if (n4 == 193) {
            n13 = m3(70, getSecretNumber(scramble4));
        }
        else if (n4 == 194) {
            n13 = m3(78, getSecretNumber(scramble4));
        }
        else if (n4 == 195) {
            n13 = m3(226, getSecretNumber(scramble4));
        }
        else if (n4 == 196) {
            n13 = m3(217, getSecretNumber(scramble4));
        }
        else if (n4 == 197) {
            n13 = m3(37, getSecretNumber(scramble4));
        }
        else if (n4 == 198) {
            n13 = m3(111, getSecretNumber(scramble4));
        }
        else if (n4 == 199) {
            n13 = m3(127, getSecretNumber(scramble4));
        }
        else if (n4 == 200) {
            n13 = m3(27, getSecretNumber(scramble4));
        }
        else if (n4 == 201) {
            n13 = m3(243, getSecretNumber(scramble4));
        }
        else if (n4 == 202) {
            n13 = m3(195, getSecretNumber(scramble4));
        }
        else if (n4 == 203) {
            n13 = m3(128, getSecretNumber(scramble4));
        }
        else if (n4 == 204) {
            n13 = m3(186, getSecretNumber(scramble4));
        }
        else if (n4 == 205) {
            n13 = m3(83, getSecretNumber(scramble4));
        }
        else if (n4 == 206) {
            n13 = m3(229, getSecretNumber(scramble4));
        }
        else if (n4 == 207) {
            n13 = m3(96, getSecretNumber(scramble4));
        }
        else if (n4 == 208) {
            n13 = m3(89, getSecretNumber(scramble4));
        }
        else if (n4 == 209) {
            n13 = m3(81, getSecretNumber(scramble4));
        }
        else if (n4 == 210) {
            n13 = m3(189, getSecretNumber(scramble4));
        }
        else if (n4 == 211) {
            n13 = m3(219, getSecretNumber(scramble4));
        }
        else if (n4 == 212) {
            n13 = m3(210, getSecretNumber(scramble4));
        }
        else if (n4 == 213) {
            n13 = m3(15, getSecretNumber(scramble4));
        }
        else if (n4 == 214) {
            n13 = m3(194, getSecretNumber(scramble4));
        }
        else if (n4 == 215) {
            n13 = m3(147, getSecretNumber(scramble4));
        }
        else if (n4 == 216) {
            n13 = m3(10, getSecretNumber(scramble4));
        }
        else if (n4 == 217) {
            n13 = m3(245, getSecretNumber(scramble4));
        }
        else if (n4 == 218) {
            n13 = m3(165, getSecretNumber(scramble4));
        }
        else if (n4 == 219) {
            n13 = m3(98, getSecretNumber(scramble4));
        }
        else if (n4 == 220) {
            n13 = m3(155, getSecretNumber(scramble4));
        }
        else if (n4 == 221) {
            n13 = m3(240, getSecretNumber(scramble4));
        }
        else if (n4 == 222) {
            n13 = m3(43, getSecretNumber(scramble4));
        }
        else if (n4 == 223) {
            n13 = m3(214, getSecretNumber(scramble4));
        }
        else if (n4 == 224) {
            n13 = m3(188, getSecretNumber(scramble4));
        }
        else if (n4 == 225) {
            n13 = m3(232, getSecretNumber(scramble4));
        }
        else if (n4 == 226) {
            n13 = m3(236, getSecretNumber(scramble4));
        }
        else if (n4 == 227) {
            n13 = m3(201, getSecretNumber(scramble4));
        }
        else if (n4 == 228) {
            n13 = m3(42, getSecretNumber(scramble4));
        }
        else if (n4 == 229) {
            n13 = m3(125, getSecretNumber(scramble4));
        }
        else if (n4 == 230) {
            n13 = m3(143, getSecretNumber(scramble4));
        }
        else if (n4 == 231) {
            n13 = m3(100, getSecretNumber(scramble4));
        }
        else if (n4 == 232) {
            n13 = m3(215, getSecretNumber(scramble4));
        }
        else if (n4 == 233) {
            n13 = m3(103, getSecretNumber(scramble4));
        }
        else if (n4 == 234) {
            n13 = m3(67, getSecretNumber(scramble4));
        }
        else if (n4 == 235) {
            n13 = m3(36, getSecretNumber(scramble4));
        }
        else if (n4 == 236) {
            n13 = m3(3, getSecretNumber(scramble4));
        }
        else if (n4 == 237) {
            n13 = m3(47, getSecretNumber(scramble4));
        }
        else if (n4 == 238) {
            n13 = m3(13, getSecretNumber(scramble4));
        }
        else if (n4 == 239) {
            n13 = m3(124, getSecretNumber(scramble4));
        }
        else if (n4 == 240) {
            n13 = m3(172, getSecretNumber(scramble4));
        }
        else if (n4 == 241) {
            n13 = m3(20, getSecretNumber(scramble4));
        }
        else if (n4 == 242) {
            n13 = m3(238, getSecretNumber(scramble4));
        }
        else if (n4 == 243) {
            n13 = m3(7, getSecretNumber(scramble4));
        }
        else if (n4 == 244) {
            n13 = m3(234, getSecretNumber(scramble4));
        }
        else if (n4 == 245) {
            n13 = m3(135, getSecretNumber(scramble4));
        }
        else if (n4 == 246) {
            n13 = m3(18, getSecretNumber(scramble4));
        }
        else if (n4 == 247) {
            n13 = m3(151, getSecretNumber(scramble4));
        }
        else if (n4 == 248) {
            n13 = m3(79, getSecretNumber(scramble4));
        }
        else if (n4 == 249) {
            n13 = m3(149, getSecretNumber(scramble4));
        }
        else if (n4 == 250) {
            n13 = m3(31, getSecretNumber(scramble4));
        }
        else if (n4 == 251) {
            n13 = m3(56, getSecretNumber(scramble4));
        }
        else if (n4 == 252) {
            n13 = m3(200, getSecretNumber(scramble4));
        }
        else if (n4 == 253) {
            n13 = m3(104, getSecretNumber(scramble4));
        }
        else if (n4 == 254) {
            n13 = m3(170, getSecretNumber(scramble4));
        }
        else if (n4 == 255) {
            n13 = m3(35, getSecretNumber(scramble4));
        }
        else {
            n13 = 0;
        }
        if ((n13 & 0xF7) != 0x61) {
            return false;
        }
        final int scramble5 = scramble(scramble4);
        int n14;
        if (n5 == 0) {
            n14 = m4(144, getSecretNumber(scramble5));
        }
        else if (n5 == 1) {
            n14 = m4(158, getSecretNumber(scramble5));
        }
        else if (n5 == 2) {
            n14 = m4(58, getSecretNumber(scramble5));
        }
        else if (n5 == 3) {
            n14 = m4(155, getSecretNumber(scramble5));
        }
        else if (n5 == 4) {
            n14 = m4(10, getSecretNumber(scramble5));
        }
        else if (n5 == 5) {
            n14 = m4(130, getSecretNumber(scramble5));
        }
        else if (n5 == 6) {
            n14 = m4(143, getSecretNumber(scramble5));
        }
        else if (n5 == 7) {
            n14 = m4(78, getSecretNumber(scramble5));
        }
        else if (n5 == 8) {
            n14 = m4(170, getSecretNumber(scramble5));
        }
        else if (n5 == 9) {
            n14 = m4(39, getSecretNumber(scramble5));
        }
        else if (n5 == 10) {
            n14 = m4(110, getSecretNumber(scramble5));
        }
        else if (n5 == 11) {
            n14 = m4(250, getSecretNumber(scramble5));
        }
        else if (n5 == 12) {
            n14 = m4(246, getSecretNumber(scramble5));
        }
        else if (n5 == 13) {
            n14 = m4(7, getSecretNumber(scramble5));
        }
        else if (n5 == 14) {
            n14 = m4(214, getSecretNumber(scramble5));
        }
        else if (n5 == 15) {
            n14 = m4(235, getSecretNumber(scramble5));
        }
        else if (n5 == 16) {
            n14 = m4(25, getSecretNumber(scramble5));
        }
        else if (n5 == 17) {
            n14 = m4(202, getSecretNumber(scramble5));
        }
        else if (n5 == 18) {
            n14 = m4(157, getSecretNumber(scramble5));
        }
        else if (n5 == 19) {
            n14 = m4(89, getSecretNumber(scramble5));
        }
        else if (n5 == 20) {
            n14 = m4(237, getSecretNumber(scramble5));
        }
        else if (n5 == 21) {
            n14 = m4(131, getSecretNumber(scramble5));
        }
        else if (n5 == 22) {
            n14 = m4(52, getSecretNumber(scramble5));
        }
        else if (n5 == 23) {
            n14 = m4(233, getSecretNumber(scramble5));
        }
        else if (n5 == 24) {
            n14 = m4(161, getSecretNumber(scramble5));
        }
        else if (n5 == 25) {
            n14 = m4(245, getSecretNumber(scramble5));
        }
        else if (n5 == 26) {
            n14 = m4(181, getSecretNumber(scramble5));
        }
        else if (n5 == 27) {
            n14 = m4(184, getSecretNumber(scramble5));
        }
        else if (n5 == 28) {
            n14 = m4(116, getSecretNumber(scramble5));
        }
        else if (n5 == 29) {
            n14 = m4(26, getSecretNumber(scramble5));
        }
        else if (n5 == 30) {
            n14 = m4(254, getSecretNumber(scramble5));
        }
        else if (n5 == 31) {
            n14 = m4(159, getSecretNumber(scramble5));
        }
        else if (n5 == 32) {
            n14 = m4(244, getSecretNumber(scramble5));
        }
        else if (n5 == 33) {
            n14 = m4(101, getSecretNumber(scramble5));
        }
        else if (n5 == 34) {
            n14 = m4(186, getSecretNumber(scramble5));
        }
        else if (n5 == 35) {
            n14 = m4(248, getSecretNumber(scramble5));
        }
        else if (n5 == 36) {
            n14 = m4(72, getSecretNumber(scramble5));
        }
        else if (n5 == 37) {
            n14 = m4(70, getSecretNumber(scramble5));
        }
        else if (n5 == 38) {
            n14 = m4(142, getSecretNumber(scramble5));
        }
        else if (n5 == 39) {
            n14 = m4(205, getSecretNumber(scramble5));
        }
        else if (n5 == 40) {
            n14 = m4(168, getSecretNumber(scramble5));
        }
        else if (n5 == 41) {
            n14 = m4(134, getSecretNumber(scramble5));
        }
        else if (n5 == 42) {
            n14 = m4(173, getSecretNumber(scramble5));
        }
        else if (n5 == 43) {
            n14 = m4(3, getSecretNumber(scramble5));
        }
        else if (n5 == 44) {
            n14 = m4(54, getSecretNumber(scramble5));
        }
        else if (n5 == 45) {
            n14 = m4(222, getSecretNumber(scramble5));
        }
        else if (n5 == 46) {
            n14 = m4(51, getSecretNumber(scramble5));
        }
        else if (n5 == 47) {
            n14 = m4(104, getSecretNumber(scramble5));
        }
        else if (n5 == 48) {
            n14 = m4(123, getSecretNumber(scramble5));
        }
        else if (n5 == 49) {
            n14 = m4(34, getSecretNumber(scramble5));
        }
        else if (n5 == 50) {
            n14 = m4(206, getSecretNumber(scramble5));
        }
        else if (n5 == 51) {
            n14 = m4(2, getSecretNumber(scramble5));
        }
        else if (n5 == 52) {
            n14 = m4(188, getSecretNumber(scramble5));
        }
        else if (n5 == 53) {
            n14 = m4(73, getSecretNumber(scramble5));
        }
        else if (n5 == 54) {
            n14 = m4(95, getSecretNumber(scramble5));
        }
        else if (n5 == 55) {
            n14 = m4(11, getSecretNumber(scramble5));
        }
        else if (n5 == 56) {
            n14 = m4(20, getSecretNumber(scramble5));
        }
        else if (n5 == 57) {
            n14 = m4(38, getSecretNumber(scramble5));
        }
        else if (n5 == 58) {
            n14 = m4(69, getSecretNumber(scramble5));
        }
        else if (n5 == 59) {
            n14 = m4(113, getSecretNumber(scramble5));
        }
        else if (n5 == 60) {
            n14 = m4(179, getSecretNumber(scramble5));
        }
        else if (n5 == 61) {
            n14 = m4(183, getSecretNumber(scramble5));
        }
        else if (n5 == 62) {
            n14 = m4(192, getSecretNumber(scramble5));
        }
        else if (n5 == 63) {
            n14 = m4(30, getSecretNumber(scramble5));
        }
        else if (n5 == 64) {
            n14 = m4(99, getSecretNumber(scramble5));
        }
        else if (n5 == 65) {
            n14 = m4(215, getSecretNumber(scramble5));
        }
        else if (n5 == 66) {
            n14 = m4(129, getSecretNumber(scramble5));
        }
        else if (n5 == 67) {
            n14 = m4(6, getSecretNumber(scramble5));
        }
        else if (n5 == 68) {
            n14 = m4(24, getSecretNumber(scramble5));
        }
        else if (n5 == 69) {
            n14 = m4(133, getSecretNumber(scramble5));
        }
        else if (n5 == 70) {
            n14 = m4(198, getSecretNumber(scramble5));
        }
        else if (n5 == 71) {
            n14 = m4(98, getSecretNumber(scramble5));
        }
        else if (n5 == 72) {
            n14 = m4(49, getSecretNumber(scramble5));
        }
        else if (n5 == 73) {
            n14 = m4(92, getSecretNumber(scramble5));
        }
        else if (n5 == 74) {
            n14 = m4(66, getSecretNumber(scramble5));
        }
        else if (n5 == 75) {
            n14 = m4(106, getSecretNumber(scramble5));
        }
        else if (n5 == 76) {
            n14 = m4(154, getSecretNumber(scramble5));
        }
        else if (n5 == 77) {
            n14 = m4(118, getSecretNumber(scramble5));
        }
        else if (n5 == 78) {
            n14 = m4(164, getSecretNumber(scramble5));
        }
        else if (n5 == 79) {
            n14 = m4(145, getSecretNumber(scramble5));
        }
        else if (n5 == 80) {
            n14 = m4(177, getSecretNumber(scramble5));
        }
        else if (n5 == 81) {
            n14 = m4(121, getSecretNumber(scramble5));
        }
        else if (n5 == 82) {
            n14 = m4(190, getSecretNumber(scramble5));
        }
        else if (n5 == 83) {
            n14 = m4(84, getSecretNumber(scramble5));
        }
        else if (n5 == 84) {
            n14 = m4(59, getSecretNumber(scramble5));
        }
        else if (n5 == 85) {
            n14 = m4(172, getSecretNumber(scramble5));
        }
        else if (n5 == 86) {
            n14 = m4(149, getSecretNumber(scramble5));
        }
        else if (n5 == 87) {
            n14 = m4(75, getSecretNumber(scramble5));
        }
        else if (n5 == 88) {
            n14 = m4(23, getSecretNumber(scramble5));
        }
        else if (n5 == 89) {
            n14 = m4(151, getSecretNumber(scramble5));
        }
        else if (n5 == 90) {
            n14 = m4(207, getSecretNumber(scramble5));
        }
        else if (n5 == 91) {
            n14 = m4(19, getSecretNumber(scramble5));
        }
        else if (n5 == 92) {
            n14 = m4(8, getSecretNumber(scramble5));
        }
        else if (n5 == 93) {
            n14 = m4(15, getSecretNumber(scramble5));
        }
        else if (n5 == 94) {
            n14 = m4(247, getSecretNumber(scramble5));
        }
        else if (n5 == 95) {
            n14 = m4(37, getSecretNumber(scramble5));
        }
        else if (n5 == 96) {
            n14 = m4(167, getSecretNumber(scramble5));
        }
        else if (n5 == 97) {
            n14 = m4(255, getSecretNumber(scramble5));
        }
        else if (n5 == 98) {
            n14 = m4(102, getSecretNumber(scramble5));
        }
        else if (n5 == 99) {
            n14 = m4(226, getSecretNumber(scramble5));
        }
        else if (n5 == 100) {
            n14 = m4(135, getSecretNumber(scramble5));
        }
        else if (n5 == 101) {
            n14 = m4(100, getSecretNumber(scramble5));
        }
        else if (n5 == 102) {
            n14 = m4(18, getSecretNumber(scramble5));
        }
        else if (n5 == 103) {
            n14 = m4(176, getSecretNumber(scramble5));
        }
        else if (n5 == 104) {
            n14 = m4(171, getSecretNumber(scramble5));
        }
        else if (n5 == 105) {
            n14 = m4(4, getSecretNumber(scramble5));
        }
        else if (n5 == 106) {
            n14 = m4(105, getSecretNumber(scramble5));
        }
        else if (n5 == 107) {
            n14 = m4(111, getSecretNumber(scramble5));
        }
        else if (n5 == 108) {
            n14 = m4(251, getSecretNumber(scramble5));
        }
        else if (n5 == 109) {
            n14 = m4(9, getSecretNumber(scramble5));
        }
        else if (n5 == 110) {
            n14 = m4(219, getSecretNumber(scramble5));
        }
        else if (n5 == 111) {
            n14 = m4(88, getSecretNumber(scramble5));
        }
        else if (n5 == 112) {
            n14 = m4(93, getSecretNumber(scramble5));
        }
        else if (n5 == 113) {
            n14 = m4(213, getSecretNumber(scramble5));
        }
        else if (n5 == 114) {
            n14 = m4(169, getSecretNumber(scramble5));
        }
        else if (n5 == 115) {
            n14 = m4(16, getSecretNumber(scramble5));
        }
        else if (n5 == 116) {
            n14 = m4(229, getSecretNumber(scramble5));
        }
        else if (n5 == 117) {
            n14 = m4(57, getSecretNumber(scramble5));
        }
        else if (n5 == 118) {
            n14 = m4(61, getSecretNumber(scramble5));
        }
        else if (n5 == 119) {
            n14 = m4(35, getSecretNumber(scramble5));
        }
        else if (n5 == 120) {
            n14 = m4(65, getSecretNumber(scramble5));
        }
        else if (n5 == 121) {
            n14 = m4(238, getSecretNumber(scramble5));
        }
        else if (n5 == 122) {
            n14 = m4(141, getSecretNumber(scramble5));
        }
        else if (n5 == 123) {
            n14 = m4(216, getSecretNumber(scramble5));
        }
        else if (n5 == 124) {
            n14 = m4(199, getSecretNumber(scramble5));
        }
        else if (n5 == 125) {
            n14 = m4(182, getSecretNumber(scramble5));
        }
        else if (n5 == 126) {
            n14 = m4(22, getSecretNumber(scramble5));
        }
        else if (n5 == 127) {
            n14 = m4(230, getSecretNumber(scramble5));
        }
        else if (n5 == 128) {
            n14 = m4(200, getSecretNumber(scramble5));
        }
        else if (n5 == 129) {
            n14 = m4(42, getSecretNumber(scramble5));
        }
        else if (n5 == 130) {
            n14 = m4(76, getSecretNumber(scramble5));
        }
        else if (n5 == 131) {
            n14 = m4(225, getSecretNumber(scramble5));
        }
        else if (n5 == 132) {
            n14 = m4(74, getSecretNumber(scramble5));
        }
        else if (n5 == 133) {
            n14 = m4(166, getSecretNumber(scramble5));
        }
        else if (n5 == 134) {
            n14 = m4(147, getSecretNumber(scramble5));
        }
        else if (n5 == 135) {
            n14 = m4(242, getSecretNumber(scramble5));
        }
        else if (n5 == 136) {
            n14 = m4(50, getSecretNumber(scramble5));
        }
        else if (n5 == 137) {
            n14 = m4(103, getSecretNumber(scramble5));
        }
        else if (n5 == 138) {
            n14 = m4(68, getSecretNumber(scramble5));
        }
        else if (n5 == 139) {
            n14 = m4(193, getSecretNumber(scramble5));
        }
        else if (n5 == 140) {
            n14 = m4(67, getSecretNumber(scramble5));
        }
        else if (n5 == 141) {
            n14 = m4(28, getSecretNumber(scramble5));
        }
        else if (n5 == 142) {
            n14 = m4(243, getSecretNumber(scramble5));
        }
        else if (n5 == 143) {
            n14 = m4(162, getSecretNumber(scramble5));
        }
        else if (n5 == 144) {
            n14 = m4(194, getSecretNumber(scramble5));
        }
        else if (n5 == 145) {
            n14 = m4(45, getSecretNumber(scramble5));
        }
        else if (n5 == 146) {
            n14 = m4(43, getSecretNumber(scramble5));
        }
        else if (n5 == 147) {
            n14 = m4(17, getSecretNumber(scramble5));
        }
        else if (n5 == 148) {
            n14 = m4(124, getSecretNumber(scramble5));
        }
        else if (n5 == 149) {
            n14 = m4(31, getSecretNumber(scramble5));
        }
        else if (n5 == 150) {
            n14 = m4(55, getSecretNumber(scramble5));
        }
        else if (n5 == 151) {
            n14 = m4(21, getSecretNumber(scramble5));
        }
        else if (n5 == 152) {
            n14 = m4(47, getSecretNumber(scramble5));
        }
        else if (n5 == 153) {
            n14 = m4(197, getSecretNumber(scramble5));
        }
        else if (n5 == 154) {
            n14 = m4(126, getSecretNumber(scramble5));
        }
        else if (n5 == 155) {
            n14 = m4(122, getSecretNumber(scramble5));
        }
        else if (n5 == 156) {
            n14 = m4(196, getSecretNumber(scramble5));
        }
        else if (n5 == 157) {
            n14 = m4(136, getSecretNumber(scramble5));
        }
        else if (n5 == 158) {
            n14 = m4(204, getSecretNumber(scramble5));
        }
        else if (n5 == 159) {
            n14 = m4(79, getSecretNumber(scramble5));
        }
        else if (n5 == 160) {
            n14 = m4(132, getSecretNumber(scramble5));
        }
        else if (n5 == 161) {
            n14 = m4(32, getSecretNumber(scramble5));
        }
        else if (n5 == 162) {
            n14 = m4(91, getSecretNumber(scramble5));
        }
        else if (n5 == 163) {
            n14 = m4(140, getSecretNumber(scramble5));
        }
        else if (n5 == 164) {
            n14 = m4(234, getSecretNumber(scramble5));
        }
        else if (n5 == 165) {
            n14 = m4(236, getSecretNumber(scramble5));
        }
        else if (n5 == 166) {
            n14 = m4(195, getSecretNumber(scramble5));
        }
        else if (n5 == 167) {
            n14 = m4(125, getSecretNumber(scramble5));
        }
        else if (n5 == 168) {
            n14 = m4(12, getSecretNumber(scramble5));
        }
        else if (n5 == 169) {
            n14 = m4(109, getSecretNumber(scramble5));
        }
        else if (n5 == 170) {
            n14 = m4(185, getSecretNumber(scramble5));
        }
        else if (n5 == 171) {
            n14 = m4(0, getSecretNumber(scramble5));
        }
        else if (n5 == 172) {
            n14 = m4(64, getSecretNumber(scramble5));
        }
        else if (n5 == 173) {
            n14 = m4(137, getSecretNumber(scramble5));
        }
        else if (n5 == 174) {
            n14 = m4(53, getSecretNumber(scramble5));
        }
        else if (n5 == 175) {
            n14 = m4(241, getSecretNumber(scramble5));
        }
        else if (n5 == 176) {
            n14 = m4(178, getSecretNumber(scramble5));
        }
        else if (n5 == 177) {
            n14 = m4(138, getSecretNumber(scramble5));
        }
        else if (n5 == 178) {
            n14 = m4(127, getSecretNumber(scramble5));
        }
        else if (n5 == 179) {
            n14 = m4(112, getSecretNumber(scramble5));
        }
        else if (n5 == 180) {
            n14 = m4(160, getSecretNumber(scramble5));
        }
        else if (n5 == 181) {
            n14 = m4(71, getSecretNumber(scramble5));
        }
        else if (n5 == 182) {
            n14 = m4(87, getSecretNumber(scramble5));
        }
        else if (n5 == 183) {
            n14 = m4(48, getSecretNumber(scramble5));
        }
        else if (n5 == 184) {
            n14 = m4(56, getSecretNumber(scramble5));
        }
        else if (n5 == 185) {
            n14 = m4(120, getSecretNumber(scramble5));
        }
        else if (n5 == 186) {
            n14 = m4(240, getSecretNumber(scramble5));
        }
        else if (n5 == 187) {
            n14 = m4(175, getSecretNumber(scramble5));
        }
        else if (n5 == 188) {
            n14 = m4(40, getSecretNumber(scramble5));
        }
        else if (n5 == 189) {
            n14 = m4(150, getSecretNumber(scramble5));
        }
        else if (n5 == 190) {
            n14 = m4(114, getSecretNumber(scramble5));
        }
        else if (n5 == 191) {
            n14 = m4(119, getSecretNumber(scramble5));
        }
        else if (n5 == 192) {
            n14 = m4(221, getSecretNumber(scramble5));
        }
        else if (n5 == 193) {
            n14 = m4(146, getSecretNumber(scramble5));
        }
        else if (n5 == 194) {
            n14 = m4(201, getSecretNumber(scramble5));
        }
        else if (n5 == 195) {
            n14 = m4(228, getSecretNumber(scramble5));
        }
        else if (n5 == 196) {
            n14 = m4(224, getSecretNumber(scramble5));
        }
        else if (n5 == 197) {
            n14 = m4(44, getSecretNumber(scramble5));
        }
        else if (n5 == 198) {
            n14 = m4(152, getSecretNumber(scramble5));
        }
        else if (n5 == 199) {
            n14 = m4(227, getSecretNumber(scramble5));
        }
        else if (n5 == 200) {
            n14 = m4(86, getSecretNumber(scramble5));
        }
        else if (n5 == 201) {
            n14 = m4(156, getSecretNumber(scramble5));
        }
        else if (n5 == 202) {
            n14 = m4(212, getSecretNumber(scramble5));
        }
        else if (n5 == 203) {
            n14 = m4(62, getSecretNumber(scramble5));
        }
        else if (n5 == 204) {
            n14 = m4(80, getSecretNumber(scramble5));
        }
        else if (n5 == 205) {
            n14 = m4(96, getSecretNumber(scramble5));
        }
        else if (n5 == 206) {
            n14 = m4(208, getSecretNumber(scramble5));
        }
        else if (n5 == 207) {
            n14 = m4(63, getSecretNumber(scramble5));
        }
        else if (n5 == 208) {
            n14 = m4(253, getSecretNumber(scramble5));
        }
        else if (n5 == 209) {
            n14 = m4(108, getSecretNumber(scramble5));
        }
        else if (n5 == 210) {
            n14 = m4(203, getSecretNumber(scramble5));
        }
        else if (n5 == 211) {
            n14 = m4(165, getSecretNumber(scramble5));
        }
        else if (n5 == 212) {
            n14 = m4(115, getSecretNumber(scramble5));
        }
        else if (n5 == 213) {
            n14 = m4(128, getSecretNumber(scramble5));
        }
        else if (n5 == 214) {
            n14 = m4(90, getSecretNumber(scramble5));
        }
        else if (n5 == 215) {
            n14 = m4(210, getSecretNumber(scramble5));
        }
        else if (n5 == 216) {
            n14 = m4(153, getSecretNumber(scramble5));
        }
        else if (n5 == 217) {
            n14 = m4(1, getSecretNumber(scramble5));
        }
        else if (n5 == 218) {
            n14 = m4(85, getSecretNumber(scramble5));
        }
        else if (n5 == 219) {
            n14 = m4(41, getSecretNumber(scramble5));
        }
        else if (n5 == 220) {
            n14 = m4(83, getSecretNumber(scramble5));
        }
        else if (n5 == 221) {
            n14 = m4(13, getSecretNumber(scramble5));
        }
        else if (n5 == 222) {
            n14 = m4(148, getSecretNumber(scramble5));
        }
        else if (n5 == 223) {
            n14 = m4(232, getSecretNumber(scramble5));
        }
        else if (n5 == 224) {
            n14 = m4(27, getSecretNumber(scramble5));
        }
        else if (n5 == 225) {
            n14 = m4(97, getSecretNumber(scramble5));
        }
        else if (n5 == 226) {
            n14 = m4(60, getSecretNumber(scramble5));
        }
        else if (n5 == 227) {
            n14 = m4(107, getSecretNumber(scramble5));
        }
        else if (n5 == 228) {
            n14 = m4(189, getSecretNumber(scramble5));
        }
        else if (n5 == 229) {
            n14 = m4(218, getSecretNumber(scramble5));
        }
        else if (n5 == 230) {
            n14 = m4(187, getSecretNumber(scramble5));
        }
        else if (n5 == 231) {
            n14 = m4(211, getSecretNumber(scramble5));
        }
        else if (n5 == 232) {
            n14 = m4(191, getSecretNumber(scramble5));
        }
        else if (n5 == 233) {
            n14 = m4(163, getSecretNumber(scramble5));
        }
        else if (n5 == 234) {
            n14 = m4(139, getSecretNumber(scramble5));
        }
        else if (n5 == 235) {
            n14 = m4(239, getSecretNumber(scramble5));
        }
        else if (n5 == 236) {
            n14 = m4(77, getSecretNumber(scramble5));
        }
        else if (n5 == 237) {
            n14 = m4(209, getSecretNumber(scramble5));
        }
        else if (n5 == 238) {
            n14 = m4(29, getSecretNumber(scramble5));
        }
        else if (n5 == 239) {
            n14 = m4(223, getSecretNumber(scramble5));
        }
        else if (n5 == 240) {
            n14 = m4(94, getSecretNumber(scramble5));
        }
        else if (n5 == 241) {
            n14 = m4(117, getSecretNumber(scramble5));
        }
        else if (n5 == 242) {
            n14 = m4(82, getSecretNumber(scramble5));
        }
        else if (n5 == 243) {
            n14 = m4(81, getSecretNumber(scramble5));
        }
        else if (n5 == 244) {
            n14 = m4(14, getSecretNumber(scramble5));
        }
        else if (n5 == 245) {
            n14 = m4(217, getSecretNumber(scramble5));
        }
        else if (n5 == 246) {
            n14 = m4(5, getSecretNumber(scramble5));
        }
        else if (n5 == 247) {
            n14 = m4(33, getSecretNumber(scramble5));
        }
        else if (n5 == 248) {
            n14 = m4(174, getSecretNumber(scramble5));
        }
        else if (n5 == 249) {
            n14 = m4(180, getSecretNumber(scramble5));
        }
        else if (n5 == 250) {
            n14 = m4(252, getSecretNumber(scramble5));
        }
        else if (n5 == 251) {
            n14 = m4(231, getSecretNumber(scramble5));
        }
        else if (n5 == 252) {
            n14 = m4(220, getSecretNumber(scramble5));
        }
        else if (n5 == 253) {
            n14 = m4(36, getSecretNumber(scramble5));
        }
        else if (n5 == 254) {
            n14 = m4(46, getSecretNumber(scramble5));
        }
        else if (n5 == 255) {
            n14 = m4(249, getSecretNumber(scramble5));
        }
        else {
            n14 = 0;
        }
        if ((n14 & 0xCA) != 0x82) {
            return false;
        }
        if ((n6 & 0x41) != 0x41) {
            return false;
        }
        final int scramble6 = scramble(scramble5);
        int n15;
        if (n7 == 0) {
            n15 = m6(6, getSecretNumber(scramble6));
        }
        else if (n7 == 1) {
            n15 = m6(112, getSecretNumber(scramble6));
        }
        else if (n7 == 2) {
            n15 = m6(67, getSecretNumber(scramble6));
        }
        else if (n7 == 3) {
            n15 = m6(152, getSecretNumber(scramble6));
        }
        else if (n7 == 4) {
            n15 = m6(88, getSecretNumber(scramble6));
        }
        else if (n7 == 5) {
            n15 = m6(74, getSecretNumber(scramble6));
        }
        else if (n7 == 6) {
            n15 = m6(161, getSecretNumber(scramble6));
        }
        else if (n7 == 7) {
            n15 = m6(124, getSecretNumber(scramble6));
        }
        else if (n7 == 8) {
            n15 = m6(42, getSecretNumber(scramble6));
        }
        else if (n7 == 9) {
            n15 = m6(100, getSecretNumber(scramble6));
        }
        else if (n7 == 10) {
            n15 = m6(247, getSecretNumber(scramble6));
        }
        else if (n7 == 11) {
            n15 = m6(70, getSecretNumber(scramble6));
        }
        else if (n7 == 12) {
            n15 = m6(226, getSecretNumber(scramble6));
        }
        else if (n7 == 13) {
            n15 = m6(19, getSecretNumber(scramble6));
        }
        else if (n7 == 14) {
            n15 = m6(215, getSecretNumber(scramble6));
        }
        else if (n7 == 15) {
            n15 = m6(61, getSecretNumber(scramble6));
        }
        else if (n7 == 16) {
            n15 = m6(141, getSecretNumber(scramble6));
        }
        else if (n7 == 17) {
            n15 = m6(186, getSecretNumber(scramble6));
        }
        else if (n7 == 18) {
            n15 = m6(190, getSecretNumber(scramble6));
        }
        else if (n7 == 19) {
            n15 = m6(129, getSecretNumber(scramble6));
        }
        else if (n7 == 20) {
            n15 = m6(24, getSecretNumber(scramble6));
        }
        else if (n7 == 21) {
            n15 = m6(255, getSecretNumber(scramble6));
        }
        else if (n7 == 22) {
            n15 = m6(173, getSecretNumber(scramble6));
        }
        else if (n7 == 23) {
            n15 = m6(131, getSecretNumber(scramble6));
        }
        else if (n7 == 24) {
            n15 = m6(23, getSecretNumber(scramble6));
        }
        else if (n7 == 25) {
            n15 = m6(180, getSecretNumber(scramble6));
        }
        else if (n7 == 26) {
            n15 = m6(25, getSecretNumber(scramble6));
        }
        else if (n7 == 27) {
            n15 = m6(27, getSecretNumber(scramble6));
        }
        else if (n7 == 28) {
            n15 = m6(33, getSecretNumber(scramble6));
        }
        else if (n7 == 29) {
            n15 = m6(84, getSecretNumber(scramble6));
        }
        else if (n7 == 30) {
            n15 = m6(237, getSecretNumber(scramble6));
        }
        else if (n7 == 31) {
            n15 = m6(245, getSecretNumber(scramble6));
        }
        else if (n7 == 32) {
            n15 = m6(30, getSecretNumber(scramble6));
        }
        else if (n7 == 33) {
            n15 = m6(45, getSecretNumber(scramble6));
        }
        else if (n7 == 34) {
            n15 = m6(8, getSecretNumber(scramble6));
        }
        else if (n7 == 35) {
            n15 = m6(122, getSecretNumber(scramble6));
        }
        else if (n7 == 36) {
            n15 = m6(126, getSecretNumber(scramble6));
        }
        else if (n7 == 37) {
            n15 = m6(133, getSecretNumber(scramble6));
        }
        else if (n7 == 38) {
            n15 = m6(234, getSecretNumber(scramble6));
        }
        else if (n7 == 39) {
            n15 = m6(114, getSecretNumber(scramble6));
        }
        else if (n7 == 40) {
            n15 = m6(185, getSecretNumber(scramble6));
        }
        else if (n7 == 41) {
            n15 = m6(89, getSecretNumber(scramble6));
        }
        else if (n7 == 42) {
            n15 = m6(97, getSecretNumber(scramble6));
        }
        else if (n7 == 43) {
            n15 = m6(203, getSecretNumber(scramble6));
        }
        else if (n7 == 44) {
            n15 = m6(125, getSecretNumber(scramble6));
        }
        else if (n7 == 45) {
            n15 = m6(10, getSecretNumber(scramble6));
        }
        else if (n7 == 46) {
            n15 = m6(90, getSecretNumber(scramble6));
        }
        else if (n7 == 47) {
            n15 = m6(213, getSecretNumber(scramble6));
        }
        else if (n7 == 48) {
            n15 = m6(71, getSecretNumber(scramble6));
        }
        else if (n7 == 49) {
            n15 = m6(99, getSecretNumber(scramble6));
        }
        else if (n7 == 50) {
            n15 = m6(172, getSecretNumber(scramble6));
        }
        else if (n7 == 51) {
            n15 = m6(196, getSecretNumber(scramble6));
        }
        else if (n7 == 52) {
            n15 = m6(224, getSecretNumber(scramble6));
        }
        else if (n7 == 53) {
            n15 = m6(208, getSecretNumber(scramble6));
        }
        else if (n7 == 54) {
            n15 = m6(251, getSecretNumber(scramble6));
        }
        else if (n7 == 55) {
            n15 = m6(206, getSecretNumber(scramble6));
        }
        else if (n7 == 56) {
            n15 = m6(209, getSecretNumber(scramble6));
        }
        else if (n7 == 57) {
            n15 = m6(142, getSecretNumber(scramble6));
        }
        else if (n7 == 58) {
            n15 = m6(91, getSecretNumber(scramble6));
        }
        else if (n7 == 59) {
            n15 = m6(239, getSecretNumber(scramble6));
        }
        else if (n7 == 60) {
            n15 = m6(174, getSecretNumber(scramble6));
        }
        else if (n7 == 61) {
            n15 = m6(176, getSecretNumber(scramble6));
        }
        else if (n7 == 62) {
            n15 = m6(94, getSecretNumber(scramble6));
        }
        else if (n7 == 63) {
            n15 = m6(0, getSecretNumber(scramble6));
        }
        else if (n7 == 64) {
            n15 = m6(4, getSecretNumber(scramble6));
        }
        else if (n7 == 65) {
            n15 = m6(75, getSecretNumber(scramble6));
        }
        else if (n7 == 66) {
            n15 = m6(167, getSecretNumber(scramble6));
        }
        else if (n7 == 67) {
            n15 = m6(222, getSecretNumber(scramble6));
        }
        else if (n7 == 68) {
            n15 = m6(205, getSecretNumber(scramble6));
        }
        else if (n7 == 69) {
            n15 = m6(146, getSecretNumber(scramble6));
        }
        else if (n7 == 70) {
            n15 = m6(156, getSecretNumber(scramble6));
        }
        else if (n7 == 71) {
            n15 = m6(108, getSecretNumber(scramble6));
        }
        else if (n7 == 72) {
            n15 = m6(240, getSecretNumber(scramble6));
        }
        else if (n7 == 73) {
            n15 = m6(199, getSecretNumber(scramble6));
        }
        else if (n7 == 74) {
            n15 = m6(76, getSecretNumber(scramble6));
        }
        else if (n7 == 75) {
            n15 = m6(238, getSecretNumber(scramble6));
        }
        else if (n7 == 76) {
            n15 = m6(18, getSecretNumber(scramble6));
        }
        else if (n7 == 77) {
            n15 = m6(51, getSecretNumber(scramble6));
        }
        else if (n7 == 78) {
            n15 = m6(63, getSecretNumber(scramble6));
        }
        else if (n7 == 79) {
            n15 = m6(228, getSecretNumber(scramble6));
        }
        else if (n7 == 80) {
            n15 = m6(113, getSecretNumber(scramble6));
        }
        else if (n7 == 81) {
            n15 = m6(16, getSecretNumber(scramble6));
        }
        else if (n7 == 82) {
            n15 = m6(158, getSecretNumber(scramble6));
        }
        else if (n7 == 83) {
            n15 = m6(182, getSecretNumber(scramble6));
        }
        else if (n7 == 84) {
            n15 = m6(183, getSecretNumber(scramble6));
        }
        else if (n7 == 85) {
            n15 = m6(69, getSecretNumber(scramble6));
        }
        else if (n7 == 86) {
            n15 = m6(110, getSecretNumber(scramble6));
        }
        else if (n7 == 87) {
            n15 = m6(9, getSecretNumber(scramble6));
        }
        else if (n7 == 88) {
            n15 = m6(65, getSecretNumber(scramble6));
        }
        else if (n7 == 89) {
            n15 = m6(120, getSecretNumber(scramble6));
        }
        else if (n7 == 90) {
            n15 = m6(249, getSecretNumber(scramble6));
        }
        else if (n7 == 91) {
            n15 = m6(204, getSecretNumber(scramble6));
        }
        else if (n7 == 92) {
            n15 = m6(81, getSecretNumber(scramble6));
        }
        else if (n7 == 93) {
            n15 = m6(233, getSecretNumber(scramble6));
        }
        else if (n7 == 94) {
            n15 = m6(34, getSecretNumber(scramble6));
        }
        else if (n7 == 95) {
            n15 = m6(62, getSecretNumber(scramble6));
        }
        else if (n7 == 96) {
            n15 = m6(220, getSecretNumber(scramble6));
        }
        else if (n7 == 97) {
            n15 = m6(216, getSecretNumber(scramble6));
        }
        else if (n7 == 98) {
            n15 = m6(166, getSecretNumber(scramble6));
        }
        else if (n7 == 99) {
            n15 = m6(162, getSecretNumber(scramble6));
        }
        else if (n7 == 100) {
            n15 = m6(57, getSecretNumber(scramble6));
        }
        else if (n7 == 101) {
            n15 = m6(13, getSecretNumber(scramble6));
        }
        else if (n7 == 102) {
            n15 = m6(78, getSecretNumber(scramble6));
        }
        else if (n7 == 103) {
            n15 = m6(192, getSecretNumber(scramble6));
        }
        else if (n7 == 104) {
            n15 = m6(159, getSecretNumber(scramble6));
        }
        else if (n7 == 105) {
            n15 = m6(7, getSecretNumber(scramble6));
        }
        else if (n7 == 106) {
            n15 = m6(191, getSecretNumber(scramble6));
        }
        else if (n7 == 107) {
            n15 = m6(171, getSecretNumber(scramble6));
        }
        else if (n7 == 108) {
            n15 = m6(17, getSecretNumber(scramble6));
        }
        else if (n7 == 109) {
            n15 = m6(188, getSecretNumber(scramble6));
        }
        else if (n7 == 110) {
            n15 = m6(211, getSecretNumber(scramble6));
        }
        else if (n7 == 111) {
            n15 = m6(218, getSecretNumber(scramble6));
        }
        else if (n7 == 112) {
            n15 = m6(168, getSecretNumber(scramble6));
        }
        else if (n7 == 113) {
            n15 = m6(246, getSecretNumber(scramble6));
        }
        else if (n7 == 114) {
            n15 = m6(135, getSecretNumber(scramble6));
        }
        else if (n7 == 115) {
            n15 = m6(128, getSecretNumber(scramble6));
        }
        else if (n7 == 116) {
            n15 = m6(56, getSecretNumber(scramble6));
        }
        else if (n7 == 117) {
            n15 = m6(225, getSecretNumber(scramble6));
        }
        else if (n7 == 118) {
            n15 = m6(140, getSecretNumber(scramble6));
        }
        else if (n7 == 119) {
            n15 = m6(232, getSecretNumber(scramble6));
        }
        else if (n7 == 120) {
            n15 = m6(231, getSecretNumber(scramble6));
        }
        else if (n7 == 121) {
            n15 = m6(107, getSecretNumber(scramble6));
        }
        else if (n7 == 122) {
            n15 = m6(14, getSecretNumber(scramble6));
        }
        else if (n7 == 123) {
            n15 = m6(11, getSecretNumber(scramble6));
        }
        else if (n7 == 124) {
            n15 = m6(58, getSecretNumber(scramble6));
        }
        else if (n7 == 125) {
            n15 = m6(153, getSecretNumber(scramble6));
        }
        else if (n7 == 126) {
            n15 = m6(136, getSecretNumber(scramble6));
        }
        else if (n7 == 127) {
            n15 = m6(201, getSecretNumber(scramble6));
        }
        else if (n7 == 128) {
            n15 = m6(60, getSecretNumber(scramble6));
        }
        else if (n7 == 129) {
            n15 = m6(36, getSecretNumber(scramble6));
        }
        else if (n7 == 130) {
            n15 = m6(132, getSecretNumber(scramble6));
        }
        else if (n7 == 131) {
            n15 = m6(243, getSecretNumber(scramble6));
        }
        else if (n7 == 132) {
            n15 = m6(111, getSecretNumber(scramble6));
        }
        else if (n7 == 133) {
            n15 = m6(73, getSecretNumber(scramble6));
        }
        else if (n7 == 134) {
            n15 = m6(163, getSecretNumber(scramble6));
        }
        else if (n7 == 135) {
            n15 = m6(144, getSecretNumber(scramble6));
        }
        else if (n7 == 136) {
            n15 = m6(164, getSecretNumber(scramble6));
        }
        else if (n7 == 137) {
            n15 = m6(39, getSecretNumber(scramble6));
        }
        else if (n7 == 138) {
            n15 = m6(236, getSecretNumber(scramble6));
        }
        else if (n7 == 139) {
            n15 = m6(137, getSecretNumber(scramble6));
        }
        else if (n7 == 140) {
            n15 = m6(77, getSecretNumber(scramble6));
        }
        else if (n7 == 141) {
            n15 = m6(160, getSecretNumber(scramble6));
        }
        else if (n7 == 142) {
            n15 = m6(47, getSecretNumber(scramble6));
        }
        else if (n7 == 143) {
            n15 = m6(241, getSecretNumber(scramble6));
        }
        else if (n7 == 144) {
            n15 = m6(87, getSecretNumber(scramble6));
        }
        else if (n7 == 145) {
            n15 = m6(66, getSecretNumber(scramble6));
        }
        else if (n7 == 146) {
            n15 = m6(200, getSecretNumber(scramble6));
        }
        else if (n7 == 147) {
            n15 = m6(223, getSecretNumber(scramble6));
        }
        else if (n7 == 148) {
            n15 = m6(170, getSecretNumber(scramble6));
        }
        else if (n7 == 149) {
            n15 = m6(250, getSecretNumber(scramble6));
        }
        else if (n7 == 150) {
            n15 = m6(37, getSecretNumber(scramble6));
        }
        else if (n7 == 151) {
            n15 = m6(103, getSecretNumber(scramble6));
        }
        else if (n7 == 152) {
            n15 = m6(92, getSecretNumber(scramble6));
        }
        else if (n7 == 153) {
            n15 = m6(157, getSecretNumber(scramble6));
        }
        else if (n7 == 154) {
            n15 = m6(96, getSecretNumber(scramble6));
        }
        else if (n7 == 155) {
            n15 = m6(105, getSecretNumber(scramble6));
        }
        else if (n7 == 156) {
            n15 = m6(217, getSecretNumber(scramble6));
        }
        else if (n7 == 157) {
            n15 = m6(28, getSecretNumber(scramble6));
        }
        else if (n7 == 158) {
            n15 = m6(139, getSecretNumber(scramble6));
        }
        else if (n7 == 159) {
            n15 = m6(53, getSecretNumber(scramble6));
        }
        else if (n7 == 160) {
            n15 = m6(93, getSecretNumber(scramble6));
        }
        else if (n7 == 161) {
            n15 = m6(82, getSecretNumber(scramble6));
        }
        else if (n7 == 162) {
            n15 = m6(179, getSecretNumber(scramble6));
        }
        else if (n7 == 163) {
            n15 = m6(130, getSecretNumber(scramble6));
        }
        else if (n7 == 164) {
            n15 = m6(195, getSecretNumber(scramble6));
        }
        else if (n7 == 165) {
            n15 = m6(35, getSecretNumber(scramble6));
        }
        else if (n7 == 166) {
            n15 = m6(2, getSecretNumber(scramble6));
        }
        else if (n7 == 167) {
            n15 = m6(26, getSecretNumber(scramble6));
        }
        else if (n7 == 168) {
            n15 = m6(59, getSecretNumber(scramble6));
        }
        else if (n7 == 169) {
            n15 = m6(229, getSecretNumber(scramble6));
        }
        else if (n7 == 170) {
            n15 = m6(101, getSecretNumber(scramble6));
        }
        else if (n7 == 171) {
            n15 = m6(116, getSecretNumber(scramble6));
        }
        else if (n7 == 172) {
            n15 = m6(147, getSecretNumber(scramble6));
        }
        else if (n7 == 173) {
            n15 = m6(109, getSecretNumber(scramble6));
        }
        else if (n7 == 174) {
            n15 = m6(40, getSecretNumber(scramble6));
        }
        else if (n7 == 175) {
            n15 = m6(44, getSecretNumber(scramble6));
        }
        else if (n7 == 176) {
            n15 = m6(214, getSecretNumber(scramble6));
        }
        else if (n7 == 177) {
            n15 = m6(184, getSecretNumber(scramble6));
        }
        else if (n7 == 178) {
            n15 = m6(235, getSecretNumber(scramble6));
        }
        else if (n7 == 179) {
            n15 = m6(80, getSecretNumber(scramble6));
        }
        else if (n7 == 180) {
            n15 = m6(154, getSecretNumber(scramble6));
        }
        else if (n7 == 181) {
            n15 = m6(79, getSecretNumber(scramble6));
        }
        else if (n7 == 182) {
            n15 = m6(21, getSecretNumber(scramble6));
        }
        else if (n7 == 183) {
            n15 = m6(43, getSecretNumber(scramble6));
        }
        else if (n7 == 184) {
            n15 = m6(119, getSecretNumber(scramble6));
        }
        else if (n7 == 185) {
            n15 = m6(207, getSecretNumber(scramble6));
        }
        else if (n7 == 186) {
            n15 = m6(193, getSecretNumber(scramble6));
        }
        else if (n7 == 187) {
            n15 = m6(104, getSecretNumber(scramble6));
        }
        else if (n7 == 188) {
            n15 = m6(102, getSecretNumber(scramble6));
        }
        else if (n7 == 189) {
            n15 = m6(244, getSecretNumber(scramble6));
        }
        else if (n7 == 190) {
            n15 = m6(22, getSecretNumber(scramble6));
        }
        else if (n7 == 191) {
            n15 = m6(85, getSecretNumber(scramble6));
        }
        else if (n7 == 192) {
            n15 = m6(68, getSecretNumber(scramble6));
        }
        else if (n7 == 193) {
            n15 = m6(106, getSecretNumber(scramble6));
        }
        else if (n7 == 194) {
            n15 = m6(202, getSecretNumber(scramble6));
        }
        else if (n7 == 195) {
            n15 = m6(151, getSecretNumber(scramble6));
        }
        else if (n7 == 196) {
            n15 = m6(254, getSecretNumber(scramble6));
        }
        else if (n7 == 197) {
            n15 = m6(41, getSecretNumber(scramble6));
        }
        else if (n7 == 198) {
            n15 = m6(145, getSecretNumber(scramble6));
        }
        else if (n7 == 199) {
            n15 = m6(15, getSecretNumber(scramble6));
        }
        else if (n7 == 200) {
            n15 = m6(98, getSecretNumber(scramble6));
        }
        else if (n7 == 201) {
            n15 = m6(219, getSecretNumber(scramble6));
        }
        else if (n7 == 202) {
            n15 = m6(49, getSecretNumber(scramble6));
        }
        else if (n7 == 203) {
            n15 = m6(117, getSecretNumber(scramble6));
        }
        else if (n7 == 204) {
            n15 = m6(143, getSecretNumber(scramble6));
        }
        else if (n7 == 205) {
            n15 = m6(5, getSecretNumber(scramble6));
        }
        else if (n7 == 206) {
            n15 = m6(48, getSecretNumber(scramble6));
        }
        else if (n7 == 207) {
            n15 = m6(72, getSecretNumber(scramble6));
        }
        else if (n7 == 208) {
            n15 = m6(86, getSecretNumber(scramble6));
        }
        else if (n7 == 209) {
            n15 = m6(20, getSecretNumber(scramble6));
        }
        else if (n7 == 210) {
            n15 = m6(198, getSecretNumber(scramble6));
        }
        else if (n7 == 211) {
            n15 = m6(12, getSecretNumber(scramble6));
        }
        else if (n7 == 212) {
            n15 = m6(253, getSecretNumber(scramble6));
        }
        else if (n7 == 213) {
            n15 = m6(248, getSecretNumber(scramble6));
        }
        else if (n7 == 214) {
            n15 = m6(1, getSecretNumber(scramble6));
        }
        else if (n7 == 215) {
            n15 = m6(118, getSecretNumber(scramble6));
        }
        else if (n7 == 216) {
            n15 = m6(242, getSecretNumber(scramble6));
        }
        else if (n7 == 217) {
            n15 = m6(177, getSecretNumber(scramble6));
        }
        else if (n7 == 218) {
            n15 = m6(29, getSecretNumber(scramble6));
        }
        else if (n7 == 219) {
            n15 = m6(175, getSecretNumber(scramble6));
        }
        else if (n7 == 220) {
            n15 = m6(148, getSecretNumber(scramble6));
        }
        else if (n7 == 221) {
            n15 = m6(227, getSecretNumber(scramble6));
        }
        else if (n7 == 222) {
            n15 = m6(121, getSecretNumber(scramble6));
        }
        else if (n7 == 223) {
            n15 = m6(115, getSecretNumber(scramble6));
        }
        else if (n7 == 224) {
            n15 = m6(50, getSecretNumber(scramble6));
        }
        else if (n7 == 225) {
            n15 = m6(134, getSecretNumber(scramble6));
        }
        else if (n7 == 226) {
            n15 = m6(123, getSecretNumber(scramble6));
        }
        else if (n7 == 227) {
            n15 = m6(3, getSecretNumber(scramble6));
        }
        else if (n7 == 228) {
            n15 = m6(83, getSecretNumber(scramble6));
        }
        else if (n7 == 229) {
            n15 = m6(38, getSecretNumber(scramble6));
        }
        else if (n7 == 230) {
            n15 = m6(194, getSecretNumber(scramble6));
        }
        else if (n7 == 231) {
            n15 = m6(54, getSecretNumber(scramble6));
        }
        else if (n7 == 232) {
            n15 = m6(230, getSecretNumber(scramble6));
        }
        else if (n7 == 233) {
            n15 = m6(127, getSecretNumber(scramble6));
        }
        else if (n7 == 234) {
            n15 = m6(210, getSecretNumber(scramble6));
        }
        else if (n7 == 235) {
            n15 = m6(64, getSecretNumber(scramble6));
        }
        else if (n7 == 236) {
            n15 = m6(189, getSecretNumber(scramble6));
        }
        else if (n7 == 237) {
            n15 = m6(165, getSecretNumber(scramble6));
        }
        else if (n7 == 238) {
            n15 = m6(149, getSecretNumber(scramble6));
        }
        else if (n7 == 239) {
            n15 = m6(181, getSecretNumber(scramble6));
        }
        else if (n7 == 240) {
            n15 = m6(252, getSecretNumber(scramble6));
        }
        else if (n7 == 241) {
            n15 = m6(212, getSecretNumber(scramble6));
        }
        else if (n7 == 242) {
            n15 = m6(32, getSecretNumber(scramble6));
        }
        else if (n7 == 243) {
            n15 = m6(95, getSecretNumber(scramble6));
        }
        else if (n7 == 244) {
            n15 = m6(187, getSecretNumber(scramble6));
        }
        else if (n7 == 245) {
            n15 = m6(155, getSecretNumber(scramble6));
        }
        else if (n7 == 246) {
            n15 = m6(150, getSecretNumber(scramble6));
        }
        else if (n7 == 247) {
            n15 = m6(55, getSecretNumber(scramble6));
        }
        else if (n7 == 248) {
            n15 = m6(178, getSecretNumber(scramble6));
        }
        else if (n7 == 249) {
            n15 = m6(46, getSecretNumber(scramble6));
        }
        else if (n7 == 250) {
            n15 = m6(221, getSecretNumber(scramble6));
        }
        else if (n7 == 251) {
            n15 = m6(169, getSecretNumber(scramble6));
        }
        else if (n7 == 252) {
            n15 = m6(31, getSecretNumber(scramble6));
        }
        else if (n7 == 253) {
            n15 = m6(52, getSecretNumber(scramble6));
        }
        else if (n7 == 254) {
            n15 = m6(138, getSecretNumber(scramble6));
        }
        else if (n7 == 255) {
            n15 = m6(197, getSecretNumber(scramble6));
        }
        else {
            n15 = 0;
        }
        if ((n15 & 0xFF) != 0xEC) {
            return false;
        }
        final int scramble7 = scramble(scramble6);
        int n16;
        if (n8 == 0) {
            n16 = m7(208, getSecretNumber(scramble7));
        }
        else if (n8 == 1) {
            n16 = m7(168, getSecretNumber(scramble7));
        }
        else if (n8 == 2) {
            n16 = m7(97, getSecretNumber(scramble7));
        }
        else if (n8 == 3) {
            n16 = m7(242, getSecretNumber(scramble7));
        }
        else if (n8 == 4) {
            n16 = m7(78, getSecretNumber(scramble7));
        }
        else if (n8 == 5) {
            n16 = m7(60, getSecretNumber(scramble7));
        }
        else if (n8 == 6) {
            n16 = m7(100, getSecretNumber(scramble7));
        }
        else if (n8 == 7) {
            n16 = m7(128, getSecretNumber(scramble7));
        }
        else if (n8 == 8) {
            n16 = m7(232, getSecretNumber(scramble7));
        }
        else if (n8 == 9) {
            n16 = m7(152, getSecretNumber(scramble7));
        }
        else if (n8 == 10) {
            n16 = m7(127, getSecretNumber(scramble7));
        }
        else if (n8 == 11) {
            n16 = m7(115, getSecretNumber(scramble7));
        }
        else if (n8 == 12) {
            n16 = m7(253, getSecretNumber(scramble7));
        }
        else if (n8 == 13) {
            n16 = m7(36, getSecretNumber(scramble7));
        }
        else if (n8 == 14) {
            n16 = m7(174, getSecretNumber(scramble7));
        }
        else if (n8 == 15) {
            n16 = m7(209, getSecretNumber(scramble7));
        }
        else if (n8 == 16) {
            n16 = m7(181, getSecretNumber(scramble7));
        }
        else if (n8 == 17) {
            n16 = m7(159, getSecretNumber(scramble7));
        }
        else if (n8 == 18) {
            n16 = m7(88, getSecretNumber(scramble7));
        }
        else if (n8 == 19) {
            n16 = m7(165, getSecretNumber(scramble7));
        }
        else if (n8 == 20) {
            n16 = m7(19, getSecretNumber(scramble7));
        }
        else if (n8 == 21) {
            n16 = m7(212, getSecretNumber(scramble7));
        }
        else if (n8 == 22) {
            n16 = m7(211, getSecretNumber(scramble7));
        }
        else if (n8 == 23) {
            n16 = m7(111, getSecretNumber(scramble7));
        }
        else if (n8 == 24) {
            n16 = m7(26, getSecretNumber(scramble7));
        }
        else if (n8 == 25) {
            n16 = m7(12, getSecretNumber(scramble7));
        }
        else if (n8 == 26) {
            n16 = m7(229, getSecretNumber(scramble7));
        }
        else if (n8 == 27) {
            n16 = m7(43, getSecretNumber(scramble7));
        }
        else if (n8 == 28) {
            n16 = m7(8, getSecretNumber(scramble7));
        }
        else if (n8 == 29) {
            n16 = m7(136, getSecretNumber(scramble7));
        }
        else if (n8 == 30) {
            n16 = m7(199, getSecretNumber(scramble7));
        }
        else if (n8 == 31) {
            n16 = m7(240, getSecretNumber(scramble7));
        }
        else if (n8 == 32) {
            n16 = m7(135, getSecretNumber(scramble7));
        }
        else if (n8 == 33) {
            n16 = m7(178, getSecretNumber(scramble7));
        }
        else if (n8 == 34) {
            n16 = m7(44, getSecretNumber(scramble7));
        }
        else if (n8 == 35) {
            n16 = m7(48, getSecretNumber(scramble7));
        }
        else if (n8 == 36) {
            n16 = m7(82, getSecretNumber(scramble7));
        }
        else if (n8 == 37) {
            n16 = m7(125, getSecretNumber(scramble7));
        }
        else if (n8 == 38) {
            n16 = m7(254, getSecretNumber(scramble7));
        }
        else if (n8 == 39) {
            n16 = m7(195, getSecretNumber(scramble7));
        }
        else if (n8 == 40) {
            n16 = m7(173, getSecretNumber(scramble7));
        }
        else if (n8 == 41) {
            n16 = m7(207, getSecretNumber(scramble7));
        }
        else if (n8 == 42) {
            n16 = m7(121, getSecretNumber(scramble7));
        }
        else if (n8 == 43) {
            n16 = m7(233, getSecretNumber(scramble7));
        }
        else if (n8 == 44) {
            n16 = m7(68, getSecretNumber(scramble7));
        }
        else if (n8 == 45) {
            n16 = m7(84, getSecretNumber(scramble7));
        }
        else if (n8 == 46) {
            n16 = m7(52, getSecretNumber(scramble7));
        }
        else if (n8 == 47) {
            n16 = m7(215, getSecretNumber(scramble7));
        }
        else if (n8 == 48) {
            n16 = m7(137, getSecretNumber(scramble7));
        }
        else if (n8 == 49) {
            n16 = m7(158, getSecretNumber(scramble7));
        }
        else if (n8 == 50) {
            n16 = m7(154, getSecretNumber(scramble7));
        }
        else if (n8 == 51) {
            n16 = m7(69, getSecretNumber(scramble7));
        }
        else if (n8 == 52) {
            n16 = m7(186, getSecretNumber(scramble7));
        }
        else if (n8 == 53) {
            n16 = m7(133, getSecretNumber(scramble7));
        }
        else if (n8 == 54) {
            n16 = m7(51, getSecretNumber(scramble7));
        }
        else if (n8 == 55) {
            n16 = m7(180, getSecretNumber(scramble7));
        }
        else if (n8 == 56) {
            n16 = m7(80, getSecretNumber(scramble7));
        }
        else if (n8 == 57) {
            n16 = m7(126, getSecretNumber(scramble7));
        }
        else if (n8 == 58) {
            n16 = m7(144, getSecretNumber(scramble7));
        }
        else if (n8 == 59) {
            n16 = m7(226, getSecretNumber(scramble7));
        }
        else if (n8 == 60) {
            n16 = m7(40, getSecretNumber(scramble7));
        }
        else if (n8 == 61) {
            n16 = m7(2, getSecretNumber(scramble7));
        }
        else if (n8 == 62) {
            n16 = m7(66, getSecretNumber(scramble7));
        }
        else if (n8 == 63) {
            n16 = m7(38, getSecretNumber(scramble7));
        }
        else if (n8 == 64) {
            n16 = m7(244, getSecretNumber(scramble7));
        }
        else if (n8 == 65) {
            n16 = m7(171, getSecretNumber(scramble7));
        }
        else if (n8 == 66) {
            n16 = m7(67, getSecretNumber(scramble7));
        }
        else if (n8 == 67) {
            n16 = m7(118, getSecretNumber(scramble7));
        }
        else if (n8 == 68) {
            n16 = m7(57, getSecretNumber(scramble7));
        }
        else if (n8 == 69) {
            n16 = m7(247, getSecretNumber(scramble7));
        }
        else if (n8 == 70) {
            n16 = m7(112, getSecretNumber(scramble7));
        }
        else if (n8 == 71) {
            n16 = m7(18, getSecretNumber(scramble7));
        }
        else if (n8 == 72) {
            n16 = m7(138, getSecretNumber(scramble7));
        }
        else if (n8 == 73) {
            n16 = m7(231, getSecretNumber(scramble7));
        }
        else if (n8 == 74) {
            n16 = m7(202, getSecretNumber(scramble7));
        }
        else if (n8 == 75) {
            n16 = m7(73, getSecretNumber(scramble7));
        }
        else if (n8 == 76) {
            n16 = m7(201, getSecretNumber(scramble7));
        }
        else if (n8 == 77) {
            n16 = m7(179, getSecretNumber(scramble7));
        }
        else if (n8 == 78) {
            n16 = m7(85, getSecretNumber(scramble7));
        }
        else if (n8 == 79) {
            n16 = m7(119, getSecretNumber(scramble7));
        }
        else if (n8 == 80) {
            n16 = m7(116, getSecretNumber(scramble7));
        }
        else if (n8 == 81) {
            n16 = m7(141, getSecretNumber(scramble7));
        }
        else if (n8 == 82) {
            n16 = m7(90, getSecretNumber(scramble7));
        }
        else if (n8 == 83) {
            n16 = m7(161, getSecretNumber(scramble7));
        }
        else if (n8 == 84) {
            n16 = m7(238, getSecretNumber(scramble7));
        }
        else if (n8 == 85) {
            n16 = m7(162, getSecretNumber(scramble7));
        }
        else if (n8 == 86) {
            n16 = m7(204, getSecretNumber(scramble7));
        }
        else if (n8 == 87) {
            n16 = m7(224, getSecretNumber(scramble7));
        }
        else if (n8 == 88) {
            n16 = m7(81, getSecretNumber(scramble7));
        }
        else if (n8 == 89) {
            n16 = m7(103, getSecretNumber(scramble7));
        }
        else if (n8 == 90) {
            n16 = m7(214, getSecretNumber(scramble7));
        }
        else if (n8 == 91) {
            n16 = m7(203, getSecretNumber(scramble7));
        }
        else if (n8 == 92) {
            n16 = m7(198, getSecretNumber(scramble7));
        }
        else if (n8 == 93) {
            n16 = m7(184, getSecretNumber(scramble7));
        }
        else if (n8 == 94) {
            n16 = m7(92, getSecretNumber(scramble7));
        }
        else if (n8 == 95) {
            n16 = m7(147, getSecretNumber(scramble7));
        }
        else if (n8 == 96) {
            n16 = m7(105, getSecretNumber(scramble7));
        }
        else if (n8 == 97) {
            n16 = m7(221, getSecretNumber(scramble7));
        }
        else if (n8 == 98) {
            n16 = m7(11, getSecretNumber(scramble7));
        }
        else if (n8 == 99) {
            n16 = m7(134, getSecretNumber(scramble7));
        }
        else if (n8 == 100) {
            n16 = m7(70, getSecretNumber(scramble7));
        }
        else if (n8 == 101) {
            n16 = m7(95, getSecretNumber(scramble7));
        }
        else if (n8 == 102) {
            n16 = m7(27, getSecretNumber(scramble7));
        }
        else if (n8 == 103) {
            n16 = m7(166, getSecretNumber(scramble7));
        }
        else if (n8 == 104) {
            n16 = m7(24, getSecretNumber(scramble7));
        }
        else if (n8 == 105) {
            n16 = m7(71, getSecretNumber(scramble7));
        }
        else if (n8 == 106) {
            n16 = m7(185, getSecretNumber(scramble7));
        }
        else if (n8 == 107) {
            n16 = m7(46, getSecretNumber(scramble7));
        }
        else if (n8 == 108) {
            n16 = m7(172, getSecretNumber(scramble7));
        }
        else if (n8 == 109) {
            n16 = m7(237, getSecretNumber(scramble7));
        }
        else if (n8 == 110) {
            n16 = m7(39, getSecretNumber(scramble7));
        }
        else if (n8 == 111) {
            n16 = m7(123, getSecretNumber(scramble7));
        }
        else if (n8 == 112) {
            n16 = m7(76, getSecretNumber(scramble7));
        }
        else if (n8 == 113) {
            n16 = m7(91, getSecretNumber(scramble7));
        }
        else if (n8 == 114) {
            n16 = m7(228, getSecretNumber(scramble7));
        }
        else if (n8 == 115) {
            n16 = m7(108, getSecretNumber(scramble7));
        }
        else if (n8 == 116) {
            n16 = m7(74, getSecretNumber(scramble7));
        }
        else if (n8 == 117) {
            n16 = m7(206, getSecretNumber(scramble7));
        }
        else if (n8 == 118) {
            n16 = m7(87, getSecretNumber(scramble7));
        }
        else if (n8 == 119) {
            n16 = m7(197, getSecretNumber(scramble7));
        }
        else if (n8 == 120) {
            n16 = m7(50, getSecretNumber(scramble7));
        }
        else if (n8 == 121) {
            n16 = m7(35, getSecretNumber(scramble7));
        }
        else if (n8 == 122) {
            n16 = m7(15, getSecretNumber(scramble7));
        }
        else if (n8 == 123) {
            n16 = m7(25, getSecretNumber(scramble7));
        }
        else if (n8 == 124) {
            n16 = m7(7, getSecretNumber(scramble7));
        }
        else if (n8 == 125) {
            n16 = m7(164, getSecretNumber(scramble7));
        }
        else if (n8 == 126) {
            n16 = m7(219, getSecretNumber(scramble7));
        }
        else if (n8 == 127) {
            n16 = m7(130, getSecretNumber(scramble7));
        }
        else if (n8 == 128) {
            n16 = m7(54, getSecretNumber(scramble7));
        }
        else if (n8 == 129) {
            n16 = m7(188, getSecretNumber(scramble7));
        }
        else if (n8 == 130) {
            n16 = m7(213, getSecretNumber(scramble7));
        }
        else if (n8 == 131) {
            n16 = m7(120, getSecretNumber(scramble7));
        }
        else if (n8 == 132) {
            n16 = m7(61, getSecretNumber(scramble7));
        }
        else if (n8 == 133) {
            n16 = m7(250, getSecretNumber(scramble7));
        }
        else if (n8 == 134) {
            n16 = m7(189, getSecretNumber(scramble7));
        }
        else if (n8 == 135) {
            n16 = m7(217, getSecretNumber(scramble7));
        }
        else if (n8 == 136) {
            n16 = m7(241, getSecretNumber(scramble7));
        }
        else if (n8 == 137) {
            n16 = m7(230, getSecretNumber(scramble7));
        }
        else if (n8 == 138) {
            n16 = m7(55, getSecretNumber(scramble7));
        }
        else if (n8 == 139) {
            n16 = m7(246, getSecretNumber(scramble7));
        }
        else if (n8 == 140) {
            n16 = m7(192, getSecretNumber(scramble7));
        }
        else if (n8 == 141) {
            n16 = m7(96, getSecretNumber(scramble7));
        }
        else if (n8 == 142) {
            n16 = m7(94, getSecretNumber(scramble7));
        }
        else if (n8 == 143) {
            n16 = m7(89, getSecretNumber(scramble7));
        }
        else if (n8 == 144) {
            n16 = m7(218, getSecretNumber(scramble7));
        }
        else if (n8 == 145) {
            n16 = m7(245, getSecretNumber(scramble7));
        }
        else if (n8 == 146) {
            n16 = m7(176, getSecretNumber(scramble7));
        }
        else if (n8 == 147) {
            n16 = m7(98, getSecretNumber(scramble7));
        }
        else if (n8 == 148) {
            n16 = m7(75, getSecretNumber(scramble7));
        }
        else if (n8 == 149) {
            n16 = m7(102, getSecretNumber(scramble7));
        }
        else if (n8 == 150) {
            n16 = m7(194, getSecretNumber(scramble7));
        }
        else if (n8 == 151) {
            n16 = m7(47, getSecretNumber(scramble7));
        }
        else if (n8 == 152) {
            n16 = m7(101, getSecretNumber(scramble7));
        }
        else if (n8 == 153) {
            n16 = m7(58, getSecretNumber(scramble7));
        }
        else if (n8 == 154) {
            n16 = m7(132, getSecretNumber(scramble7));
        }
        else if (n8 == 155) {
            n16 = m7(182, getSecretNumber(scramble7));
        }
        else if (n8 == 156) {
            n16 = m7(234, getSecretNumber(scramble7));
        }
        else if (n8 == 157) {
            n16 = m7(190, getSecretNumber(scramble7));
        }
        else if (n8 == 158) {
            n16 = m7(223, getSecretNumber(scramble7));
        }
        else if (n8 == 159) {
            n16 = m7(45, getSecretNumber(scramble7));
        }
        else if (n8 == 160) {
            n16 = m7(150, getSecretNumber(scramble7));
        }
        else if (n8 == 161) {
            n16 = m7(107, getSecretNumber(scramble7));
        }
        else if (n8 == 162) {
            n16 = m7(86, getSecretNumber(scramble7));
        }
        else if (n8 == 163) {
            n16 = m7(64, getSecretNumber(scramble7));
        }
        else if (n8 == 164) {
            n16 = m7(20, getSecretNumber(scramble7));
        }
        else if (n8 == 165) {
            n16 = m7(49, getSecretNumber(scramble7));
        }
        else if (n8 == 166) {
            n16 = m7(23, getSecretNumber(scramble7));
        }
        else if (n8 == 167) {
            n16 = m7(210, getSecretNumber(scramble7));
        }
        else if (n8 == 168) {
            n16 = m7(251, getSecretNumber(scramble7));
        }
        else if (n8 == 169) {
            n16 = m7(21, getSecretNumber(scramble7));
        }
        else if (n8 == 170) {
            n16 = m7(59, getSecretNumber(scramble7));
        }
        else if (n8 == 171) {
            n16 = m7(72, getSecretNumber(scramble7));
        }
        else if (n8 == 172) {
            n16 = m7(104, getSecretNumber(scramble7));
        }
        else if (n8 == 173) {
            n16 = m7(53, getSecretNumber(scramble7));
        }
        else if (n8 == 174) {
            n16 = m7(155, getSecretNumber(scramble7));
        }
        else if (n8 == 175) {
            n16 = m7(113, getSecretNumber(scramble7));
        }
        else if (n8 == 176) {
            n16 = m7(106, getSecretNumber(scramble7));
        }
        else if (n8 == 177) {
            n16 = m7(131, getSecretNumber(scramble7));
        }
        else if (n8 == 178) {
            n16 = m7(6, getSecretNumber(scramble7));
        }
        else if (n8 == 179) {
            n16 = m7(14, getSecretNumber(scramble7));
        }
        else if (n8 == 180) {
            n16 = m7(3, getSecretNumber(scramble7));
        }
        else if (n8 == 181) {
            n16 = m7(255, getSecretNumber(scramble7));
        }
        else if (n8 == 182) {
            n16 = m7(17, getSecretNumber(scramble7));
        }
        else if (n8 == 183) {
            n16 = m7(225, getSecretNumber(scramble7));
        }
        else if (n8 == 184) {
            n16 = m7(143, getSecretNumber(scramble7));
        }
        else if (n8 == 185) {
            n16 = m7(28, getSecretNumber(scramble7));
        }
        else if (n8 == 186) {
            n16 = m7(167, getSecretNumber(scramble7));
        }
        else if (n8 == 187) {
            n16 = m7(93, getSecretNumber(scramble7));
        }
        else if (n8 == 188) {
            n16 = m7(196, getSecretNumber(scramble7));
        }
        else if (n8 == 189) {
            n16 = m7(16, getSecretNumber(scramble7));
        }
        else if (n8 == 190) {
            n16 = m7(129, getSecretNumber(scramble7));
        }
        else if (n8 == 191) {
            n16 = m7(65, getSecretNumber(scramble7));
        }
        else if (n8 == 192) {
            n16 = m7(200, getSecretNumber(scramble7));
        }
        else if (n8 == 193) {
            n16 = m7(41, getSecretNumber(scramble7));
        }
        else if (n8 == 194) {
            n16 = m7(29, getSecretNumber(scramble7));
        }
        else if (n8 == 195) {
            n16 = m7(235, getSecretNumber(scramble7));
        }
        else if (n8 == 196) {
            n16 = m7(149, getSecretNumber(scramble7));
        }
        else if (n8 == 197) {
            n16 = m7(30, getSecretNumber(scramble7));
        }
        else if (n8 == 198) {
            n16 = m7(169, getSecretNumber(scramble7));
        }
        else if (n8 == 199) {
            n16 = m7(79, getSecretNumber(scramble7));
        }
        else if (n8 == 200) {
            n16 = m7(33, getSecretNumber(scramble7));
        }
        else if (n8 == 201) {
            n16 = m7(32, getSecretNumber(scramble7));
        }
        else if (n8 == 202) {
            n16 = m7(5, getSecretNumber(scramble7));
        }
        else if (n8 == 203) {
            n16 = m7(160, getSecretNumber(scramble7));
        }
        else if (n8 == 204) {
            n16 = m7(110, getSecretNumber(scramble7));
        }
        else if (n8 == 205) {
            n16 = m7(175, getSecretNumber(scramble7));
        }
        else if (n8 == 206) {
            n16 = m7(1, getSecretNumber(scramble7));
        }
        else if (n8 == 207) {
            n16 = m7(140, getSecretNumber(scramble7));
        }
        else if (n8 == 208) {
            n16 = m7(109, getSecretNumber(scramble7));
        }
        else if (n8 == 209) {
            n16 = m7(170, getSecretNumber(scramble7));
        }
        else if (n8 == 210) {
            n16 = m7(183, getSecretNumber(scramble7));
        }
        else if (n8 == 211) {
            n16 = m7(42, getSecretNumber(scramble7));
        }
        else if (n8 == 212) {
            n16 = m7(99, getSecretNumber(scramble7));
        }
        else if (n8 == 213) {
            n16 = m7(63, getSecretNumber(scramble7));
        }
        else if (n8 == 214) {
            n16 = m7(157, getSecretNumber(scramble7));
        }
        else if (n8 == 215) {
            n16 = m7(117, getSecretNumber(scramble7));
        }
        else if (n8 == 216) {
            n16 = m7(151, getSecretNumber(scramble7));
        }
        else if (n8 == 217) {
            n16 = m7(56, getSecretNumber(scramble7));
        }
        else if (n8 == 218) {
            n16 = m7(124, getSecretNumber(scramble7));
        }
        else if (n8 == 219) {
            n16 = m7(236, getSecretNumber(scramble7));
        }
        else if (n8 == 220) {
            n16 = m7(177, getSecretNumber(scramble7));
        }
        else if (n8 == 221) {
            n16 = m7(216, getSecretNumber(scramble7));
        }
        else if (n8 == 222) {
            n16 = m7(156, getSecretNumber(scramble7));
        }
        else if (n8 == 223) {
            n16 = m7(227, getSecretNumber(scramble7));
        }
        else if (n8 == 224) {
            n16 = m7(4, getSecretNumber(scramble7));
        }
        else if (n8 == 225) {
            n16 = m7(248, getSecretNumber(scramble7));
        }
        else if (n8 == 226) {
            n16 = m7(37, getSecretNumber(scramble7));
        }
        else if (n8 == 227) {
            n16 = m7(0, getSecretNumber(scramble7));
        }
        else if (n8 == 228) {
            n16 = m7(9, getSecretNumber(scramble7));
        }
        else if (n8 == 229) {
            n16 = m7(220, getSecretNumber(scramble7));
        }
        else if (n8 == 230) {
            n16 = m7(31, getSecretNumber(scramble7));
        }
        else if (n8 == 231) {
            n16 = m7(243, getSecretNumber(scramble7));
        }
        else if (n8 == 232) {
            n16 = m7(148, getSecretNumber(scramble7));
        }
        else if (n8 == 233) {
            n16 = m7(77, getSecretNumber(scramble7));
        }
        else if (n8 == 234) {
            n16 = m7(114, getSecretNumber(scramble7));
        }
        else if (n8 == 235) {
            n16 = m7(145, getSecretNumber(scramble7));
        }
        else if (n8 == 236) {
            n16 = m7(10, getSecretNumber(scramble7));
        }
        else if (n8 == 237) {
            n16 = m7(13, getSecretNumber(scramble7));
        }
        else if (n8 == 238) {
            n16 = m7(139, getSecretNumber(scramble7));
        }
        else if (n8 == 239) {
            n16 = m7(249, getSecretNumber(scramble7));
        }
        else if (n8 == 240) {
            n16 = m7(252, getSecretNumber(scramble7));
        }
        else if (n8 == 241) {
            n16 = m7(22, getSecretNumber(scramble7));
        }
        else if (n8 == 242) {
            n16 = m7(122, getSecretNumber(scramble7));
        }
        else if (n8 == 243) {
            n16 = m7(193, getSecretNumber(scramble7));
        }
        else if (n8 == 244) {
            n16 = m7(34, getSecretNumber(scramble7));
        }
        else if (n8 == 245) {
            n16 = m7(83, getSecretNumber(scramble7));
        }
        else if (n8 == 246) {
            n16 = m7(222, getSecretNumber(scramble7));
        }
        else if (n8 == 247) {
            n16 = m7(191, getSecretNumber(scramble7));
        }
        else if (n8 == 248) {
            n16 = m7(62, getSecretNumber(scramble7));
        }
        else if (n8 == 249) {
            n16 = m7(239, getSecretNumber(scramble7));
        }
        else if (n8 == 250) {
            n16 = m7(205, getSecretNumber(scramble7));
        }
        else if (n8 == 251) {
            n16 = m7(187, getSecretNumber(scramble7));
        }
        else if (n8 == 252) {
            n16 = m7(163, getSecretNumber(scramble7));
        }
        else if (n8 == 253) {
            n16 = m7(146, getSecretNumber(scramble7));
        }
        else if (n8 == 254) {
            n16 = m7(142, getSecretNumber(scramble7));
        }
        else if (n8 == 255) {
            n16 = m7(153, getSecretNumber(scramble7));
        }
        else {
            n16 = 0;
        }
        if ((n16 & 0xFF) != 0x8E) {
            return false;
        }
        m9(n + n2 + n3 + n4 + n5 + n6 + n7 * n8);
        final int scramble8 = scramble(scramble7 + n8);
        int n17;
        if (n9 == 0) {
            n17 = m8(74, getSecretNumber(scramble8));
        }
        else if (n9 == 1) {
            n17 = m8(42, getSecretNumber(scramble8));
        }
        else if (n9 == 2) {
            n17 = m8(108, getSecretNumber(scramble8));
        }
        else if (n9 == 3) {
            n17 = m8(90, getSecretNumber(scramble8));
        }
        else if (n9 == 4) {
            n17 = m8(10, getSecretNumber(scramble8));
        }
        else if (n9 == 5) {
            n17 = m8(82, getSecretNumber(scramble8));
        }
        else if (n9 == 6) {
            n17 = m8(182, getSecretNumber(scramble8));
        }
        else if (n9 == 7) {
            n17 = m8(2, getSecretNumber(scramble8));
        }
        else if (n9 == 8) {
            n17 = m8(156, getSecretNumber(scramble8));
        }
        else if (n9 == 9) {
            n17 = m8(188, getSecretNumber(scramble8));
        }
        else if (n9 == 10) {
            n17 = m8(147, getSecretNumber(scramble8));
        }
        else if (n9 == 11) {
            n17 = m8(187, getSecretNumber(scramble8));
        }
        else if (n9 == 12) {
            n17 = m8(66, getSecretNumber(scramble8));
        }
        else if (n9 == 13) {
            n17 = m8(137, getSecretNumber(scramble8));
        }
        else if (n9 == 14) {
            n17 = m8(18, getSecretNumber(scramble8));
        }
        else if (n9 == 15) {
            n17 = m8(140, getSecretNumber(scramble8));
        }
        else if (n9 == 16) {
            n17 = m8(44, getSecretNumber(scramble8));
        }
        else if (n9 == 17) {
            n17 = m8(115, getSecretNumber(scramble8));
        }
        else if (n9 == 18) {
            n17 = m8(26, getSecretNumber(scramble8));
        }
        else if (n9 == 19) {
            n17 = m8(64, getSecretNumber(scramble8));
        }
        else if (n9 == 20) {
            n17 = m8(255, getSecretNumber(scramble8));
        }
        else if (n9 == 21) {
            n17 = m8(229, getSecretNumber(scramble8));
        }
        else if (n9 == 22) {
            n17 = m8(204, getSecretNumber(scramble8));
        }
        else if (n9 == 23) {
            n17 = m8(50, getSecretNumber(scramble8));
        }
        else if (n9 == 24) {
            n17 = m8(153, getSecretNumber(scramble8));
        }
        else if (n9 == 25) {
            n17 = m8(53, getSecretNumber(scramble8));
        }
        else if (n9 == 26) {
            n17 = m8(30, getSecretNumber(scramble8));
        }
        else if (n9 == 27) {
            n17 = m8(101, getSecretNumber(scramble8));
        }
        else if (n9 == 28) {
            n17 = m8(161, getSecretNumber(scramble8));
        }
        else if (n9 == 29) {
            n17 = m8(145, getSecretNumber(scramble8));
        }
        else if (n9 == 30) {
            n17 = m8(136, getSecretNumber(scramble8));
        }
        else if (n9 == 31) {
            n17 = m8(155, getSecretNumber(scramble8));
        }
        else if (n9 == 32) {
            n17 = m8(159, getSecretNumber(scramble8));
        }
        else if (n9 == 33) {
            n17 = m8(78, getSecretNumber(scramble8));
        }
        else if (n9 == 34) {
            n17 = m8(11, getSecretNumber(scramble8));
        }
        else if (n9 == 35) {
            n17 = m8(142, getSecretNumber(scramble8));
        }
        else if (n9 == 36) {
            n17 = m8(131, getSecretNumber(scramble8));
        }
        else if (n9 == 37) {
            n17 = m8(226, getSecretNumber(scramble8));
        }
        else if (n9 == 38) {
            n17 = m8(68, getSecretNumber(scramble8));
        }
        else if (n9 == 39) {
            n17 = m8(233, getSecretNumber(scramble8));
        }
        else if (n9 == 40) {
            n17 = m8(109, getSecretNumber(scramble8));
        }
        else if (n9 == 41) {
            n17 = m8(62, getSecretNumber(scramble8));
        }
        else if (n9 == 42) {
            n17 = m8(88, getSecretNumber(scramble8));
        }
        else if (n9 == 43) {
            n17 = m8(99, getSecretNumber(scramble8));
        }
        else if (n9 == 44) {
            n17 = m8(94, getSecretNumber(scramble8));
        }
        else if (n9 == 45) {
            n17 = m8(19, getSecretNumber(scramble8));
        }
        else if (n9 == 46) {
            n17 = m8(114, getSecretNumber(scramble8));
        }
        else if (n9 == 47) {
            n17 = m8(100, getSecretNumber(scramble8));
        }
        else if (n9 == 48) {
            n17 = m8(39, getSecretNumber(scramble8));
        }
        else if (n9 == 49) {
            n17 = m8(138, getSecretNumber(scramble8));
        }
        else if (n9 == 50) {
            n17 = m8(237, getSecretNumber(scramble8));
        }
        else if (n9 == 51) {
            n17 = m8(144, getSecretNumber(scramble8));
        }
        else if (n9 == 52) {
            n17 = m8(143, getSecretNumber(scramble8));
        }
        else if (n9 == 53) {
            n17 = m8(98, getSecretNumber(scramble8));
        }
        else if (n9 == 54) {
            n17 = m8(251, getSecretNumber(scramble8));
        }
        else if (n9 == 55) {
            n17 = m8(246, getSecretNumber(scramble8));
        }
        else if (n9 == 56) {
            n17 = m8(146, getSecretNumber(scramble8));
        }
        else if (n9 == 57) {
            n17 = m8(33, getSecretNumber(scramble8));
        }
        else if (n9 == 58) {
            n17 = m8(199, getSecretNumber(scramble8));
        }
        else if (n9 == 59) {
            n17 = m8(91, getSecretNumber(scramble8));
        }
        else if (n9 == 60) {
            n17 = m8(171, getSecretNumber(scramble8));
        }
        else if (n9 == 61) {
            n17 = m8(195, getSecretNumber(scramble8));
        }
        else if (n9 == 62) {
            n17 = m8(200, getSecretNumber(scramble8));
        }
        else if (n9 == 63) {
            n17 = m8(192, getSecretNumber(scramble8));
        }
        else if (n9 == 64) {
            n17 = m8(126, getSecretNumber(scramble8));
        }
        else if (n9 == 65) {
            n17 = m8(248, getSecretNumber(scramble8));
        }
        else if (n9 == 66) {
            n17 = m8(38, getSecretNumber(scramble8));
        }
        else if (n9 == 67) {
            n17 = m8(35, getSecretNumber(scramble8));
        }
        else if (n9 == 68) {
            n17 = m8(29, getSecretNumber(scramble8));
        }
        else if (n9 == 69) {
            n17 = m8(205, getSecretNumber(scramble8));
        }
        else if (n9 == 70) {
            n17 = m8(230, getSecretNumber(scramble8));
        }
        else if (n9 == 71) {
            n17 = m8(71, getSecretNumber(scramble8));
        }
        else if (n9 == 72) {
            n17 = m8(166, getSecretNumber(scramble8));
        }
        else if (n9 == 73) {
            n17 = m8(176, getSecretNumber(scramble8));
        }
        else if (n9 == 74) {
            n17 = m8(239, getSecretNumber(scramble8));
        }
        else if (n9 == 75) {
            n17 = m8(197, getSecretNumber(scramble8));
        }
        else if (n9 == 76) {
            n17 = m8(6, getSecretNumber(scramble8));
        }
        else if (n9 == 77) {
            n17 = m8(217, getSecretNumber(scramble8));
        }
        else if (n9 == 78) {
            n17 = m8(25, getSecretNumber(scramble8));
        }
        else if (n9 == 79) {
            n17 = m8(209, getSecretNumber(scramble8));
        }
        else if (n9 == 80) {
            n17 = m8(241, getSecretNumber(scramble8));
        }
        else if (n9 == 81) {
            n17 = m8(152, getSecretNumber(scramble8));
        }
        else if (n9 == 82) {
            n17 = m8(202, getSecretNumber(scramble8));
        }
        else if (n9 == 83) {
            n17 = m8(93, getSecretNumber(scramble8));
        }
        else if (n9 == 84) {
            n17 = m8(117, getSecretNumber(scramble8));
        }
        else if (n9 == 85) {
            n17 = m8(13, getSecretNumber(scramble8));
        }
        else if (n9 == 86) {
            n17 = m8(228, getSecretNumber(scramble8));
        }
        else if (n9 == 87) {
            n17 = m8(86, getSecretNumber(scramble8));
        }
        else if (n9 == 88) {
            n17 = m8(80, getSecretNumber(scramble8));
        }
        else if (n9 == 89) {
            n17 = m8(207, getSecretNumber(scramble8));
        }
        else if (n9 == 90) {
            n17 = m8(96, getSecretNumber(scramble8));
        }
        else if (n9 == 91) {
            n17 = m8(21, getSecretNumber(scramble8));
        }
        else if (n9 == 92) {
            n17 = m8(48, getSecretNumber(scramble8));
        }
        else if (n9 == 93) {
            n17 = m8(196, getSecretNumber(scramble8));
        }
        else if (n9 == 94) {
            n17 = m8(224, getSecretNumber(scramble8));
        }
        else if (n9 == 95) {
            n17 = m8(102, getSecretNumber(scramble8));
        }
        else if (n9 == 96) {
            n17 = m8(58, getSecretNumber(scramble8));
        }
        else if (n9 == 97) {
            n17 = m8(149, getSecretNumber(scramble8));
        }
        else if (n9 == 98) {
            n17 = m8(133, getSecretNumber(scramble8));
        }
        else if (n9 == 99) {
            n17 = m8(89, getSecretNumber(scramble8));
        }
        else if (n9 == 100) {
            n17 = m8(232, getSecretNumber(scramble8));
        }
        else if (n9 == 101) {
            n17 = m8(157, getSecretNumber(scramble8));
        }
        else if (n9 == 102) {
            n17 = m8(106, getSecretNumber(scramble8));
        }
        else if (n9 == 103) {
            n17 = m8(125, getSecretNumber(scramble8));
        }
        else if (n9 == 104) {
            n17 = m8(132, getSecretNumber(scramble8));
        }
        else if (n9 == 105) {
            n17 = m8(7, getSecretNumber(scramble8));
        }
        else if (n9 == 106) {
            n17 = m8(63, getSecretNumber(scramble8));
        }
        else if (n9 == 107) {
            n17 = m8(60, getSecretNumber(scramble8));
        }
        else if (n9 == 108) {
            n17 = m8(165, getSecretNumber(scramble8));
        }
        else if (n9 == 109) {
            n17 = m8(254, getSecretNumber(scramble8));
        }
        else if (n9 == 110) {
            n17 = m8(9, getSecretNumber(scramble8));
        }
        else if (n9 == 111) {
            n17 = m8(116, getSecretNumber(scramble8));
        }
        else if (n9 == 112) {
            n17 = m8(59, getSecretNumber(scramble8));
        }
        else if (n9 == 113) {
            n17 = m8(208, getSecretNumber(scramble8));
        }
        else if (n9 == 114) {
            n17 = m8(216, getSecretNumber(scramble8));
        }
        else if (n9 == 115) {
            n17 = m8(111, getSecretNumber(scramble8));
        }
        else if (n9 == 116) {
            n17 = m8(173, getSecretNumber(scramble8));
        }
        else if (n9 == 117) {
            n17 = m8(105, getSecretNumber(scramble8));
        }
        else if (n9 == 118) {
            n17 = m8(84, getSecretNumber(scramble8));
        }
        else if (n9 == 119) {
            n17 = m8(201, getSecretNumber(scramble8));
        }
        else if (n9 == 120) {
            n17 = m8(151, getSecretNumber(scramble8));
        }
        else if (n9 == 121) {
            n17 = m8(253, getSecretNumber(scramble8));
        }
        else if (n9 == 122) {
            n17 = m8(123, getSecretNumber(scramble8));
        }
        else if (n9 == 123) {
            n17 = m8(220, getSecretNumber(scramble8));
        }
        else if (n9 == 124) {
            n17 = m8(69, getSecretNumber(scramble8));
        }
        else if (n9 == 125) {
            n17 = m8(225, getSecretNumber(scramble8));
        }
        else if (n9 == 126) {
            n17 = m8(236, getSecretNumber(scramble8));
        }
        else if (n9 == 127) {
            n17 = m8(24, getSecretNumber(scramble8));
        }
        else if (n9 == 128) {
            n17 = m8(22, getSecretNumber(scramble8));
        }
        else if (n9 == 129) {
            n17 = m8(242, getSecretNumber(scramble8));
        }
        else if (n9 == 130) {
            n17 = m8(16, getSecretNumber(scramble8));
        }
        else if (n9 == 131) {
            n17 = m8(194, getSecretNumber(scramble8));
        }
        else if (n9 == 132) {
            n17 = m8(31, getSecretNumber(scramble8));
        }
        else if (n9 == 133) {
            n17 = m8(110, getSecretNumber(scramble8));
        }
        else if (n9 == 134) {
            n17 = m8(193, getSecretNumber(scramble8));
        }
        else if (n9 == 135) {
            n17 = m8(36, getSecretNumber(scramble8));
        }
        else if (n9 == 136) {
            n17 = m8(20, getSecretNumber(scramble8));
        }
        else if (n9 == 137) {
            n17 = m8(61, getSecretNumber(scramble8));
        }
        else if (n9 == 138) {
            n17 = m8(150, getSecretNumber(scramble8));
        }
        else if (n9 == 139) {
            n17 = m8(167, getSecretNumber(scramble8));
        }
        else if (n9 == 140) {
            n17 = m8(162, getSecretNumber(scramble8));
        }
        else if (n9 == 141) {
            n17 = m8(184, getSecretNumber(scramble8));
        }
        else if (n9 == 142) {
            n17 = m8(190, getSecretNumber(scramble8));
        }
        else if (n9 == 143) {
            n17 = m8(127, getSecretNumber(scramble8));
        }
        else if (n9 == 144) {
            n17 = m8(72, getSecretNumber(scramble8));
        }
        else if (n9 == 145) {
            n17 = m8(234, getSecretNumber(scramble8));
        }
        else if (n9 == 146) {
            n17 = m8(172, getSecretNumber(scramble8));
        }
        else if (n9 == 147) {
            n17 = m8(141, getSecretNumber(scramble8));
        }
        else if (n9 == 148) {
            n17 = m8(175, getSecretNumber(scramble8));
        }
        else if (n9 == 149) {
            n17 = m8(54, getSecretNumber(scramble8));
        }
        else if (n9 == 150) {
            n17 = m8(8, getSecretNumber(scramble8));
        }
        else if (n9 == 151) {
            n17 = m8(174, getSecretNumber(scramble8));
        }
        else if (n9 == 152) {
            n17 = m8(5, getSecretNumber(scramble8));
        }
        else if (n9 == 153) {
            n17 = m8(206, getSecretNumber(scramble8));
        }
        else if (n9 == 154) {
            n17 = m8(168, getSecretNumber(scramble8));
        }
        else if (n9 == 155) {
            n17 = m8(45, getSecretNumber(scramble8));
        }
        else if (n9 == 156) {
            n17 = m8(67, getSecretNumber(scramble8));
        }
        else if (n9 == 157) {
            n17 = m8(43, getSecretNumber(scramble8));
        }
        else if (n9 == 158) {
            n17 = m8(148, getSecretNumber(scramble8));
        }
        else if (n9 == 159) {
            n17 = m8(250, getSecretNumber(scramble8));
        }
        else if (n9 == 160) {
            n17 = m8(51, getSecretNumber(scramble8));
        }
        else if (n9 == 161) {
            n17 = m8(87, getSecretNumber(scramble8));
        }
        else if (n9 == 162) {
            n17 = m8(103, getSecretNumber(scramble8));
        }
        else if (n9 == 163) {
            n17 = m8(81, getSecretNumber(scramble8));
        }
        else if (n9 == 164) {
            n17 = m8(119, getSecretNumber(scramble8));
        }
        else if (n9 == 165) {
            n17 = m8(73, getSecretNumber(scramble8));
        }
        else if (n9 == 166) {
            n17 = m8(189, getSecretNumber(scramble8));
        }
        else if (n9 == 167) {
            n17 = m8(163, getSecretNumber(scramble8));
        }
        else if (n9 == 168) {
            n17 = m8(214, getSecretNumber(scramble8));
        }
        else if (n9 == 169) {
            n17 = m8(178, getSecretNumber(scramble8));
        }
        else if (n9 == 170) {
            n17 = m8(221, getSecretNumber(scramble8));
        }
        else if (n9 == 171) {
            n17 = m8(227, getSecretNumber(scramble8));
        }
        else if (n9 == 172) {
            n17 = m8(4, getSecretNumber(scramble8));
        }
        else if (n9 == 173) {
            n17 = m8(23, getSecretNumber(scramble8));
        }
        else if (n9 == 174) {
            n17 = m8(130, getSecretNumber(scramble8));
        }
        else if (n9 == 175) {
            n17 = m8(240, getSecretNumber(scramble8));
        }
        else if (n9 == 176) {
            n17 = m8(120, getSecretNumber(scramble8));
        }
        else if (n9 == 177) {
            n17 = m8(55, getSecretNumber(scramble8));
        }
        else if (n9 == 178) {
            n17 = m8(177, getSecretNumber(scramble8));
        }
        else if (n9 == 179) {
            n17 = m8(85, getSecretNumber(scramble8));
        }
        else if (n9 == 180) {
            n17 = m8(243, getSecretNumber(scramble8));
        }
        else if (n9 == 181) {
            n17 = m8(247, getSecretNumber(scramble8));
        }
        else if (n9 == 182) {
            n17 = m8(249, getSecretNumber(scramble8));
        }
        else if (n9 == 183) {
            n17 = m8(180, getSecretNumber(scramble8));
        }
        else if (n9 == 184) {
            n17 = m8(231, getSecretNumber(scramble8));
        }
        else if (n9 == 185) {
            n17 = m8(52, getSecretNumber(scramble8));
        }
        else if (n9 == 186) {
            n17 = m8(223, getSecretNumber(scramble8));
        }
        else if (n9 == 187) {
            n17 = m8(218, getSecretNumber(scramble8));
        }
        else if (n9 == 188) {
            n17 = m8(183, getSecretNumber(scramble8));
        }
        else if (n9 == 189) {
            n17 = m8(34, getSecretNumber(scramble8));
        }
        else if (n9 == 190) {
            n17 = m8(46, getSecretNumber(scramble8));
        }
        else if (n9 == 191) {
            n17 = m8(128, getSecretNumber(scramble8));
        }
        else if (n9 == 192) {
            n17 = m8(70, getSecretNumber(scramble8));
        }
        else if (n9 == 193) {
            n17 = m8(77, getSecretNumber(scramble8));
        }
        else if (n9 == 194) {
            n17 = m8(65, getSecretNumber(scramble8));
        }
        else if (n9 == 195) {
            n17 = m8(32, getSecretNumber(scramble8));
        }
        else if (n9 == 196) {
            n17 = m8(97, getSecretNumber(scramble8));
        }
        else if (n9 == 197) {
            n17 = m8(203, getSecretNumber(scramble8));
        }
        else if (n9 == 198) {
            n17 = m8(49, getSecretNumber(scramble8));
        }
        else if (n9 == 199) {
            n17 = m8(95, getSecretNumber(scramble8));
        }
        else if (n9 == 200) {
            n17 = m8(219, getSecretNumber(scramble8));
        }
        else if (n9 == 201) {
            n17 = m8(56, getSecretNumber(scramble8));
        }
        else if (n9 == 202) {
            n17 = m8(185, getSecretNumber(scramble8));
        }
        else if (n9 == 203) {
            n17 = m8(215, getSecretNumber(scramble8));
        }
        else if (n9 == 204) {
            n17 = m8(15, getSecretNumber(scramble8));
        }
        else if (n9 == 205) {
            n17 = m8(124, getSecretNumber(scramble8));
        }
        else if (n9 == 206) {
            n17 = m8(37, getSecretNumber(scramble8));
        }
        else if (n9 == 207) {
            n17 = m8(238, getSecretNumber(scramble8));
        }
        else if (n9 == 208) {
            n17 = m8(12, getSecretNumber(scramble8));
        }
        else if (n9 == 209) {
            n17 = m8(210, getSecretNumber(scramble8));
        }
        else if (n9 == 210) {
            n17 = m8(1, getSecretNumber(scramble8));
        }
        else if (n9 == 211) {
            n17 = m8(244, getSecretNumber(scramble8));
        }
        else if (n9 == 212) {
            n17 = m8(76, getSecretNumber(scramble8));
        }
        else if (n9 == 213) {
            n17 = m8(57, getSecretNumber(scramble8));
        }
        else if (n9 == 214) {
            n17 = m8(211, getSecretNumber(scramble8));
        }
        else if (n9 == 215) {
            n17 = m8(129, getSecretNumber(scramble8));
        }
        else if (n9 == 216) {
            n17 = m8(75, getSecretNumber(scramble8));
        }
        else if (n9 == 217) {
            n17 = m8(28, getSecretNumber(scramble8));
        }
        else if (n9 == 218) {
            n17 = m8(212, getSecretNumber(scramble8));
        }
        else if (n9 == 219) {
            n17 = m8(3, getSecretNumber(scramble8));
        }
        else if (n9 == 220) {
            n17 = m8(113, getSecretNumber(scramble8));
        }
        else if (n9 == 221) {
            n17 = m8(121, getSecretNumber(scramble8));
        }
        else if (n9 == 222) {
            n17 = m8(107, getSecretNumber(scramble8));
        }
        else if (n9 == 223) {
            n17 = m8(169, getSecretNumber(scramble8));
        }
        else if (n9 == 224) {
            n17 = m8(92, getSecretNumber(scramble8));
        }
        else if (n9 == 225) {
            n17 = m8(170, getSecretNumber(scramble8));
        }
        else if (n9 == 226) {
            n17 = m8(135, getSecretNumber(scramble8));
        }
        else if (n9 == 227) {
            n17 = m8(154, getSecretNumber(scramble8));
        }
        else if (n9 == 228) {
            n17 = m8(181, getSecretNumber(scramble8));
        }
        else if (n9 == 229) {
            n17 = m8(41, getSecretNumber(scramble8));
        }
        else if (n9 == 230) {
            n17 = m8(213, getSecretNumber(scramble8));
        }
        else if (n9 == 231) {
            n17 = m8(222, getSecretNumber(scramble8));
        }
        else if (n9 == 232) {
            n17 = m8(112, getSecretNumber(scramble8));
        }
        else if (n9 == 233) {
            n17 = m8(164, getSecretNumber(scramble8));
        }
        else if (n9 == 234) {
            n17 = m8(252, getSecretNumber(scramble8));
        }
        else if (n9 == 235) {
            n17 = m8(0, getSecretNumber(scramble8));
        }
        else if (n9 == 236) {
            n17 = m8(134, getSecretNumber(scramble8));
        }
        else if (n9 == 237) {
            n17 = m8(27, getSecretNumber(scramble8));
        }
        else if (n9 == 238) {
            n17 = m8(14, getSecretNumber(scramble8));
        }
        else if (n9 == 239) {
            n17 = m8(40, getSecretNumber(scramble8));
        }
        else if (n9 == 240) {
            n17 = m8(118, getSecretNumber(scramble8));
        }
        else if (n9 == 241) {
            n17 = m8(245, getSecretNumber(scramble8));
        }
        else if (n9 == 242) {
            n17 = m8(235, getSecretNumber(scramble8));
        }
        else if (n9 == 243) {
            n17 = m8(191, getSecretNumber(scramble8));
        }
        else if (n9 == 244) {
            n17 = m8(104, getSecretNumber(scramble8));
        }
        else if (n9 == 245) {
            n17 = m8(17, getSecretNumber(scramble8));
        }
        else if (n9 == 246) {
            n17 = m8(79, getSecretNumber(scramble8));
        }
        else if (n9 == 247) {
            n17 = m8(186, getSecretNumber(scramble8));
        }
        else if (n9 == 248) {
            n17 = m8(198, getSecretNumber(scramble8));
        }
        else if (n9 == 249) {
            n17 = m8(179, getSecretNumber(scramble8));
        }
        else if (n9 == 250) {
            n17 = m8(83, getSecretNumber(scramble8));
        }
        else if (n9 == 251) {
            n17 = m8(158, getSecretNumber(scramble8));
        }
        else if (n9 == 252) {
            n17 = m8(139, getSecretNumber(scramble8));
        }
        else if (n9 == 253) {
            n17 = m8(47, getSecretNumber(scramble8));
        }
        else if (n9 == 254) {
            n17 = m8(122, getSecretNumber(scramble8));
        }
        else if (n9 == 255) {
            n17 = m8(160, getSecretNumber(scramble8));
        }
        else {
            n17 = 0;
        }
        return (n17 & 0xFF) == 0x67 && (getSecretNumber(n) * (long)getSecretNumber(n2) * getSecretNumber(n3) * getSecretNumber(n4) * getSecretNumber(n5) * getSecretNumber(n6) * getSecretNumber(n7) + n8 + getSecretNumber(n9)) % 144L == 37L;
    }

    static boolean solve2(final int n, final int n2, final int n3, final int n4, final int n5, final int n6, final int n7, final int n8, final int n9) {
        
        final int scramble = scramble(13);
        int n10 = m0((new int[] {100, 190, 88, 240, 97, 216, 47, 243, 39, 18, 173, 144, 157, 114, 116, 250, 152, 150, 196, 175, 28, 179, 23, 213, 73, 66, 20, 228, 67, 200, 156, 7, 221, 210, 50, 233, 110, 32, 71, 194, 117, 220, 43, 113, 148, 247, 217, 185, 41, 177, 239, 12, 232, 101, 82, 178, 128, 191, 42, 172, 136, 81, 115, 251, 69, 89, 139, 48, 129, 63, 154, 125, 242, 95, 132, 143, 102, 29, 199, 10, 146, 79, 225, 149, 236, 245, 56, 105, 27, 235, 162, 201, 193, 208, 104, 96, 209, 155, 34, 68, 202, 169, 49, 13, 134, 45, 226, 255, 14, 52, 33, 62, 44, 186, 6, 121, 21, 244, 131, 64, 111, 123, 248, 124, 36, 9, 58, 112, 222, 130, 254, 120, 75, 224, 76, 145, 80, 231, 198, 219, 182, 24, 126, 40, 246, 192, 78, 166, 140, 158, 223, 57, 207, 90, 161, 54, 38, 252, 72, 203, 70, 85, 171, 107, 98, 4, 51, 188, 238, 15, 147, 237, 65, 214, 99, 183, 22, 5, 92, 141, 184, 30, 108, 60, 135, 118, 127, 205, 133, 159, 19, 197, 74, 17, 59, 138, 195, 119, 8, 25, 206, 55, 106, 91, 160, 122, 218, 37, 181, 211, 212, 234, 241, 46, 77, 170, 11, 109, 16, 249, 168, 230, 215, 174, 204, 164, 2, 253, 94, 31, 189, 35, 153, 180, 103, 142, 1, 137, 187, 84, 165, 26, 87, 93, 83, 86, 0, 151, 3, 167, 53, 176, 227, 163, 229, 61})[n],getSecretNumber(scramble));
        if ((n10 & 0xFF) != 0xAC) {
            return false;
        }
        
        final int scramble2 = scramble(scramble);
        int n11 = m1((new int[] {29, 131, 174, 82, 200, 183, 179, 143, 182, 216, 9, 79, 44, 203, 167, 6, 135, 62, 4, 58, 242, 84, 72, 175, 171, 126, 140, 188, 18, 250, 114, 205, 137, 142, 16, 163, 159, 24, 105, 154, 186, 209, 169, 116, 138, 206, 57, 219, 132, 234, 129, 127, 247, 28, 49, 178, 5, 37, 93, 148, 25, 238, 118, 50, 166, 102, 146, 231, 81, 86, 201, 33, 197, 181, 155, 133, 85, 224, 176, 208, 170, 99, 40, 38, 204, 194, 74, 222, 144, 145, 212, 161, 141, 7, 123, 92, 26, 185, 101, 119, 223, 164, 31, 172, 249, 43, 88, 8, 19, 61, 241, 76, 157, 47, 111, 130, 60, 120, 252, 90, 117, 207, 192, 189, 158, 23, 253, 199, 80, 106, 41, 160, 221, 233, 71, 0, 36, 32, 230, 246, 52, 248, 147, 150, 95, 87, 104, 34, 232, 229, 202, 63, 66, 39, 168, 108, 139, 22, 244, 75, 190, 98, 124, 237, 77, 193, 149, 11, 100, 240, 227, 42, 121, 162, 55, 215, 165, 48, 67, 211, 35, 56, 70, 54, 78, 14, 45, 187, 89, 184, 213, 255, 27, 96, 1, 69, 122, 125, 110, 217, 228, 91, 156, 113, 243, 65, 196, 64, 3, 128, 109, 12, 153, 173, 53, 94, 68, 97, 152, 151, 2, 73, 107, 236, 17, 46, 112, 177, 10, 103, 225, 254, 136, 245, 13, 218, 115, 239, 195, 214, 180, 134, 83, 30, 59, 20, 51, 235, 191, 226, 15, 21, 251, 210, 198, 220})[n2],getSecretNumber(scramble2));
        if ((n11 & 0xFF) != 0x6) {
            return false;
        }
        
        final int scramble3 = scramble(scramble2);
        int n12 = m2((new int[] {255, 30, 98, 78, 198, 151, 15, 171, 92, 236, 93, 136, 206, 220, 56, 156, 54, 50, 82, 112, 123, 14, 77, 12, 184, 214, 208, 145, 66, 40, 52, 224, 213, 134, 227, 250, 22, 114, 79, 143, 10, 55, 174, 28, 85, 221, 154, 248, 84, 175, 168, 144, 11, 32, 64, 207, 147, 58, 176, 111, 108, 142, 216, 187, 110, 195, 5, 219, 72, 235, 49, 120, 232, 46, 155, 23, 27, 185, 233, 57, 170, 18, 71, 203, 88, 196, 140, 223, 109, 131, 103, 26, 251, 48, 180, 83, 106, 115, 130, 16, 133, 44, 164, 241, 182, 70, 204, 9, 218, 107, 179, 188, 6, 160, 190, 13, 209, 230, 119, 197, 226, 124, 121, 240, 80, 163, 97, 38, 149, 94, 202, 243, 193, 238, 167, 138, 148, 17, 3, 51, 127, 210, 62, 205, 239, 126, 169, 63, 95, 228, 199, 186, 81, 53, 152, 67, 125, 0, 153, 99, 150, 25, 217, 229, 102, 69, 246, 90, 117, 244, 60, 178, 73, 234, 2, 181, 75, 20, 24, 21, 8, 35, 141, 165, 201, 237, 96, 211, 129, 159, 19, 189, 135, 158, 33, 104, 91, 116, 177, 47, 247, 137, 122, 173, 59, 113, 29, 245, 242, 128, 39, 86, 192, 252, 37, 61, 89, 200, 157, 68, 225, 139, 1, 254, 36, 146, 162, 42, 45, 166, 172, 65, 231, 31, 105, 222, 43, 212, 118, 34, 215, 74, 87, 253, 194, 249, 100, 41, 76, 101, 4, 191, 132, 183, 7, 161})[n3],getSecretNumber(scramble3));
        if ((n12 & 0xFB) != 0x92) {
            return false;
        }
        
        final int scramble4 = scramble(scramble3);
        int n13 = m3((new int[] {1, 223, 134, 163, 178, 59, 65, 116, 117, 17, 224, 122, 99, 85, 52, 63, 206, 131, 204, 32, 40, 177, 132, 133, 92, 101, 97, 230, 106, 144, 30, 73, 0, 153, 192, 107, 44, 123, 86, 233, 62, 164, 118, 80, 71, 179, 197, 184, 29, 108, 4, 58, 244, 235, 8, 209, 41, 28, 150, 199, 14, 94, 45, 203, 159, 51, 212, 222, 183, 157, 95, 66, 142, 34, 185, 61, 74, 26, 161, 39, 55, 248, 16, 180, 191, 247, 25, 129, 91, 54, 181, 88, 207, 193, 5, 216, 231, 121, 211, 174, 167, 255, 227, 176, 82, 137, 12, 38, 198, 109, 152, 250, 126, 169, 187, 33, 253, 87, 173, 221, 46, 182, 24, 84, 228, 239, 75, 19, 72, 112, 208, 251, 220, 254, 90, 218, 2, 64, 246, 50, 114, 156, 168, 160, 148, 68, 242, 130, 113, 171, 139, 76, 23, 49, 138, 6, 225, 241, 11, 213, 48, 196, 110, 146, 119, 202, 69, 237, 22, 93, 175, 154, 102, 120, 21, 57, 140, 9, 141, 162, 190, 60, 53, 205, 136, 158, 105, 145, 166, 115, 249, 77, 252, 70, 78, 226, 217, 37, 111, 127, 27, 243, 195, 128, 186, 83, 229, 96, 89, 81, 189, 219, 210, 15, 194, 147, 10, 245, 165, 98, 155, 240, 43, 214, 188, 232, 236, 201, 42, 125, 143, 100, 215, 103, 67, 36, 3, 47, 13, 124, 172, 20, 238, 7, 234, 135, 18, 151, 79, 149, 31, 56, 200, 104, 170, 35})[n4],getSecretNumber(scramble4));
        if ((n13 & 0xF7) != 0x61) {
            return false;
        }
        
        final int scramble5 = scramble(scramble4);
        int n14 = m4((new int[] {144, 158, 58, 155, 10, 130, 143, 78, 170, 39, 110, 250, 246, 7, 214, 235, 25, 202, 157, 89, 237, 131, 52, 233, 161, 245, 181, 184, 116, 26, 254, 159, 244, 101, 186, 248, 72, 70, 142, 205, 168, 134, 173, 3, 54, 222, 51, 104, 123, 34, 206, 2, 188, 73, 95, 11, 20, 38, 69, 113, 179, 183, 192, 30, 99, 215, 129, 6, 24, 133, 198, 98, 49, 92, 66, 106, 154, 118, 164, 145, 177, 121, 190, 84, 59, 172, 149, 75, 23, 151, 207, 19, 8, 15, 247, 37, 167, 255, 102, 226, 135, 100, 18, 176, 171, 4, 105, 111, 251, 9, 219, 88, 93, 213, 169, 16, 229, 57, 61, 35, 65, 238, 141, 216, 199, 182, 22, 230, 200, 42, 76, 225, 74, 166, 147, 242, 50, 103, 68, 193, 67, 28, 243, 162, 194, 45, 43, 17, 124, 31, 55, 21, 47, 197, 126, 122, 196, 136, 204, 79, 132, 32, 91, 140, 234, 236, 195, 125, 12, 109, 185, 0, 64, 137, 53, 241, 178, 138, 127, 112, 160, 71, 87, 48, 56, 120, 240, 175, 40, 150, 114, 119, 221, 146, 201, 228, 224, 44, 152, 227, 86, 156, 212, 62, 80, 96, 208, 63, 253, 108, 203, 165, 115, 128, 90, 210, 153, 1, 85, 41, 83, 13, 148, 232, 27, 97, 60, 107, 189, 218, 187, 211, 191, 163, 139, 239, 77, 209, 29, 223, 94, 117, 82, 81, 14, 217, 5, 33, 174, 180, 252, 231, 220, 36, 46, 249})[n5],getSecretNumber(scramble5));
        if ((n14 & 0xCA) != 0x82) {
            return false;
        }
        if ((n6 & 0x41) != 0x41) {
            return false;
        }
        
        // m5 not used?
        final int scramble6 = scramble(scramble5);
        int n15 = m6((new int[] {6, 112, 67, 152, 88, 74, 161, 124, 42, 100, 247, 70, 226, 19, 215, 61, 141, 186, 190, 129, 24, 255, 173, 131, 23, 180, 25, 27, 33, 84, 237, 245, 30, 45, 8, 122, 126, 133, 234, 114, 185, 89, 97, 203, 125, 10, 90, 213, 71, 99, 172, 196, 224, 208, 251, 206, 209, 142, 91, 239, 174, 176, 94, 0, 4, 75, 167, 222, 205, 146, 156, 108, 240, 199, 76, 238, 18, 51, 63, 228, 113, 16, 158, 182, 183, 69, 110, 9, 65, 120, 249, 204, 81, 233, 34, 62, 220, 216, 166, 162, 57, 13, 78, 192, 159, 7, 191, 171, 17, 188, 211, 218, 168, 246, 135, 128, 56, 225, 140, 232, 231, 107, 14, 11, 58, 153, 136, 201, 60, 36, 132, 243, 111, 73, 163, 144, 164, 39, 236, 137, 77, 160, 47, 241, 87, 66, 200, 223, 170, 250, 37, 103, 92, 157, 96, 105, 217, 28, 139, 53, 93, 82, 179, 130, 195, 35, 2, 26, 59, 229, 101, 116, 147, 109, 40, 44, 214, 184, 235, 80, 154, 79, 21, 43, 119, 207, 193, 104, 102, 244, 22, 85, 68, 106, 202, 151, 254, 41, 145, 15, 98, 219, 49, 117, 143, 5, 48, 72, 86, 20, 198, 12, 253, 248, 1, 118, 242, 177, 29, 175, 148, 227, 121, 115, 50, 134, 123, 3, 83, 38, 194, 54, 230, 127, 210, 64, 189, 165, 149, 181, 252, 212, 32, 95, 187, 155, 150, 55, 178, 46, 221, 169, 31, 52, 138, 197})[n7],getSecretNumber(scramble6));
        if ((n15 & 0xFF) != 0xEC) {
            return false;
        }
        
        final int scramble7 = scramble(scramble6);
        // careful, this uses some nativelib array
        int n16 = m7((new int[] {208, 168, 97, 242, 78, 60, 100, 128, 232, 152, 127, 115, 253, 36, 174, 209, 181, 159, 88, 165, 19, 212, 211, 111, 26, 12, 229, 43, 8, 136, 199, 240, 135, 178, 44, 48, 82, 125, 254, 195, 173, 207, 121, 233, 68, 84, 52, 215, 137, 158, 154, 69, 186, 133, 51, 180, 80, 126, 144, 226, 40, 2, 66, 38, 244, 171, 67, 118, 57, 247, 112, 18, 138, 231, 202, 73, 201, 179, 85, 119, 116, 141, 90, 161, 238, 162, 204, 224, 81, 103, 214, 203, 198, 184, 92, 147, 105, 221, 11, 134, 70, 95, 27, 166, 24, 71, 185, 46, 172, 237, 39, 123, 76, 91, 228, 108, 74, 206, 87, 197, 50, 35, 15, 25, 7, 164, 219, 130, 54, 188, 213, 120, 61, 250, 189, 217, 241, 230, 55, 246, 192, 96, 94, 89, 218, 245, 176, 98, 75, 102, 194, 47, 101, 58, 132, 182, 234, 190, 223, 45, 150, 107, 86, 64, 20, 49, 23, 210, 251, 21, 59, 72, 104, 53, 155, 113, 106, 131, 6, 14, 3, 255, 17, 225, 143, 28, 167, 93, 196, 16, 129, 65, 200, 41, 29, 235, 149, 30, 169, 79, 33, 32, 5, 160, 110, 175, 1, 140, 109, 170, 183, 42, 99, 63, 157, 117, 151, 56, 124, 236, 177, 216, 156, 227, 4, 248, 37, 0, 9, 220, 31, 243, 148, 77, 114, 145, 10, 13, 139, 249, 252, 22, 122, 193, 34, 83, 222, 191, 62, 239, 205, 187, 163, 146, 142, 153})[n8],getSecretNumber(scramble7));
        if ((n16 & 0xFF) != 0x8E) {
            return false;
        }

        m9(n + n2 + n3 + n4 + n5 + n6 + n7 * n8); // careful, this fucks up the global s4 in the nativelib
        
        final int scramble8 = scramble(scramble7 + n8);
        // careful, this depends on the global s4 in the nativelib
        int n17 = m8((new int[] {74, 42, 108, 90, 10, 82, 182, 2, 156, 188, 147, 187, 66, 137, 18, 140, 44, 115, 26, 64, 255, 229, 204, 50, 153, 53, 30, 101, 161, 145, 136, 155, 159, 78, 11, 142, 131, 226, 68, 233, 109, 62, 88, 99, 94, 19, 114, 100, 39, 138, 237, 144, 143, 98, 251, 246, 146, 33, 199, 91, 171, 195, 200, 192, 126, 248, 38, 35, 29, 205, 230, 71, 166, 176, 239, 197, 6, 217, 25, 209, 241, 152, 202, 93, 117, 13, 228, 86, 80, 207, 96, 21, 48, 196, 224, 102, 58, 149, 133, 89, 232, 157, 106, 125, 132, 7, 63, 60, 165, 254, 9, 116, 59, 208, 216, 111, 173, 105, 84, 201, 151, 253, 123, 220, 69, 225, 236, 24, 22, 242, 16, 194, 31, 110, 193, 36, 20, 61, 150, 167, 162, 184, 190, 127, 72, 234, 172, 141, 175, 54, 8, 174, 5, 206, 168, 45, 67, 43, 148, 250, 51, 87, 103, 81, 119, 73, 189, 163, 214, 178, 221, 227, 4, 23, 130, 240, 120, 55, 177, 85, 243, 247, 249, 180, 231, 52, 223, 218, 183, 34, 46, 128, 70, 77, 65, 32, 97, 203, 49, 95, 219, 56, 185, 215, 15, 124, 37, 238, 12, 210, 1, 244, 76, 57, 211, 129, 75, 28, 212, 3, 113, 121, 107, 169, 92, 170, 135, 154, 181, 41, 213, 222, 112, 164, 252, 0, 134, 27, 14, 40, 118, 245, 235, 191, 104, 17, 79, 186, 198, 179, 83, 158, 139, 47, 122, 160})[n9],getSecretNumber(scramble8));
        return (n17 & 0xFF) == 0x67 && (getSecretNumber(n) * (long)getSecretNumber(n2) * getSecretNumber(n3) * getSecretNumber(n4) * getSecretNumber(n5) * getSecretNumber(n6) * getSecretNumber(n7) + n8 + getSecretNumber(n9)) % 144L == 37L;
    }

    public static void main(String[] args) {
        ArrayList<Integer> n1cands = new ArrayList<>();
        ArrayList<Integer> n2cands = new ArrayList<>();
        ArrayList<Integer> n3cands = new ArrayList<>();
        ArrayList<Integer> n4cands = new ArrayList<>();
        ArrayList<Integer> n5cands = new ArrayList<>();
        ArrayList<Integer> n6cands = new ArrayList<>();
        ArrayList<Integer> n7cands = new ArrayList<>();
        ArrayList<Integer> n8cands = new ArrayList<>();

        {
        final int scramble = scramble(13);
        for (int n =0;n < 256; n++) {
            int n10 = m0((new int[] {100, 190, 88, 240, 97, 216, 47, 243, 39, 18, 173, 144, 157, 114, 116, 250, 152, 150, 196, 175, 28, 179, 23, 213, 73, 66, 20, 228, 67, 200, 156, 7, 221, 210, 50, 233, 110, 32, 71, 194, 117, 220, 43, 113, 148, 247, 217, 185, 41, 177, 239, 12, 232, 101, 82, 178, 128, 191, 42, 172, 136, 81, 115, 251, 69, 89, 139, 48, 129, 63, 154, 125, 242, 95, 132, 143, 102, 29, 199, 10, 146, 79, 225, 149, 236, 245, 56, 105, 27, 235, 162, 201, 193, 208, 104, 96, 209, 155, 34, 68, 202, 169, 49, 13, 134, 45, 226, 255, 14, 52, 33, 62, 44, 186, 6, 121, 21, 244, 131, 64, 111, 123, 248, 124, 36, 9, 58, 112, 222, 130, 254, 120, 75, 224, 76, 145, 80, 231, 198, 219, 182, 24, 126, 40, 246, 192, 78, 166, 140, 158, 223, 57, 207, 90, 161, 54, 38, 252, 72, 203, 70, 85, 171, 107, 98, 4, 51, 188, 238, 15, 147, 237, 65, 214, 99, 183, 22, 5, 92, 141, 184, 30, 108, 60, 135, 118, 127, 205, 133, 159, 19, 197, 74, 17, 59, 138, 195, 119, 8, 25, 206, 55, 106, 91, 160, 122, 218, 37, 181, 211, 212, 234, 241, 46, 77, 170, 11, 109, 16, 249, 168, 230, 215, 174, 204, 164, 2, 253, 94, 31, 189, 35, 153, 180, 103, 142, 1, 137, 187, 84, 165, 26, 87, 93, 83, 86, 0, 151, 3, 167, 53, 176, 227, 163, 229, 61})[n], getSecretNumber(scramble));
            if ((n10 & 0xFF) != 0xAC) {
                continue;
            }
            n1cands.add(n);
        }

        final int scramble2 = scramble(scramble);
        for (int n2=0;n2 < 256; n2++) {
            int n11 = m1((new int[] {29, 131, 174, 82, 200, 183, 179, 143, 182, 216, 9, 79, 44, 203, 167, 6, 135, 62, 4, 58, 242, 84, 72, 175, 171, 126, 140, 188, 18, 250, 114, 205, 137, 142, 16, 163, 159, 24, 105, 154, 186, 209, 169, 116, 138, 206, 57, 219, 132, 234, 129, 127, 247, 28, 49, 178, 5, 37, 93, 148, 25, 238, 118, 50, 166, 102, 146, 231, 81, 86, 201, 33, 197, 181, 155, 133, 85, 224, 176, 208, 170, 99, 40, 38, 204, 194, 74, 222, 144, 145, 212, 161, 141, 7, 123, 92, 26, 185, 101, 119, 223, 164, 31, 172, 249, 43, 88, 8, 19, 61, 241, 76, 157, 47, 111, 130, 60, 120, 252, 90, 117, 207, 192, 189, 158, 23, 253, 199, 80, 106, 41, 160, 221, 233, 71, 0, 36, 32, 230, 246, 52, 248, 147, 150, 95, 87, 104, 34, 232, 229, 202, 63, 66, 39, 168, 108, 139, 22, 244, 75, 190, 98, 124, 237, 77, 193, 149, 11, 100, 240, 227, 42, 121, 162, 55, 215, 165, 48, 67, 211, 35, 56, 70, 54, 78, 14, 45, 187, 89, 184, 213, 255, 27, 96, 1, 69, 122, 125, 110, 217, 228, 91, 156, 113, 243, 65, 196, 64, 3, 128, 109, 12, 153, 173, 53, 94, 68, 97, 152, 151, 2, 73, 107, 236, 17, 46, 112, 177, 10, 103, 225, 254, 136, 245, 13, 218, 115, 239, 195, 214, 180, 134, 83, 30, 59, 20, 51, 235, 191, 226, 15, 21, 251, 210, 198, 220})[n2],getSecretNumber(scramble2));
            if ((n11 & 0xFF) != 0x6) {
                continue;
            }
            n2cands.add(n2);
        }

        final int scramble3 = scramble(scramble2);
        for (int n3=0;n3 < 256; n3++) {
            int n12 = m2((new int[] {255, 30, 98, 78, 198, 151, 15, 171, 92, 236, 93, 136, 206, 220, 56, 156, 54, 50, 82, 112, 123, 14, 77, 12, 184, 214, 208, 145, 66, 40, 52, 224, 213, 134, 227, 250, 22, 114, 79, 143, 10, 55, 174, 28, 85, 221, 154, 248, 84, 175, 168, 144, 11, 32, 64, 207, 147, 58, 176, 111, 108, 142, 216, 187, 110, 195, 5, 219, 72, 235, 49, 120, 232, 46, 155, 23, 27, 185, 233, 57, 170, 18, 71, 203, 88, 196, 140, 223, 109, 131, 103, 26, 251, 48, 180, 83, 106, 115, 130, 16, 133, 44, 164, 241, 182, 70, 204, 9, 218, 107, 179, 188, 6, 160, 190, 13, 209, 230, 119, 197, 226, 124, 121, 240, 80, 163, 97, 38, 149, 94, 202, 243, 193, 238, 167, 138, 148, 17, 3, 51, 127, 210, 62, 205, 239, 126, 169, 63, 95, 228, 199, 186, 81, 53, 152, 67, 125, 0, 153, 99, 150, 25, 217, 229, 102, 69, 246, 90, 117, 244, 60, 178, 73, 234, 2, 181, 75, 20, 24, 21, 8, 35, 141, 165, 201, 237, 96, 211, 129, 159, 19, 189, 135, 158, 33, 104, 91, 116, 177, 47, 247, 137, 122, 173, 59, 113, 29, 245, 242, 128, 39, 86, 192, 252, 37, 61, 89, 200, 157, 68, 225, 139, 1, 254, 36, 146, 162, 42, 45, 166, 172, 65, 231, 31, 105, 222, 43, 212, 118, 34, 215, 74, 87, 253, 194, 249, 100, 41, 76, 101, 4, 191, 132, 183, 7, 161})[n3],getSecretNumber(scramble3));
            if ((n12 & 0xFB) != 0x92) {
                continue;
            }
            n3cands.add(n3);
        }

        final int scramble4 = scramble(scramble3);
        for (int n4=0;n4 < 256; n4++) {
            int n13 = m3((new int[] {1, 223, 134, 163, 178, 59, 65, 116, 117, 17, 224, 122, 99, 85, 52, 63, 206, 131, 204, 32, 40, 177, 132, 133, 92, 101, 97, 230, 106, 144, 30, 73, 0, 153, 192, 107, 44, 123, 86, 233, 62, 164, 118, 80, 71, 179, 197, 184, 29, 108, 4, 58, 244, 235, 8, 209, 41, 28, 150, 199, 14, 94, 45, 203, 159, 51, 212, 222, 183, 157, 95, 66, 142, 34, 185, 61, 74, 26, 161, 39, 55, 248, 16, 180, 191, 247, 25, 129, 91, 54, 181, 88, 207, 193, 5, 216, 231, 121, 211, 174, 167, 255, 227, 176, 82, 137, 12, 38, 198, 109, 152, 250, 126, 169, 187, 33, 253, 87, 173, 221, 46, 182, 24, 84, 228, 239, 75, 19, 72, 112, 208, 251, 220, 254, 90, 218, 2, 64, 246, 50, 114, 156, 168, 160, 148, 68, 242, 130, 113, 171, 139, 76, 23, 49, 138, 6, 225, 241, 11, 213, 48, 196, 110, 146, 119, 202, 69, 237, 22, 93, 175, 154, 102, 120, 21, 57, 140, 9, 141, 162, 190, 60, 53, 205, 136, 158, 105, 145, 166, 115, 249, 77, 252, 70, 78, 226, 217, 37, 111, 127, 27, 243, 195, 128, 186, 83, 229, 96, 89, 81, 189, 219, 210, 15, 194, 147, 10, 245, 165, 98, 155, 240, 43, 214, 188, 232, 236, 201, 42, 125, 143, 100, 215, 103, 67, 36, 3, 47, 13, 124, 172, 20, 238, 7, 234, 135, 18, 151, 79, 149, 31, 56, 200, 104, 170, 35})[n4],getSecretNumber(scramble4));
            if ((n13 & 0xF7) != 0x61) {
                continue;
            }
            n4cands.add(n4);
        }

        final int scramble5 = scramble(scramble4);
        for (int n5=0;n5 < 256; n5++) {
            int n14 = m4((new int[] {144, 158, 58, 155, 10, 130, 143, 78, 170, 39, 110, 250, 246, 7, 214, 235, 25, 202, 157, 89, 237, 131, 52, 233, 161, 245, 181, 184, 116, 26, 254, 159, 244, 101, 186, 248, 72, 70, 142, 205, 168, 134, 173, 3, 54, 222, 51, 104, 123, 34, 206, 2, 188, 73, 95, 11, 20, 38, 69, 113, 179, 183, 192, 30, 99, 215, 129, 6, 24, 133, 198, 98, 49, 92, 66, 106, 154, 118, 164, 145, 177, 121, 190, 84, 59, 172, 149, 75, 23, 151, 207, 19, 8, 15, 247, 37, 167, 255, 102, 226, 135, 100, 18, 176, 171, 4, 105, 111, 251, 9, 219, 88, 93, 213, 169, 16, 229, 57, 61, 35, 65, 238, 141, 216, 199, 182, 22, 230, 200, 42, 76, 225, 74, 166, 147, 242, 50, 103, 68, 193, 67, 28, 243, 162, 194, 45, 43, 17, 124, 31, 55, 21, 47, 197, 126, 122, 196, 136, 204, 79, 132, 32, 91, 140, 234, 236, 195, 125, 12, 109, 185, 0, 64, 137, 53, 241, 178, 138, 127, 112, 160, 71, 87, 48, 56, 120, 240, 175, 40, 150, 114, 119, 221, 146, 201, 228, 224, 44, 152, 227, 86, 156, 212, 62, 80, 96, 208, 63, 253, 108, 203, 165, 115, 128, 90, 210, 153, 1, 85, 41, 83, 13, 148, 232, 27, 97, 60, 107, 189, 218, 187, 211, 191, 163, 139, 239, 77, 209, 29, 223, 94, 117, 82, 81, 14, 217, 5, 33, 174, 180, 252, 231, 220, 36, 46, 249})[n5],getSecretNumber(scramble5));
            if ((n14 & 0xCA) != 0x82) {
                continue;
            }
            n5cands.add(n5);
        }

        for (int n6=0; n6 < 256;n6++) {
            if ((n6 & 0x41) != 0x41) {
                continue;
            }
            n6cands.add(n6);
        }

        final int scramble6 = scramble(scramble5);
        for (int n7=0;n7 < 256; n7++) {
            int n15 = m6((new int[] {6, 112, 67, 152, 88, 74, 161, 124, 42, 100, 247, 70, 226, 19, 215, 61, 141, 186, 190, 129, 24, 255, 173, 131, 23, 180, 25, 27, 33, 84, 237, 245, 30, 45, 8, 122, 126, 133, 234, 114, 185, 89, 97, 203, 125, 10, 90, 213, 71, 99, 172, 196, 224, 208, 251, 206, 209, 142, 91, 239, 174, 176, 94, 0, 4, 75, 167, 222, 205, 146, 156, 108, 240, 199, 76, 238, 18, 51, 63, 228, 113, 16, 158, 182, 183, 69, 110, 9, 65, 120, 249, 204, 81, 233, 34, 62, 220, 216, 166, 162, 57, 13, 78, 192, 159, 7, 191, 171, 17, 188, 211, 218, 168, 246, 135, 128, 56, 225, 140, 232, 231, 107, 14, 11, 58, 153, 136, 201, 60, 36, 132, 243, 111, 73, 163, 144, 164, 39, 236, 137, 77, 160, 47, 241, 87, 66, 200, 223, 170, 250, 37, 103, 92, 157, 96, 105, 217, 28, 139, 53, 93, 82, 179, 130, 195, 35, 2, 26, 59, 229, 101, 116, 147, 109, 40, 44, 214, 184, 235, 80, 154, 79, 21, 43, 119, 207, 193, 104, 102, 244, 22, 85, 68, 106, 202, 151, 254, 41, 145, 15, 98, 219, 49, 117, 143, 5, 48, 72, 86, 20, 198, 12, 253, 248, 1, 118, 242, 177, 29, 175, 148, 227, 121, 115, 50, 134, 123, 3, 83, 38, 194, 54, 230, 127, 210, 64, 189, 165, 149, 181, 252, 212, 32, 95, 187, 155, 150, 55, 178, 46, 221, 169, 31, 52, 138, 197})[n7],getSecretNumber(scramble6));
            if ((n15 & 0xFF) != 0xEC) {
                continue;
            }
            n7cands.add(n7);
        }

        final int scramble7 = scramble(scramble6);
        for (int n8=0;n8 < 256; n8++) {
            // careful, this uses some nativelib array
            int n16 = m7((new int[] {208, 168, 97, 242, 78, 60, 100, 128, 232, 152, 127, 115, 253, 36, 174, 209, 181, 159, 88, 165, 19, 212, 211, 111, 26, 12, 229, 43, 8, 136, 199, 240, 135, 178, 44, 48, 82, 125, 254, 195, 173, 207, 121, 233, 68, 84, 52, 215, 137, 158, 154, 69, 186, 133, 51, 180, 80, 126, 144, 226, 40, 2, 66, 38, 244, 171, 67, 118, 57, 247, 112, 18, 138, 231, 202, 73, 201, 179, 85, 119, 116, 141, 90, 161, 238, 162, 204, 224, 81, 103, 214, 203, 198, 184, 92, 147, 105, 221, 11, 134, 70, 95, 27, 166, 24, 71, 185, 46, 172, 237, 39, 123, 76, 91, 228, 108, 74, 206, 87, 197, 50, 35, 15, 25, 7, 164, 219, 130, 54, 188, 213, 120, 61, 250, 189, 217, 241, 230, 55, 246, 192, 96, 94, 89, 218, 245, 176, 98, 75, 102, 194, 47, 101, 58, 132, 182, 234, 190, 223, 45, 150, 107, 86, 64, 20, 49, 23, 210, 251, 21, 59, 72, 104, 53, 155, 113, 106, 131, 6, 14, 3, 255, 17, 225, 143, 28, 167, 93, 196, 16, 129, 65, 200, 41, 29, 235, 149, 30, 169, 79, 33, 32, 5, 160, 110, 175, 1, 140, 109, 170, 183, 42, 99, 63, 157, 117, 151, 56, 124, 236, 177, 216, 156, 227, 4, 248, 37, 0, 9, 220, 31, 243, 148, 77, 114, 145, 10, 13, 139, 249, 252, 22, 122, 193, 34, 83, 222, 191, 62, 239, 205, 187, 163, 146, 142, 153})[n8],getSecretNumber(scramble7));
            if ((n16 & 0xFF) != 0x8E) {
                continue;
            }
            n8cands.add(n8);
        }
        }
        System.out.println("search space " + n1cands.size() + "*" + n2cands.size() + "*" + n3cands.size() + "*" + n4cands.size() + "*" + n5cands.size() + "*" + n6cands.size() + "*" + n7cands.size() + "*" + n8cands.size() + "*" + 256 + "="+(n1cands.size()*n2cands.size()*n3cands.size()*n4cands.size()*n5cands.size()*n6cands.size()*n7cands.size()*n8cands.size()*256));

        final int scramble = scramble(13);
        out: for (int n : n1cands) {
            int n10 = m0((new int[] {100, 190, 88, 240, 97, 216, 47, 243, 39, 18, 173, 144, 157, 114, 116, 250, 152, 150, 196, 175, 28, 179, 23, 213, 73, 66, 20, 228, 67, 200, 156, 7, 221, 210, 50, 233, 110, 32, 71, 194, 117, 220, 43, 113, 148, 247, 217, 185, 41, 177, 239, 12, 232, 101, 82, 178, 128, 191, 42, 172, 136, 81, 115, 251, 69, 89, 139, 48, 129, 63, 154, 125, 242, 95, 132, 143, 102, 29, 199, 10, 146, 79, 225, 149, 236, 245, 56, 105, 27, 235, 162, 201, 193, 208, 104, 96, 209, 155, 34, 68, 202, 169, 49, 13, 134, 45, 226, 255, 14, 52, 33, 62, 44, 186, 6, 121, 21, 244, 131, 64, 111, 123, 248, 124, 36, 9, 58, 112, 222, 130, 254, 120, 75, 224, 76, 145, 80, 231, 198, 219, 182, 24, 126, 40, 246, 192, 78, 166, 140, 158, 223, 57, 207, 90, 161, 54, 38, 252, 72, 203, 70, 85, 171, 107, 98, 4, 51, 188, 238, 15, 147, 237, 65, 214, 99, 183, 22, 5, 92, 141, 184, 30, 108, 60, 135, 118, 127, 205, 133, 159, 19, 197, 74, 17, 59, 138, 195, 119, 8, 25, 206, 55, 106, 91, 160, 122, 218, 37, 181, 211, 212, 234, 241, 46, 77, 170, 11, 109, 16, 249, 168, 230, 215, 174, 204, 164, 2, 253, 94, 31, 189, 35, 153, 180, 103, 142, 1, 137, 187, 84, 165, 26, 87, 93, 83, 86, 0, 151, 3, 167, 53, 176, 227, 163, 229, 61})[n], getSecretNumber(scramble));
            if ((n10 & 0xFF) != 0xAC) {
                continue;
            }
            // System.out.printf("n=%02x\n",n);

            final int scramble2 = scramble(scramble);
            for (int n2 : n2cands) {
                int n11 = m1((new int[] {29, 131, 174, 82, 200, 183, 179, 143, 182, 216, 9, 79, 44, 203, 167, 6, 135, 62, 4, 58, 242, 84, 72, 175, 171, 126, 140, 188, 18, 250, 114, 205, 137, 142, 16, 163, 159, 24, 105, 154, 186, 209, 169, 116, 138, 206, 57, 219, 132, 234, 129, 127, 247, 28, 49, 178, 5, 37, 93, 148, 25, 238, 118, 50, 166, 102, 146, 231, 81, 86, 201, 33, 197, 181, 155, 133, 85, 224, 176, 208, 170, 99, 40, 38, 204, 194, 74, 222, 144, 145, 212, 161, 141, 7, 123, 92, 26, 185, 101, 119, 223, 164, 31, 172, 249, 43, 88, 8, 19, 61, 241, 76, 157, 47, 111, 130, 60, 120, 252, 90, 117, 207, 192, 189, 158, 23, 253, 199, 80, 106, 41, 160, 221, 233, 71, 0, 36, 32, 230, 246, 52, 248, 147, 150, 95, 87, 104, 34, 232, 229, 202, 63, 66, 39, 168, 108, 139, 22, 244, 75, 190, 98, 124, 237, 77, 193, 149, 11, 100, 240, 227, 42, 121, 162, 55, 215, 165, 48, 67, 211, 35, 56, 70, 54, 78, 14, 45, 187, 89, 184, 213, 255, 27, 96, 1, 69, 122, 125, 110, 217, 228, 91, 156, 113, 243, 65, 196, 64, 3, 128, 109, 12, 153, 173, 53, 94, 68, 97, 152, 151, 2, 73, 107, 236, 17, 46, 112, 177, 10, 103, 225, 254, 136, 245, 13, 218, 115, 239, 195, 214, 180, 134, 83, 30, 59, 20, 51, 235, 191, 226, 15, 21, 251, 210, 198, 220})[n2],getSecretNumber(scramble2));
                if ((n11 & 0xFF) != 0x6) {
                    continue;
                }
                // System.out.printf(" n2=%02x\n",n2);

                final int scramble3 = scramble(scramble2);
                for (int n3 : n3cands) {
                    int n12 = m2((new int[] {255, 30, 98, 78, 198, 151, 15, 171, 92, 236, 93, 136, 206, 220, 56, 156, 54, 50, 82, 112, 123, 14, 77, 12, 184, 214, 208, 145, 66, 40, 52, 224, 213, 134, 227, 250, 22, 114, 79, 143, 10, 55, 174, 28, 85, 221, 154, 248, 84, 175, 168, 144, 11, 32, 64, 207, 147, 58, 176, 111, 108, 142, 216, 187, 110, 195, 5, 219, 72, 235, 49, 120, 232, 46, 155, 23, 27, 185, 233, 57, 170, 18, 71, 203, 88, 196, 140, 223, 109, 131, 103, 26, 251, 48, 180, 83, 106, 115, 130, 16, 133, 44, 164, 241, 182, 70, 204, 9, 218, 107, 179, 188, 6, 160, 190, 13, 209, 230, 119, 197, 226, 124, 121, 240, 80, 163, 97, 38, 149, 94, 202, 243, 193, 238, 167, 138, 148, 17, 3, 51, 127, 210, 62, 205, 239, 126, 169, 63, 95, 228, 199, 186, 81, 53, 152, 67, 125, 0, 153, 99, 150, 25, 217, 229, 102, 69, 246, 90, 117, 244, 60, 178, 73, 234, 2, 181, 75, 20, 24, 21, 8, 35, 141, 165, 201, 237, 96, 211, 129, 159, 19, 189, 135, 158, 33, 104, 91, 116, 177, 47, 247, 137, 122, 173, 59, 113, 29, 245, 242, 128, 39, 86, 192, 252, 37, 61, 89, 200, 157, 68, 225, 139, 1, 254, 36, 146, 162, 42, 45, 166, 172, 65, 231, 31, 105, 222, 43, 212, 118, 34, 215, 74, 87, 253, 194, 249, 100, 41, 76, 101, 4, 191, 132, 183, 7, 161})[n3],getSecretNumber(scramble3));
                    if ((n12 & 0xFB) != 0x92) {
                        continue;
                    }
                    // System.out.printf("  n3=%02x\n",n3);

                    final int scramble4 = scramble(scramble3);
                    for (int n4 : n4cands) {
                        int n13 = m3((new int[] {1, 223, 134, 163, 178, 59, 65, 116, 117, 17, 224, 122, 99, 85, 52, 63, 206, 131, 204, 32, 40, 177, 132, 133, 92, 101, 97, 230, 106, 144, 30, 73, 0, 153, 192, 107, 44, 123, 86, 233, 62, 164, 118, 80, 71, 179, 197, 184, 29, 108, 4, 58, 244, 235, 8, 209, 41, 28, 150, 199, 14, 94, 45, 203, 159, 51, 212, 222, 183, 157, 95, 66, 142, 34, 185, 61, 74, 26, 161, 39, 55, 248, 16, 180, 191, 247, 25, 129, 91, 54, 181, 88, 207, 193, 5, 216, 231, 121, 211, 174, 167, 255, 227, 176, 82, 137, 12, 38, 198, 109, 152, 250, 126, 169, 187, 33, 253, 87, 173, 221, 46, 182, 24, 84, 228, 239, 75, 19, 72, 112, 208, 251, 220, 254, 90, 218, 2, 64, 246, 50, 114, 156, 168, 160, 148, 68, 242, 130, 113, 171, 139, 76, 23, 49, 138, 6, 225, 241, 11, 213, 48, 196, 110, 146, 119, 202, 69, 237, 22, 93, 175, 154, 102, 120, 21, 57, 140, 9, 141, 162, 190, 60, 53, 205, 136, 158, 105, 145, 166, 115, 249, 77, 252, 70, 78, 226, 217, 37, 111, 127, 27, 243, 195, 128, 186, 83, 229, 96, 89, 81, 189, 219, 210, 15, 194, 147, 10, 245, 165, 98, 155, 240, 43, 214, 188, 232, 236, 201, 42, 125, 143, 100, 215, 103, 67, 36, 3, 47, 13, 124, 172, 20, 238, 7, 234, 135, 18, 151, 79, 149, 31, 56, 200, 104, 170, 35})[n4],getSecretNumber(scramble4));
                        if ((n13 & 0xF7) != 0x61) {
                            continue;
                        }
                        // System.out.printf("   n4=%02x\n",n4);

                        final int scramble5 = scramble(scramble4);
                        for (int n5 : n5cands) {
                            int n14 = m4((new int[] {144, 158, 58, 155, 10, 130, 143, 78, 170, 39, 110, 250, 246, 7, 214, 235, 25, 202, 157, 89, 237, 131, 52, 233, 161, 245, 181, 184, 116, 26, 254, 159, 244, 101, 186, 248, 72, 70, 142, 205, 168, 134, 173, 3, 54, 222, 51, 104, 123, 34, 206, 2, 188, 73, 95, 11, 20, 38, 69, 113, 179, 183, 192, 30, 99, 215, 129, 6, 24, 133, 198, 98, 49, 92, 66, 106, 154, 118, 164, 145, 177, 121, 190, 84, 59, 172, 149, 75, 23, 151, 207, 19, 8, 15, 247, 37, 167, 255, 102, 226, 135, 100, 18, 176, 171, 4, 105, 111, 251, 9, 219, 88, 93, 213, 169, 16, 229, 57, 61, 35, 65, 238, 141, 216, 199, 182, 22, 230, 200, 42, 76, 225, 74, 166, 147, 242, 50, 103, 68, 193, 67, 28, 243, 162, 194, 45, 43, 17, 124, 31, 55, 21, 47, 197, 126, 122, 196, 136, 204, 79, 132, 32, 91, 140, 234, 236, 195, 125, 12, 109, 185, 0, 64, 137, 53, 241, 178, 138, 127, 112, 160, 71, 87, 48, 56, 120, 240, 175, 40, 150, 114, 119, 221, 146, 201, 228, 224, 44, 152, 227, 86, 156, 212, 62, 80, 96, 208, 63, 253, 108, 203, 165, 115, 128, 90, 210, 153, 1, 85, 41, 83, 13, 148, 232, 27, 97, 60, 107, 189, 218, 187, 211, 191, 163, 139, 239, 77, 209, 29, 223, 94, 117, 82, 81, 14, 217, 5, 33, 174, 180, 252, 231, 220, 36, 46, 249})[n5],getSecretNumber(scramble5));
                            if ((n14 & 0xCA) != 0x82) {
                                continue;
                            }
                            // System.out.printf("    n5=%02x\n",n5);

                            for (int n6 : n6cands) {
                                if ((n6 & 0x41) != 0x41) {
                                    continue;
                                }
                                // System.out.printf("     n6=%02x\n",n6);

                                final int scramble6 = scramble(scramble5);
                                for (int n7 : n7cands) {
                                    int n15 = m6((new int[] {6, 112, 67, 152, 88, 74, 161, 124, 42, 100, 247, 70, 226, 19, 215, 61, 141, 186, 190, 129, 24, 255, 173, 131, 23, 180, 25, 27, 33, 84, 237, 245, 30, 45, 8, 122, 126, 133, 234, 114, 185, 89, 97, 203, 125, 10, 90, 213, 71, 99, 172, 196, 224, 208, 251, 206, 209, 142, 91, 239, 174, 176, 94, 0, 4, 75, 167, 222, 205, 146, 156, 108, 240, 199, 76, 238, 18, 51, 63, 228, 113, 16, 158, 182, 183, 69, 110, 9, 65, 120, 249, 204, 81, 233, 34, 62, 220, 216, 166, 162, 57, 13, 78, 192, 159, 7, 191, 171, 17, 188, 211, 218, 168, 246, 135, 128, 56, 225, 140, 232, 231, 107, 14, 11, 58, 153, 136, 201, 60, 36, 132, 243, 111, 73, 163, 144, 164, 39, 236, 137, 77, 160, 47, 241, 87, 66, 200, 223, 170, 250, 37, 103, 92, 157, 96, 105, 217, 28, 139, 53, 93, 82, 179, 130, 195, 35, 2, 26, 59, 229, 101, 116, 147, 109, 40, 44, 214, 184, 235, 80, 154, 79, 21, 43, 119, 207, 193, 104, 102, 244, 22, 85, 68, 106, 202, 151, 254, 41, 145, 15, 98, 219, 49, 117, 143, 5, 48, 72, 86, 20, 198, 12, 253, 248, 1, 118, 242, 177, 29, 175, 148, 227, 121, 115, 50, 134, 123, 3, 83, 38, 194, 54, 230, 127, 210, 64, 189, 165, 149, 181, 252, 212, 32, 95, 187, 155, 150, 55, 178, 46, 221, 169, 31, 52, 138, 197})[n7],getSecretNumber(scramble6));
                                    if ((n15 & 0xFF) != 0xEC) {
                                        continue;
                                    }
                                    // System.out.printf("      n7=%02x\n",n7);

                                    final int scramble7 = scramble(scramble6);
                                    for (int n8 : n8cands) {
                                        // careful, this uses some nativelib array
                                        int n16 = m7((new int[] {208, 168, 97, 242, 78, 60, 100, 128, 232, 152, 127, 115, 253, 36, 174, 209, 181, 159, 88, 165, 19, 212, 211, 111, 26, 12, 229, 43, 8, 136, 199, 240, 135, 178, 44, 48, 82, 125, 254, 195, 173, 207, 121, 233, 68, 84, 52, 215, 137, 158, 154, 69, 186, 133, 51, 180, 80, 126, 144, 226, 40, 2, 66, 38, 244, 171, 67, 118, 57, 247, 112, 18, 138, 231, 202, 73, 201, 179, 85, 119, 116, 141, 90, 161, 238, 162, 204, 224, 81, 103, 214, 203, 198, 184, 92, 147, 105, 221, 11, 134, 70, 95, 27, 166, 24, 71, 185, 46, 172, 237, 39, 123, 76, 91, 228, 108, 74, 206, 87, 197, 50, 35, 15, 25, 7, 164, 219, 130, 54, 188, 213, 120, 61, 250, 189, 217, 241, 230, 55, 246, 192, 96, 94, 89, 218, 245, 176, 98, 75, 102, 194, 47, 101, 58, 132, 182, 234, 190, 223, 45, 150, 107, 86, 64, 20, 49, 23, 210, 251, 21, 59, 72, 104, 53, 155, 113, 106, 131, 6, 14, 3, 255, 17, 225, 143, 28, 167, 93, 196, 16, 129, 65, 200, 41, 29, 235, 149, 30, 169, 79, 33, 32, 5, 160, 110, 175, 1, 140, 109, 170, 183, 42, 99, 63, 157, 117, 151, 56, 124, 236, 177, 216, 156, 227, 4, 248, 37, 0, 9, 220, 31, 243, 148, 77, 114, 145, 10, 13, 139, 249, 252, 22, 122, 193, 34, 83, 222, 191, 62, 239, 205, 187, 163, 146, 142, 153})[n8],getSecretNumber(scramble7));
                                        if ((n16 & 0xFF) != 0x8E) {
                                            continue;
                                        }
                                        // System.out.printf("       n8=%02x\n",n8);
                                        m9(n + n2 + n3 + n4 + n5 + n6 + n7 * n8); // careful, this fucks up the global s4 in the nativelib

                                        final int scramble8 = scramble(scramble7 + n8);
                                        // careful, this depends on the global s4 in the nativelib
                                        for (int n9=0;n9 < 256; n9++) {
                                            int n17 = m8((new int[] {74, 42, 108, 90, 10, 82, 182, 2, 156, 188, 147, 187, 66, 137, 18, 140, 44, 115, 26, 64, 255, 229, 204, 50, 153, 53, 30, 101, 161, 145, 136, 155, 159, 78, 11, 142, 131, 226, 68, 233, 109, 62, 88, 99, 94, 19, 114, 100, 39, 138, 237, 144, 143, 98, 251, 246, 146, 33, 199, 91, 171, 195, 200, 192, 126, 248, 38, 35, 29, 205, 230, 71, 166, 176, 239, 197, 6, 217, 25, 209, 241, 152, 202, 93, 117, 13, 228, 86, 80, 207, 96, 21, 48, 196, 224, 102, 58, 149, 133, 89, 232, 157, 106, 125, 132, 7, 63, 60, 165, 254, 9, 116, 59, 208, 216, 111, 173, 105, 84, 201, 151, 253, 123, 220, 69, 225, 236, 24, 22, 242, 16, 194, 31, 110, 193, 36, 20, 61, 150, 167, 162, 184, 190, 127, 72, 234, 172, 141, 175, 54, 8, 174, 5, 206, 168, 45, 67, 43, 148, 250, 51, 87, 103, 81, 119, 73, 189, 163, 214, 178, 221, 227, 4, 23, 130, 240, 120, 55, 177, 85, 243, 247, 249, 180, 231, 52, 223, 218, 183, 34, 46, 128, 70, 77, 65, 32, 97, 203, 49, 95, 219, 56, 185, 215, 15, 124, 37, 238, 12, 210, 1, 244, 76, 57, 211, 129, 75, 28, 212, 3, 113, 121, 107, 169, 92, 170, 135, 154, 181, 41, 213, 222, 112, 164, 252, 0, 134, 27, 14, 40, 118, 245, 235, 191, 104, 17, 79, 186, 198, 179, 83, 158, 139, 47, 122, 160})[n9],getSecretNumber(scramble8));
                                            if ((n17 & 0xFF) != 0x67) {
                                                continue;
                                            }

                                            // System.out.printf("        n9=%02x\n",n9);
                                            boolean ok = (getSecretNumber(n) * (long)getSecretNumber(n2) * getSecretNumber(n3) * getSecretNumber(n4) * getSecretNumber(n5) * getSecretNumber(n6) * getSecretNumber(n7) + n8 + getSecretNumber(n9)) % 144L == 37L;
                                            // System.out.println(ok);
                                            System.out.print(".");
                                            if (!ok) continue;
                                            System.out.println("*");
                                            System.out.println(ok);
                                            System.out.println(solve2( n,  n2,  n3,  n4,  n5,  n6,  n7,  n8,  n9));
                                            System.out.println(solve( n,  n2,  n3,  n4,  n5,  n6,  n7,  n8,  n9));
                                            System.out.printf("OOO{%02x%02x%02x%02x%02x%02x%02x%02x%02x}\n",n,  n2,  n3,  n4,  n5,  n6,  n7,  n8,  n9);
                                            break out;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}