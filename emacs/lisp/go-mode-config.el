;;; go-mode-config -- summary
;;; Commentary:
;;;
;;; Code:

(setq go-tab-width 4)
;; (setq gofmt-command "goimports")
(setq go-format-before-save t)
(gofmt-before-save)

(use-package lsp-mode
  :commands (lsp lsp-deferred))

(add-hook 'go-mode-hook #'lsp-deferred)

;; optional - provides fancier overlays. remove if it turns out to be slow
(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :init
  (setq lsp-ui-doc-border "orange"
        lsp-ui-doc-use-childframe nil
   )
  )

;; (spacemacs|use-package-add-hook go
;;   :post-config
;;   (spacemacs/set-leader-keys-for-major-mode 'go-mode
;;     "gg" 'go-guru-definition))


;; (spacemacs|use-package-add-hook go
;;   (add-hook 'before-save-hook 'gofmt-before-save nil 'make-it-local)
;;   )


(provide 'go-mode-config)
;;; go-mode-config.el ends here
