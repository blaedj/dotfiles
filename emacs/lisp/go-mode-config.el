;;; go-mode-config -- summary
;;; Commentary:
;;;
;;; Code:

(setq go-tab-width 4)
;; (setq gofmt-command "goimports")
(setq go-format-before-save t)
;; (gofmt-before-save)

(use-package lsp-mode
  :commands (lsp lsp-deferred))

(add-hook 'go-mode-hook #'lsp-deferred)

;; optional - provides fancier overlays. remove if it turns out to be slow
;; (use-package lsp-ui
;;   :after lsp-mode
;;   :commands lsp-ui-mode
;;   :init
;;   (setq lsp-ui-doc-border "orange"
;;         lsp-ui-doc-use-childframe nil
;;    )
;;   )

;; some experimental go pls configs for controlling where documentation/type info is displayed
;; this _should_ make the docs etc show up in the minibuffer instead of an overlay
;; (setq lsp-eldoc-render-all t)
;; (setq lsp-gopls-hover-kind "NoDocumentation")
;; (setq lsp-ui-sideline-enable nil) ;; I thought this turned off the linine overlays, but not sure..
;; (lsp-register-custom-settings
;;  '(("gopls.hoverKind" lsp-gopls-hover-kind)))

(provide 'go-mode-config)
;;; go-mode-config.el ends here
