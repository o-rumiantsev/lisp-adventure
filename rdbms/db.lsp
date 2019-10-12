(load "./table.lsp")

(defun create-db() '())

(defun db-get-table(db name)
  (cond
    ((null db) nil)
    ((equal (caar db) name) (cadar db))
    (t (db-get-table (cdr db) name))))

(defun db-create-table(db name schema)
  (cond
    ((null (db-get-table db name)) (format t "CREATED TABLE ~S~%" name)))
  (cond
    ((db-get-table db name) nil)
    (t (cons (list name (create-table schema)) db))))

(defun db-table-insert(db name values)
  (cond
    ((null db) nil)
    ((equal (caar db) name)
      (cons (list name (table-insert (cadar db) values)) (cdr db)))
    (t (cons (car db) (db-table-insert (cdr db) name values)))))

(defun db-table-update(db name mappings conditions)
  (cond
    ((null db) nil)
    ((equal (caar db) name)
      (cons (list name (table-update (cadar db) mappings conditions)) (cdr db)))
    (t (cons (car db) (db-table-update (cdr db) name mappings conditions)))))

(defun db-table-delete(db name conditions)
  (cond
    ((null db) nil)
    ((equal (caar db) name)
      (cons (list name (table-delete (cadar db) conditions)) (cdr db)))
    (t (cons (car db) (db-table-delete (cdr db) name conditions)))))


(defun db-drop-table(db name)
  (cond
    ((equal (caar db) name) (format t "DROPPED TABLE ~S~%" name)))
  (cond
    ((null db) nil)
    ((equal (caar db) name) (cdr db))
    (t (cons (car db) (db-drop-table (cdr db) name)))))

(defun db-list-tables(db)
  (cond
    ((car db) (format t "~S~%" (caar db))))
  (cond
    ((null db) nil)
    (t (db-list-tables (cdr db)))))
