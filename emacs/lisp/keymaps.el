;;; keymaps.el --- some custom keybindings

;;; Commentary:

;;; Code:

(evil-define-key 'hybrid global-map
  (kbd "\C-w") 'backward-kill-word
  (kbd "\C-x\C-k") 'kill-region)

(define-key evil-visual-state-map (kbd "u") 'undo)

(require 'mydefuns) ;; so we can move these defuns out of the keymap file...
(global-set-key (kbd "<f5>") 'bcj-revert-buffer-no-confirm)
(global-set-key (kbd "<f6>") 'bcj-window-setup)
(global-set-key (kbd "<f7>") 'pop-local-mark-ring)

;; (global-set-key (kbd "\C-x m") 'smex) ; smarter M-x
;; (global-set-key "\C-x\C-m" 'smex)     ; smarter M-x
;; (global-set-key (kbd "<menu>") 'smex)

(global-set-key (kbd "M-l") 'expand-region)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C-M-=") 'text-scale-decrease)

;; mac switch meta key
(defun mac-switch-meta nil
  "Switch meta between Option and Command."
  (interactive)
  (if (eq mac-option-modifier nil)
      (progn
        (setq mac-option-modifier 'meta)
        (setq mac-command-modifier 'hyper)
        )
    (progn
      (setq mac-option-modifier nil)
      (setq mac-command-modifier 'meta)
      )
    )
  )
(if (eq system-type 'darwin)
    (mac-switch-meta)
  )
(setq smartscan-symbol-selector "symbol")
(global-set-key (kbd "M-n") 'smartscan-symbol-go-forward )
(global-set-key (kbd "M-p") 'smartscan-symbol-go-backward)

(global-set-key (kbd "C-x i") 'ace-window)

(spacemacs/set-leader-keys
  "bt" 'bcj/switch-to-todo-buffer
  "bi" 'bcj/switch-to-org-index
  "gf" 'dumb-jump-go
  "gg" 'xref-find-references
  "ad" 'dired-jump
  "aD" 'dired
  "xh" 'mark-whole-buffer
  )


;; Mode-specific keybinds

(spacemacs/set-leader-keys-for-major-mode 'ruby-mode "tt" 'rspec-verify-single)
(spacemacs/set-leader-keys-for-major-mode 'ruby-mode "q" 'fill-paragraph)
(spacemacs/set-leader-keys-for-major-mode 'go-mode "q" 'fill-paragraph)
(spacemacs/set-leader-keys-for-major-mode 'rjsx-mode "p" 'bcj/run-prettier-autocorrect)
;; Org mode
(spacemacs/set-leader-keys-for-major-mode 'org-mode "ot" 'org-todo)
(spacemacs/set-leader-keys-for-major-mode 'org-mode "oo" 'org-todo)

(spacemacs/set-leader-keys-for-major-mode 'org-mode "oa" 'org-archive-subtree)

;; this wipes out a 'toggle' keymap set by spacemacs or something, but that
;; toggle keymap only gives access to 'toggle-table-formula..something' and
;; 'toggle-table-coordingates...something'
(spacemacs/set-leader-keys-for-major-mode 'org-mode "tt" 'org-todo)

;; (spacemacs/set-leader-keys-for-major-mode 'go-mode "tt" ')

(with-eval-after-load 'helm
  (define-key helm-map (kbd "C-w") 'backward-kill-word)
  )

(use-package helm-ag
  :ensure t
 )

(with-eval-after-load 'helm-ag
  ;; this might be better than the evilified-state-evilify thing below?
  ;;(define-key helm-ag-map (kbd "C-o") 'helm-ag-mode-jump-other-window)
  (evilified-state-evilify-map helm-ag-mode helm-ag-mode-map
    (kbd "gr") 'helm-ag--update-save-results
    (kbd "C-o") 'helm-ag-mode-jump-other-window
    (kbd "q") 'quit-window)
  )

(with-eval-after-load 'company
  ;; not sure which define key should work here, they don't seem to
  ;; automatically apply though, and C-w doesn't exit me out of the company
  ;; popup since I last upgraded spacemacs :/
  (define-key company-active-map (kbd "C-w") 'backward-kill-word)
  ;; (evil-define-key 'insert company-active-map (kbd "c-w") 'backward-kill-word)
  )

;; (use-package dired-git-info
;;   :ensure t
;;   :bind (:map dired-mode-map
;;               (")" . dired-git-info-mode)))

;; Unset default keybinds

;; Not sure why, but this isn't taking effect. Spacemacs is maybe not loading this file? or I need to do things differently.
;;(global-unset-key (kbd "C-x C-l"))

;;sick of accidentally downcasing regions instead of commenting them.
;; (global-set-key (kbd "C-x C-l") 'comment-dwim)

;; evil-collection is a set of eveil keybindings for additional modes

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init 'nov))

(provide 'keymaps)
;;; keymaps.el ends here.
