;;; display-config -- display configurations dealing with term vs gui
;;; Commentary:
;;;
;;; Code:

(defun check-if-bg-color-needed (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))

(add-hook 'after-make-frame-functions 'check-if-bg-color-needed)


(setq spacemacs-theme-comment-bg nil)
(provide 'display-config)
;;; display-config.el ends here
