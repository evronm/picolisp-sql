# 28jul23 Software Lab. Alexander Burger
# pil @lib/sqlite.l  --symbols sqlite  +

(load "@lib/clang.l")
(load "lib/util.l")

(symbols 'sqlite 'util 'pico)

(local) (sqDefs SQLITE_OK SQLITE_ROW)

# C definitions ################################
: (clang "sqlite" NIL
   (sqDefs (N) sqDefs 'I N) )

#include <stdio.h>
#include <sqlite3.h>

int sqDefs(void) {
   printf("SQLITE_OK\t%d\n", SQLITE_OK);
   printf("SQLITE_ROW\t%d\n", SQLITE_ROW);
   return 0;
}
/**/
################################################

# Read C definitions
(pipe (sqDefs)
   (while (read) (def @ (read))) )

# Globals
(local) (*SqLib)

(de *SqLib . "libsqlite3.so")

# API functions
(local) (sqlite3_open sqlite3_errmsg sqlite3_prepare_v2 sqlite3_step sqlite3_column_text sqlite3_finalize sqlite3_close sanitize parametrize get_db get_query get_row parse_col_defs get_col_defs get_col_names q)

(de sqlite3_open (Name)
  (setq Code (native *SqLib "sqlite3_open" 'I Name '(Db (8 . P))) )
  (list Code Db) #Return Code
)

(de sqlite3_errmsg (DB)
    (native *SqLib "sqlite3_errmsg" 'S DB) )

(de sqlite3_prepare_v2 (DB Sql Len Var Tail)
   (native *SqLib "sqlite3_prepare_v2" 'I
      DB Sql Len (list Var (8 . P)) Tail ) )

(de sqlite3_step (Res)
   (native *SqLib "sqlite3_step" 'I Res) )

(de sqlite3_column_text (Res Col)
   (native *SqLib "sqlite3_column_text" 'S Res Col) )

(de sqlite3_column_count (Res)
   (native *SqLib "sqlite3_column_count" 'I Res) )

(de sqlite3_column_name (Res Col)
   (native *SqLib "sqlite3_column_name" 'S Res Col) )

(de sqlite3_finalize (Res)
   (native *SqLib "sqlite3_finalize" 'I Res) )

(de sqlite3_close (DB)
   (native *SqLib "sqlite3_close" 'I DB) )

(de sanitize (Val)
  (if (num? Val)
    Val
    (surr (replace (chop Val) "'" "\\'") "'" )
  )
)

(de parametrize (Sql . @)
  (setq Parts (sc Sql) '?)
  (pack 
    (append 
      (mapcar 
        '((L)
          (list L (sanitize (next))) 
        )
        (head -1 Parts)
      )
      (tail 1 Parts)
    )
  )
)

(de get_db (Nm)
  (let Res (sqlite3_open Nm)
    (unless (= SQLITE_OK (car Res)) (quit "Cannot open database" (sqlite3_errmsg (cdr Res))))
    (cadr Res)
  )
)

(de get_query (Db Query Vals) 
  (unless (= SQLITE_OK (sqlite3_prepare_v2 Db Query -1 'Res 0 ) ) (quit "Failed to fetch data" (sqlite3_errmsg DB)) )
  Res
)

(de get_row (Q)
  (when (= SQLITE_ROW (sqlite3_step Q)) Q )
)

(de parse_col_defs (Sql)
  (mapcar '((P) (mapcar 'pack (cdr (split  P " "))) ) (sc (pack " " (nth ( member "(" (chop Sql)) 2 )) ",") )
)

(de get_col_defs (Db Tbl)
  (parse_col_defs (sqlite3_column_text (get_row (get_query Db (pack "select * from sqlite_master where type='table' and name='" Tbl "'"))) 4 ))
)

(de get_col_names (Q)
  (mapcar '((N) 
      (sqlite3_column_name Q N)
    )
    (range 0 (- (sqlite3_column_count Q) 1))
  )
)

(de q (Db Query Vals)
  (setq Q (get_query Db (parametrize Query Vals)))
  (setq Ncols (sqlite3_column_count Q))
  (prog1 
    (make (while (get_row Q) (chain (mapcar '((N) (sqlite3_column_text @ N)) (range 0 (- Ncols 1) ) ) ) ) )
    (sqlite3_finalize Res) 
  )
)


(when *Dbg 
  (finish (sqlite3_close DB) (%@ "unlink" NIL 'foo.db))
  (setq DB (get_db 'foo.db))
  (get_row (get_query DB "create table foo (id int, foo text, dt date)"))
  (get_row (get_query DB "insert into foo values (1, 'asdf', '20220101')"))
  (assert (= (q DB "select * from foo")  '(1 asdf 20220101) ))
)
