;;; mydefuns.el --- some miscellaneous functions I use.

;;; Commentary:
;; unless noted, I wrote/heavily modified these.


;;; Code:

;; the following two defuns are modified from: http://whattheemacsd.com/setup-dired.el-02.html
(defun dired-back-to-top ()
  "Move the cursor to the first 'file' line in a dired buffer."
  (interactive)
  (goto-char (point-min))
  (dired-next-line 2))


(defun dired-jump-to-bottom ()
  "Move the cursor to the last 'file' line in a dired buffer."
  (interactive)
  (goto-char (point-max))
  (dired-next-line -1))

(with-eval-after-load 'dired
  (define-key dired-mode-map [remap beginning-of-buffer] 'dired-back-to-top)
  (define-key dired-mode-map [remap end-of-buffer] 'dired-jump-to-bottom)
  )

;; ;; from seeing-is-believing: https://github.com/JoshCheek/seeing_is_believing
;; (defun seeing-is-believing ()
;;   "Replace the current region (or the whole buffer, if none) with the output
;; of seeing_is_believing."
;;   (interactive)
;;   (let ((beg (if (region-active-p) (region-beginning) (point-min)))
;;         (end (if (region-active-p) (region-end) (point-max))))
;;     (shell-command-on-region beg end "seeing_is_believing" nil 'replace)))


;; if we include a space in the url that we pass to browse-url, it seems to trigger an automatic http-encoding of the entire string.
;; (not sure if this happens in browse-url or elsewhere)
;; this breaks the url, possibly because google expects '#?=' and not '%23?=' in the query string.
;; so we handle this by pre-encoding spaces and ?'s. This seems to fix the issue.
(defun google-web-search ()
  "Search google for a user-specified query"
  (interactive)
  (browse-url
   (concat "http://www.google.com/#q=" (bcj/http-encode (read-from-minibuffer "Query: "))))
  )

(defun bcj/http-encode (string-to-encode)
  (replace-regexp-in-string
   "?" "%3F"
   (replace-regexp-in-string " " "%20" string-to-encode))
  )

;;(global-set-key (kbd "C-x g") 'google-web-search)

;;inspired by helm-dash, if you aren't on OS X, http://devdocs.io is a decent browser-based alternative to Dash. (http://kapeli.com/dash)
(defun devdocs-search ()
  "Search documentation on devDocs.io"
  (interactive)
  (let (whichdocs)
    (setq whichdocs (read-from-minibuffer "Which Documentation? "))
    (browse-url
     (concat
      (concat "http://devdocs.io/" whichdocs "/" )
      (read-from-minibuffer "Query: ")))))


;; custom defun to properly format the spacing around braces and parens
(defun formatBuf ()
  "formats the () and {}"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (while (search-forward-regexp "\)\[ \
]*\{" nil t)
      (replace-match ") {" nil t)))
  )

(defun create-scratch-buffer ()
  "creates a scratch buffer of specified type"
  (interactive)
  (let (newbuffer mode-type)
    (setq mode-type (read-from-minibuffer "scratch mode: "))
    (setq newbuffer (get-buffer-create (concat mode-type "-scratch")))
    (switch-to-buffer newbuffer)
    (funcall (intern (concat mode-type "-mode")))))

;;show the ouptut of runnin coffee on the current file since I can't get flymake
;; to work properly
(defun show-coffeelint ()
  "Show output of coffeelint on current file."
  (interactive)
  (let (filename output-buffer)
    (setq filename (buffer-file-name (current-buffer)))
    (setq output-buffer (get-buffer-create (concat "* Coffeelint" filename)))
    ;;(with-output-to-temp-buffer output-buffer (shell-command (concat "coffeelint " filename)))
    (shell-command (concat "coffee " filename) output-buffer output-buffer)
    )
  )

(defun bcj/open-project-term (orig-fun &rest args)
  "This is some advice to wrap around ORIG-FUN and ARGS.
This is advice to rename the term buffer if in a
projectile-project.  If we are in a project, the name of the
terminal buffer will be 'terminal-PROJECTNAME'."
  (let ((new-term-buffer (apply orig-fun args)))
    (let (new-name )
      (if (projectile-project-p)
	  (setq new-name
		(concat "terminal-" (upcase (projectile-project-name))))
	(setq new-name (buffer-name new-term-buffer))
	)
      (rename-buffer new-name)
      )))

(defun bcj/revert-buffer-no-confirm ()
  "Revert buffer with no confirmation."
  (interactive)
  (revert-buffer nil t))

;; (defun dwim-smartwin-visibility ()
;;   "Toggle smartwin window, if not visible make the window visible and switch to it."
;;   (interactive)
;;   (let (smartwin-is-visible)

;;     (setq smartwin-is-visible (smartwin--get-smart-window))
;;     (if smartwin-is-visible
;; 	(smartwin-hide)
;;       (smartwin-show)
;;       (switch-to-buffer (window-buffer (smartwin--get-smart-window)))
;;       )))

;; thanks to Frank Klotz
;; http://stackoverflow.com/users/9668/frank-klotz
;; http://stackoverflow.com/a/65992/1050853
(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not."
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
	 (set-window-dedicated-p window
				 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))


(defun bcj/switch-to-todo-buffer ()
  "Switch to the TODO.org buffer"
  (interactive)
  (let ((exists (get-buffer "todo.org")))
    (if exists
        (switch-to-buffer (get-buffer "todo.org"))
      (message "couldn't find the todo.org buffer"))))

(defun bcj/switch-to-org-index ()
  "Switch to the indec file for the directory that holds my org notes"
  (interactive)
  ;; (let ((exists (get-buffer "todo.org")))
  ;;   (if exists
  ;;       (switch-to-buffer (get-buffer "todo.org"))
  ;;     (message "couldn't find the todo.org buffer")))
  ;;(dired "~/Dropbox/org")
  (display-buffer-in-side-window (find-file "~/Dropbox/org/index.org") '((side . left)))
  )

(defun bcj/date (&optional arg)
  (interactive)
  (insert (if arg
              (format-time-string "%d.%m.%Y")
            (format-time-string "%Y-%m-%d"))))


;; Turn
;;
;;   T{foo: bar, baz: qux{}}
;;
;; into
;;
;;   T{
;;   	foo: bar,
;;   	baz: qux{},
;;   }
;;
;; Point needs to be anywhere before, or on, the opening {
;; thanks to Dominik Honnef from gophers slack
(defun go-neat-struct ()
  (interactive)
  (save-excursion
    (search-forward "{")
    (let ((start-level (go-paren-level))
          (start-pos (point)))
      (reindent-then-newline-and-indent)
      (while (and (>= (go-paren-level) start-level)
                  (search-forward "," nil t))
        (if (= (go-paren-level) start-level)
            (reindent-then-newline-and-indent)))
      (goto-char (1- start-pos))
      (forward-list)
      (backward-char)
      (insert ",")
      (reindent-then-newline-and-indent))))

;; thanks to Xah Lee
;; http://ergoemacs.org/emacs/emacs_jump_to_previous_position.html
;; Version 2016-04-04
(defun pop-local-mark-ring ()
  "Move cursor to last mark position of current buffer.
Call this repeatedly will cycle all positions in `mark-ring'."
  (interactive)
  (set-mark-command t)
  )


;; Thanks to Luca Ferrari
;; https://fluca1978.github.io/2022/04/13/EmacsPgFormatter.html
(defun pgformatter-on-region ()
  "A function to invoke pgFormatter as an external program."
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max)))
        (pgfrm "pg_format" ) )
    (shell-command-on-region b e pgfrm (current-buffer) 1)) )


(defun bcj/embiggen-font ()
  "A function to make the default spacemacs font bigger, useful when screensharing"
  (interactive)
 (spacemacs/set-default-font
  '("Anonymous Pro" ;; or.. "Ubuntu Mono", "Source Code Pro" etc
    :size 19
    :weight normal
    :width normal
    :powerline-scale 1.5)
  )
 )

(defun bcj/make-normal-font ()
  "A function to set the default spacemacs back to normal size"
  (interactive)
  (spacemacs/set-default-font
   '("Anonymous Pro" ;; or.. "Ubuntu Mono", "Source Code Pro" etc
     :size 14
     :weight normal
     :width normal
     :powerline-scale 1.5)
   )
  )

;; stolen from the spacemacs project.
;; requires the git-link package
(defun bcj/git-link-copy-url-only ()
  "Only copy the generated link to the kill ring."
  (interactive)
  (let (git-link-open-in-browser)
    (call-interactively 'git-link)))

;; stolen from spacemacs
;; assumes evilnc has already been loaded (whatever that is)
(defun bcj/comment-or-uncomment-lines (&optional arg)
"The DWBM (do What Blaed means) comment-lines. (ARG) is prob a region arg? dunno."
  (interactive "p")
  (let ((evilnc-invert-comment-line-by-line nil))
    (evilnc-comment-or-uncomment-lines arg)))



(provide 'mydefuns)
;;; mydefuns.el ends here
