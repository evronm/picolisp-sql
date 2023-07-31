(symbols 'util 'pico)

(de sc (Str Sep)
  (split (chop Str) Sep)
)
(de foldl (Fun Lst Init)
  (if (= () Lst)
    Init
    (foldl Fun (cdr Lst) ( Fun (car Lst) Init) )
  )
)

(de surr (Str Surr)
  (let (Close (
    case Surr
      ("(" . ")")
      ("[" . "]")
      ("{" "}")
      (T Surr)
  )) 
    (pack Surr Str Close)
  )
)

(de disp (Msg Obj . @)
    (ifn (try Msg Obj (rest))
      (send 'method_missing> Obj Msg (rest))
    )
)

(when *Dbg
  ~(assert (= "xasdfx" (surr "asdf" "x")))
  ~(assert (= "(asdf)" (surr "asdf" "(")))
  ~(assert (= "[asdf]" (surr "asdf" "[")))
  ~(assert (= "{asdf}" (surr "asdf" "{")))
  (class +Test)
    (dm method_missing> (Meth . @)
      (list Meth (rest))
    )
)

