;; alias e29o='/Applications/Emacs29.3.app/Contents/MacOS/Emacs --init-directory ~/e29org --debug-init'
;; Instead of using ~/.emacs.d, I use e29org for this configuration. Adjust to fit your needs.
;; My bash resides in /opt/local. Adjust ptath to fit your needs.

(require 'package)
  (setq package-enable-at-startup nil)
  (setq package-archives '(("org"  . "http://orgmode.org/elpa/")
                          ("gnu"   . "http://elpa.gnu.org/packages/")
                          ("melpa" . "http://melpa.org/packages/")))
  (package-initialize)

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))
  (require 'use-package)
  (setq use-package-always-ensure t)
 
 
;; Customizations

;;;# garbage collection
(use-package gcmh
  :diminish gcmh-mode
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024))  ; 16mb
  (gcmh-mode 1))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-percentage 0.1))) ;; Default value for `gc-cons-percentage'

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(message "Finished garbage collection. Line 40.")

(message "Start settings section.")
;;;# save current init.el to ~/.saves
;; source https://www.reddit.com/r/emacs/comments/11ap924/the_most_important_snippet_in_my_emacs_init_file/
(setq
backup-by-copying t ; don't clobber symlinks
backup-directory-alist
'(("." . "~/.e29orgInitSaves")) ; don't litter my fs tree
delete-old-versions t
kept-new-versions 6
kept-old-versions 2
version-control t)


;; Export from org to latex
(setq org-latex-pdf-process
  '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))




;;; Basics Configuration
;;(setq openai-key "[]")
;;(setq openai-api-key "")


(setq inhibit-startup-message t) ;; hide the startup message
;; (load-theme 'material t) ;; load material theme
;; (global-linum-mode t) ;; enable line numbers globally
(set-default 'truncate-lines t) ;; do not wrap
(prefer-coding-system 'utf-8) ;; use UTF-8

;;load prefers the newest version of a file.
;; This applies when a filename suffix is not explicitly specified and load is trying various possible suffixes (see load-suffixes and load-file-rep-suffixes). Normally, it stops at the first file that exists unless you explicitly specify one or the other. If this option is non-nil, it checks all suffixes and uses whichever file is newest.
;; (setq load-prefer-newer t) --> causes RECURSIVE LOAD error

;;;# Zoom
(set-face-attribute 'default nil :height 128)

;;;# Save History
(savehist-mode +1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))


;;;# Size of the starting Window
(setq initial-frame-alist '((top . 1)
                (left . 450)
                (width . 101)
                (height . 90)))

;;;# Line wrap
(global-visual-line-mode +1)
(delete-selection-mode +1)
(save-place-mode +1)


;;;# set browser to open url in new tab
(custom-set-variables
  '(browse-url-browser-function (quote browse-url-firefox))
  '(browse-url-firefox-new-window-is-tab t))



;;;# Global keybindings

(global-set-key (kbd "C-h D") 'devdocs-lookup)


;;;# My elisp functions
;;;## reload-init
;; Inspried https://sachachua.com/dotemacs/index.html#org4dd39d0
(defun reload-init ()
  "Reload my init.el file. Edit the path to suite your needs."
  (interactive)
  (load-file "~/e29org/init.el"))

;; ;;;## reload-hydras
;; (defun reload-hydras ()
;;   "Reload my-hydras.el. Edit the path to suite your needs."
;;   (interactive)
;;   (load-file "~/emacs29.3/my-hydras/my-hydras.el"))

;; ;;;## reload-learning-spiral-hydras
;; (defun reload-learning-spiral-hydras ()
;;   "Reload learning-spiral-hydras.el. Edit the path to suite your needs."
;;   (interactive)
;;   (load-file "~/emacs29.3/my-hydras/learning-spiral-hydras.el"))

;; ;;;## reload-talon-quiz-hydras
;; ;;(defun reload-talon-quiz-hydras ()
;; ;;  "Reload learning-spiral-hydras.el. Edit the path to suite your needs."
;; ;;  (interactive)
;; ;;  (load-file "~/emacs29.3/my-hydras/talon-quiz-hydras.el"))

;; ;;;## reload-uniteai
;; (defun reload-uniteai ()
;;   "Reload my-uniteai.el. Edit the path to suite your needs."
;;   (interactive)
;;   (load-file "~/e29org/my-uniteai.el"))

;;;# Clean and sort list of items in region

(defun clean-sort-list-in-region (beg end)
  "Clean and sort the lines in the selected region.
   Removes duplicate lines, blank lines, and sort alphabetically.
   Built by Copilot"
  (interactive "r")
  (let ((lines (split-string (buffer-substring-no-properties beg end) "\n" t))
        (cleaned-lines nil))
    ;; Remove duplicates and blank lines
    (dolist (line lines)
      (when (and (not (string-blank-p line))
                 (not (member line cleaned-lines)))
        (push line cleaned-lines)))
    ;; Sort alphabetically
    (setq cleaned-lines (sort cleaned-lines #'string<))
    ;; Replace the region with the cleaned and sorted lines
    (delete-region beg end)
    (insert (mapconcat #'identity cleaned-lines "\n"))))
(global-set-key (kbd "C-c s") 'clean-sort-list-in-region)

;;# Shell configuration
(use-package exec-path-from-shell
  :init
  (setenv "SHELL" "/opt/local/bin/bash")
  :if (memq window-system '(mac ns x))
  :config
  (setq exec-path-from-shell-variables '("PATH" "GOPATH" "PYTHONPATH"))
  (exec-path-from-shell-initialize))
(message "Finished shell configuration. Line 480.")



;;;# Faked full screen
(use-package maxframe)
(defvar my-fullscreen-p t "Check if fullscreen is on or off")
(defun my-toggle-fullscreen ()
  (interactive)
  (setq my-fullscreen-p (not my-fullscreen-p))
  (if my-fullscreen-p
    (restore-frame)
    (maximize-frame)))
(global-set-key (kbd "M-S") 'toggle-frame-fullscreen) ;; conflicts with an auctex command to insert an \item in a list.
(message "Finished frame configuration. Line 493.")

;;;# Backups
(setq vc-make-backup-files t)

(setq version-control t ;; Use version numbers for backups.
        kept-new-versions 10 ;; Number of newest versions to keep.
        kept-old-versions 0 ;; Number of oldest versions to keep.
        delete-old-versions t ;; Don't ask to delete excess backup versions.
        backup-by-copying t) ;; Copy all files, don't rename them.

;; If you want to avoid 'backup-by-copying', you can instead use
;;
;; (setq backup-by-copying-when-linked t)
;;
;; but that makes the second, "per save" backup below not run, since
;; buffers with no backing file on disk are not backed up, and
;; renaming removes the backing file.  The "per session" backup will
;; happen in any case, you'll just have less consistent numbering of
;; per-save backups (i.e. only the second and subsequent save will
;; result in per-save backups).

;; If you want to avoid backing up some files, e.g. large files,
;; then try setting 'backup-enable-predicate'.  You'll want to
;; extend 'normal-backup-enable-predicate', which already avoids
;; things like backing up files in '/tmp'.
;;;#  Default and per-save backups go here:
(setq backup-directory-alist '(("" . "~/e29org/backup/per-save")))

(defun force-backup-of-buffer ()
   ;; Make a special "per session" backup at the first save of each
   ;; emacs session.
   (when (not buffer-backed-up)
     ;; Override the default parameters for per-session backups.
     (let ((backup-directory-alist '(("" . "~/e29org/backup/per-session")))
           (kept-new-versions 3))
       (backup-buffer)))
   ;; Make a "per save" backup on each save.  The first save results in
   ;; both a per-session and a per-save backup, to keep the numbering
   ;; of per-save backups consistent.
   (let ((buffer-backed-up nil))
     (backup-buffer)))
(add-hook 'before-save-hook  'force-backup-of-buffer)
(message "Finished force-backup-of-buffer configuration. Line 537.")

;;;# Do not move the current file while creating backup.
(setq backup-by-copying t)
(message "Backup configuration finished. Line 541.")

;;;# Disable lockfiles.
(setq create-lockfiles nil)

(message "Finished lockfile configuration. Line 235.")

(column-number-mode)

;;;# Show stray whitespace.
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;;;# Add a newline automatically at the end of a file while saving.
(setq-default require-final-newline t)

;;;# A single space follows the end of sentence.
(setq sentence-end-double-space nil)



;;;# open PDFs with default system viewer (usually Preview on a Mac)
;; source: http://stackoverflow.com/a/1253761/1325477https://emacs.stackexchange.com/questions/3105/how-to-use-an-external-program-as-the-default-way-to-open-pdfs-from-emacs

;; Remove "\\.pdf" to enable use of PDF tools


(defun mac-open (filename)
  (interactive "fFilename: ")
  (let ((process-connection-type))
    (start-process "" nil "open" (expand-file-name filename))))

(defun find-file-auto (orig-fun &rest args)
  (let ((filename (car args)))
    (if (cl-find-if
         (lambda (regexp) (string-match regexp filename))
         '( "\\.doc\\'" "\\.docx?\\'" "\\.xlsx?\\'" "\\.xlsm?\\'" "\\.pptx?\\'" "\\.itmz\\'"  "\\.png\\'"))
        (mac-open filename)
      (apply orig-fun args))))

(advice-add 'find-file :around 'find-file-auto)

(message "Finished find file configuration. Line 584.")

;; (global-set-key (kbd "C-c p") 'dpkg-menpdf


;;;# Turn on font-locking or syntax highlighting
(global-font-lock-mode t)

;;;# font size in the modeline
(set-face-attribute 'mode-line nil  :height 140)

;;;# set default coding of buffers
(setq default-buffer-file-coding-system 'utf-8-unix)

;; Switch from tabs to spaces for indentation
;; Set the indentation level to 4.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;;;# Indentation setting for various languages.
(setq c-basic-offset 4)
(setq js-indent-level 2)
(setq css-indent-offset 2)
(setq python-basic-offset 4)

(setq user-init-file "/Users/blaine/e29org/init.el")
(setq user-emacs-directory "/Users/blaine/e29org/")
;; (setq default-directory "/Users/blaine")
;; the directory that you start Emacs in should be the default for the current buffer
(setenv "HOME" "/Users/blaine")
;; (load user-init-file)


;;;# Write customizations to a separate file instead of this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)




;;;# Custom command.
(defun show-current-time ()
  "Show current time."
  (interactive)
  (message (current-time-string)))

;;;# Custom key sequences.
;; (global-set-key (kbd "C-c t") 'show-current-time)
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)


;;;# display line numbers. Need with s-l.
(global-display-line-numbers-mode)

;;;# hippie-expand M-/. Seems to be comflicting with Corfu, Cape, and dabrrev.
;; (global-set-key [remap dabbrev-expand]  'hippie-expand)


;;;# GUI related settings
(if (display-graphic-p)
    (progn
      ;; Removed some UI elements
      ;; (menu-bar-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      ;; Show battery status
      (display-battery-mode 1)))


;; Hey, stop being a whimp and learn the Emacs keybindings!
;; ;; Set copy+paste
;;  (cua-mode t)
;;     (setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
;;     (transient-mark-mode 1) ;; No region when it is not highlighted
;;     (setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;; REMOVE THE SCRATCH BUFFER AT STARTUP
;; Makes *scratch* empty.
;; (setq initial-scratch-message "")
;; Removes *scratch* from buffer after the mode has been set.
;; (defun remove-scratch-buffer ()
;;   (if (get-buffer "*scratch*")
;;       (kill-buffer "*scratch*")))
;; (add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)


;;;# Disable the C-z sleep/suspend key
;; See http://stackoverflow.com/questions/28202546/hitting-ctrl-z-in-emacs-freezes-everything
(global-unset-key (kbd "C-z"))

;; Disable the C-x C-b key, use helm (C-x b) instead
;; (global-unset-key (kbd "C-x C-b"))


;;;# Make copy and paste use the same clipboard as emacs.
(setq select-enable-primary t
      select-enable-clipboard t)


(setq display-time-default-load-average nil)
(setq display-time-day-and-date t display-time-24hr-format t)
(display-time-mode t)


;;;# dired-icon-mode
(use-package dired-icon
  :ensure t
  :config
  (add-hook 'dired-mode-hook 'dired-icon-mode))


;; Revert Dired and other buffers after changes to files in directories on disk.
;; Source: [[https://www.youtube.com/watch?v=51eSeqcaikM&list=PLEoMzSkcN8oNmd98m_6FoaJseUsa6QGm2&index=2][Dave Wilson]]
(setq global-auto-revert-non-file-buffers t)


;;;# customize powerline
;; (line above the command line at the bottom of the screen)
(use-package powerline)
(powerline-default-theme)


;;;# Add line numbers.
;; (global-nlinum-mode t)

;;;# highlight current line
(global-hl-line-mode +1)
(set-face-background hl-line-face "wheat1")
(set-face-attribute 'mode-line nil  :height 180)

;;;# List recently opened files.
;; Recent files
(recentf-mode 1)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;;;# UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)



;;;# Quickly access dot emacs d
(global-set-key (kbd "C-c e")
    (lambda()
      (interactive)
      (find-file "~/e29org/init.el")))


(set-face-attribute 'default nil :height 140)

(set-frame-parameter (selected-frame) 'buffer-predicate
                     (lambda (buf)
                       (let ((name (buffer-name buf)))
                         (not (or (string-prefix-p "*" name)
                                  (eq 'dired-mode (buffer-local-value 'major-mode buf)))))))


;;;# Global keys
;; If you use a window manager be careful of possible key binding clashes
(setq recenter-positions '(top middle bottom))
(global-set-key (kbd "C-1") 'kill-this-buffer)
(global-set-key (kbd "C-<down>") (kbd "C-u 1 C-v"))
(global-set-key (kbd "C-<up>") (kbd "C-u 1 M-v"))
(global-set-key [C-tab] 'other-window)
(global-set-key (kbd "C-c c") 'calendar)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-`") 'mode-line-other-buffer)
;; (global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-c r") 'remember)


(setq case-fold-search t)


;; Show the file path in the title of the frame
;; source https://stackoverflow.com/questions/2903426/display-path-of-file-in-status-bar See entry by mortnene
;; This is much more useful than just showing the file name or buffer name in the frame title.

(setq frame-title-format
      '(:eval
        (if buffer-file-name
            (replace-regexp-in-string
             "\\\\" "/"
             (replace-regexp-in-string
              (regexp-quote (getenv "HOME")) "e30: ~"
              (convert-standard-filename buffer-file-name)))
          (buffer-name))))


