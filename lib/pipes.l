
(setq *MSG_POSTFIX ";\n.read ./in\n")
(setq *TO_PROC "in" *FROM_PROC "out") 

(class +Pipe)
  (dm T (Proc Opts)
    (=: msg_postfix (cdr (assoc "msg_postfix" Opts)))
    (call 'mkfifo *TO_PROC *FROM_PROC)  
    (push '*Bye '(call 'rm *TO_PROC *FROM_PROC))
    (call Proc)
  )

  (dm msg> (Msg Cb) #message, callback
    (prog1 (in *FROM_PROC  #ugly, but need to flush after...
      (out *TO_PROC (prinl Msg (: msg_postfix)))
      (Cb (read))
    )
    (flush))
  )
  (dm q> (Sql) 
    (send 'msg> This Sql '((x) x))
  )

(if *Dbg
  (setq x (new '(+Pipe) "./start_sqlite.sh" '(("msg_postfix" . ";\n.read ./in\n"))))
  (send 'msg> x "select 'x';" '((str) (prinl str)) )
)
