;;; display-config -- display configurations dealing with term vs gui
;;; Commentary:
;;;
;;; Code:

(defun check-if-bg-color-needed (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))

;; commented out the below line because it causes errors, "unspecified-bg" is not a valid color.
;; (set-face-background 'font-lock-comment-face "unspecified-bg")
(add-hook 'after-make-frame-functions 'check-if-bg-color-needed)

(setq spacemacs-theme-comment-bg nil)

(setq custom-theme-directory "~/.dotfiles/emacs/themes" )

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t  ; if nil, italics is universally disabled
        custom-doom-tomorrow-night-brighter-comments t ; if non-nil, comments are brighter
        doom-peacock-brighter-comments t
        )
  ;; (load-theme 'doom-Iosvkem) ;
  ;; (load-theme 'doom-tomorrow-night) ;
  ;;(load-theme 'custom-doom-tomorrow-night) ; has more visible comments


  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  ;; (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config));
(load-theme 'doom-peacock)

;; thanks to https://karthinks.com/software/batteries-included-with-emacs/
(defun pulse-line (&rest _)
  "Pulse the current line."
  (pulse-momentary-highlight-one-line (point)))

(provide 'display-config)
;;; display-config.el ends here
