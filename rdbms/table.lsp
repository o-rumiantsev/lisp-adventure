(load "utils.lsp")

(defun create-table(schema) (list schema))

(defun table-insert(table row)
  (cond
    ((validate (car table) row) (format t "INSERT ~S~%" row)))
  (cond
    ((validate (car table) row) (push-back table row))
    (t table)))

(defun table-filter(table conditions)
  (cons (car table) (filter-rows (cdr table) (car table) conditions)))

(defun table-delete(table conditions)
  (cons (car table) (delete-rows (cdr table) (car table) conditions)))

(defun table-update(table mappings conditions)
  (cons (car table) (update-rows (cdr table) (car table) mappings conditions)))

(defun table-order(table ordering)
  (cons (car table) (order-rows (cdr table) (car table) ordering)))

(defun print-row(row schema)
  (cond
    ((car schema) (format t "~S: ~S, " (caar schema) (car row))))
  (cond
    ((null schema) nil)
    (t (print-row (cdr row) (cdr schema)))))

(defun print-rows(rows)
  (cond
    ((car rows) (format t "~S~%" (car rows))))
  (cond
    ((null rows) nil)
    (t (print-rows (cdr rows)))))

(defun get-columns(schema &optional result)
  (cond
    ((null schema) result)
    (t (get-columns (cdr schema) (push-back result (caar schema))))))

(defun table-print(table)
  (format t "~S~%" (get-columns (car table)))
  (print-rows (cdr table)))
