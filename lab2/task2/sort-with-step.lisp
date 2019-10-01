(load "./utils.lisp")

(defun sort-with-step-until(i step l &optional (j i))
    (cond
        ((< j 0) l)
        ((< (nth i l) (nth j l)) (sort-with-step-until j step (swap i j l) (- j step)))
        (t (sort-with-step-until i step l (- j step)))))

(defun sort-with-step(step l &optional (i 0))
    (cond
       ((>= i (length l)) l)
       (t (sort-with-step step (sort-with-step-until i step l) (+ i step)))))
