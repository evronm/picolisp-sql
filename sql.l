
(load 'capi.l 'util.l 'lib/sqlite.l)

(symbols 'sql 'sqlite 'pico 'util)

(de sanitize (Val)
  (if (num? Val)
    Val
    (surr (replace (chop Val) "'" "\\'") "'" )
  )
)

(de parametrize (Sql . @)
  (setq Parts (split (chop Sql) '?))
  (append 
    (mapcar 
      '((L)
        (list L (sanitize (next))) 
      )
      (head -1 Parts)
    )
    (tail 1 Parts)
  )
)

(de start_db (Nm)
  (let Res (sqlite3_open Nm)
    (unless (= SQLITE_OK (car Res))
      (quit "Cannot open database" (sqlite3_errmsg (cdr Res)))
    )
    (cdr Res)
  )
)


(if *Dbg
)
