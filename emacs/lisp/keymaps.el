;;; keymaps.el --- some custom keybindings

;;; Commentary:

;;; Code:

(evil-define-key 'hybrid global-map
  (kbd "\C-w") 'backward-kill-word
  (kbd "\C-x\C-k") 'kill-region)

(require 'mydefuns ) ;; so we can move these defuns out of the keymap file...
(global-set-key (kbd "<f5>") 'bcj-revert-buffer-no-confirm)
(global-set-key (kbd "<f6>") 'bcj-window-setup)

(global-set-key (kbd "\C-x m") 'smex) ; smarter M-x
(global-set-key "\C-x\C-m" 'smex)     ; smarter M-x
(global-set-key (kbd "<menu>") 'smex)

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
  )

(spacemacs/set-leader-keys
  "gg" 'dumb-jump-go
  )

;; Mode-specific keybinds

(spacemacs/set-leader-keys-for-major-mode 'ruby-mode "tt" 'rspec-verify-single)

(with-eval-after-load 'helm
  (define-key helm-map (kbd "C-w") 'backward-kill-word)
  )

(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-w") 'backward-kill-word)
  )

;; Unset default keybinds

;;sick of accidentally downcasing regions instead of commenting them.
(global-set-key (kbd "C-x C-l") 'comment-dwim)

(provide 'keymaps)
;;; keymaps.el ends here.
