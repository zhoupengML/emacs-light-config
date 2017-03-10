

;;; black background
;;; (disable-theme 'wombat)
;; (load-theme 'wombat t)
;;; change theme
;;; M-x package-install monokai-theme


;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

;;  ___   _   ___ ___ ___    ___ ___  _  _ ___ ___ ___
;; | _ ) /_\ / __|_ _/ __|  / __/ _ \| \| | __|_ _/ __|
;; | _ \/ _ \\__ \| | (__  | (_| (_) | .` | _| | | (_ |
;; |___/_/ \_\___/___\___|  \___\___/|_|\_|_| |___\___|

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

;;; Hightlight *.cu file 
(setq auto-mode-alist (append
                  '(("\\.cu$" . c++-mode))
                    auto-mode-alist))
;;; Open yas-minor-mode when open an .py file
(add-hook 'python-mode (lambda ()
			 (yas-minor-mode t)))
;;; Doxymacs doxygen
(add-hook 'c-mode-common-hook 'doxymacs-mode)

;;  __  __  __      __
;; |  \/  | \ \    / /
;; | |\/| |  \ \/\/ /
;; |_|  |_|   \_/\_/
;;; Copy current line without selection
(defun xah-copy-line-or-region ()
  "Copy current line, or text selection.
When called repeatedly, append copy subsequent lines.
When `universal-argument' is called first, copy whole buffer (respects `narrow-to-region').

URL `http://ergoemacs.org/emacs/emacs_copy_cut_current_line.html'
Version 2016-06-18"
  (interactive)
  (let (-p1 -p2)
    (if current-prefix-arg
        (setq -p1 (point-min) -p2 (point-max))
      (if (use-region-p)
          (setq -p1 (region-beginning) -p2 (region-end))
        (setq -p1 (line-beginning-position) -p2 (line-end-position))))
    (if (eq last-command this-command)
        (progn
          (progn ; hack. exit if there's no more next line
            (end-of-line)
            (forward-char)
            (backward-char))
          ;; (push-mark (point) "NOMSG" "ACTIVATE")
          (kill-append "\n" nil)
          (kill-append (buffer-substring-no-properties (line-beginning-position) (line-end-position)) nil)
          (message "Line copy appended"))
      (progn
        (kill-ring-save -p1 -p2)
        (if current-prefix-arg
            (message "Buffer text copied")
          (message "Text copied"))))
    (end-of-line)
    (forward-char)
    ))
(global-set-key (kbd "M-w") 'xah-copy-line-or-region)
;;;------------------------------------------------------------
;;; 
(require 'dired)
;; (define-key dired-mode-map
;;   (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map
  (kbd "^") ( lambda ()
  (interactive) (find-alternate-file "..")))
;;;------------------------------------------------------------

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

;;;************************************************************
;;; Begin install plugin **************************************
;;;************************************************************
;;  ___ _   _   _  ___ ___ _  _
;; | _ \ | | | | |/ __|_ _| \| |
;; |  _/ |_| |_| | (_ || || .` |
;; |_| |____\___/ \___|___|_|\_|

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
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;  __  __  ___  _  _  ___  _  __   _   ___
;; |  \/  |/ _ \| \| |/ _ \| |/ /  /_\ |_ _|
;; | |\/| | (_) | .` | (_) | ' <  / _ \ | |
;; |_|  |_|\___/|_|\_|\___/|_|\_\/_/ \_\___|

(require-package 'monokai-theme)
(load-theme 'monokai t)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;  ___ __  __ _____  __
;; / __|  \/  | __\ \/ /
;; \__ \ |\/| | _| >  <
;; |___/_|  |_|___/_/\_\

;;; M-x complete
(require-package 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;; (require-package 'auto-complete)
;; (ac-config-default)
;;   ___ ___  __  __ ___  _   _  ___   __
;;  / __/ _ \|  \/  | _ \/_\ | \| \ \ / /
;; | (_| (_) | |\/| |  _/ _ \| .` |\ V /
;;  \___\___/|_|  |_|_|/_/ \_\_|\_| |_|

;;; company
(require-package 'company)
;; (global-company-mode)
(add-hook 'after-init-hook #'global-company-mode)

;;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;;;  flycheck-ycmd
(require-package 'flycheck-ycmd)
(require 'flycheck-ycmd) 		
(flycheck-ycmd-setup)
;; __   _____ __  __ ___
;; \ \ / / __|  \/  |   \
;;  \ V / (__| |\/| | |) |
;;   |_| \___|_|  |_|___/

;;; ycmd
(require-package 'ycmd)
(require 'ycmd)				; ycmd-parse-conditions
(add-hook 'after-init-hook #'global-ycmd-mode)

(set-variable 'ycmd-server-command
              '("python" "/home/shhs/usr/soft/ycmd/ycmd"))
(set-variable 'ycmd-global-config "/home/shhs/.ycm_extra_conf.py")
(set-variable 'ycmd-extra-conf-whitelist '("please add project .ycm_extra_conf.py"))
;;; company-ycmd 
(require-package 'company-ycmd)
(require 'company-ycmd)
(company-ycmd-setup)

(global-set-key [(f12)] 'ycmd-goto-definition)
(global-set-key [(S-f12)] 'ycmd-goto-declaration)

;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(require-package 'nlinum)
(nlinum-mode)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;    _  _   _ _____ ___  ___  _   ___ ___
;;   /_\| | | |_   _/ _ \| _ \/_\ |_ _| _ \
;;  / _ \ |_| | | || (_) |  _/ _ \ | ||   /
;; /_/ \_\___/  |_| \___/|_|/_/ \_\___|_|_\

(require-package 'autopair)
(autopair-global-mode)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;  _   _ _  _ ___   ___    _____ ___ ___ ___
;; | | | | \| |   \ / _ \  |_   _| _ \ __| __|
;; | |_| | .` | |) | (_) |   | | |   / _|| _|
;;  \___/|_|\_|___/ \___/    |_| |_|_\___|___|

(require-package 'undo-tree)
(global-undo-tree-mode)
(global-set-key (kbd "M-/") 'undo-tree-visualize)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;  _____      _____ _____ ___ _  _  __      _____ _  _
;; / __\ \    / /_ _|_   _/ __| || | \ \    / /_ _| \| |
;; \__ \\ \/\/ / | |  | || (__| __ |  \ \/\/ / | || .` |
;; |___/ \_/\_/ |___| |_| \___|_||_|   \_/\_/ |___|_|\_|

;; (require-package 'switch-window)
;; (global-set-key (kbd "C-M-z") 'switch-window)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;    _   _    ___ _  _   _
;;   /_\ | |  | _ \ || | /_\
;;  / _ \| |__|  _/ __ |/ _ \
;; /_/ \_\____|_| |_||_/_/ \_\

(require-package 'alpha)
(require 'alpha)
(global-set-key (kbd "C-M-)") 'transparency-increase)
(global-set-key (kbd "C-M-(") 'transparency-decrease)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;   ___ ___  _   _   _ __  __ _  _   __  __  ___  ___  ___
;;  / __/ _ \| | | | | |  \/  | \| | |  \/  |/ _ \|   \| __|
;; | (_| (_) | |_| |_| | |\/| | .` | | |\/| | (_) | |) | _|
;;  \___\___/|____\___/|_|  |_|_|\_| |_|  |_|\___/|___/|___|

;;; The text now will change color when it exceeds a certain character
;;; limit.
;; (require-package 'column-enforce-mode)
;; (column-enforce-mode)
;; (global-column-enforce-mode)
;; (setq column-enforce-column 90)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;  __  __ ___ _  _ ___ __  __   _   ___
;; |  \/  |_ _| \| |_ _|  \/  | /_\ | _ \
;; | |\/| || || .` || || |\/| |/ _ \|  _/
;; |_|  |_|___|_|\_|___|_|  |_/_/ \_\_|

;;; See a minimap at the side of the screen.
(require-package 'minimap)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;  __  __ _   _ _  _____ ___    ___ _   _ ___  ___  ___  ___
;; |  \/  | | | | ||_   _|_ _|  / __| | | | _ \/ __|/ _ \| _ \
;; | |\/| | |_| | |__| |  | |  | (__| |_| |   /\__ \ (_) |   /
;; |_|  |_|\___/|____|_| |___|  \___|\___/|_|_\|___/\___/|_|_\

(require-package 'multiple-cursors)
(global-set-key (kbd "C-M-}") 'mc/mark-next-like-this)
(global-set-key (kbd "C-M-{") 'mc/mark-previous-like-this)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;  ___  _____      _____ ___ _    ___ _  _ ___
;; | _ \/ _ \ \    / / __| _ \ |  |_ _| \| | __|
;; |  _/ (_) \ \/\/ /| _||   / |__ | || .` | _|
;; |_|  \___/ \_/\_/ |___|_|_\____|___|_|\_|___|

;;; Modify the mode-line at the bottom of the screen.
(require-package 'powerline)
(powerline-vim-theme)
(setq powerline-default-separator 'wave)
;;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;  ___ ___   ___   __   _____ ___ _____ ___ ___   _   _
;; |_ _|   \ / _ \  \ \ / / __| _ \_   _|_ _/ __| /_\ | |
;;  | || |) | (_) |  \ V /| _||   / | |  | | (__ / _ \| |__
;; |___|___/ \___/    \_/ |___|_|_\ |_| |___\___/_/ \_\____|

;;; vertical show the ido candidate
(require-package 'ido-vertical-mode)
(ido-vertical-mode)
;;;------------------------------------------------------------
;;  ___ _____   _______   _____
;; | _ \ __\ \ / /_ _\ \ / / __|
;; |   / _| \ V / | | \ V /| _|
;; |_|_\___| \_/ |___| \_/ |___|

;;; save your current opened buffer nad window layout, 
;;;auto-restore next time
(require-package 'revive)
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe Emacs" t)
;And define favorite keys to those functions.  Here is a sample.
(global-set-key (kbd "C-x S") 'save-current-configuration)
(define-key ctl-x-map "F" 'resume)
(define-key ctl-x-map "K" 'wipe)
;[Sample Operations]
;C-u 2 C-x S		;save status into the buffer #2
;C-u 3 C-x F		;load status from the buffer #3
;;;------------------------------------------------------------
;; __   ___   ___ _  _ ___ ___ ___ ___ _____
;; \ \ / /_\ / __| \| |_ _| _ \ _ \ __|_   _|
;;  \ V / _ \\__ \ .` || ||  _/  _/ _|  | |
;;   |_/_/ \_\___/_|\_|___|_| |_| |___| |_|

(require-package 'yasnippet)
(yas-global-mode t)
;;;------------------------------------------------------------
;;  ___ ___ _  _ ___    ___ ___ _    ___
;; | __|_ _| \| |   \  | __|_ _| |  | __|
;; | _| | || .` | |) | | _| | || |__| _|
;; |_| |___|_|\_|___/  |_| |___|____|___|

;; (require-package 'helm)
(require-package 'find-file-in-project)
(global-set-key (kbd "<f7>") 'find-file-in-project)
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
;;  _  ___   _____  ___    _
;; | || \ \ / /   \| _ \  /_\
;; | __ |\ V /| |) |   / / _ \
;; |_||_| |_| |___/|_|_\/_/ \_\

(require-package 'hydra)
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))
;;;------------------------------------------------------------
;;    ___   ____   __
;;   /_\ \ / /\ \ / /
;;  / _ \ V /  \ V /
;; /_/ \_\_/    |_|

(require-package 'avy)
(global-set-key (kbd "C->") 'avy-goto-word-or-subword-1)
;;;------------------------------------------------------------
;; __      _____ ___ _____ ___   __  __  ___  ___  ___
;; \ \    / / _ \_ _|_   _| __| |  \/  |/ _ \|   \| __|
;;  \ \/\/ /|   /| |  | | | _|  | |\/| | (_) | |) | _|
;;   \_/\_/ |_|_\___| |_| |___| |_|  |_|\___/|___/|___|

(require-package 'writeroom-mode)
;;;------------------------------------------------------------
;;  ___ ___ _   _ ___ ___ ___ ___  __   _____
;; |_ _| _ ) | | | __| __| __| _ \ \ \ / / __|
;;  | || _ \ |_| | _|| _|| _||   /  \ V / (__
;; |___|___/\___/|_| |_| |___|_|_\   \_/ \___|

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
;;  ___ _   _ ___ ___ ___ ___   __  __  _____   _____
;; | _ ) | | | __| __| __| _ \ |  \/  |/ _ \ \ / / __|
;; | _ \ |_| | _|| _|| _||   / | |\/| | (_) \ V /| _|
;; |___/\___/|_| |_| |___|_|_\ |_|  |_|\___/ \_/ |___|

;; swap buffers' posotion
(require-package 'buffer-move)
;;;------------------------------------------------------------
;;  __  __ _   _ _  _____ ___   _____ ___ ___ __  __
;; |  \/  | | | | ||_   _|_ _| |_   _| __| _ \  \/  |
;; | |\/| | |_| | |__| |  | |    | | | _||   / |\/| |
;; |_|  |_|\___/|____|_| |___|   |_| |___|_|_\_|  |_|

(require-package 'multi-term)
;; Close yasnippet in term-mode aim to use tab complete
(add-hook 'term-mode-hook (lambda()
        (setq yas-dont-activate t)))
(setq multi-term-program "/bin/bash")
(global-set-key (kbd "<f8>") 'multi-term)
;;;------------------------------------------------------------
;;    _  _   _  ___ _____ _____  __
;;   /_\| | | |/ __|_   _| __\ \/ /
;;  / _ \ |_| | (__  | | | _| >  <
;; /_/ \_\___/ \___| |_| |___/_/\_\

;; Let emacs load auctex
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook
(lambda()
(add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
(setq TeX-command-default "XeLaTeX")))

(setq TeX-output-view-style (quote (("^pdf$" "." "evince %o %(outpage)"))))
;; set the size of formula in org-mode
(require 'org)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

;; org to pdf support Chinese
;; (setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
;; 			      "xelatex -interaction nonstopmode %f"))
;; (setq org-latex-default-packages-alist 
;; (remove '("AUTO" "inputenc" t) org-latex-default-packages-alist))

;;;------------------------------------------------------------
;;   ___ _____ ___
;;  / __|_   _|   \
;; | (_ | | | | |) |
;;  \___| |_| |___/

;;; GTD 日程管理
(global-set-key (kbd "C-c c")  'remember)
;; GTD 收集项目的模板设置 
(org-remember-insinuate)
(setq org-directory "~/usr/notes/GTD")

(setq org-remember-templates '(
("Task" ?t "** TODO %? %t\n %i\n" (concat org-directory "/inbox.org") "Tasks")
("Book" ?b "** %? %t\n %i\n" (concat org-directory "/inbox.org") "Book")
("Calendar" ?c "** %? %t\n %i\n " (concat org-directory "/inbox.org") "Calender")
("Project" ?p "** %? %t\n %i\n " (concat org-directory "/inbox.org") "Project")
("Idea" ?i "** %? %t\n %i\n " (concat org-directory "/inbox.org") "Idea")))
(setq org-default-notes-file (concat org-directory "/inbox.org"))
;;设置TODO关键字
(setq org-todo-keywords
      (list "TODO(t)" "|" "CANCELED(c)" "DONE(d)"))
;; 将项目转接在各文件之间，方便清理和回顾。
(custom-set-variables
'(org-refile-targets
  (quote
   (("inbox.org" :level . 1)("canceled.org" :level . 1) ("finished.org":level . 1))
)))
;; 快速打开inbox
(defun inbox() (interactive) (find-file org-default-notes-file))
(global-set-key "\C-cz" 'inbox)

;; 快速启动 agenda-view
(setq org-agenda-span 30)
(setq org-agenda-start-day "-5d") 
(define-key global-map "\C-ca" 'org-agenda-list)
(setq org-agenda-window-setup 'current-window)

(define-key global-map "\C-ct" 'org-todo-list)
(define-key global-map "\C-cm" 'org-tags-view)
;; Set org-agenda files
(setq org-agenda-files
(list (concat org-directory "/inbox.org")
      (concat org-directory "/canceled.org")
      (concat org-directory "/finished.org")
))
;;;------------------------------------------------------------
;;; markdown
;; (require-package 'markdown-mode)
;;; Open org to makedown transformation 
;; (eval-after-load "org"
;;   '(require 'ox-md nil t))

;;;------------------------------------------------------------
;;  ___ ___ ___ _    ___ _____
;; | __|_ _/ __| |  | __|_   _|
;; | _| | | (_ | |__| _|  | |
;; |_| |___\___|____|___| |_|
;;; Insert asic picture
;; sudo apt-get install figlet
;;Have a look at `figlet-comment', `figlet-figletify-region' and
;;`figlet-figletify-region-comment'.
(require-package 'figlet)

;;;------------------------------------------------------------
;; __      _____ _  _ ___   _____      __
;; \ \    / /_ _| \| |   \ / _ \ \    / /
;;  \ \/\/ / | || .` | |) | (_) \ \/\/ /
;;   \_/\_/ |___|_|\_|___/ \___/ \_/\_/

(require-package 'window-numbering)
(window-numbering-mode)
;;;------------------------------------------------------------

;;;************************************************************
;;; End install plugin **************************************
;;;************************************************************


(provide 'init)
;;;
;;;

(put 'dired-find-alternate-file 'disabled nil)
