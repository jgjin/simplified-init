;;; package --- Summary

;;; Commentary:
;;; poop

;;; Code:

;; Add load paths
(add-to-list 'load-path "~/.emacs.d/elpa/")

;; Initialize package archives
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Fetch list of available packages
(package-refresh-contents)

;; Turn on/off non-package modes
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Set non-package variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(confirm-kill-emacs (quote y-or-n-p))
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "#dc752f")
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
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f"))))
 '(inhibit-startup-screen t)
 '(ns-alternate-modifier (quote control))
 '(ns-command-modifier (quote meta))
 '(ns-right-alternate-modifier (quote control))
 '(ns-right-command-modifier (quote meta))
 '(package-selected-packages
   (quote
    (zzz-to-char vlf spacemacs-theme smartparens rainbow-delimiters powerline use-package multiple-cursors iedit hydra hungry-delete goto-chg expand-region diminish dashboard csv-mode counsel avy)))
 '(pdf-view-midnight-colors (quote ("#b2b2b2" . "#292b2e"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Set font size
;; (set-face-attribute 'default nil :height 240)

;; Enable use-package
;; See https://github.com/jwiegley/use-package for explanation
(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

;; Diminish non-package minor modes
(diminish 'abbrev-mode)

(use-package avy
  :ensure t
  :config
  ;; Set package-related faces (colors)
  (set-face-attribute 'avy-lead-face nil
		      :foreground "#86dc2f" :background "#444444")
  (set-face-attribute 'avy-lead-face-0 nil
		      :foreground "#86dc2f" :background "#444444")
  (set-face-attribute 'avy-lead-face-1 nil
		      :foreground "#86dc2f" :background "#444444")
  (set-face-attribute 'avy-lead-face-2 nil
		      :foreground "#86dc2f" :background "#444444")

  :bind
  (("M-k" . avy-goto-char-timer)
   ("M-l" . avy-goto-line)))

(use-package counsel
  :ensure t
  :diminish counsel-mode
  :config
  (counsel-mode 1)
  :bind
  (("M-x" . counsel-M-x)
   ("C-h a" . counsel-apropos)
   ("C-h b" . counsel-descbinds)
   ("C-p" . counsel-ag)))

(use-package csv-mode
  :ensure t)

(use-package dashboard
  :ensure t
  :init
  ;; Start dashboard when emacs starts
  (dashboard-setup-startup-hook)

  :config
  ;; Set greeting message
  (setq dashboard-banner-logo-title "Welcome to Jason's BananaMacs!")
  ;; Set dashboard image
  ;; (setq dashboard-startup-banner "~/.emacs.d/banana/banana.png")
  ;; Set dashboard items
  (setq dashboard-items '((recents . 40)
                          (bookmarks . 0)
                          (projects . 0)
                          (agenda . 0)))

  :bind
  (:map dashboard-mode-map
        ("M-w" . widget-backward)
        ("M-s" . widget-forward)))

(use-package dired
  :bind
  ;; Overrides M-s as a prefix key
  (:map dired-mode-map
	("M-s" . next-line)))

(use-package expand-region
  :ensure t
  :config
  (defhydra hydra-mark
    (:hint nil
	   :idle 3.00)
    "
Move    ^Small^      ^Containers^  ^Miscellaneous^
^^^^^^-----------------------------------------------
Normal  _p_ Point    _q_ In ''     _u_       Url
        _w_ Word     _Q_ Out ''    _c_       Comment
        _s_ Symbol   _i_ In Pair   _t_       In Tag
        _S_ Pre+sym  _o_ Out Pair  _T_       Out Tag
        _c_ Call     _b_ Block     _C-SPC_   Expand
        _a_ Accessor _f_ Function  _C-M-SPC_ Contract
    "
    ("M-w"     previous-line)
    ("M-s"     next-line)
    ("M-a"     left-char)
    ("M-d"     right-char)
    ("<up>"    previous-line-message)
    ("<down>"  next-line-message)
    ("<left>"  left-char-message)
    ("<right>" right-char-message)
    ("C-w"     beginning-of-buffer)
    ("C-s"     end-of-buffer)
    ("C-a"     sp-backward-sexp)
    ("C-d"     sp-forward-sexp)
    ("M-q"     sp-backward-delete-word)
    ("C-q"     (lambda() (interactive) (custom-mc-select-previous) (hydra-mc/body)) :exit t)
    ("C-M-q"   sp-beginning-of-sexp)
    ("M-e"     sp-delete-word)
    ("C-e"     (lambda() (interactive) (custom-mc-select-next) (hydra-mc/body)) :exit t)
    ("C-M-e"   sp-end-of-sexp)
    ("p"       (lambda() (interactive) (deactivate-mark) (push-mark-command (point))))
    ("w"       er/mark-word)
    ("s"       er/mark-symbol)
    ("S"       er/mark-symbol-with-prefix)
    ("c"       er/mark-method-call)
    ("a"       er/mark-next-accessor)
    ("q"       er/mark-inside-quotes)
    ("Q"       er/mark-outside-quotes)
    ("i"       er/mark-inside-pairs)
    ("o"       er/mark-inside-pairs)
    ("b"       mark-sexp)
    ("d"       er/mark-defun)
    ("f"       er/mark-defun)
    ("u"       er/mark-url)
    ("c"       er/mark-comment)
    ("t"       er/mark-inner-tag)
    ("T"       er/mark-outer-tag)
    ("k"       avy-goto-char-timer)
    ("l"       avy-goto-line)
    ("C-f"     swiper)
    ("e"       exchange-point-and-mark)
    ("C-SPC"   (er/expand-region 1))
    ("C-M-SPC" (er/contract-region 1))
    ("C-z"     undo)
    ("r"       (lambda() (interactive) (deactivate-mark) (rectangle-mark-mode) (hydra-rectangle-mark/body)) :exit t)
    ("C-c"     (lambda() (interactive) (kill-ring-save (region-beginning) (region-end)) (deactivate-mark)) :exit t)
    ("C-x"     (lambda() (interactive) (kill-region (region-beginning) (region-end))) :exit t)
    ("C-l"     copy-lines :exit t)
    ("C-M-d"   duplicate-line-or-region :exit t))

  (defhydra hydra-rectangle-mark
    (:hint nil
	   :idle 3.00)
    "
Move    ^Commands^
^^^^-------------------------
Normal  _s_ String _d_ Delete
        _c_ Copy   _x_ Cut
        _v_ Paste  _o_ Open
        _C_ Close
    "
    ("M-w"     previous-line)
    ("M-s"     next-line)
    ("M-a"     left-char)
    ("M-d"     right-char)
    ("<up>"    previous-line-message)
    ("<down>"  next-line-message)
    ("<left>"  left-char-message)
    ("<right>" right-char-message)
    ("C-w"     beginning-of-buffer)
    ("C-s"     end-of-buffer)
    ("C-a"     sp-backward-sexp)
    ("C-d"     sp-forward-sexp)
    ("M-q"     sp-backward-delete-word)
    ("C-q"     scroll-down)
    ("M-e"     sp-delete-word)
    ("C-e"     scroll-up)
    ("s"       string-rectangle :exit t)
    ("c"       copy-rectangle-as-kill :exit t)
    ("v"       yank-rectangle :exit t)
    ("C"       close-rectangle)
    ("d"       delete-rectangle :exit t)
    ("x"       kill-rectangle :exit t)
    ("o"       open-rectangle)
    ("k"       avy-goto-char-timer)
    ("e"       exchange-point-and-mark)
    ("C-z"     undo)
    ("r"       (lambda() (interactive) (deactivate-mark) (push-mark-command (point)) (hydra-mark/body)) :exit t)))

(use-package goto-chg
  :ensure t
  :bind
  ("C-<" . goto-last-change)
  ("C->" . goto-last-change-reverse))

(use-package hl-line
  :config
  (global-hl-line-mode)
  (set-face-background 'hl-line "#c4cedd"))

(use-package hungry-delete
  :ensure t)

(use-package hydra
  :ensure t)

(use-package iedit
  :ensure t
  :bind
  (("C-;" . iedit-mode)))

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  (setq ivy-wrap t)
  (setq ivy-action-wrap t)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (ivy-mode 1)
  :bind
  (("C-c C-M-r" . ivy-resume)
   :map ivy-switch-buffer-map
   ("C-S-k" . ivy-switch-buffer-kill)
   :map ivy-minibuffer-map
   ("C-r" . ivy-reverse-i-search)
   ("C-M-s" . ivy-next-line-and-call)
   ("M-d" . ivy-dispatching-done)
   ("C-M-d" . ivy-dispatching-call)
   ("M-l" . ivy-avy)
   ("TAB" . ivy-alt-done)
   ("<C-tab>" . ivy-backward-kill-word)))

(use-package multiple-cursors
  :ensure t
  :config
  (add-to-list 'mc/cmds-to-run-for-all 'custom-delete)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mark/lambda-C-q-and-exit)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mark/lambda-C-e-and-exit)
  
  (defhydra hydra-mc
    (:hint nil
	   :idle 3.00)
    "
( ͡° ͜ʖ ͡°)
    "
    ("<up>"    mc/mmlte--up)
    ("<down>"  mc/mmlte--down)
    ("<left>"  mc/mmlte--left)
    ("<right>" mc/mmlte--right)
    ("M-q"     mc/cycle-backward)
    ("C-q"     custom-mc-select-previous)
    ("C-M-q"   mc/unmark-previous-like-this)
    ("M-e"     mc/cycle-forward)
    ("C-e"     custom-mc-select-next)
    ("C-M-e"   mc/unmark-next-like-this))

  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/body)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/mc/mmlte--up)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/mc/mmlte--down)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/mc/mmlte--left)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/mc/mmlte--right)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/mc/cycle-backward)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/custom-mc-select-previous)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/mc/unmark-previous-like-this)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/mc/cycle-forward)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/custom-mc-select-next)
  (add-to-list 'mc/cmds-to-run-once 'hydra-mc/mc/unmark-next-like-this))

