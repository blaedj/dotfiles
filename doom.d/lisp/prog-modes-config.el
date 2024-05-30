;;; prog-modes-config.el --- hooks and things for programming modes -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2024 Blaed Johnston
;;
;; Author: Blaed Johnston <blaed@blaed.org>
;; Maintainer: Blaed Johnston <blaed@blaed.org>
;; Created: May 22, 2024
;; Modified: May 22, 2024
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  hooks and things for programming modes
;;
;;; Code:


(after! copilot
  (map! :i [C-tab] #'copilot-accept-completion)

  (defun bcj/copilot-mode-maybe ()
    "Enable copilot-mode only if a specific directory-local variable is not set."
    (unless (bound-and-true-p bcj-disable-copilot)
      (unless (eq major-mode 'lisp-interaction-mode) ;; this could probably be it's own unnested condition
        (copilot-mode 1))))

  (add-hook 'prog-mode-hook 'bcj/copilot-mode-maybe))

(defun bcj/prog-mode-hook ()
    "Custom configuration for programming modes."
    ;; (hl-line-mode)
    ;; (use-package nlinum
    ;;   :init
    ;;   (global-nlinum-mode t))

    ;; (require 'idle-highlight)
    ;; (idle-highlight t)
    ;(linum-relative-on) ;;makes 400+ line files so laggy to scroll/move!!
    (if (display-graphic-p) (hl-line-mode t))
  ) ;
(add-hook 'prog-mode-hook 'bcj/prog-mode-hook)

(provide 'prog-modes-config)
;;; prog-modes-config.el ends here
