;;; ruby-mode-config -- configuration for editing ruby files
;;; Commentary:
;;;
;;; Code:

(add-to-list 'auto-mode-alist '("\\.ruby\\'" . ruby-mode))
(setq rspec-spec-command "bin/rspec") ;;should change per-project...
(setq rspec-use-spring-when-possible nil) ;

;; this defaults to 'lsp if lsp layer is used. Since I don't have lsp set up for
;; ruby, change back to the old robe default.
(setq ruby-backend 'robe)

(require 'seeing-is-believing)
(add-hook 'ruby-mode-hook 'seeing-is-believing)

(provide 'ruby-mode-config)
;;; ruby-mode-config.el ends here
