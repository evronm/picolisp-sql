
(setq *SQLITE_LIB "/usr/lib/x86_64-linux-gnu/libsqlite3.so")

(symbols 'sql 'pico)

(def '*qlite3 (%@ "malloc" ))

(de call_sqlite @
(!)
  (cons (native *SQLITE_LIB (next) NIL) (rest))
)

(de open_sql (fn) 
  (call_sqlite "sqlite3_open" fn)
)

(class +Sql)
  (dm T (Fn) 

)
