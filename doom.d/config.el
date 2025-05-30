;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Anonymous Pro" :size 15))


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
;; default: (setq doom-theme 'doom-one)

(setq
 custom-doom-tomorrow-night-brighter-comments t ; if non-nil, comments are brighter
 doom-theme 'custom-doom-tomorrow-night
 )

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; evil-snipe mode messes with the keybindings I expect: s/S should replace, and I want to use ',' for my localleader
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(setq doom-localleader-key ",")

(add-load-path! "lisp/")
(require 'mydefuns)
(require 'magit-config)
(require 'org-doom-settings)
(require 'prog-modes-config)
(require 'ruby-mode-config)

(after! projectile
  ;; when I switch a project, I don't want to open a file, I just want to open a
  ;; dired buffer in the project root
  (setq projectile-switch-project-action 'projectile-dired)
  )

(after! web-mode
  (setq web-mode-enable-current-element-highlight t)
  (setq hl-line-mode nil) ;; this can slow down cursor movement in erb templates
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset   2)
  (setq web-mode-script-padding 0)
  )

(after! yasnippet
  (add-to-list 'hippie-expand-try-functions-list 'yas-hippie-try-expand)
  )


(after! dired-x
  ;; I don't actually want to omit files, I like seeing them all turning off
  ;; dired-omit-mode altogether is tricky, because doom turns it on in places,
  ;; but we can work around that by telling dired-omit to hide nothing
  (setq dired-omit-files nil)
  (add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode 1)) )
)


;; mac-specific

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
    (mac-switch-meta))

;; /mac-specific

;; Custom Keymaps!
(map!
 :leader

 :desc "M-x"
 "<SPC>" #'execute-extended-command

 ;; buffer-related commands
 :desc "next buffer"
 "<tab>" #'evil-switch-to-windows-last-buffer
 ;; "[tab]" #'evil-switch-to-windows-last-buffer


 :desc "open org index file"
 "b i" #'bcj/switch-to-org-index
 ;; / buffer-related commands

 ;; need to unbind 'a' to avoid error like:
 ;; error Key sequence a d starts with non-prefix key a
 ;; afaict, this effectively makes 'a' a prefix key
 :desc "my shortcuts (dired)"
 "a" nil

 :desc "dired-jump"
 "a d" #'dired-jump

 :desc "dired"
 "a D" #'dired

 :desc "magit status"
 "g s" #'magit-status

 ;; bound to 'remove known project' by default...
 :desc "projectile-find-dir"
 "p d" #'projectile-find-dir

 ;; (figure out how to restrict these to prog-mode based modes..)
 :desc "copy git link"
 "g L" #'bcj/git-link-copy-url-only

 ;;:code
 :desc "comment dwim"
 "c l" #'bcj/comment-or-uncomment-lines

 :desc "copy and comment lines"
 "c y" #'evilnc-copy-and-comment-lines
)

(map! :after org
      :map org-mode-map
      "<f8>" #'bcj/org-sort-entries
      )

(map!
 :v "s" #'evil-surround-region)

(map! "M-/" #'hippie-expand)

(map! "<f5>" #'bcj-revert-buffer-no-confirm)

(map! :after web-mode
      :map web-mode-map
      "M-/" #'hippie-expand)

;; or
;; (map! :prefix "C-x"
;;       "C-r" #'git-gutter:revert-hunk
;;       "C-b" #'ibuffer
;;       "C-l" #'+lookup/file)

(setq copilot-indent-offset-warning-disable t)
(after! go-mode
  (add-hook 'go-mode-hook #'lsp-deferred)
  (add-hook 'before-save-hook 'gofmt-before-save)
  )
