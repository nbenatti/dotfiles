;; -*- lexical-binding: t; -*-

;; <**> Initial setup <**>

(setq custom-file "~/.emacs.d/custom-set-vars.el")
(setq make-backup-files nil)

;; configure the package manager
(setq straight-use-package-by-default t)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

;; <**> Keybindings <**>

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-c x") 'check-parens)
(define-key emacs-lisp-mode-map (kbd "C-c b") 'eval-buffer)
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)

;; standard undo/redo behaviour
;; (default is still available at the default bindings)
(global-set-key (kbd "C-*") 'undo-only)
(global-set-key (kbd "C-+") 'undo-redo)



;; <**> UI tweaks <**>

;; general configuration
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq calendar-week-start-day 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(global-hl-line-mode 1)
(electric-pair-mode 1)
(column-number-mode t)

;; 1-line scrolling instead of paging
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; blink the status bar orange as a visual bell
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg) (set-face-foreground 'mode-line fg))
                               orig-fg))))

;; custom font
(set-face-attribute 'default nil :height 105)
(set-frame-font "Iosevka Semibold Extended" nil t)

;; custom icons
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-dired
  :ensure t
  :defer t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-ibuffer
  :ensure t
  :defer t
  :hook
  (ibuffer-mode . nerd-icons-ibuffer-mode))

;; dashboard at startup
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-banner-logo-title "ÆLYSIµM")
  (setq dashboard-center-content t)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-init-info t)
  (setq dashboard-items '((recents . 5)))
  (setq dashboard-item-names '(("Recent Files:" . "R€cent Filezzz:")))
  (setq dashboard-footer-messages '("\"Don't sacrifice your life for your health\" - Grian Chatten"))
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*"))))

;; <**> Core editor functionalities <**>

;; enrich syntax highlighting with proper parsing
;; (the language grammar is parsed in LR fashion)
(use-package treesit-auto
  :ensure t
  :defer t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(awk bash bibtex c cmake commonlisp cpp markdown
				 dockerfile glsl html java json make python rust verilog vhdl))
  (treesit-auto-add-to-auto-mode-alist 'all) ;; all == "for every auto-lang"
  (global-treesit-auto-mode))

;; handle code snippets
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)
  (setq yas-snippet-dirs
	'("~/.emacs.d/straight/build/yasnippet-snippets/snippets")))

(use-package yasnippet-snippets
  :ensure t)

;; <**> Integration with useful services <**>

