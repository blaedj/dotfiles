;;; display-config -- display configurations dealing with term vs gui
;;; Commentary:
;;;
;;; Code:

(defun check-if-bg-color-needed (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))

(set-face-background 'font-lock-comment-face "unspecified-bg")
(add-hook 'after-make-frame-functions 'check-if-bg-color-needed)

(setq spacemacs-theme-comment-bg nil)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-Iosvkem) ;

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  ;; (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config));

(provide 'display-config)
;;; display-config.el ends here
