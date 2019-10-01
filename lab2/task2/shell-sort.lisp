(load "./inc-steps.lisp")
(load "./sort-with-step.lisp")

(defun sort-by-inc-steps(steps l)
    (cond
        ((null steps) l)
        (t (sort-by-inc-steps (cdr steps) (sort-with-step (car steps) l)))))

(defun shell-sort(l)
    (sort-by-inc-steps (inc-steps (length l)) l))

(defparameter test-list '(10 9 8 7 6 5 4 3 2 1))

(write test-list)
(terpri)

(write (shell-sort test-list))
(terpri)
