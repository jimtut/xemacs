;; ============================
; NEW FUNCTIONS:

;; To make a function interactive (in the minibuffer),
;; define one (or more) arguments to the function,
;; and include a line like this:
;; 		  (interactive "MyFunction: Enter a file name? ")


(if (and
	 (string-match "XEmacs" emacs-version)
	 (or (eq 'mswindows (device-type)) (eq 'x (device-type)))
	)

	; then:
	(progn
		(defun my-print-obsolete ()
			"Jim's Printer Dialog Box (obsolete use of popup-dialog-box)"
			(interactive)
			(popup-dialog-box
			 (list
			  (format "You are about to print to '%s'.\nIs that OK?" 
					  (getenv "PRINTER"))
			  (vector "OK" 'ps-print-buffer-with-faces t)
			  (vector "Cancel" (list 'null()) t)
			  )
			 )
		) ;; end of DEFUN my-print-obsolete

		(defun my-print ()
			"Jim's Printer Dialog Box"
			(interactive)
			(make-dialog-box 'question :question (format "You are about to print to '%s'.\nIs that OK?" (getenv "PRINTER")) :buttons (list (vector "OK" 'ps-print-buffer-with-faces t) (vector "Cancel" (list 'null()) t)))
		) ;; end of DEFUN my-print

		(defun msgbox (message_body)
			"Jim's Generic Message Box"
			(popup-dialog-box
			 (list
			  (format message_body)
			  (vector "OK" (list 'null()) t)
			  )
			 )
		) ;; end of DEFUN msgbox
	) ;; end of if-then PROGN
  ) ;; end of IF

(if (not (string-match "XEmacs" emacs-version))
    ;; then:
    (progn
      (defun my-print ()
	"Jim's Printer Dialog box for Emacs"
	(interactive)
	(if (x-popup-dialog t (list (format "You are about to print to '%s'." (getenv "PRINTER")) '("OK" . t) '("Cancel" . nil))) (ps-print-buffer-with-faces))
	) ;; end of DEFUN my-print
      ) ;; end of else PROGN
  ) ;; end of IF

(defun my-undo-more ()
	"Jim's undo-more"
	(interactive)
	(undo-with-space)
;	(undo-more 1)
;; If I go back to using the undo-more function (from the prim/simple.el file),
;; I need to execute a regular undo function before calling this my-undo.
)

(defun select-all ()
	"Jim's select-all"
	(interactive)
	(beginning-of-buffer)
	(set-mark-command nil)
	(end-of-buffer)
)

(defun contacts ()
	"Process exported Contacts"
	(interactive)

	; Fix bad line-breaks:
	(setq lineBreakCounter 0)
	(while (re-search-forward "^\"," nil t)
		(setq lineBreakCounter (1+ lineBreakCounter))
		(backward-char)
		(backward-char)
		; Delete 2 chars: a "^M" (no dos2unix cleanup performed) and a CR
		(delete-backward-char 1)
		)

	; Strip ^M's and replace with extra line-feeds:
	(beginning-of-buffer)
	(while (re-search-forward "\^M" nil t)
		(backward-char)
		(delete-char 1)
		;(newline)
		)

	; Remove all double-quotes:
	(beginning-of-buffer)
	(replace-string "\"" "")

	; Replace corrupted EMC.com email addresses:
	(setq corruptedAddresses 0)
	(beginning-of-buffer)
	(while (re-search-forward "\/o=EMC" nil t)
		(setq corruptedAddresses (1+ corruptedAddresses))
		; delete back over the string we just found:
		(delete-backward-char 6)
		; delete the remainder of the EMC garbage:
		(delete-char 31)
		; delete the last-name + first-initial of this contact:
		(kill-word 1)
		; put in a placeholder (this IS important):
		(insert-before-markers "foo")
		(forward-char 4)
		; Kill (and hold!) the next 2 words, which is the "Display Name",
		; which had BETTER be set to the real email address!
		(kill-word 4)
		; go back to that inserted "foo":
		(backward-word 2)
		; yank back the Display Name:
		(yank)
		; Remove "foo" placeholder:
		(kill-word 1)
		)

	; Output:
	(beginning-of-buffer)
	(message "Fixed %d bad line-breaks, %d bad EMC addresses, and removed all double-quotes." lineBreakCounter corruptedAddresses)
)

(defun cv ()
	"test"
	(interactive)
	(setq e-string "Error")
	(re-search-backward e-string)
)

(defun select-buffers-tab-all-buffers-orig (next-buffer current-buf)
;; This came right out the XEmacs source .el files.
  "For use as a value of `buffers-tab-selection-function'.
This selects all buffers except those which begin with an asterix (*)."
  (interactive)
  (let ((mode1 (symbol-name (symbol-value-in-buffer 'major-mode current-buf)))
	(mode2 (symbol-name (symbol-value-in-buffer 'major-mode next-buffer)))
	(modenm1 (symbol-value-in-buffer 'mode-name current-buf))
	(modenm2 (symbol-value-in-buffer 'mode-name next-buffer)))
    (cond ((or (eq mode1 mode2)
	       (eq modenm1 modenm2)
	       (and (string-match "^[^-]+-" mode1)
		    (string-match
		     (concat "^" (regexp-quote 
				  (substring mode1 0 (match-end 0))))
		     mode2))
	       (and buffers-tab-grouping-regexp
		    (find-if #'(lambda (x)
				 (or
				  (and (string-match x mode1)
				       (string-match x mode2))
				  (and (string-match x modenm1)
				       (string-match x modenm2))))
			     buffers-tab-grouping-regexp)))
	   t)
	  (t nil))))

(defun select-buffers-tab-all-buffers (next-buffer current-buffer)
  "For use as a value of `buffers-tab-filter-functions'.
This selects all buffers except those which begin with an asterix (*)."
  (interactive)
  (setq next-buffer-name (buffer-name next-buffer))
  (setq current-buffer-name (buffer-name current-buffer))
  (cond
   ;; If the current and the next buffer are both * buffers, show them.
   ((if (and (string-match "^\*" current-buffer-name) (string-match "\*" next-buffer-name)) t) t)
   ;; If the current buffer is a *, but the next is not, don't show the next buffer.
   ((if (and (string-match "^\*" current-buffer-name) (not (string-match "\*" next-buffer-name))) t) nil)
   ;; By now, we're guaranteed the current buffer is not a *.
   ;; If the next buffer buffer is *, then we don't want to see it.
   ((string-match "^\*" next-buffer-name) nil)
   ;; All other buffers should be shown.
   (t t)
   )
)

(defun cperl-regular-tab ()
  "This functions inserts a 'real' TAB, regardless of what type of tab/indent mode you have turned on."
  ;; That's not quite true.  If you're at the beginning of a line, it won't insert a tab.
  ;; I've stopped using this in favor of using tab-to-tab-stop.
  (interactive)
  (setq cperl-tab-always-indent nil)
  (cperl-indent-command)
  (setq cperl-tab-always-indent t)
)
