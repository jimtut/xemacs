;; LOAD SOUNDS:
;; Don't load sounds if you're using the CD player, 'cause the volume
;; can shift radically on you, and the output switches to mono (from stereo)
;; until you do something (like pause and then un-pause the CD player).

(cond 
 (
  (or (eq 'mswindows (device-type)) (eq 'x (device-type)))
;  (eq 'x (device-type))
  ; This conflicts w/ running XEmacs from CADSYS web server:
  ;(string-match ":0" (getenv "DISPLAY"))
  (load-default-sounds)
  (setq bell-volume 20)
  ) ;; end of first COND statement (for loading sounds)
 (t
  (setq bell-volume 40)
  (setq sound-alist
		(append sound-alist '((no-completion :pitch 500))))
  )  ;; end of last COND statement (for loading sounds)
 )  ;; end of COND (for loading sounds)


