

#(symbols 'sql 'pico)
(setq *Sqlite_postfix "\n.read in")
(class +Sql)
  (dm T (Fn)
    (call 'mkfifo "in" "out")  # this is from the point of view of the app being automated, not from the pil perspective
    (push '*Bye '(call 'rm "in" "out"))
    #(=: Fd (pipe (exec "echo" "(.read " "|cat" "./in " "|sqlite3" "Fn')" ">out" "&")))
    (=: Fd (pipe (exec "./start_sqlite.sh")))
    (task (: Fd) (in @ (if (read) (prinl @) ())))
  )
  (dm q> (QueryStr)
    (prinl (: Fd))
    (out (: Fd) QueryStr)
    (flush)
  )
(setq x (new '(+Sql) "db"))
