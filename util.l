#(symbols 'util 'pico)

(de opts_lamb (Args  Prg)
#takes an args list and a prg list.  Adds an Opt argument to the former, and prepends options interning in the latter and returns a lambda
  (make
    (link(make (chain Args) (link 'Opts)))
    (chain
        (make 
          (link  '(for X Opts (put This (car X) (cdr x)) )) 
          (chain Prg)
        )
    )
  )
)

(if *Dbg
  
)

