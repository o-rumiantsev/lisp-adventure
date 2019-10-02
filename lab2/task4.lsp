(defun merge-lists(l1 l2
    &optional (l1i (- (length l1) 1)) (l2i (- (length l2) 1)) (result '()))

    (cond
        ((and (eq l1i -1) (eq l2i -1)) result)
        ((eq l1i -1)
            (merge-lists l1 l2 -1 (- l2i 1) (cons (nth l2i l2) result)))
        ((eq l2i -1)
            (merge-lists l1 l2 (- l1i 1) -1 (cons (nth l1i l1) result)))
        ((> (nth l1i l1) (nth l2i l2))
            (merge-lists l1 l2 (- l1i 1) l2i (cons (nth l1i l1) result)))
        (t (merge-lists l1 l2 l1i (- l2i 1) (cons (nth l2i l2) result)))))

(defparameter list1 '(1 2 2 4 7 10))
(defparameter list2 '(2 3 4 5 6 14))

(write (merge-lists list1 list2))
(terpri)
