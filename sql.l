
(load 'capi.l 'util.l 'lib/sqlite.l)

(symbols 'sql 'sqlite 'pico 'util)

(de sanitize (Val)
  (if (num? Val)
    Val
    (surr (replace (chop Val) "'" "\\'") "'" )
  )
)

(de parametrize (Sql . @)
  (setq Parts (util~sc Sql) '?)
  (pack 
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
)

(de get_db (Nm)
  (let Res (sqlite3_open Nm)
    (unless (= SQLITE_OK (car Res)) (quit "Cannot open database" (sqlite3_errmsg (cdr Res))))
    (cadr Res)
  )
)

(de get_query (Db Query Vals) 
  (unless (= SQLITE_OK (sqlite3_prepare_v2 Db Query -1 'Res 0 ) ) (quit "Failed to fetch data" (sqlite3_errmsg DB)) )
  Res
)

(de get_row (Row)
  (when (= SQLITE_ROW (sqlite3_step Row)) Row )
)

(de parse_col_defs (Sql)
 (mapcar '((P) (mapcar 'pack (cdr (split  P " "))) ) (util~sc (pack " " (nth ( member "(" (chop Sql)) 2 )) ",") )
)

(de get_col_defs (Db Tbl)
  (parse_col_defs (sqlite3_column_text (get_row (get_query Db (pack "select * from sqlite_master where type='table' and name='" Tbl "'"))) 4 ))
)

(de q (Db Query Vals)
  (setq Q (get_query Db (parametrize Query Vals)))
  (setq Ncols (sqlite3_column_count Q))
  (prog1 
    (make
      (while (get_row Q)
        (chain
          (mapcar '((N)
              (sqlite3_column_text @ N)
            )
            (range 0 (- Ncols 1))
          )
        )
      )
    )
    (sqlite3_finalize Res) 
  )
)


(if *Dbg
  (setq DB (get_db 'foo.db))
)
