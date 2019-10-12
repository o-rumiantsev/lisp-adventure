(defun boolp(value)
  (or
    (equal (type-of value) 'boolean)
    (equal (type-of value) 'null)))

(defun push-back(lst value)
  (cond
    ((null lst) (cons value nil))
    (t (cons (car lst) (push-back (cdr lst) value)))))

(defun validate(schema row)
  (cond
    ((null schema) t)
    ((null (equal (length schema) (length row))) nil)
    ((and (equal (cadar schema) 'number) (null (numberp (car row)))) nil)
    ((and (equal (cadar schema) 'string) (null (stringp (car row)))) nil)
    ((and (equal (cadar schema) 'bool) (null (boolp (car row)))) nil)
    (t (validate (cdr schema) (cdr row)))))

(defun substitute-recursive(newitem olditem sequence)
  (cond
    ((null sequence) nil)
    ((listp (car sequence))
      (cons
        (substitute-recursive newitem olditem (car sequence))
        (substitute-recursive newitem olditem (cdr sequence))))
    (t (substitute newitem olditem (cons
      (car sequence)
      (substitute-recursive newitem olditem (cdr sequence)))))))

(defun row-accept-conditions(row schema conditions)
  (cond
    ((null conditions) t)
    ((null schema) (eval conditions))
    ((null row) nil)
    (t (row-accept-conditions
      (cdr row)
      (cdr schema)
      (substitute-recursive (car row) (caar schema) conditions)))))

(defun filter-rows(rows schema conditions &optional result)
  (cond
    ((null rows) result)
    ((row-accept-conditions (car rows) schema conditions)
      (filter-rows (cdr rows) schema conditions (push-back result (car rows))))
    (t (filter-rows (cdr rows) schema conditions result))))

(defun delete-rows(rows schema conditions &optional result)
  (cond
    ((row-accept-conditions (car rows) schema conditions)
      (format t "DELETE ~S~%" (car rows))))
  (cond
    ((null rows) result)
    ((null (row-accept-conditions (car rows) schema conditions))
      (delete-rows (cdr rows) schema conditions (push-back result (car rows))))
    (t (delete-rows (cdr rows) schema conditions result))))

(defun get-mapping(column-name mappings)
  (cond
    ((null mappings) nil)
    ((equal (caar mappings) column-name) (cadar mappings))
    (t (get-mapping column-name (cdr mappings)))))

(defun apply-mapping(value column-name mapping)
  (cond
    ((listp mapping) (eval (substitute value column-name mapping)))
    (t mapping)))

(defun map-row(row schema mappings
  &optional (source-row row) (source-schema schema) result)
  (cond
    ((and (null schema) (validate source-schema result))
      (format t "UPDATE ~S --> ~S~%" source-row result)))
  (cond
    ((and (null schema) (validate source-schema result)) result)
    ((null schema) source-row)
    ((null mappings) row)
    ((get-mapping (caar schema) mappings)
      (map-row
        (cdr row)
        (cdr schema)
        mappings
        source-row
        source-schema
        (push-back
          result
          (apply-mapping
            (car row)
            (caar schema)
            (get-mapping (caar schema) mappings)))))
    (t
      (map-row
        (cdr row)
        (cdr schema)
        mappings
        source-row
        source-schema
        (push-back result (car row))))))

(defun update-rows(rows schema mappings conditions &optional result)
  (cond
    ((null rows) result)
    ((row-accept-conditions (car rows) schema conditions)
      (update-rows
        (cdr rows)
        schema
        mappings
        conditions
        (push-back result (map-row (car rows) schema mappings))))
    (t
      (update-rows
        (cdr rows)
        schema
        mappings
        conditions
        (push-back result (car rows))))))

(defun get-type(schema column-name)
  (cond
    ((null schema) nil)
    ((equal (caar schema) column-name) (cadar schema))
    (t (get-type (cdr schema) column-name))))

(defun get-value(row schema column-name)
  (cond
    ((null schema) nil)
    ((equal (caar schema) column-name) (car row))
    (t (get-value (cdr row) (cdr schema) column-name))))

(defun compare-rows(row1 row2 schema ordering &optional result)
  (cond
    (result t)
    ((null ordering) nil)
    ((equal (get-type schema (caar ordering)) 'number)
      (cond
        ((equal (cadar ordering) 'desc)
          (compare-rows
            row1
            row2
            schema
            (cdr ordering)
            (>=
              (get-value row1 schema (caar ordering))
              (get-value row2 schema (caar ordering)))))
        (t
          (compare-rows
            row1
            row2
            schema
            (cdr ordering)
            (<=
              (get-value row1 schema (caar ordering))
              (get-value row2 schema (caar ordering)))))))
    ((equal (get-type schema (caar ordering)) 'string)
      (cond
        ((equal (cadar ordering) 'desc)
          (compare-rows
            row1
            row2
            schema
            (cdr ordering)
            (string>=
              (get-value row1 schema (caar ordering))
              (get-value row2 schema (caar ordering)))))
        (t
          (compare-rows
            row1
            row2
            schema
            (cdr ordering)
            (string<=
              (get-value row1 schema (caar ordering))
              (get-value row2 schema (caar ordering)))))))
    ((equal (get-type schema (caar ordering)) 'bool)
      (cond
        ((equal (get-value row1 schema (caar ordering))
          (get-value row2 schema (caar ordering)))
            (compare-rows row1 row2 schema (cdr ordering)))
        ((equal (cadar ordering) 'desc)
          (compare-rows
            row1
            row2
            schema
            (cdr ordering)
            (and
              (null (get-value row1 schema (caar ordering)))
              (get-value row2 schema (caar ordering)))))
        (t
          (compare-rows
            row1
            row2
            schema
            (cdr ordering)
            (and
              (get-value row1 schema (caar ordering))
              (null (get-value row2 schema (caar ordering))))))))
    (t (compare-rows row1 row2 schema (cdr ordering)))))

(defun order-rows(rows schema ordering)
  (cond
    ((null ordering) rows)
    (t (sort rows
      (lambda(row1 row2) (compare-rows row1 row2 schema ordering))))))
