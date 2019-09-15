-- $ nc rev.chal.csaw.io 1002
-- Do you know the secret code?:
-- 11*1*11191411111*111191*11111*111*1*11
-- Alright good job! now guess a number
-- 371403488018579819126082
-- "keep going!"
-- ok! now guess the next number
-- 557105232027869728689126
-- "keep going!"
-- yes! last one ??
-- 742806976037159638252172
-- "flag{y0u_4r3_d3f1nat3lY_a_M4tH_w1zKiD}\n"

-- stage1 = 11*1*11191411111*111191*11111*111*1*11 , found via LITEARL FUZZING LMAO
-- stage2 = 371403488018579819126082 , 2 times stage1
-- stage3 = 557105232027869728689126 , 3 times (stage1 + 1)
-- stage4 = 742806976037159638252172 , 4 times (stage1 + 2)

-- https://sctf.ehsandev.com/reversing/lambda1.html

Main_main_closure = >> $fMonadIO
    (putStrLn (unpackCString# "Do you know the secret code?:"))
    (>>= $fMonadIO
        getLine
        (\s3Fd_info_arg_0 ->
            case == $fEqInt
                ((\ruw_info_arg_0 ->
                    case ruw_info_arg_0 of
                        c4du_info_case_tag_DEFAULT_arg_0@_DEFAULT -> + $fNumInt loc_7325432 (max $fOrdInt !!ERROR!! !!ERROR!!),
                        c4du_info_case_tag_DEFAULT_arg_0@_DEFAULT -> + $fNumInt loc_7325432 (max $fOrdInt !!ERROR!! !!ERROR!!),
                        c4du_info_case_tag_DEFAULT_arg_0@_DEFAULT -> loc_7325432
                )
                    s3EJ_info
                )
                (I# 8)
            of
                False -> error (pushCallStack (Z2T (unpackCString# "error") (SrcLoc (unpackCString# "main") (unpackCString# "Main") (unpackCString# "wizkid.hs") (I# 101) loc_7325560 (I# 101) (I# 66))) emptyCallStack) (unpackCString# "Please think more deeply about this problem ..."),
                True -> >> $fMonadIO
                    (ruD_info
                        s3EW_info
                        (unpackCString# "Alright good job! now guess a number")
                        (\ruF_info_arg_0 -> + $fNumInt ruF_info_arg_0 ruF_info_arg_0) -- THE ASNWER OF THE SECOND STAGE IS THE DOUBLE OF THE ANSWER OF THE FIRST STAGE
                        ruC_info
                    ) (>> $fMonadIO 
                        (ruD_info
                            s3EX_info -- STAGE1 ANSWER PLUS ONE
                            (unpackCString# "ok! now guess the next number")
                            (\ruG_info_arg_0 -> + $fNumInt (+ $fNumInt ruG_info_arg_0 ruG_info_arg_0) ruG_info_arg_0) -- THE ASNWER OF THE SECOND STAGE IS THE TRIPLE OF THE ANSWER OF THE FIRST STAGE, PLUS ON
                            ruC_info
                        ) (ruD_info 
                            (ruB_info (+ $fNumInt s3EX_info loc_7325432)) -- STAGE 1 ANSWER PLUS ONE PLUS ONE
                            (unpackCString# "yes! last one ??")
                            (\ruH_info_arg_0 -> + $fNumInt (+ $fNumInt (+ $fNumInt ruH_info_arg_0 ruH_info_arg_0) ruH_info_arg_0) ruH_info_arg_0) -- THE ASNWER OF THE SECOND STAGE IS FOUR TIMES OF THE ANSWER OF THE FIRST STAGE, PLUS TWO
                            (>>= $fMonadIO (openFile (unpackCString# "./flag.txt") ReadMode) (\s3Bn_info_arg_0 -> >>= $fMonadIO (hGetContents s3Bn_info_arg_0) (\s3Bm_info_arg_0 -> >> $fMonadIO (print ($fShow[] $fShowChar) s3Bm_info_arg_0) (hClose s3Bn_info_arg_0))))
                        )
                    )
        )
    )

-- 7325432 = 0x6FC6F8 = struct { void* typeinfo = &ghc-prim_GHC.Types_I#_static_info , uint64_t val = 1 };
-- Constant immediate 1
loc_7325432 = I# 1

-- Lexer/evaluator shit
s3EW_info = (\rut_info_arg_0 ->
    case rut_info_arg_0 of
        c4fk_info_case_tag_DEFAULT_arg_0@_DEFAULT -> * $fNumInt !!ERROR!! !!ERROR!!,
        c4fk_info_case_tag_DEFAULT_arg_0@_DEFAULT -> + $fNumInt !!ERROR!! !!ERROR!!,
        c4fk_info_case_tag_DEFAULT_arg_0@_DEFAULT -> !!ERROR!!
)

-- increment by one
s3EX_info = ruB_info (+ $fNumInt s3EW_info loc_7325432)

-- stage number (False = stage1, True = stage2-4)
ruA_info = \ruA_info_arg_0 -> == ($fEq[] $fEqInt) (filter (\s3CG_info_arg_0 -> == $fEqInt (mod $fIntegralInt ruA_info_arg_0 s3CG_info_arg_0) (I# 0)) (enumFromTo $fEnumInt loc_7325448 (div $fIntegralInt ruA_info_arg_0 loc_7325448))) []

-- does nothing in stages 2-4
ruB_info = \ruB_info_arg_0 ->
    case ruA_info ruB_info_arg_0 of
        False -> ruB_info (+ $fNumInt ruB_info_arg_0 loc_7325432),
        True -> ruB_info_arg_0

ruC_info = print ($fShow[] $fShowChar) (unpackCString# "keep going!")

-- print message1, then read a number, check if input value == (ruD_info_arg_2 message1)
-- if correct, go to next_func. else, print fail message and exit
ruD_info = \input message1 ruD_info_arg_2 next_func ->
    case input of
        c49j_info_case_tag_DEFAULT_arg_0@_DEFAULT -> case ruA_info <index 0 in c49j_info_case_tag_DEFAULT> of
            False -> error (pushCallStack (Z2T (unpackCString# "error") (SrcLoc (unpackCString# "main") (unpackCString# "Main") (unpackCString# "wizkid.hs") (I# 102) loc_7325560 (I# 102) (I# 46))) emptyCallStack) (unpackCString# "Getting deeper I see :) ..."),
            True -> >> $fMonadIO
                (putStrLn message1)
                (>>= $fMonadIO
                    getLine
                    (\s3Dj_info_arg_0 ->
                        case == $fEqInt (read $fReadInt s3Dj_info_arg_0) 2 of
                            False -> error (pushCallStack (Z2T (unpackCString# "error") (SrcLoc (unpackCString# "main") (unpackCString# "Main") (unpackCString# "wizkid.hs") (I# 103) loc_7325560 (I# 103) (I# 62))) emptyCallStack) (unpackCString# "OOooooohh sooo close, you're almost there!!"),
                            True -> next_func
                    )
                )
