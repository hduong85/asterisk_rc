;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Emacs GUI settings
(setq doom-font (font-spec :family "Iosevka SS07" :size 15))
(setq doom-theme 'doom-palenight)
(setq doom-localleader-key ",")
(setq display-line-numbers-type 'relative)
(setq line-number-mode nil)

(custom-set-faces '(cursor ((t (:background "#98f5ff")))))

(setq exec-path-from-shell-check-startup-files nil)
(exec-path-from-shell-initialize)

;; truncate-lines in all buffers
(setq-default truncate-lines nil)
(setq-default global-visual-line-mode t)

;; Make titlebar match background color
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;; Make Emacs fullscreen by default
(add-to-list 'default-frame-alist '(fullscreen . fullboth))

;; Workaround for magithub authentication stuffs
(setq auth-sources '("~/.authinfo"))

;; Set command key as super on OSX
(setq mac-command-modifier 'super)

;; Set option key as meta on OSX
(setq mac-option-modifier 'meta)

(setq delete-by-moving-to-trash t)

(after! doom-modeline
  (remove-hook! 'doom-modeline-mode-hook #'column-number-mode)
  (setq doom-modeline-buffer-file-name-style 'file-name)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-percent-position nil))

;; Reduce which-key delay
(after! which-key
  (setq which-key-idle-delay 0.5))

(after! osx-trash
  (when (eq system-type 'darwin)
    (osx-trash-setup)))

(after! dired
  ;; Icons in dired
  (require 'font-lock+)
  (map! :mode dired-mode
        [remap dired-find-file] #'dired-single-buffer
        [remap dired-up-directory] #'dired-single-up-directory))

;; Set default source and destination languages for Google Translate
(after! google-translate-core-ui
  (setq google-translate-default-source-language "en")
  (setq google-translate-default-target-language "vi"))

;; Keybindings
(map! "s-c"  #'evil-yank
      "s-v"  #'yank
      ;; Easier window navigation
      :nvi "C-h"  #'evil-window-left
      :nvi "C-j"  #'evil-window-down
      :nvi "C-k"  #'evil-window-up
      :nvi "C-l"  #'evil-window-right
      :nv "C-S-k" #'move-line-up
      :nv "C-S-j" #'move-line-down

      (:leader
        :nv "x" nil ;; Disable x prefix for scratch buffer

        (:prefix "o"
          :desc "List processes" :nv "x"  #'list-processes
          :desc "Terminal" :nv "t" #'vterm/open-in-project
          :desc "Project sidebar" :nv "p"  #'treemacs
          :desc "Prodigy" :nv "s"  #'prodigy)

        (:prefix "b"
          :nv "s" nil
          :nv "k" nil
          :desc "Delete buffer" :nv "d"  #'kill-this-buffer)

        (:prefix "w"
          :nv "c" nil
          :nv "d"  #'evil-window-delete)

        (:prefix "/"
          :desc "Search this text in project" :nv "*"  #'counsel-projectile-ag)

        (:prefix "p"
          :desc "Find dir" :nv "d" #'counsel-projectile-find-dir)

        (:prefix "g"
          :desc "Resolve conflicts" :n "r" #'hydra-smerge/body)

        (:prefix "w"
          :desc "evil-window-resize" :n "r" #'hydra-evil-window-resize/body)

        (:prefix "i"
          :desc "UUIDv4" :n "u" #'uuidgen
          (:prefix ("l" . "lorem-ipsum")
            :desc "list" :n "l" #'lorem-ipsum-insert-list
            :desc "sentences" :n "s" #'lorem-ipsum-insert-sentences
            :desc "paragraphs" :n "p" #'lorem-ipsum-insert-paragraphs)
          :desc "Emoji" :n "e" #'emoji-cheat-sheet-plus-insert)

        (:prefix "t"
          :desc "Truncate lines" :n "t" #'toggle-truncate-lines)

        (:prefix ("x" . "text-transform")
          :desc "Translate this text" :nv "g" #'google-translate-at-point
          (:prefix ("f" . "copy-as-format")
            :desc "Github" :nv "g" #'copy-as-format-github
            :desc "HTML" :nv "h" #'copy-as-format-html
            :desc "Markdown" :nv "m" #'copy-as-format-markdown
            :desc "Org" :nv "o" #'copy-as-format-org
            :desc "Slack" :nv "s" #'copy-as-format-slack))))

;; Emacs sometimes registers C-s-f as this weird keycode
(global-set-key (kbd "<C-s-268632070>") #'toggle-frame-fullscreen)

;; Modules
;; Evil
(after! evil
  (evil-define-text-object evil-inner-buffer (count &optional beg end type)
    (list (point-min) (point-max)))
  (add-to-list 'evil-motion-state-modes #'process-menu-mode)
  (map! :map evil-inner-text-objects-map "g" 'evil-inner-buffer
        :map evil-motion-state-map "," nil))

;; Magit
(after! magit
  (setq magit-status-mode-hook nil)
  (setq-hook! 'magit-status-mode-hook header-line-format '(:eval (awesome-tab-line)))
  (setq magit-repository-directories '(("~/EH-Workspace" . 1)
                                       ("~/Workspace" . 1))
        magit-save-repository-buffers nil))

;; lang/org
(after! org
  (add-hook! 'org-pomodoro-finished-hook
    (terminal-notifier-notify "org-pomodoro" "Pomodoro finished!"))
  (map! "C-c c" #'org-capture
        "C-c n p" #'org-projectile-project-todo-completing-read
        :nv "C-c C-p" #'org-pomodoro)
  (set-face-attribute 'org-headline-done nil :strike-through t)
  (add-to-list 'org-modules 'org-drill)
  (advice-add 'org-babel-execute-src-block :around 'ob-async-org-babel-execute-src-block)
  (setq org-plantuml-jar-path "~/.local/bin/plantuml.jar")
  (remove-hook! org-mode #'org-indent-mode)
  (setq org-startup-indented nil)
  (setq org-directory (expand-file-name "~/Workspace/orgs")
        org-agenda-files (list org-directory))
  ;; Org capture templates
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
                                 (file "~/Workspace/orgs/inbox.org")
                                 "* ☛ TODO %i%?")))
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-use-outline-path 'file)
  ;; makes org-refile outline working with helm/ivy
  (setq org-outline-path-complete-in-steps nil)
  ;; Org TODO keywords
  (setq org-todo-keywords '((sequence "☛ TODO" "⚑ IN-PROGRESS" "|" "✓ DONE" "✘ CANCELED")))
  (setq org-todo-keyword-faces '(("☛ TODO" . (:foreground "grey"))
                                 ("⚑ IN-PROGRESS" . (:foreground "yellow"))
                                 ("✓ DONE" . (:foreground "green"))
                                 ("✘ CANCELED" . (:foreground "red")))))

;; flycheck-apib
(def-package! flycheck-apib
  :when (featurep! :feature syntax-checker)
  :after apib-mode
  :config (add-hook! apib-mode #'flycheck-apib-setup))

;; apib-mode
(add-to-list 'auto-mode-alist '("\\.apib\\'" . apib-mode))

;; js2-mode
(after! js2-mode
  (setq-default js-indent-level 2)
  (add-hook! js2-mode #'(add-node-modules-path prettier-js-mode indent-guide-mode))
  (map! :mode js2-mode
        (:leader
          (:prefix "p"
            :desc "Toggle source <=> test" :n "a" #'projectile-toggle-between-implementation-and-test))))

;; json-mode
(after! json-mode
  (setq-default js-indent-level 2))

;; projectile
(after! projectile
  ;; Configure npm project with projectile
  (projectile-register-project-type 'npm '("package.json")
                                    :test "npm run test"
                                    :test-suffix ".spec"))

;; Re-add visual-line-mode's fringes
(after! fringe-helper
  (add-to-list 'fringe-indicator-alist
               (list 'continuation
                     (fringe-lib-load fringe-lib-slash)
                     (fringe-lib-load fringe-lib-backslash))))

(after! rspec-mode
  (add-hook! rspec-compilation-mode #'inf-ruby-switch-setup)
  (set-popup-rule! "\\`\\*rspec-compilation.*?\\*\\'" :side 'right :quit 'current)
  ;; Rspec doesn't use RVM!
  (setq rspec-use-rvm nil))

(after! treemacs
  (map! :mode treemacs-mode
        "C-h"  #'evil-window-left
        "C-j"  #'evil-window-down
        "C-k"  #'evil-window-up
        "C-l"  #'evil-window-right)
  (setq treemacs-show-cursor t)
  (setq doom-treemacs-use-generic-icons nil)
  (treemacs-follow-mode t))

(after! helm
  (setq helm-ag-insert-at-point 'symbol)
  (setq +helm-posframe-text-scale nil))

(after! ivy
  (set-face-foreground 'ivy-current-match "#c3e88d")
  (add-to-list 'ivy-display-functions-alist 'ivy-source-awesome-tab-group)
  (setq counsel-projectile-ag-initial-input '(ivy-thing-at-point)))

(after! enh-ruby-mode
  (add-hook! enh-ruby-mode #'indent-guide-mode)
  (map! :mode enh-ruby-mode
        (:leader
          (:prefix "p"
            :desc "Toggle source <=> test" :n "a" #'projectile-toggle-between-implementation-and-test))
        (:localleader
          (:desc "Toggle block" "}" #'enh-ruby-toggle-block)
          (:prefix ("l" . "lsp")
            "f" #'lsp-format-buffer)
          (:prefix ("b" . "bundle"))
          (:prefix ("k" . "rake"))
          (:prefix ("r" . "robe"))
          (:prefix ("s" . "inf-ruby"))
          (:prefix ("t" . "rspec")))))

(after! all-the-icons
  (add-to-list 'all-the-icons-mode-icon-alist
               '(enh-ruby-mode all-the-icons-alltheicon "ruby-alt" :face all-the-icons-lred))
  (add-to-list 'all-the-icons-mode-icon-alist
               '(vterm-mode all-the-icons-octicon "terminal" :v-adjust 0.2)))

(after! org-projectile
  (setq org-projectile-projects-file "~/Workspace/orgs/inbox.org")
  (push (org-projectile-project-todo-entry) org-capture-templates)
  (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files))))

(after! reason-mode
  (add-hook! reason-mode #'lsp)
  (add-hook! reason-mode (add-hook 'before-save-hook #'lsp-format-buffer nil t)))

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("solargraph" "stdio"))
                    :major-modes '(ruby-mode enh-ruby-mode)
                    :priority 1
                    :initialization-options '(:diagnostics t)
                    :server-id 'enh-ruby-ls))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "reason-language-server")
                    :major-modes '(reason-mode)
                    :notification-handlers (ht ("client/registerCapability" 'ignore))
                    :priority 1
                    :server-id 'reason-ls))
  (setq lsp-eldoc-render-all nil))

(after! company-lsp
  (setq company-lsp-cache-candidates 'auto))

(after! lsp-ui
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-imenu-enable nil)
  (setq lsp-ui-doc-enable nil))

(after! web-mode
  (add-hook! (html-mode css-mode sass-mode less-css-mode web-mode) #'(lsp! indent-guide-mode)))

(after! elisp-mode
  (add-hook! elisp-mode #'indent-guide-mode)
  (map! :mode emacs-lisp-mode
        (:leader
          (:prefix "p"
            :desc "Toggle source <=> test" :n "a" #'projectile-toggle-between-implementation-and-test))))

(after! css-mode
  (add-hook! css-mode #'indent-guide-mode)
  (setq css-indent-offset 2))

(awesome-tab-mode t)

(after! awesome-tab
  (setq awesome-tab-hide-tab-function #'+awesome-tab-hide-tab)
  (setq awesome-tab-buffer-groups-function #'+awesome-tab-buffer-groups)
  (setq awesome-tab-display-sticky-function-name nil)
  (setq awesome-tab-style 'alternate)

  (map! [header-line mouse-1] #'awesome-tab-click-to-tab
        "s-]" #'awesome-tab-forward-tab
        "s-[" #'awesome-tab-backward-tab

        (:leader
          (:prefix ("TAB" . "awesome-tab")
            :desc "Forward tab group" :nv "]" #'+awesome-tab-forward-group
            :desc "Backward tab group" :nv "[" #'+awesome-tab-backward-group
            :desc "Kill all buffers in group" :nv "d" #'awesome-tab-kill-all-buffers-in-current-group
            :desc "Kill other buffers in group" :nv "D" #'awesome-tab-kill-other-buffers-in-current-group
            :desc "Switch to tab group" :nv "TAB" #'awesome-tab-build-ivy-source))))

(after! vterm
  (map! :mode vterm-mode
        :i [return] #'vterm-send-return
        :i "C-g" #'vterm-send-escape
        :i "C-c" #'vterm--self-insert))

(after! forge
  (setq forge-topic-list-limit '(5 . 5)))

(after! hydra
  (setq hydra-hint-display-type 'message))

(after! prodigy
  (set-evil-initial-state! 'prodigy-mode 'normal))

;;;;;;;;;; Functions ;;;;;;;;;;
(defhydra hydra-smerge (:hint nil)
  "
Movement^^^^            Merge action^^           Other
------------------^^^^  ---------------------^^  -----------
[_n_]^^    next hunk    [_b_] keep base          [_u_] undo
[_N_/_p_]  prev hunk    [_m_] keep mine          [_r_] refine
[_k_]^^    move up      [_a_] keep all           [_q_] quit
[_j_]^^    move down    [_o_] keep other
[_C-u_]^^  scroll up    [_c_] keep current
[_C-d_]^^  scroll down  [_C_] combine with next"
  ("n" smerge-next)
  ("N" smerge-prev)
  ("p" smerge-prev)
  ("j" evil-next-line)
  ("k" evil-previous-line)
  ("C-u" evil-scroll-up)
  ("C-d" evil-scroll-down)
  ("b" smerge-keep-base)
  ("m" smerge-keep-mine)
  ("a" smerge-keep-all)
  ("o" smerge-keep-other)
  ("c" smerge-keep-current)
  ("C" smerge-combine-with-next)
  ("u" undo-tree-undo)
  ("r" smerge-refine)
  ("q" nil))

(defhydra hydra-evil-window-resize (:hint nil)
  ("k" (evil-window-increase-height 10) "increase height by 10 rows")
  ("j" (evil-window-decrease-height 10) "decrease height by 10 rows")
  ("l" (evil-window-increase-width 10) "increase width by 10 columns")
  ("h" (evil-window-decrease-width 10) "decrease width by 10 columns")
  ("q" nil "quit"))

(defun terminal-notifier-notify (title message)
  "Show a message with `terminal-notifier-command`."
  (start-process "terminal-notifier"
                 "*terminal-notifier*"
                 (executable-find "terminal-notifier")
                 "-title" title
                 "-message" message
                 "-sound" "default"
                 "-activate" "org.gnu.Emacs"
                 "-group" "org.gnu.Emacs"
                 "-appIcon" "/Users/qhuyduong/Workspace/inventory/org-unicorn.png"))

(defun +awesome-tab-hide-tab (x)
  (let ((name (format "%s" x)))
    (or
     ;; Current window is not dedicated window.
     (window-dedicated-p (selected-window))

     ;; Buffer name begin with asterisk *
     (and (string-match-p "^[ ]*\\*" name)
          ;; but not one of these buffers
          (not (or (string-prefix-p "*rspec" name)
                   (string-prefix-p "*prodigy-" name))))

     (string-match-p "treemacs-persist" name)

     ;; Is not magit-* buffer (except magit source file)
     (and (string-prefix-p "magit-" name)
          (not (string= (file-name-extension name) "el"))))))

(defun +awesome-tab-buffer-groups ()
  "Group priority:
1. Handle some exceptional buffers (e.g: Prodigy)
2. Try to add buffer to project.
3. Group buffer with mode if buffer is derived from `dired-mode' `org-mode'.
4. Other buffers pushed to group \"Emacs\"."
  (let ((current-project (cdr (project-current))))
    (list
     (cond
      ((string-prefix-p "*prodigy-" (buffer-name))
       "Prodigy")
      (current-project
       current-project)
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(org-mode org-agenda-mode diary-mode))
       "OrgMode")
      (t "Emacs")))))

(defun vterm-send-escape ()
  (interactive)
  (vterm-send-string "\e"))

(defun vterm-send-return ()
  "Sends C-m to the libvterm."
  (interactive)
  (process-send-string vterm--process "\C-m"))

(defun vterm/open-in-project ()
  (interactive)
  (+vterm/open t))

(defun +awesome-tab-forward-group ()
  (interactive)
  (awesome-tab-forward-group)
  (minibuffer-message "Awesome-Tab Group: %s" (cdr (awesome-tab-selected-tab (awesome-tab-current-tabset t)))))

(defun +awesome-tab-backward-group ()
  (interactive)
  (awesome-tab-backward-group)
  (minibuffer-message "Awesome-Tab Group: %s" (cdr (awesome-tab-selected-tab (awesome-tab-current-tabset t)))))

(defun awesome-tab-click-to-tab (event)
  "Switch to buffer (obtained from EVENT) on clicking header line"
  (interactive "e")
  (let ((position (event-start event)))
    (select-window (posn-window position))
    (let ((selected-tab-name
           (string-trim (car (posn-string position)))))
      (unless (string-match-p "^%-$" selected-tab-name)
        (switch-to-buffer selected-tab-name)))))

(when (file-exists-p "~/.doom.d/+prodigy-services.el")
  (load! "+prodigy-services"))
