;; ============================
;; FONTS:

(require 'font-lock)

;; These don't seem to look right in Emacs, so just use in XEmacs:
(if
    (and
     (or
      (string-match "XEmacs" emacs-version)
      (and
       (string-match "GNU" (emacs-version))
       (= emacs-major-version 20)
       )
      )
     (not terminal-frame) 
     ;; i.e., we're not in TTY mode.
     ;; Normally, I'd use (eq 'x (device-type)), but GNU Emacs doesn't
     ;; support that function.
     )
	; then
    (progn
      (set-face-font 'default "-*-Courier-Medium-R-*-*-*-120-*-*-*-*-*-*")
      (set-face-font 'modeline "-*-Courier-Medium-R-*-*-*-120-*-*-*-*-*-*")
      (set-face-foreground 'default      "black")  ; normal text
      (set-face-background 'highlight    "blue")   ; selecting buffernames
      (set-face-foreground 'highlight    "yellow") ; selecting buffernames
      (set-face-background 'modeline     "grey")   ; Line at bottom of buffer
      (set-face-foreground 'modeline     "white")
      (set-face-foreground 'font-lock-comment-face "#6920ac")
      (set-face-foreground 'font-lock-string-face "green4")
      (set-face-foreground 'font-lock-function-name-face "red3")
      (set-face-foreground 'font-lock-keyword-face "blue3")
      (set-face-foreground 'font-lock-type-face "blue3")
    ) ;; end of PROGN
) ;; end of IF

;; Some definitely XEmacs-only faces:
(if (string-match "XEmacs" emacs-version)
    (progn
		;; frame background (this works in GNU emacs, but looks funny):
      (set-face-background 'default      "bisque")

		;; search highlight color
      (set-face-background 'isearch      "yellow")
      (set-face-foreground 'isearch      "blue")

		;; BG/FG when highlighting (selecting text):
      (set-face-background 'zmacs-region "black")	
      (set-face-foreground 'zmacs-region "yellow")

		;; what is this?
      (set-face-foreground 'font-lock-doc-string-face "green4")

      (add-spec-list-to-specifier (face-property 'default 'font) '((global (nil . "-*-Screen-Medium-R-*-*-*-120-*-*-*-*-iso8859-1"))))
      (add-spec-list-to-specifier (face-property 'modeline 'font) '((global (nil . "-*-Screen-Medium-R-*-*-*-120-*-*-*-*-iso8859-1"))))

   )
)  ;; end of IF

;; Setting default fonts (I don't know if this works in all versions of emacs):

; Adds to bg color, so keep black:
(setq x-pointer-foreground-color   "black") 
; This is color you really want ptr/crsr:
;(setq x-pointer-background-color   "darkgreen")
