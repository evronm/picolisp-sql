
(load 'capi.l 'util.l 'pipes.l)

(symbols 'sql 'pico)

(de sanitize (Val)
  (if (num? Val)
    Val
    (list "'" (replace (chop Val) "'" "\\'") "'" )
  )
)
(de parametrize (Sql . @)
  (mapcar '((E) (append E (list (sanitize (next) ) ) ) ) (split (chop Sql) '?))
)

(class +Db)
  (dm T (Nm)
    #(=: handle (open_sqlite Nm)
    (setq  (new '(+Pipe) "./start_sqlite.sh" '(("msg_postfix" . ";\n.read ./in\n"))))

  )
  (dm q> (Sql Vals)
    
  )
  (dm close> ()
  )


(if *Dbg
)
