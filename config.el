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

(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))

;; Shows the battery in modeline
;; (display-battery-mode)
;; (use-package! doom-modeline
;;   :custom
;;   (setq doom-modeline-battery t)
;;   ;; (setq doom-modeline-mu4e nil)
;;   )

(use-package! projectile
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '(("~/Projects")
                                           ("~/Documents")))))

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

(use-package! which-key
  :config
  (setq which-key-idle-delay 0.25))

(use-package! company
  :config
  (setq company-idle-delay 0.0)
  (setq company-minimum-prefix-length 1))

(use-package! rustic
  :config
  (setq rustic-format-on-save t))

(use-package! mu4e
  :config
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

(use-package! smudge
  :commands (smudge-command-map)
  ;; Store our passwords securely in "pass".
  :config (setq smudge-oauth2-client-secret (password-store-get "spotify/client-secret"))
  (setq smudge-oauth2-client-id (password-store-get "spotify/client-id"))
  ;; Set the default device to be Spotifyd
  (setq smudge-selected-device-id "ab40c540246d409abe2555e7cf1622992992ea60")
  )

(defhydra hydra-spotify (:hint nil)
  "
  ^Search^                  ^Control^               ^Manage^
  ^^^^^^^^-----------------------------------------------------------------
  _t_: Track               _SPC_: Play/Pause        _+_: Volume up
  _m_: My Playlists        _n_  : Next Track        _-_: Volume down
  _f_: Featured Playlists  _p_  : Previous Track    _x_: Mute
  _u_: User Playlists      _r_  : Repeat            _d_: Device
  ^^                       _s_  : Shuffle           _q_: Quit
  "
  ("t" smudge-track-search :exit t)
  ("m" smudge-my-playlists :exit t)
  ("f" smudge-featured-playlists :exit t)
  ("u" smudge-user-playlists :exit t)
  ("SPC" smudge-controller-toggle-play :exit nil)
  ("n" smudge-controller-next-track :exit nil)
  ("p" smudge-controller-previous-track :exit nil)
  ("r" smudge-controller-toggle-repeat :exit nil)
  ("s" smudge-controller-toggle-shuffle :exit nil)
  ("+" smudge-controller-volume-up :exit nil)
  ("-" smudge-controller-volume-down :exit nil)
  ("x" smudge-controller-volume-mute-unmute :exit nil)
  ("d" smudge-select-device :exit nil)
  ("q" quit-window "quit" :color blue))
(map! :leader :desc "Spotify" "os" #'hydra-spotify/body)
