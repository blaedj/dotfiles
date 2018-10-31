;;; go-mode-config -- summary
;;; Commentary:
;;;
;;; Code:

(setq go-tab-width 4)
(setq gofmt-command "goimports")
(setq go-format-before-save t)

(gofmt-before-save)

(spacemacs|use-package-add-hook go
  :post-config
  (spacemacs/set-leader-keys-for-major-mode 'go-mode
    "gg" 'go-guru-definition))


(spacemacs|use-package-add-hook go
  (add-hook 'before-save-hook 'gofmt-before-save nil 'make-it-local)
  )

;; (add-hook 'go-mode-hook
;;           (lambda ()
;;             (js2-mode-hide-warnings-and-errors)
;;             (add-hook 'after-save-hook 'bcj/run-prettier-autocorrect nil 'make-it-local)))

(provide 'go-mode-config)
;;; go-mode-config.el ends here
