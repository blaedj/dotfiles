;;; org-mode-settings.el --- Org mode defaults and settings
;;; Commentary:

;;; Code:

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

;; show prettier bullet points instead of asterisks
(require 'org-bullets)
(add-hook 'org-mode-hook
	  (lambda ()
	    (org-bullets-mode 1)))


(setq org-return-follows-link t)

(add-hook 'org-mode-hook
	  '(lambda ()
	     (turn-on-auto-fill)
	     (set-fill-column 80)))


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


;; (eval-after-load 'org
;;   (progn
;;     ;; (define-key org-mode-map (kbd "<f8>") 'org-todo)
;;     ;; (define-key org-mode-map (kbd "<f7>") 'org-schedule)
;;     )
;;  )

;; custom org-agenda commands
(setq org-agenda-custom-commands
      '(
	("b" "Agenda and In-progress todos"
	 ((todo "IN-PROGRESS") (tags-todo "next") (agenda "" ((org-agenda-ndays 1)))))

	("w" "Weekly review"
	 agenda ""
	 ((org-agenda-span 'week)
	  (org-agenda-start-on-weekday 0)
	  (org-agenda-start-with-log-mode t)
	  (org-agenda-skip-function
	   '(org-agenda-skip-entry-if 'nottodo 'done))
	  ))
	))

;; setup org-mobile-push and org-mobile-pull for sync w/mobile devices.
(setq org-mobile-directory (concat org-directory "/../Apps/MobileOrg/mobile") )
(setq org-mobile-inbox-for-pull (concat org-mobile-directory "/inbox.org"))

;;google calendar and org-mode syncing
(setq org-gcal-file-alist '(("blaedj@gmail.com" .  "~/Dropbox/org/gcal.org")))


(setq org-capture-templates
      '(("t" "To Do Item" entry (file+headline "~/Dropbox/org/todo.org" "Tasks")
	"* %?\n%T :unfiled:" :prepend t)

	("c" "Contingency ToDo"
	 entry
	 (file+headline "~/Dropbox/org/todo.org" "Contingency") "** %?")

       ("j" "Journal Entry"
	entry (file+weektree (concat org-directory "/personal/journal.org"))
	"* %U %?" :empty-lines 1)

       ("p" "tracking"
	entry (file
	       (concat org-directory "/personal/tracking.org")
	       "."
	       ) "* %t .")
       ))


;;; SORTING ;;;;;

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


;; enable org-babel execution of sh source blocks
;; TODO: the below doesn't work when ran from here
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((emacs-lip . t)
;;    (sh . t)
;;    ))

;; turn on flyspell mode in org mode.
(add-hook 'org-mode-hook
	  (lambda ()
	    (flyspell-mode 1)
	    (yas-minor-mode 1)
	    ))
(provide 'org-mode-settings)
;;; org-mode-settings.el ends here
