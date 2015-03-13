;; ============================ 
;; Here's a way to add scrollbar-like buttons to the menubar
;(add-menu-item nil "Top" 'beginning-of-buffer t)
;(add-menu-item nil "Bot" 'end-of-buffer t)


;; ============================ 
;; Custom Toolbar:

;; Turn off captions on the toolbar buttons:
; (set-specifier toolbar-buttons-captioned-p nil)

(defvar my-icon-directory (expand-file-name "icons" xemacs-files) "My icon directory")

; All of these 'blank-icon' files don't even exist, but that seems OK.
(defvar my-toolbar-blank-icon
	(if (featurep 'xpm)
		(toolbar-make-button-list
			(expand-file-name "blank-xx.xbm" my-icon-directory)
			(expand-file-name "blank-xx.xbm" my-icon-directory)
			(expand-file-name "blank-xx.xbm" my-icon-directory)
			(expand-file-name "blank-cap-xx.xpm" my-icon-directory)
			(expand-file-name "blank-cap-xx.xpm" my-icon-directory)
			(expand-file-name "blank-cap-xx.xpm" my-icon-directory)
		)
		(toolbar-make-button-list
			(expand-file-name "blank-up.xbm" my-icon-directory)
			(expand-file-name "blank-dn.xbm" my-icon-directory)
			(expand-file-name "blank-xx.xbm" my-icon-directory)
		)
	)
  "a blank icon")

(defvar my-toolbar-shell-icon
	(if (featurep 'xpm)
		(toolbar-make-button-list
			(expand-file-name "shell-up.xpm" my-icon-directory)
			nil
			(expand-file-name "shell-xx.xpm" my-icon-directory)
			(expand-file-name "shell-cap-up.xpm" my-icon-directory)
			nil
			(expand-file-name "shell-cap-xx.xpm" my-icon-directory)
		)
		(toolbar-make-button-list
			(expand-file-name "shell-up.xbm" my-icon-directory)
			(expand-file-name "shell-dn.xbm" my-icon-directory)
			(expand-file-name "shell-xx.xbm" my-icon-directory)
		)
	)
  "the SHELL icon")

(defvar my-toolbar-fill-icon
	(if (featurep 'xpm)
		(toolbar-make-button-list
			(expand-file-name "fill-up.xpm" my-icon-directory)
			nil
			(expand-file-name "fill-xx.xpm" my-icon-directory)
			(expand-file-name "fill-cap-up.xpm" my-icon-directory)
			nil
			(expand-file-name "fill-cap-xx.xpm" my-icon-directory)
		)
		(toolbar-make-button-list
			(expand-file-name "fill-up.xbm" my-icon-directory)
			(expand-file-name "fill-dn.xbm" my-icon-directory)
			(expand-file-name "fill-xx.xbm" my-icon-directory)
		)
	)
  "the FillParagraph icon")

(defvar my-toolbar-fill-icon
	(if (featurep 'xpm)
		(toolbar-make-button-list
			(expand-file-name "fill-up.xpm" my-icon-directory)
			nil
			(expand-file-name "fill-xx.xpm" my-icon-directory)
			(expand-file-name "fill-cap-up.xpm" my-icon-directory)
			nil
			(expand-file-name "fill-cap-xx.xpm" my-icon-directory)
		)
		(toolbar-make-button-list
			(expand-file-name "fill-up.xbm" my-icon-directory)
			(expand-file-name "fill-dn.xbm" my-icon-directory)
			(expand-file-name "fill-xx.xbm" my-icon-directory)
		)
	)
  "the FillParagraph icon")

(defvar my-toolbar-log-icon
	(if (featurep 'xpm)
		(toolbar-make-button-list
			(expand-file-name "log-up.xpm" my-icon-directory)
			nil
			(expand-file-name "fill-xx.xpm" my-icon-directory)
			(expand-file-name "log-cap-up.xpm" my-icon-directory)
			nil
			(expand-file-name "log-cap-xx.xpm" my-icon-directory)
		)
		(toolbar-make-button-list
			(expand-file-name "log-up.xbm" my-icon-directory)
			(expand-file-name "log-dn.xbm" my-icon-directory)
			(expand-file-name "log-xx.xbm" my-icon-directory)
		)
	)
  "the Log icon")

(defvar my-toolbar-spec
  '([toolbar-file-icon		find-file	t	"Open a file"	]
	[toolbar-folder-icon	dired		t	"View directory"]
	[toolbar-disk-icon	save-buffer	t	"Save buffer"	]
	[toolbar-printer-icon	my-print	t	"Pretty Print"	]
	[my-toolbar-blank-icon	nil		nil	"" ]
	[toolbar-cut-icon	kill-primary-selection t "Kill"]
	[toolbar-copy-icon	copy-primary-selection t "Copy"]
	[toolbar-paste-icon	yank-clipboard-selection t "Paste"]
	[toolbar-undo-icon	undo		t	"Undo"	]
	[my-toolbar-blank-icon	nil		nil	"" ]
	[my-toolbar-fill-icon	fill-paragraph		t	"Fill Paragraph"	]
	[toolbar-replace-icon	query-replace	t	"Replace text"	]
	nil
	[my-toolbar-shell-icon	shell		t	"UNIX Shell"	]
	[my-toolbar-log-icon   show-message-log t   "Message Log"   ]
	[toolbar-compile-icon   eval-current-buffer t   "Eval Buffer"   ]
	[toolbar-spell-icon	toolbar-ispell	t	"Spellcheck"	]
	[toolbar-info-icon	toolbar-info	t	"Information"	]
  )
  "Jim's toolbar.")

(set-specifier default-toolbar my-toolbar-spec)

;; ============================ 
;; Custom XEmacs desktop icon:
(if 
		;; if Xemacs version is higher than 19.13:
		(or
		 (and
		  (string-match "XEmacs" emacs-version)
		  (boundp 'emacs-major-version)
		  (= emacs-major-version 19)
		  (> emacs-minor-version 13)
		 )  ; end of AND
		 (and
		  (string-match "XEmacs" emacs-version)
		  (boundp 'emacs-major-version)
		  (> emacs-major-version 19)
		  )  ; end of AND
		 )  ; end of OR
		;; then:
		(cond 
		 ((featurep 'xpm)
		  ; This doesn't look right in Windows, but looks good in UNIX?
		  (set-glyph-image frame-icon-glyph
						   (expand-file-name "my-xemacs-icon.xpm" my-icon-directory)
						   'global 'x)
		  )  ;; end of 1st COND statement
		 ((featurep 'x)
		  (set-glyph-image frame-icon-glyph
						   (expand-file-name "my-xemacs-icon.xbm" my-icon-directory)
						   'global 'x)
		  )  ;; end of 2nd COND statement
		 )  ;;end of COND
)  ;; end if IF

;; ============================ 
;; Misc:

;; set to nil to remove toolbar captions:
;(set-specifier toolbar-buttons-captioned-p nil)
