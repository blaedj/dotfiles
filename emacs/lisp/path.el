;;; path -- sets up the exec path within emacs
;;; Commentary:
;;;
;;; Code:

;; this is pretty hard-code-ey, should probably find a better way to pull the
;; shell $PATH in
(let (
      (custom-exec-paths
      '(
        "/Users/blaed/google-cloud-sdk/bin"
        "/Users/blaed/.yarn/bin"
        "/Applications/Postgres.app/Contents/Versions/9.4/bin"
        "/Users/blaed/.rbenv/shims"
        "/usr/local/heroku/bin"
        "/usr/local/bin"
        "/usr/bin"
        "/bin"
        "/usr/sbin"
        "/sbin"
        "/Users/blaed/google-cloud-sdk/bin"
        "/Users/blaed/.yarn/bin"
        "/Applications/Postgres.app/Contents/Versions/9.4/bin"
        "/usr/local/heroku/bin"
        "/usr/lib/lightdm/lightdm"
        "/usr/local/sbin"
        "/usr/games"
        "/Users/blaed/.dotfiles/bin"
        "/Users/blaed/code/go/bin"
        "/usr/local/opt/fzf/bin"
        "/usr/lib/lightdm/lightdm"
        "/usr/local/sbin"
        "/usr/local/bin"
        "/usr/sbin"
        "/usr/bin"
        "/sbin"
        "/bin"
        "/usr/games"
        "/Users/blaed/.dotfiles/bin"
        "/Users/blaed/code/go/bin"
        "./bin"
        ))
      )

  (setenv "PATH" (mapconcat 'identity custom-exec-paths ":"))
  (setq exec-path (append custom-exec-paths (list "." exec-directory)))
  )

(provide 'path)
;;; path.el ends here
