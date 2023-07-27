(symbols 'util 'pico)

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
  ~(assert (= "xasdfx" (util~surr "asdf" "x")))
  ~(assert (= "(asdf)" (util~surr "asdf" "(")))
  ~(assert (= "[asdf]" (util~surr "asdf" "[")))
  ~(assert (= "{asdf}" (util~surr "asdf" "{")))
)