; ;; Source https://stackoverflow.com/questions/50222656/setting-emacs-frame-title-in-emacs
; (setq frame-title-format
;   (concat "%b - emacs@" (system-name)))
; (setq-default frame-title-format '("%f [%m]"))
; (setq frame-title-format "Main emacs29.3 config - %b " )




;;;# Browse URLS in text mode
(global-goto-address-mode +1)


;;;# Revert buffers when the underlying file has changed.
(global-auto-revert-mode 1)


;;;# Save history going back 25 commands.
;; Use M-p to get previous command used in the minibuffer.
;; Use M-n to move to next command.
(setq history-length 25)
(savehist-mode 1)


;;;# Save place in a file.
(save-place-mode 1)


;;;# sets monday to be the first day of the week in calendar
(setq calendar-week-start-day 1)

;;;# save emacs backups in a different directory
;; (some build-systems build automatically all files with a prefix, and .#something.someending breakes that)
(setq backup-directory-alist '(("." . "~/.emacsbackups")))


;;;# Enable show-paren-mode (to visualize paranthesis) and make it possible to delete things we have marked
(show-paren-mode 1)
(delete-selection-mode 1)


;;;# use y or n instead of yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

;;;# These settings enables using the same configuration file on multiple platforms.
;; Note that windows-nt includes [[https://www.gnu.org/software/emacs/manual/html_node/elisp/System-Environment.html][windows 10]].
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-a-linux* (eq system-type 'gnu/linux))
(defconst *is-windows* (eq system-type 'windows-nt))
(defconst *is-cygwin* (eq system-type 'cygwin))
(defconst *is-unix* (not *is-windows*))


;; ==> adjust here
;; See this [[http://ergoemacs.org/emacs/emacs_hyper_super_keys.html][ for more information.]]
;; set keys for Apple keyboard, for emacs in OS X
;; Source http://xahlee.info/emacs/emacs/emacs_hyper_super_keys.html
(setq mac-command-modifier 'meta) ; make cmd key do Meta
(setq mac-option-modifier 'super) ; make option key do Super.
(setq mac-control-modifier 'control) ; make Control key do Control
(setq mac-function-modifier 'hyper)  ; make Fn key do Hyper. Only works on Apple produced keyboards.
(setq mac-right-command-modifier 'hyper)



;;;# Copy selected region to kill ring and clipboard. Should use M-w for same functionality.
(define-key global-map (kbd "H-c") 'cua-copy-region)


;;;# Save the buffer. Should use C-x 0
;; (define-key global-map (kbd "s-s") 'save-buffer)


;;;# Switch to previous buffer
(define-key global-map (kbd "H-<left>") 'previous-buffer)
;;;# Switch to next buffer
(define-key global-map (kbd "H-<right>") 'next-buffer)


;;;# Minibuffer history keybindings
;; The calling up of a previously issued command in the minibuffer with ~M-p~ saves times.
(autoload 'edit-server-maybe-dehtmlize-buffer "edit-server-htmlize" "edit-server-htmlize" t)
(autoload 'edit-server-maybe-htmlize-buffer "edit-server-htmlize" "edit-server-htmlize" t)
(add-hook 'edit-server-start-hook 'edit-server-maybe-dehtmlize-buffer)
(add-hook 'edit-server-done-hook  'edit-server-maybe-htmlize-buffer)
(define-key minibuffer-local-map (kbd "M-p") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "M-n") 'next-complete-history-element)
(define-key minibuffer-local-map (kbd "<up>") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "<down>") 'next-complete-history-element)

;;;# switch-to-minibuffer
(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))

(global-set-key "\C-cm" 'switch-to-minibuffer) ;; Bind to `C-c m' for minibuffer.

;;;# Bibtex configuration
(defconst blaine/bib-libraries (list "/Users/blaine/Documents/global.bib"))

;;;# Combined with emacs-mac, this gives good PDF quality for [[https://www.aidanscannell.com/post/setting-up-an-emacs-playground-on-mac/][retina display]].
(setq pdf-view-use-scaling t)


;;;# PDF default page width behavior
(setq-default pdf-view-display-size 'fit-page)


;;;# Set delay in the matching parenthesis to zero.
(setq show-paren-delay 0)
(show-paren-mode t)

;;;# Window management
;; winner-mode C-c <rigth> undo change C-c <left> redo change
(winner-mode 1)

(defun split-vertical-evenly ()
  (interactive)
  (command-execute 'split-window-vertically)
  (command-execute 'balance-windows))
(global-set-key (kbd "C-x 2") 'split-vertical-evenly)


(defun split-horizontal-evenly ()
  (interactive)
  (command-execute 'split-window-horizontally)
  (command-execute 'balance-windows))
(global-set-key (kbd "C-x 3") 'split-horizontal-evenly)

(message "Starting config of packages--takes 5-60 seconds, depending on the operating system.")

;;;#  Zoom in and out via C-scroll wheel
;; (global-set-key [C-wheel-up] 'text-scale-increase)
;; (global-set-key [C-wheel-down] 'text-scale-decrease)

;;;# Control-scroll wheel to zoom in and out. Very Sweet!
(global-set-key [C-mouse-4] 'text-scale-increase)
(global-set-key [C-mouse-5] 'text-scale-decrease)


;;; Aliases
;; Source: https://www.youtube.com/watch?v=ufVldIrUOBg
;; Defalias: a quick guide to making an alias in Emacs
;; Usage: M-x ct

(defalias 'ct 'customize-themes)
(defalias 'cz 'customize)
(defalias 'ddl 'delete-duplicate-lines)
(defalias 'dga 'define-global-abbrev)
(defalias 'dma 'define-mode-abbrev)
(defalias 'ea 'edit-abbrevs)
(defalias 'ff 'flip-frame)
(defalias 'fl 'flush-lines)
(defalias 'fnd 'find-name-dired)
(defalias 'klm 'kill-matching-lines)
(defalias 'lc 'langtool-check)
(defalias 'lcu 'langtool-check-buffer)
(defalias 'lp 'list-packages)
(defalias 'pcr 'package-refresh-contents)
(defalias 'pi 'package-install)
(defalias 'pua 'package-upgrade-all)
(defalias 'qr 'query-replace)
(defalias 'rg 'rgrep)
(defalias 'rsv 'replace-smart-quotes)
(defalias 'sl 'sort-lines)
(defalias 'slo 'single-lines-only)
(defalias 'spe 'ispell-region)
(defalias 'udd 'package-upgrade-all)
(defalias 'ugg 'package-upgrade-all)
(defalias 'wr 'write-region)
(message "Finished global settings section.")


(message "Start package configurations C")
;;;# C
;;;## Corfu configuration
(use-package corfu
  :ensure t
  :init
  (setq tab-always-indent 'complete)
  (global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-echo-documentation t
        corfu-scroll-margin 0
        corfu-count 8
        corfu-max-width 50
        corfu-min-width corfu-max-width
        corfu-auto-prefix 2)

  (corfu-history-mode 1)
  (savehist-mode 1)
  (add-to-list 'savehist-additional-variables 'corfu-history)

  (defun corfu-enable-always-in-minibuffer ()
    (setq-local corfu-auto nil)
    (corfu-mode 1))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)
)
(message "SFinished corfu package configuration")

;;;## Cape Configuration
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;; kinda confusing re length, WIP/TODO
  ;; :hook (org-mode . (lambda () (add-to-list 'completion-at-point-functions #'cape-dabbrev)))
  ;; :config
  ;; (setq dabbrev-check-other-buffers nil
  ;;       dabbrev-check-all-buffers nil
  ;;       cape-dabbrev-min-length 6)
  )


;;;;;; Extra Completion Functions
(use-package consult
 :ensure t
 :after vertico
 :bind (("C-x b"       . consult-buffer)
        ("C-x C-k C-k" . consult-kmacro)
        ("C-x C-o"     . consult-outline)
        ("M-y"         . consult-yank-pop)
        ("M-g g"       . consult-goto-line)
        ("M-g M-g"     . consult-goto-line)
        ("M-g f"       . consult-flymake)
        ("M-g i"       . consult-imenu)
        ("M-s l"       . consult-line)
        ("M-s L"       . consult-line-multi)
        ("M-s u"       . consult-focus-lines)
        ("M-s g"       . consult-ripgrep)
        ("M-s M-g"     . consult-ripgrep)
        ("C-x C-SPC"   . consult-global-mark)
        ("C-x M-:"     . consult-complex-command)
;        ("C-c n"       . consult-org-agenda)
        ("C-c m"       . my/notegrep)
        :map help-map
        ("a" . consult-apropos)
        :map minibuffer-local-map
        ("M-r" . consult-history))
 :custom
 (completion-in-region-function #'consult-completion-in-region)
 :config
 (defun my/notegrep ()
   "Use interactive grepping to search my notes"
   (interactive)
   (consult-ripgrep org-directory))
 (recentf-mode t))
(use-package consult-dir
 :ensure t
 :bind (("C-x C-j" . consult-dir)
        ;; :map minibuffer-local-completion-map
        :map vertico-map
        ("C-x C-j" . consult-dir)))

(use-package consult-recoll
 :bind (("M-s r" . counsel-recoll)
        ("C-c I" . recoll-index))
 :init
 (setq consult-recoll-inline-snippets t)
 :config
 (defun recoll-index (&optional arg) (interactive)
   (start-process-shell-command "recollindex"
                                "*recoll-index-process*"
                                  "recollindex")))



(message "Start package configurations E")
;;;# E
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-." . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))




(message "Start package configurations G")
;;;# G
(use-package general)







(message "Start H packages configurations")
; ;;;#
;; major-mode-hydra
;; source https://github.com/jerrypnz/major-mode-hydra.el
(use-package major-mode-hydra
  :bind
  ("s-SPC" . major-mode-hydra))


(major-mode-hydra-define emacs-lisp-mode nil
  ("Eval"
   (("b" eval-buffer "buffer")
    ("e" eval-defun "defun")
    ("r" eval-region "region"))
   "REPL"
   (("I" ielm "ielm"))
   "Test"
   (("t" ert "prompt")
    ("T" (ert t) "all")
    ("F" (ert :failed) "failed"))
   "Doc"
   (("d" describe-foo-at-point "thing-at-pt")
    ("f" describe-function "function")
    ("v" describe-variable "variable")
    ("i" info-lookup-symbol "info lookup"))))

(message "Start I packages configurations")
;;*** ivy
(use-package counsel)
(use-package ivy
  :diminish ivy-mode
  :config
  (setq ivy-extra-directories nil) ;; Hides . and .. directories
  (setq ivy-initial-inputs-alist nil) ;; Removes the ^ in ivy searches
  ; (if (eq jib/computer 'laptop)
  ;     (setq-default ivy-height 10)
  ;   (setq-default ivy-height 11))
  (setq ivy-fixed-height-minibuffer t)
  (add-to-list 'ivy-height-alist '(counsel-M-x . 7)) ;; Don't need so many lines for M-x, I usually know what command I want

  ;;(ivy-mode 1)

  ;; Shows a preview of the face in counsel-describe-face
  (add-to-list 'ivy-format-functions-alist '(counsel-describe-face . counsel--faces-format-function))

  :general
  (general-define-key
   ;; Also put in ivy-switch-buffer-map b/c otherwise switch buffer map overrides and C-k kills buffers
   :keymaps '(ivy-minibuffer-map ivy-switch-buffer-map)
   "S-SPC" 'nil
   "C-SPC" 'ivy-restrict-to-matches ;; Default is S-SPC, changed this b/c sometimes I accidentally hit S-SPC
   ;; C-j and C-k to move up/down in Ivy
   "C-k" 'ivy-previous-line
   "C-j" 'ivy-next-line)
  )


;;;; Nice icons in Ivy. Replaces all-the-icons-ivy.
;;(use-package all-the-icons-ivy-rich
;;  :init (all-the-icons-ivy-rich-mode 1)
;;  :config
;;  (setq all-the-icons-ivy-rich-icon-size 1.0))

;;
(use-package ivy-rich
  :after ivy
  :init
  (setq ivy-rich-path-style 'abbrev)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
  :config
  (ivy-rich-mode 1))


(use-package ivy-bibtex
    :init
    (setq bibtex-completion-notes-path "/Users/blaine/org-roam/references/notes/"
        bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"
        bibtex-completion-additional-search-fields '(keywords)
        bibtex-completion-display-formats
        '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
          (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
          (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
        bibtex-completion-pdf-open-function
        (lambda (fpath)
          (call-process "open" nil 0 nil fpath)))
)

(message "Finishd I packages configurations")




(message "Started K packages configurations")
;;;## Kind-Icon Configuration
(use-package kind-icon
  :config
  (setq kind-icon-default-face 'corfu-default)
  (setq kind-icon-default-style '(:padding 0 :stroke 0 :margin 0 :radius 0 :height 0.9 :scale 1))
  (setq kind-icon-blend-frac 0.08)
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (add-hook 'counsel-load-theme #'(lambda () (interactive) (kind-icon-reset-cache)))
  (add-hook 'load-theme         #'(lambda () (interactive) (kind-icon-reset-cache))))



(message "Start package configurations M")
;;;# M
;;;## Marginalia Configuration
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))
(customize-set-variable 'marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
(marginalia-mode 1)


(message "Start package configurations O")
;;;# O

;; Optionally use the `orderless' completion style.
(use-package orderless
  :ensure t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))


;;;; Org configurations
;; org-ref
;; Set the case of the Author and Title to Capitalize with customize.
(use-package org-ref
     :init
    (use-package bibtex)
    (setq bibtex-autokey-year-length 4
          bibtex-autokey-name-year-separator ""
          bibtex-autokey-year-title-separator ""
          bibtex-autokey-titleword-separator ""
          bibtex-autokey-titlewords 9
          bibtex-autokey-titlewords-stretch 9
          bibtex-autokey-titleword-length 15)
    ;; H is the hyper key. I have bound H to Fn. For the MacAlly keyboard, it is bound to right-command.
    (define-key bibtex-mode-map (kbd "H-b") 'org-ref-bibtex-hydra/body)
;    (use-package org-ref-ivy)
    (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
                org-ref-insert-cite-function 'org-ref-cite-insert-ivy
                org-ref-insert-label-function 'org-ref-insert-label-link
                org-ref-insert-ref-function 'org-ref-insert-ref-link
                org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))
    ; (use-package org-ref-arxiv)
    ; (use-package org-ref-pubmed)
    ; (use-package org-ref-wos)
)


; (message "Start package configurations P")
; ;;;# P
; (use-package pdf-tools
;  :pin manual ;; manually update
;  :config
;  ;; initialise
;  (pdf-tools-install)
;  ;; open pdfs scaled to fit width
;  (setq-default pdf-view-display-size 'fit-width)
;  ;; use normal isearch
;  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
;  :custom
;  (pdf-annot-activate-created-annotations t "automatically annotate highlights"))
;
;
;
;
(message "Start package configurations V")
;;;# V
;;;## Vertico Configuration
(use-package vertico
  :ensure t
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :ensure t
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))


