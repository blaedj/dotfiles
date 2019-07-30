;;; ruby-mode-config -- configuration for editing ruby files
;;; Commentary:
;;;
;;; Code:

(add-to-list 'auto-mode-alist '("\\.ruby\\'" . ruby-mode))
(setq rspec-spec-command "bin/rspec") ;;should change per-project...
(setq rspec-use-spring-when-possible nil) ;

(provide 'ruby-mode-config)
;;; ruby-mode-config.el ends here
