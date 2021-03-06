(require 'xa-email)
;; Check for new mail
(require 'gnus-demon)
;; Move spam into spam
(require 'spam)
;; Pretty gnus
(require 'xa-gnus-faces)

;; gnus
(setq gnus-select-method '(nnnil ""))
(setq gnus-novice-user nil)             ; I AM NOT!
(setq gnus-spam-process-destinations
      '(("." "spam")))
(setq gnus-agent nil)                   ; No agent
(setq gnus-summary-line-format
      (concat "%z%U%R %~(max-right 17)~(pad-right 17)&user-date;  "
              "%~(max-right 20)~(pad-right 20)f %B%s\n"))
(setq gnus-message-archive-group "sent")
;; Expire
(setq gnus-total-expirable-newsgroups
      (concat "^\\("
              (mapconcat 'identity
                         '("lists\\."
                           "spam$"
                           "INBOX\\.naquadah\\.adm$")
                         "\\|")
              "\\)"))

(setq gnus-parameters
      '(("^lists\\."
         (subscribed . t)
         (gnus-message-archive-group . "sent"))
        ("^lists\\.ding"
         (to-list . "ding@gnus.org"))
        ("^lists\\.launchpad\\.\\(.+\\)"
         (to-list . "\\1@lists.launchpad.net")
         (list-identifier . "\\\\[\\1\\\\]")
         (banner . "_______________________________________________
Mailing list: https://launchpad.net/~\\1
Post to     : \\1@lists.launchpad.net
Unsubscribe : https://launchpad.net/~\\1
More help   : https://help.launchpad.net/ListHelp"))
        ("^lists\\.debian\\.\\(.+\\)"
         (to-list . "debian-\\1@lists.debian.org"))
        ("^lists\\.freedesktop\\.\\(.+\\)"
         (list-identifier . "\\\\[\\1\\\\]")
         (banner
          .
          "_______________________________________________
\\1 mailing list
\\1@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/\\1"))
        ("^lists\\.ornix\\.\\(.+\\)"
         (to-list . "\\1@ornix.org"))
        ("^lists\\.\\(muse-el-.*\\)"
         (to-list . "\\1@gna.org"))
        ("^lists\\.camlistore"
         (to-list . "camlistore@googlegroups.com"))
        ("^lists\\.gnu\\.\\(.+\\)"
         (to-list . "\\1@gnu.org"))
        ("^lists\\.el-get-devel"
         (to-list . "el-get-devel@tapoueh.org"))
        ("^lists\\.debconf\\.\\(.+\\)"
         (list-identifier . "\\\\[\\1\\\\]")
         (banner . "_______________________________________________
\\1 mailing list
\\1@lists.debconf.org
http://lists.debconf.org/mailman/listinfo/\\1"))
        ("^lists\\.openstack\\.\\(.+\\)"
         (to-list . "\\1@lists.openstack.org")
         (list-identifier . "\\\\[\\1\\\\]")
         (banner . "_______________________________________________
\\1 mailing list
\\1@lists.openstack.org
http://lists.openstack.org/cgi-bin/mailman/listinfo/\\1"))
        ("^lists\\.debian\\.alioth\\.\\(.+\\)"
         (to-list . "\\1@lists.alioth.debian.org")
         (list-identifier . "\\\\[\\1\\\\]")
         (banner . "_______________________________________________
\\1 mailing list
\\1@lists.alioth.debian.org
http://lists.alioth.debian.org/mailman/listinfo/\\1"))
        ("^INBOX"
         (gcc-self . t))))

;; gnus-start
(setq gnus-subscribe-newsgroup-method 'gnus-subscribe-alphabetically)
;; Do not save .newsrc, we do not use a newsreader
(setq gnus-save-newsrc-file nil)
(setq gnus-read-newsrc-file nil)
(setq gnus-always-read-dribble-file t)

;; gnus-group
;; Redefine this to nil because I pressed it by mistake too many times
(define-key gnus-group-mode-map (kbd "M-c") nil)
(setq gnus-group-default-list-level (- gnus-level-subscribed 2))
(setq gnus-group-sort-function '(gnus-group-sort-by-alphabet
                                 gnus-group-sort-by-level))

(defun jd:gnus-image-or-space (string image image-p)
  (let ((image (create-image image)))
    (if (display-images-p)
        (if image-p
            (propertize string 'display
                        (append image
                                '(:ascent center)))
          (propertize " " 'display `(space . (:width ,(car (image-size image))))))
      string)))

(defun gnus-user-format-function-e (dummy)
  (jd:gnus-image-or-space (char-to-string gnus-unread-mark) "~/.emacs.d/icons/email.png"
                          (> (string-to-number gnus-tmp-number-of-unread) 0)))

(defun gnus-user-format-function-M (dummy)
  (jd:gnus-image-or-space (char-to-string gnus-ticked-mark) "~/.emacs.d/icons/important.png"
                          (cdr (assq 'tick gnus-tmp-marked))))

(add-hook 'gnus-group-mode-hook
	  (lambda ()
	    (setq header-line-format "    Ticked    New     Unread   Group" )))

(setq gnus-group-line-format "%ue%uM %1(%1{%6i %}%)%{ %}%2(%2{%7U %}%)%{ %}%3(%3{%7y %}%)%{%* %}%4(%B%-45G%)\n")
;;(setq gnus-group-line-format "%ue%uM %S%p[%5t][%L]\t%P%5y:%B%(%g%)%O\n")

;; gnus-sum
(setq gnus-ignored-from-addresses (xa:email-addresses-regexp))
(setq gnus-thread-sort-functions '(gnus-thread-sort-by-number
                                   gnus-thread-sort-by-subject
                                   gnus-thread-sort-by-date
                                   gnus-thread-sort-by-total-score))
(setq gnus-auto-select-subject 'unread) ; Select unread article on group entering
(setq gnus-summary-stop-at-end-of-message t)
(setq gnus-summary-to-prefix "→"
      gnus-summary-newsgroup-prefix "⇶"
      ;; Marks
      gnus-ticked-mark ?⚑
      gnus-dormant-mark ?⚐
      gnus-expirable-mark ?♻
      gnus-read-mark ?✓
      gnus-del-mark ?✗
      gnus-killed-mark ?☠
      gnus-replied-mark ?⟲
      gnus-forwarded-mark ?⤳
      gnus-cached-mark ?☍
      gnus-recent-mark ?★
      gnus-unseen-mark ?✩
      gnus-unread-mark ?✉
      gnus-attach-mark ?⚓
      gnus-score-over-mark ?↑           ; ↑ ☀
      gnus-score-below-mark ?↓         ; ↓ ☂
      gnus-sum-thread-tree-false-root " ◌ "
      gnus-sum-thread-tree-single-indent "◎ "
      gnus-sum-thread-tree-indent "   "
      gnus-sum-thread-tree-root "● "
      gnus-sum-thread-tree-leaf-with-other "├─▶ "
      gnus-sum-thread-tree-single-leaf     "└─▶ " ; "╰─►"
      gnus-sum-thread-tree-vertical        "│ ")

;; gnus-msg
(setq gnus-gcc-mark-as-read t)
;; Automatically sign when sending mails
(add-hook 'gnus-message-setup-hook 'mml-secure-message-sign-pgpmime)
;; This is used when "posting"...
(setq gnus-mailing-list-groups "lists")

(setq gnus-posting-styles xa:posting-styles)

;; gnus-async
(setq gnus-use-header-prefetch t)       ; prefetch header for next group

;; gnus-art
(setq gnus-visible-headers
      (concat gnus-visible-headers "\\|^User-Agent:\\|^X-Mailer:"))
(setq gnus-sorted-header-list
      '("^From:" "^To:" "^Newsgroups:" "^Cc:" "^Subject:" "^Summary:" "^Keywords:" "^Followup-To:" "^Date:" "^Organization:"))
(setq gnus-face-properties-alist
      '((pbm . (:face gnus-x-face :ascent center))
        (png . (:ascent center))))
(setq gnus-treat-from-picon nil)
(setq gnus-treat-newsgroups-picon nil)
(setq gnus-treat-mail-picon nil)
(setq gnus-treat-from-gravatar 'head)
(setq gnus-treat-mail-gravatar 'head)
(setq gnus-treat-body-boundary nil)    ; No body/header separator
(add-hook 'gnus-article-prepare-hook 'egocentric-mode-on)
(add-to-list 'gnus-buttonized-mime-types "multipart/signed")
(setq gnus-blocked-images nil)          ; HTML rendering

;; gnus-gravatar
(setq gnus-gravatar-properties '(:ascent center))
(setq gnus-gravatar-too-ugly (xa:email-addresses-regexp))

;; nnheader
(setq gnus-nov-is-evil t)               ; No NOV

;; nnmail
(setq nnmail-expiry-wait 60)

;; gnus-score
(setq gnus-home-score-file "~/.gnus.score")

;; No cursor
(defun jd:no-cursor ()
  (setq cursor-type nil))
(add-hook 'gnus-summary-mode-hook 'jd:no-cursor)
(add-hook 'gnus-group-mode-hook 'jd:no-cursor)
