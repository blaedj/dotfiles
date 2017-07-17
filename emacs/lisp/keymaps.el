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


(provide 'keymaps)
;;; keymaps.el ends here.
