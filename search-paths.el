;(defvar site-lisp-top-dir "/usr/local/lib/xemacs/site-lisp")
(defvar site-lisp-top-dir (expand-file-name "local/lib/xemacs/site-lisp" tuttle-home))

(if
	(not
	 (and
	  (string-match "XEmacs" emacs-version)
	  (boundp 'emacs-major-version)
	  (= emacs-major-version 20)
	 )
	)

	; then:
	(progn
		;; for any emacs other than XEmacs 20.x (and higher?),
		;; to add new site-lisp directories to the load-path,
		;; add lines just like the setq commands below:
		(setq load-path (cons (concat site-lisp-top-dir "/calc-2.02f") 
							  load-path))
		(setq load-path (cons (concat site-lisp-top-dir "/misc") load-path))
		(setq load-path (cons (concat site-lisp-top-dir "/emacs-site-lisp") 
							  load-path))
	) ;; end of PROGN
) ;; end of IF


;; I was under the impression that the autoload magic-cookie (;;;###autoload)
;; would cause a following function definition to automatically be available
;; at any time.  I was wrong.  The contents of the 'loaddefs.el' file seem to
;; reflect the autoloads with which emacs was built.  You can change to
;; contents of that file (like with the function 'update-file-autoloads'),
;; but that 'loaddefs.el' is not normally looked at again during emacs launch
;; time.  So, that's why I explicity load *my* version here.
(setq generated-autoload-file (concat site-lisp-top-dir "/prim/loaddefs.el"))
(setq loaded-autoload-file "no")
(if (file-exists-p generated-autoload-file)
	(load generated-autoload-file)
)


;; Include the "local" info pages:
(setq Info-default-directory-list
	(append Info-default-directory-list '("/usr/local/info/")))

