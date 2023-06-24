
#(symbols 'util 'pico)
(de opts_lamb (Args Prg)
   (cons
      (conc Args '(Opts))
      (list
         '(for X Opts
            (put This (car X) (cdr x)) )
         Prg ) ) )

(if *Dbg
  
)

