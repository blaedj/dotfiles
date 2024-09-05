;;; go-mode-config -- summary
;;; Commentary:
;;;
;;; Code:

(after! go-mode
  (setq go-tab-width 4)
  (setq go-format-before-save t)
  (add-hook 'before-save-hook 'gofmt-before-save)
  )

(use-package! lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :init
  (setq lsp-ui-doc-border "orange"
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-show-with-cursor t
   )
  )

(provide 'go-mode-config)
;;; go-mode-config.el ends here
