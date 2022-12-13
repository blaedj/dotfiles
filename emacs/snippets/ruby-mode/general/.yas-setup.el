
(defun ruby-snippet-init-assignments (arg-string)
  (let ((indentation (make-string (save-excursion
                                    (goto-char start-point)
                                    (current-indentation))
                                  ?\s)))
    (string-trim (mapconcat (lambda (arg)
                              (if (string-match "^\\*" arg)
                                  ""
                                (format "@%s = %s\n%s"
                                        arg arg indentation)))
                            (ruby-snippet-split-args arg-string)
                            ""))))

(defun ruby-snippet-split-args (arg-string)
  (mapcar (lambda (x)
            (if (and x (string-match "\\([[:alnum:]]*\\):" x))
                (match-string-no-properties 1 x)
              x))
          (split-string arg-string "[[:blank:]]*,[[:blank:]]*" t)))
