;;; org-doom-settings.el --- Org mode defaults and settings
;;; Commentary:

;;; Code:

(after! org
  (setq org-log-done t)
  (setq org-directory "~/Dropbox/org" )
  (setq org-agenda-files (list (concat org-directory "/todo.org")
                               (concat org-directory "/gcal.org")
                               ))
  ;; todo.org file, probably in dropbox if dropbox is installed
  (setq org-default-notes-file (concat org-directory "/todo.org"))

  ;; other possibilities
  ;; ▼, ↴, ⬎, ⤷, and ⋱.
  (setq org-ellipsis "↴")
  (setq org-return-follows-link t)

  (defun bcj/org-mode-hook ()
    (turn-on-auto-fill)
    (hl-line-mode -1)
    )
  (add-hook 'org-mode-hook 'bcj/org-mode-hook)

  (defun open-todo ()
    "Opens the todo.org file stored in dropbox, if present."
    (interactive)
    (if (file-exists-p org-default-notes-file)
        (find-file org-default-notes-file)
      ))
  (push #'open-todo after-init-hook)

  (setq org-todo-keywords
        '(
          (sequence "TODO"
                    "IN-PROGRESS"
                    "DONE" )
          (sequence "ON-HOLD")
          ))

  (setq org-todo-keyword-faces
        '(
          ("IN-PROGRESS" .
           (:background "lime green"  :foreground "#002b36" :weight bold))
          ("ON-HOLD" .
           (:background "#427"  :foreground "#ddd" :weight normal))
          ))

  (evil-define-key 'normal org-mode-map
    (kbd "<f8>") 'bcj/org-sort-entries
    )


  )
