;;; epub-config -- stuff for reading epubs
;;; Code:


;;nov ;; epub-reading mode
(use-package nov
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(provide 'epub-config)
;;; epub-config.el ends here
