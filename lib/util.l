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

(if *Dbg
  ~(assert (= "xasdfx" (surr "asdf" "x")))
  ~(assert (= "(asdf)" (surr "asdf" "(")))
  ~(assert (= "[asdf]" (surr "asdf" "[")))
  ~(assert (= "{asdf}" (surr "asdf" "{")))
)

