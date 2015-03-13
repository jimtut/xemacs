(defvar tuttle-home "/aehw/tuttle")
(defvar xemacs-files (expand-file-name ".xemacs" tuttle-home))

(load (expand-file-name "functions.el" xemacs-files))
(load (expand-file-name "search-paths.el" xemacs-files))
;(load (expand-file-name "verilog-simple.el" xemacs-files))
(load (expand-file-name "fonts-and-faces.el" xemacs-files))
(load (expand-file-name "misc-variables.el" xemacs-files))
;(load (expand-file-name "sounds.el" xemacs-files))

(if (string-match "XEmacs" emacs-version)
    ;then:
    (progn
      (load (expand-file-name 
			 "key-definitions.el" xemacs-files))
      (if (eq 'x (device-type))
		; then:
		(load (expand-file-name 
			   "menu-and-toolbars.el" xemacs-files))
	   )  ;; end of IF
    )  ;; end of PROGN
) ;; end of IF


;; =====================
(message "Finished loading init.el file")
