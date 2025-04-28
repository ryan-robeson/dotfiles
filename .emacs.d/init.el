;;; -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Allow installing some system packages
;; (require 'use-package-ensure-system-package)

(use-package cider
  :config
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  :custom
  (cider-print-fn "puget")
  (cider-babashka-parameters "nrepl-server localhost:1667"))

;; Completion framework
(use-package company
  :config
  (global-company-mode)
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2))

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest
            :branch "main")
  ;;:hook (prog-mode . copilot-mode)
  :custom
  (copilot-indent-offset-warning-disable t))

;; Doesn't currently work
;;(use-package copilot-chat
;;  :after (copilot))

(use-package emmet-mode
  :hook (web-mode css-mode))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-define-key 'insert copilot-mode-map
    (kbd "<backtab>") 'copilot-accept-completion
    (kbd "C-n") 'copilot-next-completion
    (kbd "C-p") 'copilot-previous-completion
    (kbd "C-e") 'copilot-accept-completion-by-line)
  (evil-mode 1)
  :custom
  (evil-esc-delay 0.1)
  (evil-move-beyond-eol t)
  ;; Fix redo
  (evil-undo-system 'undo-redo))

(use-package evil-cleverparens
  :hook (smartparens-strict-mode))

(use-package evil-collection
  :after (cider evil)
  :ensure t
  :config
  (evil-collection-init)
  ;; CIDER bindings
  (evil-collection-define-key 'normal 'clojure-mode-map
    (kbd ",eb") 'cider-eval-buffer
    (kbd ",ee") 'cider-eval-last-sexp
    (kbd ",ef") 'cider-eval-defun-at-point
    (kbd ",euf") 'cider-eval-defun-up-to-point
    (kbd ",er") 'cider-eval-dwim
    (kbd ",hh") 'cider-doc
    (kbd ",ss") 'cider-switch-to-repl-buffer
    (kbd ",qq") 'cider-quit
    (kbd ",pf") 'cider-pprint-eval-defun-at-point
    (kbd ",cju") 'cider-jack-in-universal
    (kbd ",ccu") 'cider-connect)
    (kbd ",ree") 'cider-insert-last-sexp-in-repl

  ;; REPL specific bindings
  (evil-collection-define-key 'normal 'cider-repl-mode-map
    (kbd ",ss") 'cider-switch-to-last-clojure-buffer
    (kbd ",qq") 'cider-quit))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package git-gutter
  :config
  (global-git-gutter-mode +1))

(use-package magit)

;;(use-package marginalia
;;  :ensure t
;;  :init
;;  (marginalia-mode)
;;
;;  ;; Enable richer annotations for commands
;;  (setq marginalia-annotators '(marginalia-annotators-heavy
;;                               marginalia-annotators-light
;;                               nil))
;;
;;  ;; Show documentation in the marginalia
;;  (setq marginalia-field-width 120)
;;  :bind
;;  ;; Toggle between minimal and full annotations
;;  (:map minibuffer-local-map
;;        ("<leader>a" . marginalia-cycle)))

;;(use-package prescient
;;  :ensure t
;;  :config
;;  (prescient-persist-mode +1))

(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :hook (markdown-mode . visual-line-mode)
  :custom
  (markdown-command "pandoc")
  :config
  (evil-define-key 'normal markdown-mode-map
    (kbd ", p") 'markdown-preview))

(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-enable-caching t)
  ;; Use fd for file indexing when available (much faster than find)
  ;; and supposedly better than ripgrep: https://www.reddit.com/r/linux4noobs/comments/egb644/comment/fc5li3r
  (when (executable-find "fd")
    (setq projectile-generic-command "fd . -0 --type f --color=never"))
  ;; Alternatively, use ripgrep when available
  (when (and (not (executable-find "fd")) (executable-find "rg"))
    (setq projectile-generic-command "rg -0 --files --color=never"))
  (with-eval-after-load 'evil
    (evil-define-key 'normal 'global (kbd "C-p") 'projectile-find-file)
    (evil-define-key 'normal 'global (kbd "<leader>p") 'projectile-command-map)))

;; Persistent undo (equivalent to your persistent undo settings)
(use-package undo-tree
  :config
  ;; This is buggy with vim commands
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package vertico
  :init
  (vertico-mode)
  :config
  (setq completion-styles '(basic partial-completion flex emacs22)))

;;(use-package vertico-prescient
;;  :ensure t
;;  :after (vertico prescient)
;;  :config
;;  (vertico-prescient-mode +1))

(use-package yaml-mode)

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

;; Make * and # search for symbols rather than words
(setq-default evil-symbol-word-search t)

;; Basic settings equivalent to your Vim settings
(setq-default indent-tabs-mode nil)        ; expandtab
(setq-default tab-width 2)                 ; tabstop
(setq backward-delete-char-untabify-method 'hungry) ; backspace behavior
(setq case-fold-search t)                  ; ignorecase
(setq-default indent-line-function 'indent-relative) ; smartindent
(global-display-line-numbers-mode)         ; set number
(setq tab-always-indent 'complete)         ; smarttab behavior

;; Search settings
(setq search-highlight t)
(setq query-replace-highlight t)
(setq case-fold-search t)                  ; ignorecase
(setq search-whitespace-regexp ".*?")      ; improved search

;; Window movement (equivalent to your C-h,j,k,l mappings)
(global-set-key (kbd "C-h") 'windmove-left)
(global-set-key (kbd "C-j") 'windmove-down)
(global-set-key (kbd "C-k") 'windmove-up)
(global-set-key (kbd "C-l") 'windmove-right)

;; File backup settings (equivalent to swap file settings)
(setq backup-directory-alist
      `((".*" . ,"~/.emacs.d/backup")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs.d/auto-save" t)))

;; Create backup directory if it doesn't exist
(unless (file-exists-p "~/.emacs.d/backup")
  (make-directory "~/.emacs.d/backup" t))

;; Highlight trailing whitespace
(setq-default show-trailing-whitespace t)

;; File type associations (equivalent to your filetypes autogroup)
(add-to-list 'auto-mode-alist '("\\.thor\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Cheffile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.yaml|.yml\\'" . yaml-mode ))

;; Python and Markdown indent settings
(setq-default python-indent-offset 4)
(setq-default markdown-indent-offset 4)

;; Save place in files between sessions
(save-place-mode 1)

;; Enable winner mode for window configuration undo/redo
(winner-mode 1)

(setq scroll-preserve-screen-position t)
;; Keep cursor from jumping to center of screen when moving past top/bottom
;; of screen.
(setq scroll-conservatively 101)
(setq scroll-margin 10)

(xterm-mouse-mode 1)
(mouse-wheel-mode 1)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)

;; Make sentence jumping work correctly
(setq sentence-end-double-space nil)

;; Setup smartparens
(add-hook 'clojure-mode-hook #'smartparens-strict-mode)
(add-hook 'emacs-lisp-mode-hook #'smartparens-strict-mode)

;; Allow eval-defun-at-point etc to work as expected with (comment) forms in clojure
(add-hook 'clojure-mode-hook (lambda () (setq-local clojure-toplevel-inside-comment-form t)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company copilot copilot-chat emmet-mode evil-cleverparens
             evil-collection evil-surround flycheck git-gutter magit
             prescient projectile undo-tree
             use-package-ensure-system-package vertico
             vertico-prescient yaml-mode zenburn-theme)))

(provide 'init)
;;; init.el ends here
