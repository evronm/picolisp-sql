
(load 'util.l)
(setq *MSG_POSTFIX ";\n.read ./in\n")
(setq *TO_PROC "in" *FROM_PROC "out") 

(class +Pipe)

  (dm T 
    ~( opts_meth (Proc) 
      (call 'mkfifo *TO_PROC *FROM_PROC)  
      (finish (call 'rm *TO_PROC *FROM_PROC))
      (call Proc)
    )
  )

  (dm msg> (Msg Cb) #message, callback
    (in *FROM_PROC
      (out *TO_PROC (prinl Msg (: msg_postfix)))
      (Cb (read))
    )
    (flush)
  )

(if *Dbg
  
  (setq X (new '(+Pipe) "./start_sqlite.sh" '(("msg_postfix" . ";\n.read ./in\n"))))
  (send 'msg> X "select 'x';" '((str) (prinl str)) )
)

