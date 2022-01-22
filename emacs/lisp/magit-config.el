
;;; magit-config.el ---  magit mode defaults and settings
;;; Commentary:

;;; Code:
(setq magit-push-always-verify t)
(setq magit-display-buffer-function
      (quote magit-display-buffer-same-window-except-diff-v1))
(setq git-commit-fill-column 70)

(setq magit-repository-directories '("~/code/"))


(provide 'magit-config)
;;; magit-config.el ends here
