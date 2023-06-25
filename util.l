#(symbols 'util 'pico)

(de opts_lamb (Args  Prg)
#takes an args list and a prg list.  Adds an Opt argument to the former, and prepends options interning in the latter and returns a lambda
     (cons
        (append Args '(Opts))
        '(for X Opts (put This (car X) (cdr x)))
        Prg ) 

)

(de opts_meth Fun
  (cons
    (append (car Fun) '(Opts))
    '(for X Opts (put This (car X) (cdr X)))
     (cdr Fun) 
  ) 
)


#(de opts_meth Fun
#  (cons
#    (append (car Fun) '(Opts))
#    '(for X Opts (put This (car X) (cdr x)))
#     (cdr Fun) 
#  )
#)
(if *Dbg
  
)

