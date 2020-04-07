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

;; Fun with font-lock and images :)
;; (font-lock-add-keywords 'go-mode
;;                         '(("\\_<\\(go\\) " 1 '(face nil display (image :type png :file "~/Desktop/gopher_small.png" :ascent center)))))

;; (spacemacs|use-package-add-hook go
;;   :post-config
;;   (spacemacs/set-leader-keys-for-major-mode 'go-mode
;;     "gg" 'go-guru-definition))


;; (spacemacs|use-package-add-hook go
;;   (add-hook 'before-save-hook 'gofmt-before-save nil 'make-it-local)
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
