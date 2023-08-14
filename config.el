(setq scroll-margin 10)
(setq display-line-numbers-type 'relative)
(pixel-scroll-mode)

;; Make it so scroll margin is unset in popup buffers
(setq-hook! '(+popup-mode-hook +popup-buffer-mode-hook) scroll-margin 0)

(map! :i "C-j" #'next-line)
(map! :i "C-k" #'previous-line)
(map! :i "C-h" #'left-char)
(map! :i "C-l" #'right-char)

(evil-collection-init 'mu4e)

(map! :leader :desc "Calculator" "oc" #'calc)

(setq doom-theme 'modus-vivendi)

(set-frame-parameter nil 'alpha-background 70)
(add-to-list 'default-frame-alist '(alpha-background . 70))

(use-package! projectile
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects"))))

(set-popup-rules!
  '(("\*godot - .+\*")
    ("\*cargo-.+\*" :size 0.20) ;; Set the rest of the rustic-related buffers
    ("\*rustfmt\*")
    ("\*Async Shell Command\*")
    ))

(use-package! org
  :config
  (setq org-link-abbrev-alist
        '(("spellwiki" . "http://dnd5e.wikidot.com/spell:")))
  (setq org-startup-folded t))

(use-package! org-roam
  :after org
  :commands (org-roam-node-insert org-roam-node-find org-roam-capture)
  :config
  (setq org-roam-directory (file-truename "~/org-roam"))
  (org-roam-db-autosync-mode)
  )

(map! :leader :prefix "r"
     :desc "Node Insert" "i" #'org-roam-node-insert
     :desc "Node Find" "f" #'org-roam-node-find
     :desc "Node Capture" "c" #'org-roam-capture)

(use-package! all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

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
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")

  ;; Configure the function to be used for sending mail
  (setq message-send-mail-function 'smtpmail-send-it)

  (setq mu4e-contexts
        (list
         ;; Personal Account
         (make-mu4e-context
          :name "Professional"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/Gmail" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "georgenpadron@gmail.com")
                  (user-full-name . "George N Padron")
                  (smtpmail-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type . ssl)
                  (mu4e-drafts-folder . "/Gmail/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/Gmail/[Gmail]/Sent Mail")
                  (mu4e-refile-folder . "/Gmail/[Gmail]/All Mail")
                  (mu4e-trash-folder . "/Gmail/[Gmail]/Trash")
                  (mu4e-maildir-shortcuts .
                                          (("/Gmail/Inbox" . ?i)
                                           ("/Gmail/[Gmail]/Sent Mail" . ?s)
                                           ("/Gmail/[Gmail]/Trash" . ?t)
                                           ("/Gmail/[Gmail]/Drafts" . ?d)
                                           ("/Gmail/[Gmail]/All Mail" . ?a)))
                  ))

         ;; Wealth Account
         (make-mu4e-context
          :name "Wealth"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/Wealth" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "wealth2005@gmail.com")
                  (user-full-name . "George N Padron")
                  (smtpmail-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type . ssl)
                  (mu4e-drafts-folder . "/Wealth/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/Wealth/[Gmail]/Sent Mail")
                  (mu4e-refile-folder . "/Wealth/[Gmail]/All Mail")
                  (mu4e-trash-folder . "/Wealth/[Gmail]/Trash")
                  (mu4e-maildir-shortcuts .
                                          (("/Wealth/Inbox" . ?i)
                                           ("/Wealth/[Gmail]/Sent Mail" . ?s)
                                           ("/Wealth/[Gmail]/Trash" . ?t)
                                           ("/Wealth/[Gmail]/Drafts" . ?d)
                                           ("/Wealth/[Gmail]/All Mail" . ?a)))
                  ))
         ;; Vanderbilt Account
         (make-mu4e-context
          :name "Vanderbilt"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/Vanderbilt" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "george.n.padron@vanderbilt.edu")
                  (user-full-name . "George N Padron")
                  (smtpmail-smtp-server . "smtp.gmail.com")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type . ssl)
                  (mu4e-drafts-folder . "/Vanderbilt/[Gmail]/Drafts")
                  (mu4e-sent-folder . "/Vanderbilt/[Gmail]/Sent Mail")
                  (mu4e-refile-folder . "/Vanderbilt/[Gmail]/All Mail")
                  (mu4e-trash-folder . "/Vanderbilt/[Gmail]/Trash")
                  (mu4e-maildir-shortcuts .
                                          (("/Vanderbilt/Inbox" . ?i)
                                           ("/Vanderbilt/[Gmail]/Sent Mail" . ?s)
                                           ("/Vanderbilt/[Gmail]/Trash" . ?t)
                                           ("/Vanderbilt/[Gmail]/Drafts" . ?d)
                                           ("/Vanderbilt/[Gmail]/All Mail" . ?a)))
                  ))
         ))
  )

(defun yay-update ()
    "Run the Yay shell command to automatically update the system on arch"
    (interactive)
    (with-editor-async-shell-command "yay -Syu"))

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
