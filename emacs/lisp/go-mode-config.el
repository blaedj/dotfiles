;;; go-mode-config -- summary
;;; Commentary:
;;;
;;; Code:


;; (add-hook 'go-mode-hook
;;           (lambda ()
;;             (auto-complete-for-go)
;;             (add-hook 'after-save-hook nil 'make-it-local))
;;             (add-hook 'after-save-hook 'gofmt-before-save nil 'make-it-local)))

;; (with-eval-after-load 'go-mode
;;   (require 'go-autocomplete))
(setq gofmt-command "goimports")


(provide 'go-mode-config)
;;; go-mode-config.el ends here
