# 28jul23 Software Lab. Alexander Burger
# pil @lib/sqlite.l  --symbols sqlite  +

(load "@lib/clang.l")

(symbols 'sqlite 'pico)

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
(local) (sqlite3_open sqlite3_errmsg sqlite3_prepare_v2 sqlite3_step
sqlite3_column_text sqlite3_finalize sqlite3_close)

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

(de sqlite3_finalize (Res)
   (native *SqLib "sqlite3_finalize" 'I Res) )

(de sqlite3_close (DB)
   (native *SqLib "sqlite3_close" 'I DB) )
