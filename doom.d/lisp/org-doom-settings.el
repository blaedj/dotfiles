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
    (auto-fill-mode 1)
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

  (setq org-capture-templates
        '(("t" "To Do Item" entry (file+headline "~/Dropbox/org/todo.org" "Tasks")
           "* %?\n%T :unfiled:" :prepend t)

          ("c" "Contingency ToDo"
           entry
           (file+headline "~/Dropbox/org/todo.org" "Contingency") "** %?")

          ("j" "Journal Entry"
           entry (file+weektree "~/Dropbox/org/personal/journal.org")
           "* %U %?" :empty-lines 1)

          ("p" "tracking"
           entry (file
                  (concat org-directory "/personal/tracking.org")
                  "."
                  ) "* %t .")
          ))

  (setq org-default-priority 68)

  (defun todo-to-int (todo)
    "Get the int score of TODO for sorting, based on keyword."
    (cond ((string= todo "IN-PROGRESS") 1)
          ((string= todo "TODO") 2)
          ((string= todo "ON-HOLD") 3)
          ((string= todo "DONE") 5)
          (t 4) ; default
          ))

  (defun bcj/org-sort-key ()
    "Return the sorting key for the todo at point."
    (let* ( (todo-max (+ (apply #'max (mapcar #'length org-todo-keywords)) 1))
            (todo (org-entry-get (point) "TODO"))
            ;; (todo-int (if todo (todo-to-int todo) todo-max))
            (todo-int (todo-to-int todo))
            (priority (org-entry-get (point) "PRIORITY"))
            (priority-int (if priority (string-to-char priority) org-default-priority)))
      (format "%03d %03d" todo-int priority-int)
      ))

  (defun bcj/org-sort-entries ()
    "Sort the entries at point via my custom sorting function."
    (interactive)
    (org-sort-entries nil ?f #'bcj/org-sort-key))
  ) ;; / after! org

(provide 'org-doom-settings)
;;; org-doom-settings.el ends here
