;; dot emacs from Julien Danjou <julien@danjou.info>
;; Written since 2009!

;; Expand load-path
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/el-get/el-get") ; Load el-get
(add-to-list 'load-path "~/.emacs.d/el-get/org-mode/contrib/lisp") ; org-contrib
(add-to-list 'load-path "~/.emacs.d/mu/mu4e") ; mu4e
(require 'mu4e)

;; Generate autoloads
(let ((generated-autoload-file "~/.emacs.d/jd-autoloads.el"))
  (update-directory-autoloads "~/.emacs.d")
  (load generated-autoload-file)
  (let ((buf (get-file-buffer generated-autoload-file)))
    (when buf (kill-buffer buf))))

;; Each file named <somelibrary>.pre.conf.el is loaded right now, e.g.
;; before the library is loaded. This should really not be needed, but some
;; libraries are badly designed and need this until I have the time to fix
;; them.
(dolist (file (directory-files user-emacs-directory))
  (when (string-match (format "^\\(.+\\)\\.preload\\.el$") file)
    (load (concat user-emacs-directory file))))

;; Each file named <somelibrary>.conf.el is loaded just after the library is
;; loaded.
(dolist (file (directory-files user-emacs-directory))
  (when (string-match (format "^\\(.+\\)\\.conf\\.el$") file)
    (eval-after-load (match-string-no-properties 1 file)
      `(load ,(concat user-emacs-directory file)))))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Require el-get to install packages
(require 'el-get-bootstrap)

(require 'jd-keybindings)
(require 'jd-daemon)
(require 'jd-coding)
(require 'ob)
(require 'org-crypt)
(require 'org-habit)
(require 'org-plot)
(require 'naquadah-theme)
(require 'saveplace)
(require 'uniquify)
(require 'mmm-auto)
(require 'sws-mode)
(require 'jade-mode)

;;(require 'google-contacts-message)
;;(require 'google-contacts-gnus)

;; C source code
(setq frame-title-format '("" invocation-name ": %b"))
(tool-bar-mode -1)			; Kill the toolbar
(menu-bar-mode -1)                      ; Kill the menu bar
(setq scroll-step 1)
(setq visible-bell t)
(setq-default fill-column 76)
(setq user-full-name "Niv Sardi")
(defalias 'yes-or-no-p 'y-or-n-p)
(set-default 'indicate-buffer-boundaries '((up . nil) (down . nil) (t . left)))
(setq next-screen-context-lines 5)      ; I want to keep more lines when
                                        ; switching pages
(setq use-dialog-box nil)               ; Seriously…
(setq source-directory "~/Work/src/emacs")
(put 'narrow-to-region 'disabled nil)
(set-default 'indent-tabs-mode nil)    ; always use spaces to indent, no tab

(display-time-mode 1)
(global-hi-lock-mode 1)                 ; highlight stuff
(savehist-mode 1)
(blink-cursor-mode 0)			; no blink!
(delete-selection-mode 1)		; Transient mark can delete/replace
(set-scroll-bar-mode 'right)		; Scrollbar on the right
(scroll-bar-mode -1)			; But no scrollbar
(line-number-mode 1)			; Show line number
(column-number-mode 1)			; Show colum number
(global-hl-line-mode 1)			; Highlight the current line
(windmove-default-keybindings)	      ; Move between frames with Shift+arrow
(show-paren-mode t)
(url-handler-mode 1)                    ; Allow to open URL
(mouse-avoidance-mode 'animate)         ; Move the mouse away
(ffap-bindings)                         ; Use ffap

;;(iswitchb-mode 1)
(ido-mode 'both)                            ; Interactively Do Things
(global-set-key "" 'ido-find-file)
(smex-initialize)			; ido for M-x

(browse-kill-ring-default-keybindings)
(which-func-mode 1)

(org-crypt-use-before-save-magic)

(package-initialize)

