

#(symbols 'sql 'pico)
(setq *MSG_POSTFIX ";\n.read ./in\n")
(setq *TO_DB "in" *FROM_DB "out") 

(class +Pipe)
  (dm T (Proc Opts)
    (call 'mkfifo *TO_DB *FROM_DB)  
    (push '*Bye '(call 'rm *TO_DB *FROM_DB))
    (call Proc)
  )

  (dm msg> (Msg Cb) #message, callback
    (in *FROM_DB
      (out *TO_DB (prinl Msg *MSG_POSTFIX))
      (Cb (read))
    )
    (flush)
  )

(if *Dbg
  (setq x (new '(+Pipe) "./start_sqlite.sh"))
  (send 'msg> x "select 'x';" '((str) (prinl str)) )
)
