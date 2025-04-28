;;; ruby-mode-config -- summary
;;; Commentary:
;;; my personal ruby mode tweaks
;;; Code:

;; if we find #!/usr/bin/env rails runner at the beginning of a file, it's a ruby file
(add-to-list 'magic-mode-alist '("^#!.* rails runner" . ruby-mode) )

(provide 'ruby-mode-config)
;;; ruby-mode-config.el ends here
