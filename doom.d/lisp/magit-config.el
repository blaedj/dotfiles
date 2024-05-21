;;; magit-config.el ---  magit mode defaults and settings
;;; Commentary:

;;; Code:
(setq magit-push-always-verify t)
(setq magit-display-buffer-function
      (quote magit-display-buffer-same-window-except-diff-v1))
(setq git-commit-fill-column 70)

(setq magit-repository-directories '("~/code/"))

;; like magit-refs--format-local-branches, but only for the 20 most recent
;; branches, sorted by committerdate
(defun bcj/magit-refs--format-recent-local-branches ()
  (let ((lines (-keep #'magit-refs--format-local-branch
                      (magit-git-lines
                       "for-each-ref"
                       "--sort=-committerdate"
                       "--count=20"
                       (concat "--format=\
%(HEAD)%00%(refname:short)%00%(refname)%00\
%(upstream:short)%00%(upstream)%00%(upstream:track)%00"
                               (if magit-refs-show-push-remote "\
%(push:remotename)%00%(push)%00%(push:track)%00%(subject)"
                                 "%00%00%00%(subject)"))
                       "refs/heads"
                       magit-buffer-arguments))))
    (unless (magit-get-current-branch)
      (push (magit-refs--format-local-branch
             (concat "*\0\0\0\0\0\0\0\0" (magit-rev-format "%s")))
            lines))
    (setq-local magit-refs-primary-column-width
                (let ((def (default-value 'magit-refs-primary-column-width)))
                  (if (atom def)
                      def
                    (pcase-let ((`(,min . ,max) def))
                      (min max (apply #'max min (mapcar #'car lines)))))))
    (mapcar (pcase-lambda (`(,_ ,branch ,focus ,branch-desc ,u:ahead ,p:ahead
                                ,u:behind ,upstream ,p:behind ,push ,msg))
              (list branch focus branch-desc u:ahead p:ahead
                    (make-string (max 1 (- magit-refs-primary-column-width
                                           (length (concat branch-desc
                                                           u:ahead
                                                           p:ahead
                                                           u:behind))))
                                 ?\s)
                    u:behind upstream p:behind push
                    msg))
            lines)))

;; like magit-insert-local-branches, but only for a few of the most recent
;; branches. `b b' will set you up to hit 'enter' and check out the branch under
;; point. might be worth looking at
;; https://magit.vc/manual/magit.html#index-magit_002dvisit_002dref_002dbehavior
;; which would allow for checking out a branch by 'visiting' (enter) a
;; ref/branch
(defun bcj/magit-insert-recent-local-branches ()
  "Insert sections showing 10 of the most recently used local branches."
  (magit-insert-section (local nil)
    (magit-insert-heading "Recent Branches:")
    (dolist (line (bcj/magit-refs--format-recent-local-branches))
      (pcase-let ((`(,branch . ,strings) line))
        (magit-insert-section
          ((eval (if branch 'branch 'commit))
           (or branch (magit-rev-parse "HEAD"))
           t)
          (apply #'magit-insert-heading strings)
          (when (magit-buffer-margin-p)
            (magit-refs--format-margin branch))
          (magit-refs--insert-cherry-commits branch))))
    (insert ?\n)
    (magit-make-margin-overlay nil t)))


(with-eval-after-load 'magit
  ;; I like this old version, that fills in the completion buffer with a prefix lile:
  ;; On <branchname>: ...
  ;; and then you can add your stash message after that
  (setq magit-stash-read-message-function #'magit-stash-read-message-traditional)

  ;; add a list of the 20 most recently used branches to the bottom of magit
  ;; status buffers
  (magit-add-section-hook
   'magit-status-sections-hook
   'bcj/magit-insert-recent-local-branches
   'magit-insert-unpulled-from-upstream ;; this is the section that we want to show the branches below.
   )
  )

;; use this to remove the functions addded to the hook above
;; (remove-hook 'magit-status-sections-hook 'bcj/magit-insert-recent-local-branches)


(provide 'magit-config)
;;; magit-config.el ends here
