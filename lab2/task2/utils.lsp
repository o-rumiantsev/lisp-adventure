(defun set-by-index(v i l)
    (cond
        ((eq i 0) (cons v (cdr l)))
        (t (cons (car l) (set-by-index v (- i 1) (cdr l))))))

(defun swap(i j l)
    (cond
        ((> i j) (swap j i l))
        (t (set-by-index (nth i l) j (set-by-index (nth j l) i l)))))
