;;; black background
;;; (disable-theme 'wombat)
;; (load-theme 'wombat t)
;;; change theme
;;; M-x package-install monokai-theme


(setq frame-title-format "emacs")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

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

;;; add repositories to be able to install packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/")
	     t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/")
	     t)

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

(require-package 'ace-jump-mode)
(global-set-key (kbd "C->") 'ace-jump-mode)

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
(global-set-key (kbd "C-}") 'mc/mark-next-like-this)
(global-set-key (kbd "C-{") 'mc/mark-previous-like-this)

;;; Modify the mode-line at the bottom of the screen.
(require-package 'powerline)
(powerline-vim-theme)
(setq powerline-default-separator 'wave)

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
(desktop-save-mode t)
(setq auto-save-default t)










(provide 'init)
