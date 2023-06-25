(setq *TO_PROC "in" *FROM_PROC "out") 


(de opts_meth Fun
  (cons
    (append (car Fun) '(Opts))
    '(for X Opts (put This (car X) (cdr X)))
     (cdr Fun) ) )

(class +Pipe)

  (dm T
    ~(opts_meth (Proc) 
        (call 'mkfifo *TO_PROC *FROM_PROC)  
        (finish (call 'rm *TO_PROC *FROM_PROC))
        (call Proc) ) )

(setq X (new '(+Pipe) "./start_sqlite.sh" '(("msg_postfix" . ";\n.read ./in\n"))))

(show X)


