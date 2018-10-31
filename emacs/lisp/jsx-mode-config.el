;;; jsx-mode-config -- configuration for jsx files
;;; Commentary:
;;;
;;; Code:


(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-jsx-mode))
(add-hook 'js2-jsx-mode-hook (lambda () (flycheck-mode 1)))

(defun bcj/run-prettier-autocorrect ()
    "Run prettier on the current buffer's file"
  (interactive)
  (let (filename)
    (setq filename (buffer-file-name (current-buffer)))
    (shell-command (concat " prettier --write " filename ))
    ))

(add-hook 'js2-jsx-mode-hook
          (lambda ()
            (js2-mode-hide-warnings-and-errors)
            (add-hook 'after-save-hook 'bcj/run-prettier-autocorrect nil 'make-it-local)))

(provide 'jsx-mode-config)
;;; jsx-mode.el ends here
