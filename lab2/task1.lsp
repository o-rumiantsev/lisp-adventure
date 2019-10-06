#|

Задание 1.
Реализовать функцию включения объекта на заданное место в списке (нумерация
элементов – от начала списка).

Исходные данные:
    * 10      - объект
    * 2       - место в списке
    * (1 2 3) - список

Результат: (1 2 10 3)

|#

(defun insert(element index list)
    (cond
        ((eq index 0) (cons element list))
        (t (cons (car list) (insert element (- index 1) (cdr list))))))

(write (insert 10 3 '(1 2 3)))
(terpri)
