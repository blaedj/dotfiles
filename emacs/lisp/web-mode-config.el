;;; web-mode-config.el -- web mode configuration and customization
;;; Commentary:
;;;
;;; Code:

(spacemacs|disable-company web-mode)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-code-indent-offset   2)
(setq web-mode-script-padding 0)

(defun bcj/web-mode-hook ()
  (company-mode nil)
)

(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))
(add-hook 'web-mode-hook 'bcj/web-mode-hook)

(provide 'web-mode-config)
;;; package.el ends here
