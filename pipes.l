(load 'util.l)

(class +Pipe)

  (dm T (Proc Opts) 
    (=:  proc Proc)
    (while Opts (put This (pop 'Opts) (pop 'Opts)))
    (call 'mkfifo 
      (=: to_proc (tmp (pack (: to_p_fn) inc (0)))) 
      (=: from_proc (tmp (pack (: from_p_fn) inc (0)))) 
    )
    ( let (@to_proc (: to_proc) @from_proc (: from_proc))
      (! eval (fill (append '(call) (: proc))  ))
    )
  )

  (dm post_fix> ()
    ( let (@to_proc (: to_proc) @from_proc (: from_proc))
      (! fill (: msg_postfix))
    )
  )

  (dm msg> (Msg Cb) #message, callback
    (in (: from_proc)
        (out (: to_proc) (prinl Msg (postfix>))
        (Cb (read))
      )
    )
    (flush)
  )


(if *Dbg
  (setq X (new '(+Pipe) '('sqlite3 '<  "\".output" @from_proc "\n.read"  @to_proc "\"" '&) '(msg_postfix  '("\n.read" @to_proc "\n") to_p_fn "in" from_p_fn "out")))
  #(setq X (new '(+Pipe) '('echo "\".output" @from_proc "\n.read"  @to_proc "\"" "|" 'sqlite3 '&) '(msg_postfix  '("\n.read" @to_proc "\n") to_p_fn "in" from_p_fn "out")))
#  (send 'msg> X "select 'x';" '((str) (prinl str)) )
)

