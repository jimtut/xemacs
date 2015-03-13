;; ============================
;; VERILOG LSE:

;;; if the 'emacs-version' is 19.1x, load these routines:
;;; (each clause in a COND statement is evaluated until one passes)
(cond
 (
;;  (string-match "19.1" emacs-version)
  (and 
   (string-match "XEmacs" emacs-version)
   (boundp 'emacs-major-version)
   (>= emacs-major-version 19)
   ;(>= emacs-minor-version 10)
   )
  
  (condition-case err
			(let 
				;; Declare variables to be used in the body of the LET statement:
				(
					(cds-inst-dir (getenv "CDS_INST_DIR"))
				)

				;; body of LET statement:
				(remove-hook 'activate-menubar-hook 'energize-font-lock-sensitize-menu)

;; We need the shell variable CDS_INST_DIR to be set.
;; If not, set/defvar the cvlog-source-directory variable by hand 
;; before running this!
				(if cds-inst-dir
					;; then:
					(progn
						(setq cvlog-source-directory
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
					)	;;; end of 'if then progn' statement
					;; else (cds-inst-dir is nil because then CDS_INST_DIR
					;; environment variable is not set):
					(progn
						(require 'cvlog)
						(require 'vet)
					)  ;;; end of 'if .... else progn' statement
				)	;;; end of IF [cds-inst-dir] statement
			)	;;; end of LET statement

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


