(load "./db.lsp")
(load "./fs.lsp")

(defun process-create(db cmd-type)
  (if (equal cmd-type 'TABLE)
      (db-create-table db (read) (read))
      (progn
        (format t "Try: CREATE TABLE <name> <schema>~%")
        db)))

(defun process-drop(db cmd-type)
  (if (equal cmd-type 'TABLE)
      (db-drop-table db (read))
      (progn
        (format t "Try: DROP TABLE <name>~%")
        db)))

(defun process-insert(db cmd-type)
  (if (equal cmd-type 'INTO)
      (db-table-insert db (read) (read))
      (progn
        (format t "Try: INSERT INTO <name> <values>~%")
        db)))

(defun process-update(db table-name)
  (db-table-update db table-name (read) (read)))

(defun process-delete(db table-name)
  (db-table-delete db table-name (read)))

(defun process-select(db table-name)
  (table-print
    (table-order
      (table-filter
        (db-get-table db table-name)
        (read)) (read))))

(defun process-list(db cmd-type)
  (if (null (equal cmd-type 'TABLES))
      (format t "Try: LIST TABLES~%")
      (db-list-tables db)))

(defun process-save(db filename)
  (write-file filename db)
  (format t "Saved db to ~S~%" filename))

(defun process-load(filename)
  (format t "Loaded db from ~S~%" filename)
  (read-file filename))

(defun help()
  (write-line "")
  (write-line "General commands:")
  (write-line "  EXIT               close CLI")
  (write-line "  SAVE <filename>    save db to file")
  (write-line "  LOAD <filename>    load db from file")
  (write-line "")
  (write-line "Database:")
  (write-line "  LIST TABLES                              list db tables")
  (write-line "  CREATE TABLE <name> <schema>             create table")
  (write-line "  DROP TABLE <name>                        drop table")
  (write-line "  SELECT <name> <conditions> <ordering>    select data from table")
  (write-line "  INSERT INTO <name> <row>                 insert data to table")
  (write-line "  UPDATE <name> <mappings> <conditions>    update data in table")
  (write-line "  DELETE <name> <conditions>               delete data from table")
  (write-line ""))

(defun prompt()
    (write-string "> ")
    (force-output))

(defun read-command()
    (prompt)
    (read))

(defun process-command(db cmd)
  (cond
    ((equal cmd 'SELECT) (process-select db (read)))
    ((equal cmd 'LIST)   (process-list   db (read)))
    ((equal cmd 'SAVE)   (process-save   db (read)))
    ((equal cmd 'HELP)   (help)))
  (cond
    ((equal cmd 'LOAD)   (process-load      (read)))
    ((equal cmd 'CREATE) (process-create db (read)))
    ((equal cmd 'DROP)   (process-drop   db (read)))
    ((equal cmd 'INSERT) (process-insert db (read)))
    ((equal cmd 'UPDATE) (process-update db (read)))
    ((equal cmd 'DELETE) (process-delete db (read)))
    (t db)))

(defun process-command-loop(db cmd)
  (if (equal cmd 'EXIT) (write-line "bye")
  (process-command-loop (process-command db cmd) (read-command))))

(defun cli(db)
  (write-line "Welcome to LiSQL CLI")
  (help)
  (process-command-loop db (read-command)))

(cli (create-db))
