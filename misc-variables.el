;; ============================
;; If this is any version of XEmacs except 19.13, do the following.
;; These are XEmacs only (compared to Emacs 21.3.50.6).
(if 
    (and
     (string-match "XEmacs" emacs-version) 
     (not
      (and
       (= emacs-major-version 19)
       (= emacs-minorc-version 13)
       )
      )
     )
    (progn
      (custom-set-variables
       '(gutter-buffers-tab-visible-p t)
       '(load-home-init-file t t)
       )
      ) ;; end of PROGN
  ) ;; end of IF

;; If this is any version of XEmacs, do the following.
;; These are XEmacs only (compared to Emacs 21.3.50.6).
(if 
    (string-match "XEmacs" emacs-version)
    (progn
      (require 'paren)
      (paren-set-mode 'blink-paren)
      (mwheel-install)
      )
  )

;; If this is Emacs (not XEmacs), do the following.
(if
    (not (string-match "XEmacs" emacs-version))
    (progn
      (message "This is Emacs!")
      )
  )

;; ============================
;; TAB setup:
;(setq lisp-body-indent 4)
;(setq lisp-indent-offset 0)
;(setq ksh-indent 4)
;(setq ksh-group-offset 0)
;(setq ksh-tab-always-indent nil)
;(setq cvlog-indent 4)
;(setq-default tab-width 4)
;(setq-default tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100))

;; ============================
;; Printing:
(setq ps-print-color-p nil)
(setq ps-lpr-command "lpr")

;; ============================
;; PERL:

; To allow the TAB key to insert tabs, as well as properly indent,
; set this to non-nil.  This is useful for lining up comments,
; but does mean you have to be at the beginning of a line for indenting to work.
(setq cperl-tab-always-indent t)

;; ============================
;; VBSCRIPT:
;; ============================
(autoload 'visual-basic-mode "visual-basic-mode" "Visual Basic mode." t)
(setq auto-mode-alist (append '(("\\.\\(vbs\\|frm\\|bas\\|cls\\)$" . visual-basic-mode)) auto-mode-alist))


;; ============================
;; SKILL and Allegro Scripts:
(setq auto-mode-alist (cons '("\\.il$" . lisp-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ilinit$" . lisp-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.scr$" . shell-script-mode) auto-mode-alist))

;; ============================
;; HTML and XML:

(setq auto-mode-alist (cons '("\\.rss$" . xml-mode) auto-mode-alist))

;; Settings for the hm--html-mode:
; (setq html-document-previewer "netscape_7.0")
; (setq hm--html-expert t)
(setq hm--html-automatic-changed-comment nil)
;; Use the "hm--html-mode" instead of any default html-mode (from the psgml package):
;(autoload 'html-mode "hm--html-mode" "HTML Mode (autoloaded by Jim)" t)
;(setq auto-mode-alist (cons '("\\.html$" . hm--html-mode) auto-mode-alist))

;; ============================
;; MISC:

; This should be on by default!
; Set this to allow you to overwrite the highlighted text just by typing
; or hitting DELETE/BACKSPACE (like any modern text editor).
(pending-delete-mode 1)

; Turn on line/column numbering:
(setq line-number-mode t)
(column-number-mode 1)
(put 'downcase-region 'disabled nil)

; Enable GnuClient (see http://www.emacswiki.org/emacs/GnuClient)
;(load "gnuserv")
;(gnuserv-start)
; Re-use existing frames.
;(setq gnuserv-frame (selected-frame))
;(setq gnuserv-frame (lambda (f) (eq f (quote x))))


; Print the date and/or time in the Modeline
;(setq display-time-day-and-date '1)	;; add Day/Date to display-time function
;(display-time)                      ;; turn on the modeline day/date/time

; This puts the full pathname in the window title area (doesn't work right in 19.11):
(setq frame-title-format "%S: %f")

; If you are using "fast" font-locking, this specifies where to keep
; the "cache" files that that function generates:
(setq fast-lock-cache-directories '("/tmp"))

;; Don't limit the size of buffers the will font-lock:
(setq font-lock-maximum-size nil)

;; To display a variable (usefule while debugging):
;(message "%s" pending-undo-list)

;; Set this to scroll lines one at a time, instead of a half-page at a time:
;(setq scroll-step 1)

;; Emacs (not XEmacs) seems to require you to explicitly enable
;; the upcase-region function.
(put 'upcase-region 'disabled nil)

;; Load the version control (VC) hooks
;(vc-load-vc-hooks)
(require 'vc)

;; This makes killing MUCH faster for slow connections (like VPN).
;; I also need to try setting x-selection-strict-motif-ownership to nil (see Help).
(if (eq system-type 'usg-unix-v)
    ;; This only works on UNIX and causes a real problem on Windows (so skip it).
    (unless (eq (aref (device-connection) 0) ?:)
      ;; We're running over a "remote" link (I don't understand how that above line works)
      (setq interprogram-cut-function nil
	    interprogram-paste-function nil)
      (message "Remote XEmacs connection: interprogram cut & paste has been disabled.")
      )
  )

;; Code Folding
;; There's a copy in /emc/eda/lib/xemacs/xemacs-packages/lisp,
;; but this is flakey.  I wouldn't use it.
;(autoload 'folding-mode          "folding" "Folding mode" t)
;(autoload 'turn-off-folding-mode "folding" "Folding mode" t)
;(autoload 'turn-on-folding-mode  "folding" "Folding mode" t)
