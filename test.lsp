(defun f1(a b c d &optional operator)
    (cond
        ((equal operator "member")
            (cond
                ((null b) nil)
                ((equal a (car b)) t)
                (t (f1 a (cdr b) nil nil "member"))))
        ((equal operator "union")
            (cond
                ((null a) b)
                ((null b) a)
                ((f1 (car b) a nil nil "member") (f1 a (cdr b) nil nil "union"))
                (t (cons (car b) (f1 a (cdr b) nil nil "union")))))
        ((equal operator "intersect")
            (cond
                ((null a) nil)
                ((null b) nil)
                ((f1 (car b) a nil nil "member") (f1 (list (car b)) (f1 a (cdr b) nil nil "intersect") nil nil "union"))
                (t (f1 a (cdr b) nil nil "intersect"))))
        ((equal operator "except")
            (cond
                ((null a) nil)
                ((null b) a)
                ((f1 (car a) b nil nil "member") (f1 (cdr a) b nil nil "except"))
                (t (f1 (list (car a)) (f1 (cdr a) b nil nil "except") nil nil "union"))))
        ((null a) nil)
        ((null operator)
            (f1 a (f1 b (f1 c d nil nil "intersect") nil nil "union") nil nil "except"))))

(write (f1 '(1 2 3 4 5) '(2 3) '(3 4) '(4 5)))
(terpri)

(write (f1 '(1 2 3 4 5) '(6 7 8) '(3 4) '(4 5)))
(terpri)

(write (f1 '() '(2 3) '(3 4) '(4 5)))
(terpri)