(use-package org
  :ensure t
  :config
  (setq org-export-preserve-breaks t)
  (setq org-catch-invisible-edits 1)
  (setq org-startup-folded 1)
  
  :bind
  (:map org-mode-map
	("C-a" . sp-backward-sexp)
	("M-a" . left-char)
	("<M-return>" . org-insert-heading)
	("<C-return>" . org-insert-heading-respect-content)
	("<M-S-return>" . org-insert-todo-heading)
	("<C-S-return>" . org-insert-todo-heading-respect-content)
	("<tab>" . org-cycle)
	("<M-left>" . org-do-promote)
	("<M-right>" . org-do-demote)
	("<C-left>" . org-promote-subtree)
	("<C-right>" . org-demote-subtree)
	("<C-up>" . org-move-subtree-up)
	("<C-down>" . org-move-subtree-down)
	("M-SPC" . org-mark-element)
	("C-M-SPC" . org-mark-subtree)))

(use-package powerline
  :ensure t
  :config
  ;; Set powerline to default theme
  (powerline-default-theme))

(use-package projectile
  :ensure t
  :config
  ;; Enable projectile-mode
  (projectile-mode)
  ;; Set ivy as projectile completion system
  (setq projectile-completion-system 'ivy))

(use-package rainbow-delimiters
  :ensure t
  :init
  ;; ???
  (require 'rainbow-delimiters)

  :config
  ;; Turn on rainbow-delimiters mode for programming modes
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :init
  ;; Configure smartparens
  (require 'smartparens-config)

  :config
  ;; Turn on smartparens globally
  (smartparens-global-mode 1)
  ;; Highlight matching parentheses
  (show-smartparens-global-mode 1)
  ;; Turn on "strict mode" globally
  (smartparens-global-strict-mode 1)
  
  :bind
  (("C-a" . sp-backward-sexp)
   ("C-d" . sp-forward-sexp)
   ("M-q" . sp-backward-delete-word)
   ("M-e" . sp-delete-word)))

(use-package spacemacs-theme
  :ensure t
  :defer t
  :init
  (set-face-attribute 'default nil :background "#fff4ee")
  (set-face-background 'font-lock-comment-face "#f5eae5"))

(use-package swiper
  :ensure t
  :config
  ;; Does this work? I want swiper-mc to then call hydra-mc/body
  (delete 'swiper-mc mc/cmds-to-run-for-all)
  (add-to-list 'mc/cmds-to-run-once 'swiper-mc)
  (add-to-list 'mc/cmds-to-run-once 'swiper-mc-custom)
  :bind
  (("C-f" . swiper)
   ("C-S-f" . swiper-all)
   :map swiper-map
   ("M-l" . swiper-avy)
   ("C-;" . swiper-mc-custom)
   :map swiper-all-map
   ("M-l" . swiper-avy)
   ("C-;" . swiper-mc-custom)))

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode 1)

  (setq undo-tree-auto-save-history t)
  (setq undo-tree-enable-undo-in-region t)
  (setq undo-tree-visualizer-diff t)

  (setq undo-tree-history-dir
	(let ((dir (concat user-emacs-directory
                           "undo-tree-history/")))
          (make-directory dir :parents) dir))
  (setq undo-tree-history-directory-alist `(("." . , undo-tree-history-dir)))

  (add-hook 'write-file-functions #'undo-tree-save-history-hook)
  (add-hook 'find-file-hook #'undo-tree-load-history-hook))

(use-package vlf
  :ensure t
  :config
  (require 'vlf-setup)
  (eval-after-load "vlf"
    '(define-key vlf-prefix-map (kbd "C-x C-v") vlf-mode-map)))

(use-package zzz-to-char
  :ensure t
  :config
  (setq zzz-to-char-reach 800)
  :bind
  (("M-z" . zzz-to-char)))

;; Set custom functions
(defun yank-pop-reverse ()
  "Invoke 'yank-pop' with -1 argument."
  (interactive)
  (yank-pop -1))

;; https://www.emacswiki.org/emacs/DuplicateStartOfLineOrRegion
(defun duplicate-line-or-region ()
  "Duplicate region if region is marked, otherwise duplicate line."
  (interactive)
  (if mark-active
      (duplicate-region)
    (if (string-match-p "^[[:space:]]*$" (buffer-substring (line-beginning-position) (line-end-position)))
	(copy-from-above-command)
      (duplicate-line))))

(defun duplicate-line ()
  "Duplicate line."
  (let ((text (buffer-substring (line-beginning-position)
                                (line-end-position))))
    (forward-line)
    (push-mark)
    (insert text)
    (open-line 1)))

(defun duplicate-region ()
  "Duplicate region if region is marked."
  (let* ((end (region-end))
         (text (buffer-substring (region-beginning)
                                 end)))
    (goto-char end)
    (insert text)
    (push-mark end)
    (setq deactivate-mark nil)
    (exchange-point-and-mark)))

(defun indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (indent-buffer)
        (message "Indented buffer.")))))

;; https://www.emacswiki.org/emacs/AutoIndentation
(defun yank-and-indent ()
  "Yank and then indent the newly formed region according to mode."
  (interactive)
  (yank)
  (call-interactively 'indent-region))

(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))

(defun parenthesize-to-beginning-of-line ()
  "Select current position to beginning of line as region and insert parentheses."
  (interactive)
  (insert ")")
  (set-mark (point))
  (beginning-of-line)
  (insert "(")
  (exchange-point-and-mark))

(defun parenthesize-to-end-of-line ()
  "Select current position to end of line as region and insert parentheses."
  (interactive)
  (insert "(")
  (set-mark (point))
  (end-of-line)
  (insert ")")
  (exchange-point-and-mark))

(defun parenthesize-end-of-line ()
  "Insert parentheses at end of line."
  (interactive)
  (set-mark (point))
  (end-of-line)
  (insert ")")
  (exchange-point-and-mark))

(defun double-quotes-to-end-of-line ()
  "Select current position to end of line as region and insert double quotes."
  (interactive)
  (insert "\"")
  (set-mark (point))
  (end-of-line)
  (insert "\"")
  (exchange-point-and-mark))

(defun single-quotes-to-end-of-line ()
  "Select current position to end of line as region and insert single quotes."
  (interactive)
  (insert "'")
  (set-mark (point))
  (end-of-line)
  (insert "'")
  (exchange-point-and-mark))

(defun square-brackets-to-end-of-line ()
  "Select current position to end of line as region and insert square brackets."
  (interactive)
  (insert "[")
  (set-mark (point))
  (end-of-line)
  (insert "]")
  (exchange-point-and-mark))

(defun angular-brackets-to-end-of-line ()
  "Select current position to end of line as region and insert angular brackets."
  (interactive)
  (insert "<")
  (set-mark (point))
  (end-of-line)
  (insert ">")
  (exchange-point-and-mark))

(defun custom-delete ()
  "Delete with custom (more complex) behavior.  See function body for more information."
  (interactive)
  (if mark-active
      ;; If region is active,
      ;; then delete region
      (if (eq (line-number-at-pos (region-beginning)) (line-number-at-pos (region-end)))
	  ;; If region contained in single line,
	  ;; then sp-delete-region
	  (sp-delete-region (region-beginning) (region-end))
	;; If region contained in multiple lines,
	;; then regular delete-region
	(delete-region (region-beginning) (region-end)))
    (if (or
	 (sp--looking-back (sp--get-opening-regexp (sp--get-pair-list-context 'navigate)))
	 (sp--looking-back (sp--get-closing-regexp (sp--get-pair-list-context 'navigate))))
	;; If point is after opening or closing pair,
	;; then delete opening and closing pair.
	(sp-backward-unwrap-sexp)
      (if (sp-point-in-blank-line)
	  ;; If current line is empty or only whitespace characters,
	  ;; then delete consecutive empty surrounding lines if they exist,
	  ;; otherwise delete current line.
	  (delete-blank-lines)
	(if (string-match-p "[^[:space:]]+" (buffer-substring (line-beginning-position) (point)))
	    ;; If line up to point contains at least one non-whitespace character,
	    ;; then delete non-whitespace character previous to point if it exists,
	    ;; otherwise hungrily delete whitespace characters backward
	    (hungry-delete-backward 1)
	  (let ((original-line (string-to-number (format-mode-line "%l")))
		(original-column (string-to-number (format-mode-line "%c"))))
	    (forward-line -1)
	    (if (string-match-p "^[[:space:]]*$" (buffer-substring (line-beginning-position) (line-end-position)))
		;; If line up to point is empty or only whitespace characters and previous line, Line P, is empty,
		;; then delete consecutive empty lines previous to Line P if they exist,
		;; otherwise delete Line P
		(progn
		  (goto-char (point-max))
		  (let ((original-number-of-lines (string-to-number (format-mode-line "%l"))))
		    (goto-char (point-min))
		    (forward-line (- original-line 2))
		    (delete-blank-lines)
		    (goto-char (point-max))
		    (let ((new-number-of-lines (string-to-number (format-mode-line "%l"))))
		      (goto-char (point-min))
		      (forward-line (- original-line (- original-number-of-lines new-number-of-lines) 1))
		      (right-char original-column))))
	      ;; If line up to point is empty or only whitespace characters and previous line is non-empty,
	      ;; then hungrily delete whitespace characters backward
	      (goto-char (point-min))
	      (forward-line (- original-line 1))
	      (right-char original-column)
	      (hungry-delete-backward 1))))))))

(defun call-hydra-mark ()
  "Call 'push-mark-command' then 'hydra-mark/body'."
  (interactive)
  (push-mark-command (point))
  (hydra-mark/body))

;; https://www.emacswiki.org/emacs/CopyingWholeLines
(defun copy-lines (arg)
  "Copy whole lines.  If region is active, copy its whole lines (even if whole line is not in region).  Otherwise, copy ARG lines.  If last command was copy-lines, append lines."
  (interactive "p")
  (let ((beg (line-beginning-position))
	(end (line-end-position arg)))
    (when mark-active
      (if (> (point) (mark))
	  (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
	(setq end (save-excursion (goto-char (mark)) (line-end-position)))))
    (if (eq last-command 'copy-lines)
	(kill-append (buffer-substring beg end) (< end beg))
      (kill-ring-save beg end)))
  (kill-append "\n" nil)
  (beginning-of-line (or (and arg (1+ arg)) 2))
  (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))

(defun custom-mc-select-next ()
  "Multiple cursors with custom behavior."
  (interactive)
  (when mark-active
    (mc/mark-next-like-this 1)
    (mc/cycle-forward)))

(defun custom-mc-select-previous ()
  "Multiple cursors with custom behavior."
  (interactive)
  (when mark-active
    (mc/mark-previous-like-this 1)
    (mc/cycle-backward)))

(defun swiper-input ()
  "Either word at point or empty string if no symbol at point."
  (interactive)
  (if (symbol-at-point)
      (format "%s" (sexp-at-point))
    ""))

(defun swiper-mc-custom ()
  "Call swiper-mc then hydra-mc/body."
  (interactive)
  (hydra-mc/body)
  (swiper-mc))

;; http://emacsredux.com/blog/2013/04/21/edit-files-as-root/
(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;; https://unix.stackexchange.com/questions/48289/emacs-m-x-query-replace-wrap-around-the-document
(defadvice query-replace
    (around replace-wrap
	    (FROM-STRING TO-STRING &optional DELIMITED START END))
  "Execute 'query-replace', wrapping to the top of the buffer after you reach the bottom."
  (save-excursion
    (let ((start (point)))
      ad-do-it
      (beginning-of-buffer)
      (ad-set-args 4 (list (point-min) start))
      ad-do-it)))

;; Set non-package keybindings
;; Set overriding non-package keybindings
(bind-keys*
 ((kbd "C-q") . scroll-down-command)
 ((kbd "C-S-q") . switch-to-prev-buffer)
 ;; Check why behavior is "reversed" in some contexts
 ((kbd "C-M-q") . sp-beginning-of-sexp)
 ((kbd "C-e") . scroll-up-command)
 ((kbd "C-S-e") . switch-to-next-buffer)
 ((kbd "C-M-e") . sp-end-of-sexp)
 ((kbd "M-v") . yank-pop)
 ((kbd "C-M-v") . yank-pop-reverse)
 ((kbd "M-f") . goto-line)
 ((kbd "C-z") . undo)
 ((kbd "C-S-z") . undo-tree-redo)
 ((kbd "M-c") . comment-dwim)
 ((kbd "M-r") . query-replace-regexp)
 ((kbd "C-x <tab>") . indent-region-or-buffer)
 ;; ((kbd "C-;") . (lambda() (interactive) (if (not mark-active) (er/mark-word)) (mc/mark-all-like-this) (hydra-mc/body)))
 ((kbd "C-(") . parenthesize-to-beginning-of-line)
 ((kbd "C-)") . parenthesize-to-end-of-line)
 ((kbd "M-)") . parenthesize-end-of-line)
 ((kbd "C-\"") . double-quotes-to-end-of-line)
 ((kbd "C-'") . single-quotes-to-end-of-line)
 ((kbd "C-]") . square-brackets-to-end-of-line)
 ((kbd "C->") . angular-brackets-to-end-of-line)
 ((kbd "C-k") . kill-line)
 ((kbd "<C-S-escape>") . server-force-delete)
 ;; ((kbd "C-x C-f") . helm-find-files)
 ((kbd "C-x C-f") . counsel-find-file)
 ((kbd "C-x b") . ivy-switch-buffer)
 ((kbd "C-x r") . rename-buffer)
 ((kbd "C-x C-r") . rename-file-and-buffer)
 ((kbd "C-x d") . kill-this-buffer)
 ((kbd "C-x C-M-d") . delete-file-and-buffer)
 ((kbd "C-x C-S-w") . split-window-vertically)
 ((kbd "C-x C-S-s") . split-window-below)
 ((kbd "C-x C-S-a") . split-window-horizontally)
 ((kbd "C-x C-S-d") . split-window-right)
 ((kbd "C-x C-S-f") . delete-other-windows)
 ((kbd "C-c C-v") . yank-and-indent)
 ((kbd "C-c C-d") . duplicate-line-or-region)
 ((kbd "C-c C-r") . counsel-yank-pop)
 ((kbd "C-c C-c") . hydra-cargo/body))

;; Set non-overriding non-package keybindings
(global-set-key (kbd "M-w") 'previous-line)
(global-set-key (kbd "M-s") 'next-line)
(global-set-key (kbd "M-a") 'left-char)
(global-set-key (kbd "M-d") 'right-char)
(global-set-key (kbd "<up>") 'previous-line-message)
(global-set-key (kbd "<down>") 'next-line-message)
(global-set-key (kbd "<left>") 'left-char-message)
(global-set-key (kbd "<right>") 'right-char-message)
(global-set-key (kbd "C-w") 'beginning-of-buffer)
(global-set-key (kbd "C-s") 'end-of-buffer)
(global-set-key (kbd "C-S-w") (lambda() (interactive) (windmove-up)))
(global-set-key (kbd "C-S-s") (lambda() (interactive) (windmove-down)))
(global-set-key (kbd "C-S-a") (lambda() (interactive) (windmove-left)))
(global-set-key (kbd "C-S-d") (lambda() (interactive) (windmove-right)))
(global-set-key (kbd "C-S-k") 'kill-whole-line)
(global-set-key (kbd "C-r") 'query-replace)
(global-set-key (kbd "C-SPC") 'call-hydra-mark)
(global-set-key (kbd "<C-backspace>") 'hungry-delete-backward)
(global-set-key (kbd "<backspace>") 'custom-delete)
(global-set-key (kbd "C-f") (lambda () (interactive) (swiper (swiper-input))))
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "C-o") 'hydra-org/body)
(global-set-key (kbd "C-M-a") 'beginning-of-line)
(global-set-key (kbd "C-M-d") 'end-of-line)
(global-set-key (kbd "C-M-r") 'repeat-complex-command)
(global-set-key (kbd "C-l") 'copy-lines)
(global-set-key (kbd "<C-up>") 'upcase-dwim)
(global-set-key (kbd "<C-down>") 'downcase-dwim)
(global-set-key (kbd "M-DEL") 'backward-delete-char)
(global-set-key (kbd "C-M-S-e") 'eval-region)
(global-set-key (kbd "C-M-S-t") 'toggle-truncate-lines)

(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(defun minibuffer-setup-avoid-gc-hook ()
  "Extend garbage collection threshold when loading buffer."
  (setq gc-cons-threshold most-positive-fixnum))

(defun minibuffer-exit-restore-gc-hook ()
  "Restore garbage collection threshold once done loading buffer."
  (setq gc-cons-threshold 800000))
(add-hook 'minibuffer-setup-hook #'minibuffer-setup-avoid-gc-hook)
(add-hook 'minibuffer-exit-hook #'minibuffer-exit-restore-gc-hook)

;; Load theme
;; Not working on Mac?
(add-hook 'after-init-hook (lambda () (load-theme 'spacemacs-dark t)))

;; Enable emacsclient
(server-start)

(provide 'init)
;;; init.el ends here
