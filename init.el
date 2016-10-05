;;; black background
;;; (disable-theme 'wombat)
;; (load-theme 'wombat t)
;;; change theme
;;; M-x package-install monokai-theme


(setq frame-title-format "emacs")
(global-set-key (kbd "C-x C-b") 'ibuffer) 

(menu-bar-mode t)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(desktop-save-mode t)
(setq auto-save-default t)

;;; display a horizontal bar cursor 
(set-default 'cursor-type 'hollow)

;;; C-x C-f hint
(ido-mode)

;;; show column number
(column-number-mode)
(line-number-mode)
(global-linum-mode)

;;; highlight matching parenthesis
(show-paren-mode)

;;; highlight current line
(global-hl-line-mode -1)

;;; winner-undo/redo
(winner-mode t)

;;; Keybindings are of the form MODIFIER-{left,right,up,down}.
;;; Default MODIFIER is 'shift.
(windmove-default-keybindings)

;;;*******************************************************************
;;; Max window size when start emacs.
;;;*******************************************************************
(defun my-max-window()
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
			 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
			 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  )
(run-with-idle-timer 1 nil 'my-max-window)
;;;*******************************************************************
;;;*******************************************************************
;;;*******************************************************************

;;;************************************************************
;;; Begin install plugin **************************************
;;;************************************************************

;;; add repositories to be able to install packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/")
	     t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/")
	     t)
(add-to-list 'package-archives
	     '("melpa-stable" . "http://melpa.org/packages/"))


(package-initialize)
;; On-demand installation of packages
(defun require-package (package &optional min-version no-refresh)
  "Ask elpa to install given PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(require-package 'monokai-theme)
(require-package 'auto-complete)
;;; ''' M-x complete
(require-package 'smex)
(load-theme 'monokai t)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(ac-config-default)

(require-package 'nlinum)
(nlinum-mode)

(require-package 'autopair)
(autopair-global-mode)

(require-package 'undo-tree)
(global-undo-tree-mode)
(global-set-key (kbd "M-/") 'undo-tree-visualize)

(require-package 'switch-window)
(global-set-key (kbd "C-M-z") 'switch-window)



(require-package 'alpha)
(require 'alpha)
(global-set-key (kbd "C-M-)") 'transparency-increase)
(global-set-key (kbd "C-M-(") 'transparency-decrease)

;;; The text now will change color when it exceeds a certain character
;;; limit.
(require-package 'column-enforce-mode)
(column-enforce-mode)
(global-column-enforce-mode)
(setq column-enforce-column 70)

;;; See a minimap at the side of the screen.
(require-package 'minimap)

(require-package 'multiple-cursors)
(global-set-key (kbd "C-M-}") 'mc/mark-next-like-this)
(global-set-key (kbd "C-M-{") 'mc/mark-previous-like-this)

;;; Modify the mode-line at the bottom of the screen.
(require-package 'powerline)
(powerline-vim-theme)
(setq powerline-default-separator 'wave)

;;; vertical show the ido candidate
(require-package 'ido-vertical-mode)
(ido-vertical-mode)

;;;------------------------------------------------------------
;;; save your current opened buffer nad window layout, 
;;;auto-restore next time
(require-package 'revive)
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe Emacs" t)
					;And define favorite keys to those functions.  Here is a sample.
(define-key ctl-x-map "S" 'save-current-configuration)
(define-key ctl-x-map "F" 'resume)
(define-key ctl-x-map "K" 'wipe)
					;[Sample Operations]
					;C-u 2 C-x S		;save status into the buffer #2
					;C-u 3 C-x F		;load status from the buffer #3
;;;------------------------------------------------------------
(require-package 'yasnippet)
(yas-global-mode t)
;;;------------------------------------------------------------
;; (require-package 'helm)
(require-package 'find-file-in-project)
(global-set-key (kbd "<f6>") 'find-file-in-project)
;; Usage,
;; - `M-x find-file-in-project-by-selected' use the selected region
;; as the keyword to search file.  Or you need provide the keyword
;; if no region selected.
;; - `M-x find-directory-in-project-by-selected' use the select region
;; to find directory.  Or you need provide the keyword if no region
;; selected.
;; - `M-x find-file-in-project' will start search file immediately
;; - `M-x ffip-create-project-file' create .dir-locals.el
;;;------------------------------------------------------------
(require-package 'hydra)
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))
;;;------------------------------------------------------------
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
;;;------------------------------------------------------------
(require-package 'avy)
(global-set-key (kbd "C->") 'avy-goto-word-or-subword-1)
;;;------------------------------------------------------------
(require-package 'writeroom-mode)
;;;------------------------------------------------------------
(require-package 'ibuffer-vc)
(add-hook 'ibuffer-hook
	  (lambda ()
	    (ibuffer-vc-set-filter-groups-by-vc-root)
	    (unless (eq ibuffer-sorting-mode 'alphabetic)
	      (ibuffer-do-sort-by-alphabetic))))
;;;------------------------------------------------------------
(require-package 'flx-ido)
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
;;;------------------------------------------------------------
;; swap buffers' posotion
(require-package 'buffer-move)
;;;------------------------------------------------------------
(require-package 'multi-term)
(global-set-key (kbd "<f8>") 'multi-term)
;;;------------------------------------------------------------






;;;************************************************************
;;; End install plugin **************************************
;;;************************************************************





(provide 'init)
