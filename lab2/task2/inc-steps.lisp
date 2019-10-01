(defun step-even(i) (+ 1 (- (* 9 (expt 2 i)) (* 9 (expt 2 (/ i 2))))))

(defun step-odd(i) (+ 1 (- (* 8 (expt 2 i)) (* 6 (expt 2 (/ (+ i 1) 2))))))

(defun inc-step(i)
    (cond
        ((eq (mod i 2) 0) (step-even i))
        (t (step-odd i))))

(defun check-step(value s)
    (cond
        ((null value) t)
        ((> (* value 3) s) nil)
        (t t)))

(defun inc-steps(s &optional (i 0) steps)
    (cond
        ((check-step (car steps) s) (inc-steps s (+ i 1) (cons (inc-step i) steps)))
        (t (cdr steps))))
