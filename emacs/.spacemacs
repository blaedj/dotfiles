;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(windows-scripts
     lua
     typescript
     ;;elixir
     csv
     rust
     python
     sql
     (go :variables godoc-at-point-function 'godoc-gogetdoc)
     javascript
     yaml
     html
     ;; tree-sitter provides a bit richer syntax highlighting. It also sometimes
     ;; bogs things down, so it isn't auto-enabled.
     ;;
     ;;   enable globally: (global-tree-sitter-mode)
     ;;
     ;;   enable for one mode: (add-hook 'rust-mode-hook #'tree-sitter-mode)
     ( tree-sitter )

     ;; ( ruby :variables ruby-test-runner 'rspec ruby-backend 'lsp)
     ( ruby :variables ruby-test-runner 'rspec)
     markdown
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     ;; ivy
     ( auto-completion :disabled-for org git web
                       :variables
                       auto-completion-private-snippets-directory "~/.dotfiles/emacs/snippets/")
     emacs-lisp
     git
     (version-control
      :variables
      version-control-diff-tool 'git-gutter+)
     org
     syntax-checking
     lsp
     copy-as-format
     helpful
     xkcd
     (treemacs
      :variables
      treemacs-use-icons-dired nil)
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(
                                      figlet
                                      ag
                                      ample-zen-theme
                                      dockerfile-mode
                                      doom-themes
                                      protobuf-mode
                                      rainbow-mode
                                      smartscan
                                      csharp-mode
                                      graphql-mode
                                      exec-path-from-shell
                                      coffee-mode
                                      quick-peek
                                      format-all
                                      ox-gfm ;; gfm = github-flavored-markdown
                                      ob-go ;; golang support for org-babel
                                      seeing-is-believing
                                      undo-fu
                                      (vue-mode
                                       :location
                                       (recipe
                                        :fetcher github
                                        :repo "codefalling/vue-mode")))
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(forge)

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default (format "spacemacs-%s.pdmp" emacs-version))
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'hybrid

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'lisp-interaction-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light
                         doom-Iosvkem
                         custom-doom-tomorrow-night
                         )

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.

   ;; dotspacemacs-default-font '("Inconsolata"
   ;;                             :size 15
   ;;                             :weight normal
   ;;                             :width normal
   ;;                             :powerline-scale 1.5)
   ;;dotspacemacs-default-font '("Share Tech Mono"
   ;;
   dotspacemacs-default-font '("Anonymous Pro"
                               :size 14
                               :weight normal
                               :width normal
                               :powerline-scale 1.5)

   ;; To dynamically set the font:
   ;; (spacemacs/set-default-font
   ;;  '("Ubuntu Mono"
   ;;    :size 15
   ;;    :weight normal
   ;;    :width normal
   ;;    :powerline-scale 1.5)
   ;;  )


   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'origami

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode t

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server t

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "rg" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Show trailing whitespace (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'changed

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first.")

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  (add-to-list 'load-path "~/.dotfiles/emacs/lisp")
  (add-to-list 'load-path "~/.dotfiles/emacs/vendor")


  ;; I _think_ undo-tree might be causing hangs. We'll see if this reduces how
  ;; often it happens
  ;;  see https://github.com/emacs-evil/evil/issues/1074 for some discussion
  ;; there is also a new undo system in emacs28 that might help with this?
  ;; If trying it, it should be contitionally loaded, as it's annoying to get
  ;; an up-to-date emacs build for linux (ironically enough).
  (global-undo-tree-mode -1)
  (evil-set-undo-system 'undo-fu)
  (yas-global-mode)

  (add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode t)))

  ;; put auto-saves into a tmp dir
  (let ((auto-saves-dir "~/tmp/emacs/auto-saves/"))
    (when (not (file-directory-p auto-saves-dir))
      (make-directory dir t))
    (setq auto-save-file-name-transforms `((".*", auto-saves-dir t))
          auto-save-list-file-prefix (concat auto-saves-dir ".saves-")))

  (require 'mydefuns)
  (require 'display-config)
  (require 'magit-config)
  (require 'org-mode-settings)
  (require 'keymaps)

  (require 'prog-modes-config)
  (require 'go-mode-config)
  (require 'web-mode-config)
  (require 'css-mode-config)
  (require 'js-mode-config)
  (require 'jsx-mode-config)
  (require 'ruby-mode-config)
  (require 'path)

  ;; libs in vendor/
  (require 'highlight)
  (require 'liquid-mode)
  (require 'blamer)

  (setq-default js2-basic-offset 2)
  (setq js-indent-level 2)

  (with-eval-after-load 'flycheck-mode
    (flycheck-add-mode 'javascript-eslint 'web-mode)
    ;; assumes that ruby-standard is installed, and will be used instead
    (setq-default flycheck-disabled-checkers '(ruby-rubocop ruby-reek))
    )

  ;; I don't want <bleeping> ESC-ESC-ESC to close all my windows!
  (defadvice keyboard-escape-quit
      (around keyboard-escape-quit-dont-close-windows activate)
    (let ((buffer-quit-function (lambda () ())))
      ad-do-it))

  ;; helm-buffers-fuzzy-matching and helm-recentf-fuzzy-match to t.
  (setq helm-mode-fuzzy-match t)
  (setq helm-buffers-fuzzy-matching t)
  (setq helm-recentf-fuzzy-matching t)
  (setq helm-always-two-windows nil)
  (setq helm-M-x-fuzzy-match t)
  (setq helm-imenu-fuzzy-match t)
  (setq helm-semantic-fuzzy-match t)

  (with-eval-after-load 'helm-projectile
    (setq helm-source-projectile-files-and-dired-list '(helm-source-projectile-files-list))
    )

  ;; open liquid-markdown files in liquid mode.
  (add-to-list 'auto-mode-alist '("\\.liqmd$" . liquid-mode))
  (add-to-list 'auto-mode-alist '("\\.liquid$" . liquid-mode))
  ;; if we find #!/usr/bin/env rails runner at the beginning of a file, it's a ruby file
  (add-to-list 'magic-mode-alist '("^#!.* rails runner" . ruby-mode) )

  (setq projectile-switch-project-action 'projectile-dired)
  (with-eval-after-load 'dumb-jump
    (add-to-list 'dumb-jump-language-file-exts '((:language "ruby" :ext "erb" :agtype "ruby" :rgtype "ruby")))
    )
  (setq aw-keys '(?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9))

  (global-hl-line-mode 0) ;

  (setq powerline-default-separator 'bar)
  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-version-control-on)

  (setq flycheck-idle-change-delay 4) ;; given the line below, this *should* have no effect
  (setq flycheck-display-errors-function 'flycheck-display-error-messages)
  ;; only run flycheck when the file is saved or flycheck is enabled
  (setq flycheck-check-syntax-automatically '(save))

  ;; don't know yet if this is effective or not
  (setq-default flycheck-disabled-checkers '(go-errcheck go-unconvert go-megacheck))

  ;; workaround for https://github.com/syl20bnr/spacemacs/issues/9608
  (require 'helm-bookmark)

  (exec-path-from-shell-initialize)
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes

   (quote
    ("b0c1052cdf0dbe9ba34ec58caeeff968a4431651fcb7202d1d7c7d65b3341c28" "1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5" default)))
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-color "#2e2e2e" t)
 '(fci-rule-width 1 t)
 '(flycheck-display-errors-function (quote flycheck-display-error-messages))
 '(flycheck-emacs-lisp-load-path (quote inherit))
 '(flycheck-global-modes
   (quote
    (go-mode json-mode js2-mode coffee-mode yaml-mode web-mode slim-mode scss-mode sass-mode pug-mode less-mode haml-mode enh-ruby-mode ruby-mode)))
 '(flycheck-pos-tip-mode nil)
 '(flycheck-sass-executable nil)
 '(flycheck-standard-error-navigation nil)
 '(global-flycheck-mode t)
 '(helm-org-format-outline-path t t)
 '(org-agenda-files (quote ("~/Dropbox/org/todo.org" "~/Dropbox/org/gcal.org")))
 '(org-agenda-restore-windows-after-quit t t)
 '(org-default-notes-file "~/Dropbox/org/todo.org")
 '(org-default-priority 68)
 '(org-directory "~/Dropbox/org")
 '(org-ellipsis "↴")
 '(org-image-actual-width nil)
 '(org-imenu-depth 8)
 '(org-link-translation-function (quote toc-org-unhrefify))
 '(org-log-done t)
 '(org-projectile:per-repo-filename "TODOs.org")
 '(org-return-follows-link t)
 '(org-startup-with-inline-images t)
 '(org-todo-keywords
   (quote
    ((sequence "TODO" "IN-PROGRESS" "DONE")
     (sequence "ON-HOLD"))))
 '(package-selected-packages
   (quote
    (org-mime org-present org-plus-contrib jsx-mode graphql-mode treepy company-ycmd ycmd request-deferred deferred go-autocomplete go-complete rjsx-mode alchemist flycheck-mix flycheck-credo elixir-mode magit-gh-pulls gh marshal logito pcache ghub+ apiwrap ghub magithub enh-ruby-mode tide typescript-mode protobuf-mode intero hlint-refactor hindent helm-hoogle haskell-snippets flycheck-haskell csv-mode company-ghci company-ghc ghc haskell-mode company-cabal cmm-mode dockerfile-mode slack emojify circe oauth2 websocket vimrc-mode flyspell-correct-helm flyspell-correct dactyl-mode auto-dictionary racer cargo toml-mode flycheck-rust seq rust-mode yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode helm-pydoc cython-mode company-anaconda anaconda-mode pythonic nlinum sql-indent magit-popup git-commit with-editor js2-mode go-guru go-eldoc company-go go-mode ledger-mode flycheck-ledger helpful evil-goggles pandoc-mode ox-pandoc ht origami web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor multiple-cursors js-doc company-tern dash-functional tern coffee-mode vue-mode ssass-mode vue-html-mode rainbow-mode ag git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter diff-hl smartscan ample-zen-theme wgrep smex ivy-hydra counsel-projectile counsel swiper ivy yaml-mode flycheck-pos-tip pos-tip flycheck web-mode tagedit slim-mode scss-mode sass-mode pug-mode less-css-mode helm-css-scss haml-mode emmet-mode company-web web-completion-data helm-company helm-c-yasnippet fuzzy company-statistics company auto-yasnippet yasnippet ac-ispell auto-complete org-projectile org-pomodoro alert log4e gntp org-download htmlize gnuplot rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rbenv rake minitest chruby bundler inf-ruby smeargle magit-gitflow helm-gitignore gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link evil-magit magit mmm-mode markdown-toc markdown-mode gh-md ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint info+ indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile pkg-info epl helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu highlight elisp-slime-nav dumb-jump f s diminish define-word column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed dash aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async)))
 '(paradox-github-token t)
 '(ruby-align-chained-calls t)
 '(spacemacs-theme-org-agenda-height nil)
 '(spacemacs-theme-org-height nil)
 '(toc-org-max-depth 10 t)
 '(vc-annotate-background "#3b3b3b")
 '(vc-annotate-color-map
   (quote
    ((20 . "#dd5542")
     (40 . "#CC5542")
     (60 . "#fb8512")
     (80 . "#baba36")
     (100 . "#bdbc61")
     (120 . "#7d7c61")
     (140 . "#6abd50")
     (160 . "#6aaf50")
     (180 . "#6aa350")
     (200 . "#6a9550")
     (220 . "#6a8550")
     (240 . "#6a7550")
     (260 . "#9b55c3")
     (280 . "#6CA0A3")
     (300 . "#528fd1")
     (320 . "#5180b3")
     (340 . "#6380b3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#c9b4cf" "#8abeb7" "#c5c8c6"])
 '(custom-safe-themes
   '("1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5" default))
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-color "#2e2e2e" t)
 '(fci-rule-width 1 t)
 '(flycheck-display-errors-function 'flycheck-display-error-messages)
 '(flycheck-emacs-lisp-load-path 'inherit)
 '(flycheck-global-modes
   '(go-mode json-mode js2-mode coffee-mode yaml-mode web-mode slim-mode scss-mode sass-mode pug-mode less-mode haml-mode enh-ruby-mode ruby-mode))
 '(flycheck-pos-tip-mode nil)
 '(flycheck-sass-executable nil)
 '(flycheck-standard-error-navigation nil)
 '(global-flycheck-mode t)
 '(helm-completion-style 'emacs)
 '(helm-org-format-outline-path t t)
 '(highlight-tail-colors ((("#2c2e28") . 0) (("#272e30") . 20)))
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX" . "#dc752f")
     ("XXXX" . "#dc752f")))
 '(jdee-db-active-breakpoint-face-colors (cons "#10151C" "#5EC4FF"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#10151C" "#8BD49C"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#10151C" "#41505E"))
 '(objed-cursor-color "#D95468")
 '(org-agenda-files '("~/Dropbox/org/todo.org" "~/Dropbox/org/gcal.org"))
 '(org-agenda-restore-windows-after-quit t)
 '(org-default-notes-file "~/Dropbox/org/todo.org")
 '(org-default-priority 68)
 '(org-directory "~/Dropbox/org")
 '(org-ellipsis "↴")
 '(org-image-actual-width nil)
 '(org-imenu-depth 8)
 '(org-link-translation-function 'toc-org-unhrefify)
 '(org-log-done t)
 '(org-priority-default 68)
 '(org-projectile:per-repo-filename "TODOs.org")
 '(org-return-follows-link t)
 '(org-startup-with-inline-images t)
 '(org-todo-keywords
   '((sequence "TODO" "IN-PROGRESS" "DONE")
     (sequence "ON-HOLD")))
 '(package-selected-packages
   '(figlet ts-fold tree-sitter tsc dap-mode bui org-mime org-present org-plus-contrib jsx-mode graphql-mode treepy company-ycmd ycmd request-deferred deferred go-autocomplete go-complete rjsx-mode alchemist flycheck-mix flycheck-credo elixir-mode magit-gh-pulls gh marshal logito pcache ghub+ apiwrap ghub magithub enh-ruby-mode tide typescript-mode protobuf-mode intero hlint-refactor hindent helm-hoogle haskell-snippets flycheck-haskell csv-mode company-ghci company-ghc ghc haskell-mode company-cabal cmm-mode dockerfile-mode slack emojify circe oauth2 websocket vimrc-mode flyspell-correct-helm flyspell-correct dactyl-mode auto-dictionary racer cargo toml-mode flycheck-rust seq rust-mode yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode helm-pydoc cython-mode company-anaconda anaconda-mode pythonic nlinum sql-indent magit-popup git-commit with-editor js2-mode go-guru go-eldoc company-go go-mode ledger-mode flycheck-ledger helpful evil-goggles pandoc-mode ox-pandoc ht origami web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor multiple-cursors js-doc company-tern dash-functional tern coffee-mode vue-mode ssass-mode vue-html-mode rainbow-mode ag git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter diff-hl smartscan ample-zen-theme wgrep smex ivy-hydra counsel-projectile counsel swiper ivy yaml-mode flycheck-pos-tip pos-tip flycheck web-mode tagedit slim-mode scss-mode sass-mode pug-mode less-css-mode helm-css-scss haml-mode emmet-mode company-web web-completion-data helm-company helm-c-yasnippet fuzzy company-statistics company auto-yasnippet yasnippet ac-ispell auto-complete org-projectile org-pomodoro alert log4e gntp org-download htmlize gnuplot rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rbenv rake minitest chruby bundler inf-ruby smeargle magit-gitflow helm-gitignore gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link evil-magit magit mmm-mode markdown-toc markdown-mode gh-md ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint info+ indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile pkg-info epl helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu highlight elisp-slime-nav dumb-jump f s diminish define-word column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed dash aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async))
 '(paradox-github-token t)
 '(pdf-view-midnight-colors (cons "#c5c8c6" "#1d1f21"))
 '(ruby-align-chained-calls t)
 '(rustic-ansi-faces
   ["#1D252C" "#D95468" "#8BD49C" "#EBBF83" "#5EC4FF" "#E27E8D" "#70E1E8" "#A0B3C5"])
 '(safe-local-variable-values
   '((whitespace-line-column . 80)
     (typescript-backend . tide)
     (typescript-backend . lsp)
     (javascript-backend . tide)
     (javascript-backend . tern)
     (javascript-backend . lsp)
     (go-backend . go-mode)
     (go-backend . lsp)))
 '(spacemacs-theme-org-agenda-height nil)
 '(spacemacs-theme-org-height nil)
 '(toc-org-max-depth 10)
 '(vc-annotate-background "#3b3b3b")
 '(vc-annotate-color-map
   '((20 . "#dd5542")
     (40 . "#CC5542")
     (60 . "#fb8512")
     (80 . "#baba36")
     (100 . "#bdbc61")
     (120 . "#7d7c61")
     (140 . "#6abd50")
     (160 . "#6aaf50")
     (180 . "#6aa350")
     (200 . "#6a9550")
     (220 . "#6a8550")
     (240 . "#6a7550")
     (260 . "#9b55c3")
     (280 . "#6CA0A3")
     (300 . "#528fd1")
     (320 . "#5180b3")
     (340 . "#6380b3")
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(warning-suppress-log-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blamer-face ((t :foreground "#7a88cf" :background nil :height 130 :italic t)))
 '(lsp-ui-sideline-code-action ((t (:foreground "#dc752f" :weight extra-bold))))
 '(lsp-ui-sideline-global ((t (:background "#5e5079")))))
)
