;;; bcj-layouts.el --- custom layouts. and also calendar stuff...

;;; Commentary:

;;; Code:

(setq default-frame-alist '((undecorated . t)))
(add-to-list 'default-frame-alist '(drag-internal-border . 1))
(add-to-list 'default-frame-alist '(internal-border-width . 5))

(setq calendar-latitude 46.78)
(setq calendar-longitude -92.1)
(setq calendar-location-name "Duluth, MN")

;; (spacemacs|define-custom-layout "@bcj-default"
;;   :binding "d"
;;   :body
;;   (org-agenda nil "b")
;;   (other-window 1)
;;   (delete-other-windows)
;;   ()
;;   (split-window-right 110)         ; split window @ 120 chars, creating 2nd col.
;;   (split-window-below 65)          ; create 2nd row for terminals in 1st column
;;   (other-window 1)                 ; jump to 1st column, 2nd row
;;   (ansi-term "/bin/zsh")
;;   (toggle-window-dedicated)        ; make the window for terminal 'dedicated'
;;   (other-window 1)                 ; jump to 2nd column
;;   (split-window-right 95)          ; split 2nd col at 85 cols, creating 3rd col.
;;   (other-window 1)                 ; jump to 3rd column
;;   (split-window-below)             ; create 2nd row in 3rd col for agenda.
;;   (other-window 1)                 ; jump to 2nd row in 3rd col
;;   (switch-to-buffer "*Org Agenda*"); open agenda buffer
;;   (toggle-window-dedicated)        ; make window for agenda dedicated
;;   (other-window -1)                ; jump back to 1st row, 3rd col
;;   (switch-to-buffer "todo.org")    ; open todo file
;;   (toggle-window-dedicated)        ; make window for todo.org dedicated
;; )

;; (provide 'bcj-layouts)
;;; bcj-layouts.el ends here
