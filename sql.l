
(load 'capi.l)

(symbols 'sql 'pico)

(class +Db)
  (dm T (Nm)
    (=: handle (open_sqlite Nm)
  )
  (dm q> (sql vals)
  )
  (dm close> ()
  )


(if *Dbg
)
