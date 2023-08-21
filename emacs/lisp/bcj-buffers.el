;;; bcj-buffers --
;;; Commentary:
;;; buffer setup
;;; Code:


;; Just trying to make sure the index.org is always open in a buffer
(with-temp-buffer
  (find-file-noselect "~/Dropbox/org/index.org")
  )


(provide 'bcj-buffers)
;;; bcj-buffers.el ends here
