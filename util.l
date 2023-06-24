
#(symbols 'util 'pico)
(de add_opts (Args Prg)
   (cons
      (conc Args '(Opts))
      (list
         '(for X Opts
            (put This (car X) (cdr x)) )
         (val 'Prg) ) ) )

