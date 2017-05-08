;;; prog-modes-config -- general setup for progamming modes
;;; Commentary:
;;;
;;; Code:
(defun bjc/prog-mode-hook ()
    "Custom configuration for programming modes."
    (fci-mode t)
  )
(add-hook 'prog-mode-hook 'bcj/prog-mode-hook)


(provide 'prog-modes-config)
;;; prog-modes-config.el ends here
