;; ============================
; RE-MAP SOME KEYS:
; I mostly use (define-key global-map ...),
; but I can alos use (global-set key ...)

; shortcut to "replace-string":
(define-key global-map "\M-r" 'replace-string)

; call my-undo-more function, which keeps undoing all the previous commands:
(define-key global-map "\M-u" 'my-undo-more)

; Call 'my-print, which calls "ps-print-buffer-with-faces":
(define-key global-map "\M-p" 'my-print)

; Call 'x-copy-primary-selection
(define-key global-map "\M-c" 'x-copy-primary-selection)

; Call 'contacts, to process Exported contacts
(define-key global-map "\C-c\C-c" 'contacts)

; select all:
;(define-key global-map "\M-a" '[?\M-< ?\C-@ ?\M->])
(define-key global-map "\M-a" 'select-all)

; re-fontify the current buffer:
(define-key global-map "\C-xf" 'font-lock-fontify-buffer)

; hide the buffer in the current half of the window (type Ctrl-x Ctrl-h):
;(define-key global-map [(control x) (control h)] [(control x) 0])

; use Meta-K to View Buffer in Netscape:
; [The proper way to do this would be to modify "html-mode-map",
; but that doesn't seem to work (HTML mode not loaded).
; So, that leaves me with defining it in the "global-map", which means
; that the keystroke is redefined for ALL modes, even ones which don't
; know what the "sgml-html-netscape-file" function does.]
(define-key global-map "\M-k" 'sgml-html-netscape-file)

; allow "<" to show up as an open-tag under HTML mode:
;(define-key html-mode-map "<" 'html-real-less-than)
;(define-key html-mode-map ">" 'html-real-greater-than)

; This function prompts you for a line to JUMP to:
; (apparently, Meta-G does this too, in some emacses)
;(global-set-key "\C-x\C-j" 'goto-line)

; Re-map C-x C-k to be same as C-x k (kill-buffer), since I screw it up a lot:
(global-set-key "\C-x\C-k" 'kill-buffer)

(add-hook 'cperl-mode-hook
	  (defun my-cperl-mode-hook ()
	    ;; Map shift-tab (aka, "kp-tab" (meaning "keypad-tab") and "iso-left-tab") to a regular tab.
	    ;; Should these just be done with global-set-key (or define-key global-map)?
	    (define-key cperl-mode-map [(kp-tab)] 'tab-to-tab-stop)
	    (define-key cperl-mode-map [(iso-left-tab)] 'tab-to-tab-stop)
	    ;; What does this one do?!?
	    (define-key cperl-mode-map "\C-xp" (read-kbd-macro "print SPC \"\\n\"; C-a TAB 7*<right>"))
	    )
	  )
