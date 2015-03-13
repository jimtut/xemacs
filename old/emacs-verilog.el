;; ============================
; NEW FUNCTIONS:

;; To make a function interactive (in the minibuffer),
;; define one (or more) arguments to the function,
;; and include a line like this:
;; 		  (interactive "MyFunction: Enter a file name? ")

(defun my-print ()
	"Jim's Printer Dialog Box"
	(interactive)
	(popup-dialog-box
	     (list
			(format "You are about to print to '%s'.\nIs that OK?" (getenv "PRINTER"))
			(vector "OK" 'ps-print-buffer-with-faces t)
			(vector "Cancel" (list 'null()) t)
		)
	)
)

(defun msgbox (message_body)
        "Jim's Generic Message Box"
        (popup-dialog-box
                (list
                        (format message_body)
                        (vector "OK" (list 'null()) t)
                )
        )
)

(defun my-undo-more ()
	"Jim's undo-more"
	(interactive)
	(undo-with-space)
;	(undo-more 1)
;; If I go back to using the undo-more function (from the prim/simple.el file),
;; I need to execuate a regular undo function before calling this my-undo.
)


;; ============================
;; FONTS:
(set-face-font 'default "-*-Courier-Medium-R-*-*-*-120-*-*-*-*-*-*")
(set-face-font 'modeline "-*-Courier-Medium-R-*-*-*-120-*-*-*-*-*-*")
;(set-face-background 'zmacs-region "red")	; BG when highlighting (doesn't work)
;(set-face-foreground 'zmacs-region "yellow")	; FG when highlighting (doesn't work)
(set-face-background 'default      "bisque")     ; frame background
(set-face-foreground 'default      "black")      ; normal text
(set-face-background 'highlight    "blue")       ; Ie when selecting buffers 
(set-face-foreground 'highlight    "yellow")
(set-face-background 'modeline     "grey")       ; Line at bottom of buffer
(set-face-foreground 'modeline     "white")
(set-face-background 'isearch      "yellow")     ; When highlighting while
                                                 ; searching             
(set-face-foreground 'isearch      "blue")
(setq x-pointer-foreground-color   "black")      ; Adds to bg color,
                                                 ; so keep black
;(setq x-pointer-background-color   "blue")       ; This is color you really
                                                 ; want ptr/crsr

;; ============================
;; VERILOG LSE:

;;; if the 'emacs-version' is 19.1x, load these routines:
;;; (each clause in a COND statement is evaluated until one passes)
(cond
	((string-match "19.1" emacs-version)
		(condition-case err
			(let 
				;; Declare variables to be used in the body of the LET statement:
				(
					(cds-inst-dir (getenv "CDS_INST_DIR")) 
				)

				;; body of LET statement:
				(remove-hook 'activate-menubar-hook 'energize-font-lock-sensitize-menu)
;;; LSE - needs shell variable CDS_INST_DIR to be set
				(if cds-inst-dir
					(progn
						(defvar cvlog-source-directory
							(concat cds-inst-dir "/tools/lse/lse/venv-lse"))
						(setq load-path (cons cvlog-source-directory load-path))


;; By "loading" cvlog here, I end up overriding some other things.
;;
;; For example, when I save an HTML buffer, emacs drops all font-locking
;; on that buffer, and only reinstates font-locking when you make new
;; changes to text of a defined font (and even then, emacs only
;; font-locks that piece of text).
;;
;; Without these REQUIRE statements, HTML font-locking *does* work correctly!
;; Unfortunately, I need to REQUIRE cvlog in order to use its functions
;; and modify its variables later in this file.
						(require 'cvlog)
						(require 'vet)
					)	;;; end of PROGN statement
				)	;;; end of IF [cds-inst-dir] statement
			)	;;; end of LET loop

			;; handling routines for CONDITION-CASE go here:
			(error (popup-dialog-box
				(list (format "Fatal error during LSE initialization: %s" err)
					(vector "EXIT" (list 'kill-emacs) t))))
		)	;;; end of CONDITION-CASE

		(discard-input)
	)	;; end of first CLAUSE in COND statement

;;; start of 2nd (and final) CLAUSE in this COND statement
;;; (this one will only be evaluated if the previous one(s) have failed)
	(t
		(popup-dialog-box
			(list
				(format "Wrong lemacs version (%S).\nThe LSE requires version 19.1x of lemacs.\nLSE initialization failed.\nLanguage sensitive editing will not be available." (emacs-version))
				(vector "OK" (list 'null()) t)
			)	;; end of LIST
		)	;; end of POPUP-DIALOG-BOX
	)	;; end of 2nd CLAUSE in COND statement
)	;;; end of COND statement

;; =====================
;; Options Menu Settings
(cond
 ((and (string-match "XEmacs" emacs-version)
       (boundp 'emacs-major-version)
       (= emacs-major-version 19)
       (>= emacs-minor-version 10))
  (setq-default highlight-paren-expression nil)
  (setq-default overwrite-mode nil)
  (setq-default teach-extended-commands-p nil)
  (setq-default complex-buffers-menu-p nil)
  (setq-default buffers-menu-max-size 20)
  (setq-default case-fold-search t)
  (blink-paren 1)
  (if (featurep 'pending-del) (pending-delete 0))
  (remove-hook 'c-mode-hook 'turn-on-font-lock)
  (remove-hook 'c++-mode-hook 'turn-on-font-lock)
  (remove-hook 'lisp-mode-hook 'turn-on-font-lock)
  (remove-hook 'emacs-lisp-mode-hook 'turn-on-font-lock)
  (require 'font-lock)
  (require 'fast-lock)
  (remove-hook 'font-lock-mode-hook 'turn-on-fast-lock)
  (setq lisp-font-lock-keywords lisp-font-lock-keywords-2)
  (set-face-foreground 'font-lock-comment-face "#6920ac")
  (set-face-foreground 'font-lock-string-face "green4")
  (set-face-foreground 'font-lock-doc-string-face "green4")
  (set-face-foreground 'font-lock-function-name-face "red3")
  (set-face-foreground 'font-lock-keyword-face "blue3")
  (set-face-foreground 'font-lock-type-face "blue3")
  ))


;; ============================
;; HTML:

(setq html-document-previewer "netscape_4.03")
(setq hm--html-expert t)

;; This next 2 commands are only necessary under XEmacs 19.14 and 19.15
;; (which I'm not running 'cuz some regexp searching (specifically, matching newlines)
;; doesn't work right for the Verilog LSE environment).
;; Use the "hm--html-mode" instead of any default html-mode (like psgml):
;(autoload 'html-mode "hm--html-mode" "HTML Mode (autoloaded by Jim)" t)
;(setq auto-mode-alist (cons '("\\.html$" . hm--html-mode) auto-mode-alist))


;; ============================ 
;; Here's a way to add scrollbar-like buttons to the menubar
(add-menu-item nil "Top" 'beginning-of-buffer t)
(add-menu-item nil "<<<" 'scroll-down t)
;(add-menu-item nil " . " 'recenter t)
(add-menu-item nil ">>>" 'scroll-up t)
(add-menu-item nil "Bot" 'end-of-buffer t)

;; ============================
; RE-MAP SOME KEYS:
; I mostly use (define-key global-map ...),
; but I can alos use (global-set key ...)

; shortcut to "replace-string":
(define-key global-map '(meta r) 'replace-string)

; call my-undo-more function, which keeps undoing all the previous commands:
(define-key global-map '(meta u) 'my-undo-more)

; Call 'my-print, which calls "ps-print-buffer-with-faces":
(define-key global-map '(meta p) 'my-print)

; select all:
(define-key global-map '(meta a) [(meta <) (control space) (meta >)])

; re-fontify the current buffer:
(define-key global-map [(control x) f] 'font-lock-fontify-buffer)

; hide the buffer in the current half of the window (type Ctrl-x Ctrl-h):
(define-key global-map [(control x) (control h)] [(control x) o (control x) 49])

; allow "<" to show up as an open-tag under HTML mode:
;(define-key html-mode-map "<" 'html-real-less-than)
;(define-key html-mode-map ">" 'html-real-greater-than)

; This function prompts you for a line to JUMP to:
(global-set-key "\C-x\C-j" 'goto-line)


;; ============================
;; MISC:

; Turn on line-numbering:
(setq line-number-mode t)

; This puts the full pathname in the window title area (doesn't work right in 19.11):
(setq frame-title-format "%S: %f")


; If you are using "fast" font-locking, this specifies where to keep
; the "cache" files that that function generates:
(setq fast-lock-cache-directories '("/tmp"))

;; To display a variable (usefule while debugging):
;; (message "%s" pending-undo-list)


;; ============================
;; LOAD SOUNDS:
(cond ((string-match ":0" (getenv "DISPLAY"))
	(load-default-sounds))
	(t
		(setq bell-volume 40)
		(setq sound-alist
			(append sound-alist '((no-completion :pitch 500))))
		))


;; ===================================================================
;; VERILOG LSE

; You can get xemacs to recognize ANY file as a Verilog file
; by placing "//  -*-cvlog-c-*-" in the first line of the file.
; However, the Analyzer (a GREAT tool) requires a ".v" extension.
; This line overrides that suffix definition!
(setq cvlog-file-suffix "\.$")


;; ============================
; SET TAB and SHIFT-TAB:
(define-key cvlog-c-mode-map 'tab 'tab-to-tab-stop)
(define-key cvlog-c-mode-map '(shift tab) 'cvlog-tab)
(define-key cvlog-c-mode-map '(control tab) 'cvlog-tab)

;; ============================
; CHANGE SOME DEFAULT COLORS:
(lse-make-face 'comment "green4" )
(lse-make-face 'module "red" )
(lse-make-face 'block "brown" )
(lse-make-face 'subprogram "BlueViolet" )
(lse-make-face 'begin-end "red" )
(lse-make-face 'if-else "navy" )
(lse-make-face 'registers "blue" )
(lse-make-face 'assign "nil" "nil" "courier-bold")
(lse-make-face 'case "coral" )
(lse-make-face 'in-out "magenta" )

;; ============================
; Add some new cvlog-mode-hilit definitions:
; (if you don't like the way these change the color of the ENTIRE
;  line starting from the keyword, remove the ".*\n" from the
;  corresponding expression(s))

(setq cvlog-mode-hilit (cons
	'("^[ \t]*if .*\n"	nil	if-else)
	cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^[ \t]*else.*\n"	nil	if-else)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^[ \t]*case.*\n"	nil	case)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^[ \t]*endcase"	nil	case)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^input"	nil	in-out)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^output"	nil	in-out)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^inout"	nil	in-out)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^reg"	nil	registers)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^wire"	nil	registers)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^parameter"	nil	registers)
	 cvlog-mode-hilit))

(setq cvlog-mode-hilit (cons
	'("^assign"	nil	assign)
	 cvlog-mode-hilit))

(lse-hilit::mode-list-update cvlog-mode-name cvlog-mode-hilit)

; Make the defined "comment" face a 12-point Italic Courier ("O"="Oblique"):
;(set-face-font 'comment "-*-Courier-Medium-O-*-*-*-120-*-*-*-*-*-*")

; Make the defined "comment" font BOLD and ITALIC when printed using
; "ps-print-buffer-with-faces" [also, Meta-p (defined above)]
; (there should be a more graceful way of adding our "comment" font to the
; pre-existing lists of "ps-*-faces", but I couldn't get it to work):


;; Old PS Bold/Italic Faces:
;(setq ps-bold-faces '(comment bold bold-italic font-lock-function-name-face message-headers))
;(setq ps-italic-faces '(comment registers italic bold-italic font-lock-function-name-face font-lock-string-face font-lock-comment-face message-header-contents message-highlighted-header-contents message-cited-text))

;; New PS Bold/Italic Faces:
(setq ps-bold-faces '(comment assign registers block begin-end if-else case bold bold-italic))
(setq ps-italic-faces '(comment italic bold-italic))

(setq ps-print-color-p nil)
;(setq ps-lpr-command "lpr -m")
(setq ps-lpr-command "lpr")

;; Include the "local" info pages:
(setq Info-default-directory-list
	(append Info-default-directory-list '("/usr/local/info/")))

