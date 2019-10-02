(load "./task2/utils.lsp")

(defun count-list(l &optional (level 0) (result '()))
    (cond
        ((null l) result)
        ((listp (car l))
            (count-list (cdr l) level
                (count-list (car l) (+ level 1) result)))
        ((null (numberp (car l))) (count-list (cdr l) level result))
        ((null (nth level result))
            (count-list (cdr l) level
                (set-by-index
                    (set-by-index 1 1
                        (set-by-index (+ level 1) 0 (nth level result)))
                level result)))
        (t (count-list (cdr l) level
                (set-by-index
                    (set-by-index
                        (+ (nth 1 (nth level result)) 1)
                    1 (nth level result))
                level result)))))

(defparameter test-list '(1 2 k (1) (2 3 (10) k) 3))

(write (count-list test-list))
(terpri)

