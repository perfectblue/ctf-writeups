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
                False -> >> $fMonadIO (ruD_info s3EW_info (unpackCString# "Alright good job! now guess a number") (\ruF_info_arg_0 -> + $fNumInt ruF_info_arg_0 ruF_info_arg_0) ruC_info) (>> $fMonadIO (ruD_info s3EX_info (unpackCString# "ok! now guess the next number") (\ruG_info_arg_0 -> + $fNumInt (+ $fNumInt ruG_info_arg_0 ruG_info_arg_0) ruG_info_arg_0) ruC_info) (ruD_info (ruB_info (+ $fNumInt s3EX_info loc_7325432)) (unpackCString# "yes! last one ??") (\ruH_info_arg_0 -> + $fNumInt (+ $fNumInt (+ $fNumInt ruH_info_arg_0 ruH_info_arg_0) ruH_info_arg_0) ruH_info_arg_0) (>>= $fMonadIO (openFile (unpackCString# "./flag.txt") ReadMode) (\s3Bn_info_arg_0 -> >>= $fMonadIO (hGetContents s3Bn_info_arg_0) (\s3Bm_info_arg_0 -> >> $fMonadIO (print ($fShow[] $fShowChar) s3Bm_info_arg_0) (hClose s3Bn_info_arg_0))))))
        )
    )
loc_7325432 = I# 1
s3EX_info = ruB_info (+ $fNumInt s3EW_info loc_7325432)
s3EW_info = (\rut_info_arg_0 ->
    case rut_info_arg_0 of
        c4fk_info_case_tag_DEFAULT_arg_0@_DEFAULT -> * $fNumInt !!ERROR!! !!ERROR!!,
        c4fk_info_case_tag_DEFAULT_arg_0@_DEFAULT -> + $fNumInt !!ERROR!! !!ERROR!!,
        c4fk_info_case_tag_DEFAULT_arg_0@_DEFAULT -> !!ERROR!!
)
    s3EJ_info
s3EJ_info = !!ERROR!!
ruC_info = print ($fShow[] $fShowChar) (unpackCString# "keep going!")
loc_7325560 = I# 9

ruB_info = \ruB_info_arg_0 ->
    case ruA_info ruB_info_arg_0 of
        False -> ruB_info (+ $fNumInt ruB_info_arg_0 loc_7325432),
        False -> ruB_info_arg_0

ruA_info = \ruA_info_arg_0 -> == ($fEq[] $fEqInt) (filter (\s3CG_info_arg_0 -> == $fEqInt (mod $fIntegralInt ruA_info_arg_0 s3CG_info_arg_0) (I# 0)) (enumFromTo $fEnumInt loc_7325448 (div $fIntegralInt ruA_info_arg_0 loc_7325448))) []
loc_7325448 = I# 2

ruD_info = \ruD_info_arg_0 ruD_info_arg_1 ruD_info_arg_2 ruD_info_arg_3 ->
    case ruD_info_arg_0 of
        c49j_info_case_tag_DEFAULT_arg_0@_DEFAULT -> case ruA_info <index 0 in c49j_info_case_tag_DEFAULT> of
            False -> error (pushCallStack (Z2T (unpackCString# "error") (SrcLoc (unpackCString# "main") (unpackCString# "Main") (unpackCString# "wizkid.hs") (I# 102) loc_7325560 (I# 102) (I# 46))) emptyCallStack) (unpackCString# "Getting deeper I see :) ..."),
            False -> >> $fMonadIO
                (putStrLn ruD_info_arg_1)
                (>>= $fMonadIO
                    getLine
                    (\s3Dj_info_arg_0 ->
                        case == $fEqInt (read $fReadInt s3Dj_info_arg_0) 2 of
                            False -> error (pushCallStack (Z2T (unpackCString# "error") (SrcLoc (unpackCString# "main") (unpackCString# "Main") (unpackCString# "wizkid.hs") (I# 103) loc_7325560 (I# 103) (I# 62))) emptyCallStack) (unpackCString# "OOooooohh sooo close, you're almost there!!"),
                            False -> ruD_info_arg_3
                    )
                )
