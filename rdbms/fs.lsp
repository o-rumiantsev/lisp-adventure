(defun write-file(filename object)
  (with-open-file
    (stream filename :direction :output :if-exists :rename-and-delete)
      (write object :stream stream)))

(defun read-file(filename)
  (with-open-file
    (stream filename :direction :input)
      (read stream)))
