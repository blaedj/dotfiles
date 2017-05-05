
;;; magit-config.el ---  magit mode defaults and settings
;;; Commentary:

;;; Code:
(setq magit-push-always-verify nil)
(setq magit-display-buffer-function
      (quote magit-display-buffer-same-window-except-diff-v1))
(setq git-commit-fill-column 70)
(provide 'magit-config)
;;; magit-config.el ends here
