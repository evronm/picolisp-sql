
(symbols 'sql 'pico)
(zero Fd)
(setq *Sqlite_postfix "\n.read in")
(class +Sql)
  (dm T (Fn)
    (call 'mkfifo "in" "out")  # this is from the point of view of the app being automated, not from the pil perspective
    (push '*Bye '(call 'rm "in" "out"))
    (setq Fd ()))
  (dm q> (QueryStr)
    (out Fd ))
