;;; web-mode-config.el -- web mode configuration and customization
;;; Commentary:
;;;
;;; Code:

(setq web-mode-markup-indent-offset 2)
(setq web-mode-code-indent-offset   2)
(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))

(provide 'web-mode-config)
;;; package.el ends here
