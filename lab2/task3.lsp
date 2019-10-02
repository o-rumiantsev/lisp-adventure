(load "./task2/utils.lsp")

(defun bin-search(l key right &optional (left -1))
    (cond
        ((>= left (- right 1)) right)
        ((> key (nth (floor (/ (+ left right) 2)) l)) (bin-search l key right (floor (/ (+ left right) 2))))
        (t (bin-search l key (floor (/ (+ left right) 2)) left))))

(defun move-left(count i l)
    (cond
        ((eq count 0) l)
        (t (move-left (- count 1) (- i 1) (swap i (- i 1) l)))
    )
)

(defun bin-insertion-sort(l &optional (i 0))
    (cond
        ((eq (length l) i) l)
        (t (bin-insertion-sort (move-left (- i (bin-search l (nth i l) i)) i l) (+ i 1)))
    )
)

(defparameter test-list '(10 9 8 7 6 5 4 3 2 21))

(write (bin-insertion-sort test-list))
(terpri)
