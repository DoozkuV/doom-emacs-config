(setq scroll-margin 10)
(setq display-line-numbers-type 'relative)
(setq inhibit-x-resources t)
(pixel-scroll-mode)

;; Make it so scroll margin is unset in popup buffers
(setq-hook! '(+popup-mode-hook +popup-buffer-mode-hook) scroll-margin 0)

(map! :i "C-j" #'next-line)
(map! :i "C-k" #'previous-line)
(map! :i "C-h" #'left-char)
(map! :i "C-l" #'right-char)

(map! :leader :desc "Calculator" "oc" #'calc)

(setq doom-theme 'doom-gruvbox)

(defvar gp/background-opacity 75
  "The default opacity of the background when the transparency
  mode is toggled on."
  )

  ;;;###autoload
(define-minor-mode gp/opacity-mode
  "Enables background frame opacity"
  :lighter " op"
  :global t
  (if gp/opacity-mode
      ;; Turn on opacity by setting the alpha value of the current
      ;; and all future frames
      (progn
        (set-frame-parameter nil 'alpha-background gp/background-opacity)
        (add-to-list 'default-frame-alist `(alpha-background . ,gp/background-opacity))
        )
    ;; Turn off the opacity otherwise
    (set-frame-parameter nil 'alpha-background 100)
    (assq-delete-all 'alpha-background default-frame-alist)
    ))

(provide 'gp/opacity-mode)
;; Automatically enable transparency at launch
(gp/opacity-mode)

(map! :leader :desc "Opacity Mode" "oo" #'gp/opacity-mode)

;; (use-package! projectile
;;   :init
;;   (when (file-directory-p "~/Projects")
;;     (setq projectile-project-search-path '(("~/Projects")
;;                                            ("~/Documents")))))

(set-popup-rules!
  '(("\*godot - .+\*")
    ("\*cargo-.+\*" :size 0.20) ;; Set the rest of the rustic-related buffers
    ("\*rustfmt\*")
    ("\*Async Shell Command\*")
    ))

(after! org
  ;; Set up some abbreviations for org-mode links
  (setq org-link-abbrev-alist
        '(("spellwiki" . "http://dnd5e.wikidot.com/spell:")))
  (setq org-startup-folded t)

  (setq org-directory "~/Documents/org")
  ;; Org Roam config
  (setq org-roam-directory "~/Documents/org/roam/"))

(after! which-key
  (setq which-key-idle-delay 0.25))

(after! company
  (setq company-idle-delay 0.0)
  (setq company-minimum-prefix-length 1))

(after! rustic
  (setq rustic-format-on-save t))

(after! mu4e
  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-use-maildirs-extension nil)

  ;; Referesh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mailsync")
  (setq mu4e-maildir "~/.local/share/mail")

  ;; Configure mail sending to use msmtp
  (setq sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail)

  (setq mu4e-contexts
        (list
         ;; Personal Account
         (make-mu4e-context
          :name "Professional"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/georgenpadron@gmail.com" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "georgenpadron@gmail.com")
                  (user-full-name . "George N Padron")
                  ;; (smtpmail-smtp-server . "smtp.gmail.com")
                  ;; (smtpmail-smtp-service . 465)
                  ;; (smtpmail-stream-type . ssl)
                  (mu4e-drafts-folder . "/georgenpadron@gmail.com/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/georgenpadron@gmail.com/[Gmail]/Sent")
                  (mu4e-refile-folder . "/georgenpadron@gmail.com/[Gmail]/All Mail")
                  (mu4e-trash-folder . "/georgenpadron@gmail.com/[Gmail]/Trash")
                  (mu4e-maildir-shortcuts .
                                          (("/georgenpadron@gmail.com/INBOX" . ?i)
                                           ("/georgenpadron@gmail.com/[Gmail]/Sent Mail" . ?s)
                                           ("/georgenpadron@gmail.com/[Gmail]/Trash" . ?t)
                                           ("/georgenpadron@gmail.com/[Gmail]/Drafts" . ?d)
                                           ("/georgenpadron@gmail.com/[Gmail]/All Mail" . ?a)))
                  ))

         ;; Wealth Account
         (make-mu4e-context
          :name "Wealth"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/wealth2005@gmail.com" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "wealth2005@gmail.com")
                  (user-full-name . "George N Padron")
                  ;; (smtpmail-smtp-server . "smtp.gmail.com")
                  ;; (smtpmail-smtp-service . 465)
                  ;; (smtpmail-stream-type . ssl)
                  (mu4e-drafts-folder . "/wealth2005@gmail.com/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/wealth2005@gmail.com/[Gmail]/Sent Mail")
                  (mu4e-refile-folder . "/wealth2005@gmail.com/[Gmail]/All Mail")
                  (mu4e-trash-folder . "/wealth2005@gmail.com/[Gmail]/Trash")
                  (mu4e-maildir-shortcuts .
                                          (("/wealth2005@gmail.com/INBOX" . ?i)
                                           ("/wealth2005@gmail.com/[Gmail]/Sent Mail" . ?s)
                                           ("/wealth2005@gmail.com/[Gmail]/Trash" . ?t)
                                           ("/wealth2005@gmail.com/[Gmail]/Drafts" . ?d)
                                           ("/wealth2005@gmail.com/[Gmail]/All Mail" . ?a)))
                  ))
         ;; george.n.padron@vanderbilt.edu Account
         (make-mu4e-context
          :name "Vanderbilt"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/george.n.padron@vanderbilt.edu" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "george.n.padron@vanderbilt.edu")
                  (user-full-name . "George N Padron")
                  (smtpmail-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type . ssl)
                  (mu4e-drafts-folder . "/george.n.padron@vanderbilt.edu/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/george.n.padron@vanderbilt.edu/[Gmail]/Sent Mail")
                  (mu4e-refile-folder . "/george.n.padron@vanderbilt.edu/[Gmail]/All Mail")
                  (mu4e-trash-folder . "/george.n.padron@vanderbilt.edu/[Gmail]/Trash")
                  (mu4e-maildir-shortcuts .
                                          (("/george.n.padron@vanderbilt.edu/INBOX" . ?i)
                                           ("/george.n.padron@vanderbilt.edu/[Gmail]/Sent Mail" . ?s)
                                           ("/george.n.padron@vanderbilt.edu/[Gmail]/Trash" . ?t)
                                           ("/george.n.padron@vanderbilt.edu/[Gmail]/Drafts" . ?d)
                                           ("/george.n.padron@vanderbilt.edu/[Gmail]/All Mail" . ?a)))
                  ))
         ))
  )

(defun yay-update ()
    "Run the Yay shell command to automatically update the system on arch"
    (interactive)
    (async-shell-command "yay -Syu"))

(map! :leader :desc "Update System" "C-u" #'yay-update)

(use-package zoxide
  :commands
  (zoxide-find-file zoxide-find-file-with-query zoxide-travel zoxide-travel-with-query
                    zoxide-cd zoxide-cd-with-query zoxide-add zoxide-remove zoxide-query
                    zoxide-query-with zoxide-open-with)
  :config
  (add-hook 'find-file-hook 'zoxide-add))

  (map! :leader :desc "Zoxide Find File" "z" #'zoxide-find-file)
  (map! :leader :desc "Zoxide Find File" "Z" #'zoxide-travel)
