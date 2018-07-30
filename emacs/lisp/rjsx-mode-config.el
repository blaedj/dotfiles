;;; rjsx-mode-config -- configuration for jsx files
;;; Commentary:
;;;
;;; Code:


(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
(add-hook 'rjsx-mode-hook (lambda () (flycheck-mode 1)))

(defun bcj/run-prettier-autocorrect ()
    "Run prettier on the current buffer's file"
  (interactive)
  (let (filename)
    (setq filename (buffer-file-name (current-buffer)))
    (shell-command (concat " prettier --write " filename ))
    ))

(add-hook 'rjsx-mode-hook
          (lambda ()
            (js2-mode-hide-warnings-and-errors)
            (add-hook 'after-save-hook 'bcj/run-prettier-autocorrect nil 'make-it-local)))

(provide 'rjsx-mode-config)
;;; rjsx-mode.el ends here
