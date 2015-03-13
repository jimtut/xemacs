;; If this is not XEmacs (i.e., it's Emacs) or any version of XEmacs except 19.13,
;; do the following.
(if
    (or
     (not (string-match "XEmacs" emacs-version))
     (and
      (string-match "XEmacs" emacs-version) 
      (not
       (and
	(= emacs-major-version 19)
	(= emacs-minor-version 13)
	)
       )
      )
     )
    (progn
      (custom-set-variables
       '(case-fold-search t)
       '(current-language-environment "English")
       '(global-font-lock-mode t nil (font-lock))
       '(load-home-init-file t t)
       '(query-user-mail-address nil)
       '(show-paren-mode t nil (paren))
       '(transient-mark-mode t)
       '(user-mail-address "tuttle_james@emc.com")
       )
      (custom-set-faces)
      )  ;; end of PROGN
  )  ;; end of IF

(if
    (boundp 'aquamacs-version)
    (progn
      (custom-set-variables
       '(aquamacs-additional-fontsets nil t)
       '(aquamacs-customization-version-id 144 t)
       '(one-buffer-one-frame-mode nil nil (aquamacs-frame-setup))
       '(tabbar-mode t nil (tabbar))
       )
      )
  )

;; Further details about ECB can be found at 
;;    http://www.xemacs.org/Documentation/packages/html/ecb.html
;;
;; Further layouts can be seen in
;;    ...lib/xemacs/xemacs-packages/lisp/ecb/ecb-layout-defs.el

;; Should this stuff be moved to the PROGN section above?
;; so it's not run in XEmacs 19.13?
;; If I did that, wouldn't XEmacs just recreate this the next time
;; I custom-set-variables?

;; Delete the "buffers-tab-filter-functions" line if I only want buffers
;; of the same type/mode to show in the tabs (list of open buffers).

(custom-set-variables
 '(bell-volume 5)
 '(buffers-tab-filter-functions (quote (select-buffers-tab-all-buffers)))
 '(case-fold-search t)
 '(current-language-environment "English")
 '(ecb-layout-name "left9")
 '(ecb-layout-window-sizes (quote (("left9" (0.3 . 0.95)))))
 '(ecb-options-version "2.31")
 '(global-font-lock-mode t nil (font-lock))
 '(gutter-buffers-tab-visible-p t)
 '(load-home-init-file t t)
 '(query-user-mail-address nil)
 '(show-paren-mode t nil (paren))
 '(transient-mark-mode t)
 '(user-mail-address "james.tuttle@emc.com")
 '(visible-bell t))
(custom-set-faces
 '(html-helper-link-face ((t (:foreground "blue" :bold t :underline t)))))
(message "Finished loading custom.el file, PC edit")
