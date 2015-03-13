;; ============================
;; VERILOG LSE:

;; cond: a built-in function.
;; (cond CLAUSES...): try each clause until one succeeds.
;; Each clause looks like (CONDITION BODY...).  CONDITION is evaluated
;; and, if the value is non-nil, this clause succeeds, and the BODY is evaluated.

(defvar use-cvlog t "Indicates whether or not it's OK to use CVLOG mode.")

(cond
 ; first COND clause - if this is XEmacs 19.13, require the CDS_INST_VAR to be set:
 (
  (and 
   (string-match "XEmacs" emacs-version)
   (boundp 'emacs-major-version)
   (= emacs-major-version 19)
   (= emacs-minor-version 13)
   )  ; end of AND

  ;(msgbox "19.13")
  
  (setq cds-inst-dir (getenv "CDS_INST_DIR"))
  (remove-hook 'activate-menubar-hook 'energize-font-lock-sensitize-menu)

;; We need the shell variable CDS_INST_DIR to be set.
;; If not, set/defvar the cvlog-source-directory variable by hand 
;; before running this!
  (if cds-inst-dir
	  (progn
			  (setq cvlog-source-directory (concat cds-inst-dir "/tools/lse/lse/venv-lse"))
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
	  )	;;; end of 'progn' statement
  )	;;; end of IF [cds-inst-dir] statement

  (discard-input)
 )	;; end of first clause in COND statement

;; second COND clause - if this is XEmacs 19.x (where x != 13):
 (
  (and 
   (string-match "XEmacs" emacs-version)
   (boundp 'emacs-major-version)
   (= emacs-major-version 19)
  )  ; end of AND
  ;(msgbox "19.x, but not 19.13")
  (if (not (boundp 'site-lisp-top-dir))
		  (progn
			  ;; (msgbox "site lisp not bound")
			  (setq site-lisp-top-dir "/usr/local/lib/xemacs/site-lisp")
	  )
  )
  (defvar cvlog-source-directory (concat site-lisp-top-dir "/cvlog-02.40-modified"))
  (setq load-path (cons (concat site-lisp-top-dir "/cvlog-02.40-modified") load-path))
  (setq load-path (cons (concat site-lisp-top-dir "/venv-common-02.40") load-path))
  (setq load-path (cons site-lisp-top-dir load-path))
  (require 'cvlog)
  (require 'vet)
 )	;; end of second clause in COND statement

;; third COND clause - if this is XEmacs 20.x:
 (
  (and 
   (string-match "XEmacs" emacs-version)
   (boundp 'emacs-major-version)
   (= emacs-major-version 20)
  )  ; end of AND
  ;(msgbox "20")
  (if (not (boundp 'site-lisp-top-dir))
		  (progn
			  ;; (msgbox "site lisp not bound")
			  (setq site-lisp-top-dir "/usr/local/lib/xemacs/site-lisp")
	  )
  )
  (defvar cvlog-source-directory (concat site-lisp-top-dir "/cvlog-02.40-modified"))
  (require 'cvlog)
  (require 'vet)
 )   ;; end of COND clause

;; fourth COND clause - if this is GNU Emacs
 (
  (and
   (string-match "GNU" (emacs-version))
   ;(string-match "Emacs 20." (emacs-version))
  )  ; end of AND

  (setq use-cvlog nil)
 )   ;; end of COND clause

;; final clause in the COND statement
 (t (message "Verilog LSE initialization failed."))
)	;;; end of COND statement

;;;; Only continue if 'use-cvlog' is still true:
(if use-cvlog
(progn

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
))