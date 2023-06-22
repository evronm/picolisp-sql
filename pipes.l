

#(symbols 'sql 'pico)
(setq *MSG_POSTFIX ";\n.read ./in\n")
(setq *TO_PROC "in" *FROM_PROC "out") 

(class +Pipe)
  (dm T (Proc Opts)
    (call 'mkfifo *TO_PROC *FROM_PROC)  
    (push '*Bye '(call 'rm *TO_PROC *FROM_PROC))
    (call Proc)
  )

  (dm msg> (Msg Cb) #message, callback
    (in *FROM_PROC
      (out *TO_PROC (prinl Msg *MSG_POSTFIX))
      (Cb (read))
    )
    (flush)
  )

(if *Dbg
  (setq x (new '(+Pipe) "./start_sqlite.sh"))
  (send 'msg> x "select 'x';" '((str) (prinl str)) )
)
