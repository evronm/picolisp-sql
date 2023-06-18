
(symbols 'sql 'pico)
(setq *Sqlite_postfix "\n.read in")
(class +Sql)
  (dm T (Fn)
    (call 'mkfifo "in" "out")  # this is from the point of view of the app being automated, not from the pil perspective
    (push '*Bye '(call 'rm "in" "out"))
    (=: Fd (pipe (exec "echo" ".read " "|cat" "./in " "|sqlite3" "Fn" ">out" "&")))
    (task (: Fd) (prinl (in :Fd)))) 
  (dm q> (QueryStr)
    (out (: Fd) QueryStr))
