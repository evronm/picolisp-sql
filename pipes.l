

#(symbols 'sql 'pico)
(setq *Sqlite_postfix ";\n.read ./in\n")
(setq *TO_DB "in" *FROM_DB "out")

(class +Sql)
  (dm T (Fn)
    (call 'mkfifo "in" "out")  # this is from the point of view of the app being automated, not from the pil perspective
    (push '*Bye '(call 'rm "in" "out"))
    (call "./start_sqlite.sh")
  )

  (dm q> (QueryStr)
    (in *FROM_DB
      (out *TO_DB (prinl QueryStr *Sqlite_postfix))
      (setq res (read))
      (prinl res)
    )
    (flush)
  )



(if *Dbg
  (setq x (new '(+Sql) "db"))
  (send 'q> x "select 'x';")
)
