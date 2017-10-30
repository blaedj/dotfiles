;;; prog-modes-config -- general setup for progamming modes
;;; Commentary:
;;;
;;; Code:

;; thanks to https://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun bcj/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'bcj/use-eslint-from-node-modules)

(defun bcj/prog-mode-hook ()
    "Custom configuration for programming modes."
    (fci-mode t)
    (setq fci-rule-color "#616d9f")

    (use-package nlinum
      :init
      (global-nlinum-mode t))
    ;; (require 'idle-highlight)
    ;; (idle-highlight t)
    ;(linum-relative-on) ;;makes 400+ line files so laggy to scroll/move!!
  ) ;
(add-hook 'prog-mode-hook 'bcj/prog-mode-hook)

(provide 'prog-modes-config)
;;; prog-modes-config.el ends here
