

#(symbols 'sql 'pico)
(setq *MSG_POSTFIX ";\n.read ./in\n")
(setq *TO_DB "in" *FROM_DB "out") # this is from the point of view of the app being automated, not from the pil perspective

(class +Pipe)
  (dm T (Proc)
    (call 'mkfifo *TO_DB *FROM_DB)  
    (push '*Bye '(call 'rm *TO_DB *FROM_DB))
    (call Proc)
  )

  (dm msg> (Msg Cb) #message, callback
    (in *FROM_DB
      (out *TO_DB (prinl Msg *MSG_POSTFIX))
      (Cb (read))
      #(setq res (read))
      #(prinl res)
    )
    (flush)
  )
  (de cb (Str)
    (prinl Str)
  )


(if *Dbg
  (setq x (new '(+Pipe) "./start_sqlite.sh"))
  (send 'msg> x "select 'x';" 'cb)
)
