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
    ;; (hl-line-mode)
    ;; (use-package nlinum
    ;;   :init
    ;;   (global-nlinum-mode t))

    ;; (require 'idle-highlight)
    ;; (idle-highlight t)
    ;(linum-relative-on) ;;makes 400+ line files so laggy to scroll/move!!
    (if (display-graphic-p) (hl-line-mode t))
  ) ;
(add-hook 'prog-mode-hook 'bcj/prog-mode-hook)

(add-hook 'elixir-format-hook
          (lambda ()
            (if (projectile-project-p)
                (setq elixir-format-arguments
                      (list "--dot-formatter"
                            (concat
                             (locate-dominating-file buffer-file-name ".formatter.exs")
                             ".formatter.exs")))
              (setq elixir-format-arguments nil))))

(use-package blamer
  :ensure t
  :defer 20
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                   :background nil
                   :height 130
                   :italic t)))
  :custom
  (blamer-idle-time 0.8)
  (blamer-min-offset 10)
  (blamer-view 'overlay)
  (blamer-commit-formatter "-- %s")
  :config
  (global-blamer-mode 0)
  )

(provide 'prog-modes-config)
;;; prog-modes-config.el ends here
